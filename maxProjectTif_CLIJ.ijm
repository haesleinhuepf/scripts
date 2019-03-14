sourceFolder = "F:/temp/fly/";
targetMaxFolder = "F:/temp/fly_mask_max/";

run("CLIJ Macro Extensions", "cl_device=[TITAN Xp]");
Ext.CLIJ_clear();

for (i = 0; i < 532; i += 5) {
	
	run("Close All");

	if (i < 10) {
		open(sourceFolder + "00000" + i + ".tif");
	} else if (i < 100) {
		open(sourceFolder + "0000" + i + ".tif");
	} else {
		open(sourceFolder + "000" + i + ".tif");
	}
	run("32-bit");
	
	rename("original");
	
	//run("Brightness/Contrast...");
	Ext.CLIJ_push("original");

	Ext.CLIJ_automaticThreshold("original", "temp2", "Default");

	Ext.CLIJ_binaryNot("temp2", "temp1");
	Ext.CLIJ_mask("original", "temp1", "temp3");
	
	Ext.CLIJ_maximumOfAllPixels("temp3");
	maxVal = getResult("Max", nResults() - 1);
	Ext.CLIJ_release("temp3");
	//Ext.CLIJ_pull("temp3");
	
	
	Ext.CLIJ_erodeBoxIJ("temp2", "temp1");
	Ext.CLIJ_erodeBoxIJ("temp1", "temp2");
	Ext.CLIJ_erodeBoxIJ("temp2", "temp1");
	Ext.CLIJ_dilateBoxIJ("temp1", "temp2");
	Ext.CLIJ_dilateBoxIJ("temp2", "temp1");
	Ext.CLIJ_dilateBoxIJ("temp1", "temp2");
	Ext.CLIJ_dilateBoxIJ("temp2", "temp1");
	Ext.CLIJ_dilateBoxIJ("temp1", "temp2");
	Ext.CLIJ_dilateBoxIJ("temp2", "temp1");
	Ext.CLIJ_dilateBoxIJ("temp1", "temp2");
	Ext.CLIJ_dilateBoxIJ("temp2", "temp1");
	//Ext.CLIJ_pull("temp1");
	
	Ext.CLIJ_mask("original", "temp1", "masked");
	//Ext.CLIJ_pull("masked");

	
	Ext.CLIJ_addImageAndScalar("masked", "temp1", -maxVal);
	Ext.CLIJ_maximumImageAndScalar("temp1", "temp2", 0);
	//Ext.CLIJ_pull("temp2");
	Ext.CLIJ_release("temp1");
	
	Ext.CLIJ_downsampleSliceBySliceHalfMedian("temp2", "temp1");
	Ext.CLIJ_downsampleSliceBySliceHalfMedian("temp1", "downsampled");
	
	Ext.CLIJ_blur3DFast("downsampled", "background", 5.0, 5.0, 0.0);
	
	Ext.CLIJ_addImagesWeighted("downsampled", "background", "backgroundSubtracted", 1.0, -1.0);
	
	Ext.CLIJ_maximumZProjection("backgroundSubtracted", "maximumProjected");
	
	Ext.CLIJ_pull("maximumProjected");
	
	run("Enhance Contrast", "saturated=0.35");
	if (i < 10) {
		saveAs("Tiff", targetMaxFolder + "00000" + i + ".tif");
	} else if (i < 100) {
		saveAs("Tiff", targetMaxFolder + "0000" + i + ".tif");
	} else {
		saveAs("Tiff", targetMaxFolder + "000" + i + ".tif");
	}

	//break;
}

