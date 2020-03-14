// CLIJ example macro: bread_clij_weka_segmentation_training.ijm
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
ground_truth = "ground_truth";

// load and prepare image data
open(path + "bread.tif");
run("32-bit");
makeRectangle(1, 64, 564, 561);
run("Crop");
getDimensions(width, height, channels, slices, frames);
rename(original);

// generate empty ground truth
newImage(ground_truth, "32-bit black", width, height, 1);
selectWindow(original);

// utility method to add some pixels to a given class
function addToGroundTruth(class) {
	selectWindow(ground_truth);
	
	run("Restore Selection");
	run("Line to Area");
	run("Add...", "value=" + class);
	
	selectWindow(original);
}

// define ground truth (this is macro recorded)
makeLine(108,106,119,94,119,82,128,74,144,68,152,73,181,63,193,56,214,66,233,68,243,75,254,88,255,105,254,124,237,112,236,103,229,98,224,98,200,89,190,77,171,79,152,87,136,93);
addToGroundTruth(2);

makeLine(137,250,127,272,127,300,150,304,152,282,167,287,184,284,192,253,203,253,203,281,214,284,223,303,198,331,178,329,166,324,160,336,164,345,180,350,190,345,215,348,215,362,190,377,175,376,171,386,175,395,170,404,171,415,183,420,167,440,204,459);
addToGroundTruth(2);

makeLine(365,58,401,65,398,79,408,88,430,88,456,111,465,131,463,138,440,139,428,135,418,115,397,107,379,107,367,109,356,121,348,138,360,145,364,147,370,160,385,168,385,181,398,190,410,203,406,221,398,225,380,214,366,211,352,197,338,218,328,242,339,246,353,250,355,269,383,277,393,278,406,294,385,311,361,323,363,337,386,335,399,339,396,354,377,365,363,365,339,352,339,333,338,322,324,314,323,384,339,396,371,408,389,429,358,441,353,447,343,456,332,458,353,490,372,497,391,500,374,513,353,521,340,520);
addToGroundTruth(2);

makeLine(111, 84, 97, 105);
addToGroundTruth(1);

makeLine(125, 88, 188, 70);
addToGroundTruth(1);

makeLine(148, 60, 186, 38);
addToGroundTruth(1);

makeLine(171, 148, 159, 161);
addToGroundTruth(1);

makeLine(152, 218, 175, 202);
addToGroundTruth(1);

makeLine(189, 223, 163, 237);
addToGroundTruth(1);

makeLine(172, 279, 177, 261);
addToGroundTruth(1);

makeLine(208, 292, 180, 317);
addToGroundTruth(1);

makeLine(41, 257, 54, 307);
addToGroundTruth(1);

makeLine(72, 266, 70, 304);
addToGroundTruth(1);

makeLine(76, 329, 91, 377);
addToGroundTruth(1);

makeLine(181, 402, 214, 372);
addToGroundTruth(1);

makeLine(186, 427, 207, 417);
addToGroundTruth(1);

makeLine(179, 439, 194, 447);
addToGroundTruth(1);

makeLine(161, 446, 187, 458);
addToGroundTruth(1);

makeLine(16, 464, 101, 544);
addToGroundTruth(1);

makeLine(281, 529, 252, 558);
addToGroundTruth(1);

makeLine(455, 548, 545, 485);
addToGroundTruth(1);

makeLine(454, 15, 551, 109);
addToGroundTruth(1);

makeLine(106, 7, 12, 95);
addToGroundTruth(1);

makeLine(359, 37, 394, 51);
addToGroundTruth(1);

makeLine(364, 70, 383, 74);
addToGroundTruth(1);

makeLine(362, 95, 388, 95);
addToGroundTruth(1);

makeLine(440, 113, 448, 126);
addToGroundTruth(1);

makeLine(433, 74, 451, 94);
addToGroundTruth(1);

makeLine(476, 130, 490, 158);
addToGroundTruth(1);

addToGroundTruth(1);

makeLine(463, 242, 456, 265);
addToGroundTruth(1);

makeLine(512, 190, 515, 221);
addToGroundTruth(1);

makeLine(478, 210, 494, 235);
addToGroundTruth(1);

makeLine(439, 113, 451, 128);
addToGroundTruth(1);

makeLine(408, 124, 415, 145);
addToGroundTruth(1);

makeLine(441, 142, 458, 162);
addToGroundTruth(1);

makeLine(464, 118, 484, 157);
addToGroundTruth(1);

makeLine(349, 469, 374, 487);
addToGroundTruth(1);

makeLine(466, 442, 474, 424);
addToGroundTruth(1);

makeLine(473, 454, 493, 431);
addToGroundTruth(1);

makeLine(505, 415, 512, 400);
addToGroundTruth(1);

makeLine(533, 344, 538, 332);
addToGroundTruth(1);

// init GPU
run("CLIJ Macro Extensions", "cl_device=");
Ext.CLIJ2_clear();

// push image and ground truth to GPU memory
Ext.CLIJ2_push(original);
Ext.CLIJ2_push(ground_truth);

// ---------------------------------------------------------------------------
// compute features on original image - must be identical during prediction!
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
// train classifier, save it as .model and as .model.cl file
print("Train");

Ext.CLIJx_trainWekaModel(feature_stack, ground_truth, path + "bread.model");

print("Bye.");
