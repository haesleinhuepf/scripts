// CLIJ example macro: bread_clij_weka_segmentation_prediction.ijm
//
// This macro shows how to use Weka Trainable Segmentation using CLIJ. 
// Thanks to Christophe Leterrier for the idea:
// https://twitter.com/christlet/status/1238595830468292615?s=20
//
// Author: Robert Haase
//         March 2020
// ---------------------------------------------

// clean up first
run("Close All");

// configure script
path = "C:/structure/code/scripts/bread/"; 

original = "original";
prediction = "prediction";

// load and prepare image data
open(path + "bread.tif");
run("32-bit");
makeRectangle(1, 64, 564, 561);
run("Crop");
getDimensions(width, height, channels, slices, frames);
rename(original);

// init GPU
run("CLIJ Macro Extensions", "cl_device=");
Ext.CLIJ2_clear();

// push image and ground truth to GPU memory
Ext.CLIJ2_push(original);

// ---------------------------------------------------------------------------
// compute features on original image - must be identical during training!
feature_stack = "feature_stack";
feature_slice = "feature_slice";
feature_slice_sobel = "feature_slice_sobel";
number_of_features = 10;
Ext.CLIJ2_create3D(feature_stack, width, height, number_of_features, 32);
Ext.CLIJ2_create2D(feature_slice, width, height, 32);

feature = 0;
sigma = 0;
while (feature < number_of_features) {  

	// feature: gaussian blurred version of the image (starting with sigma=0)
	if (sigma == 0) {
		Ext.CLIJ2_copy(original, feature_slice);	
	} else {
		Ext.CLIJ2_gaussianBlur2D(original, feature_slice, sigma, sigma);
	}
	sigma = sigma + 1;
	Ext.CLIJ2_copySlice(feature_slice, feature_stack, feature);
	feature++;

	// feature: sobel filtered version of the blurred image
	Ext.CLIJ2_sobel(feature_slice, feature_slice_sobel);
	Ext.CLIJ2_copySlice(feature_slice_sobel, feature_stack, feature);
	feature++;
}

// visualise feature stack for academic purposes
Ext.CLIJ2_pull(feature_stack);


// -------------------------------------------------------------------
// apply classifier, saved as .model.cl file
print("Predicting");

Ext.CLIJx_applyOCLWekaModel(feature_stack, prediction, path + "bread.model");

print("Bye.");

Ext.CLIJ2_pull(prediction);