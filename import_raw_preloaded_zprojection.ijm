// This macro generates maximum projections of a folder of RAW
// files. In order to make it work, activate the update site
// "clij" to make it work.
//
//
// Author: Robert Haase, Myers lab, MPI CBG, rhaase@mpi-cbg.de
// March 2019
// --------------------------------------------------------
// config

// define image size
imageWidth = 512;
imageHeight = 1024;
noOfSlices = 100000;

// process every nth image
timePointStep = 1;

// configure background subtraction
subtractBackground = false;
sigmaXYbackgroundDetermination = 10;
sigmaZbackgroundDetermination = 0; // 0 for "no blurring" in Z

// configure folders; use / instead of \ . Folders should end with /
sourcePath =  "C:/structure/data/2018-05-23-16-18-13-89-Florence_multisample/stacks/opticsprefused/";
targetZPath = "C:/structure/data/2018-05-23-16-18-13-89-Florence_multisample/processed/temp/";

// configure max-projection file format
saveWithNewEnding = ".tif";
saveAsFormat = "Tiff";

// define which GPU to use
cl_device = "";

// --------------------------------------------------------
setBatchMode(true);


// Init GPU
run("CLIJ Macro Extensions", "cl_device=" + cl_device);
Ext.CLIJ_clear();

fileList = getFileList(sourcePath);
for (i = 0; i < lengthOf(fileList); i = i + timePointStep) {

	// cleanup at the beginning
	run("Close All");
	Ext.CLIJ_clear();

	// define current file and next file for pre-loading
	currentFile = sourcePath + fileList[i];
	nextFile = sourcePath + fileList[i];
	
	print("" + i + ":" + sourcePath + fileList[i]);

	//open(sourcePath + fileList[i]);
	run("Raw Preloader", "current=[" + currentFile + "] next=[" + nextFile + "] loader=1 image=[16-bit Unsigned] width=" + imageWidth + " height=" + imageHeight + " number=" + noOfSlices + " little-endian");
	//run("Raw...", "open=" + sourcePath + fileList[i] + " image=[16-bit Unsigned] width=" + imageWidth + " height=" + imageHeight + " number=10000 little-endian");
	
	rename("input");
	
	
	// push images to GPU
	Ext.CLIJ_push("input");

	if (subtractBackground) {
		// Blur in GPU
		Ext.CLIJ_blur3DFast("input", "background", sigmaXYbackgroundDetermination, sigmaXYbackgroundDetermination, sigmaZbackgroundDetermination);
		
		// subtraction from original
		Ext.CLIJ_subtractImages("input", "background", "background_subtracted");
		
		// maximum projection
		Ext.CLIJ_maximumZProjection("background_subtracted", "maximum_projected");
	} else {
		// maximum projection
		Ext.CLIJ_maximumZProjection("input", "maximum_projected");
	}
	
	// Get results back from GPU
	Ext.CLIJ_pull("maximum_projected");
	
	// configure view and save to disc
	run("Enhance Contrast", "saturated=0.35");
	run("8-bit");
	saveAs(saveAsFormat, targetZPath + fileList[i] + saveWithNewEnding);
}

// Cleanup GPU by the end
Ext.CLIJ_clear();

run("Close All");

//
setBatchMode(false);
IJ.log("Bye.");
