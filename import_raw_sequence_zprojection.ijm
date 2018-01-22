

imageWidth = 512;
imageHeight = 1024;
noOfSlices = 111;

pixelSizeX = 0.52;
pixelSizeY = 0.52;
pixelSizeZ = 2;

timePointStep = 1;
minTimePoint = 2810;
maxTimePoint = 2825;

sourcePath =  "F:/xxwing/2018-01-18-16-30-25-11-Robert_CalibZAP_Wfixed/stacks/default/";
targetZPath = "F:/xxwing/2018-01-18-16-30-25-11-Robert_CalibZAP_Wfixed/processed/z_projection/";

//setBatchMode(true);

fileList = getFileList(sourcePath);

for (i = minTimePoint; i < lengthOf(fileList); i = i + timePointStep) {
//for (i = 250; i < 280; i++) {\
	if (!File.exists(targetZPath + fileList[i] + ".tif")) {
		print("" + i + ":" + sourcePath + fileList[i]);
		//open(sourcePath + fileList[i]);
		run("Raw...", "open=" + sourcePath + fileList[i] + " image=[16-bit Unsigned] width=" + imageWidth + " height=" + imageHeight + " number=10000 little-endian");
		run("Properties...", "channels=1 slices=" + noOfSlices + " frames=1 unit=um pixel_width=" + pixelSizeX + " pixel_height=" + pixelSizeY + " voxel_depth=" + pixelSizeZ );
		    
		run("Duplicate...", "duplicate range=1-45");
		run("Subtract Background...", "rolling=20 sliding stack");
		run("Z Project...", "projection=[Max Intensity]");
		imageProjected = getTitle();
		run("Duplicate...", "duplicate");
		run("Gaussian Blur...", "sigma=50");
		imageBackground = getTitle();
		imageCalculator("Divide create 32-bit", imageProjected,imageBackground);
		run("Enhance Contrast", "saturated=0.35");
		run("8-bit");
		saveAs("Tiff", targetZPath + fileList[i] + ".tif");
	
		run("Close All");
	
		if (i > maxTimePoint) {
			break;
		}
	}
}

//selectWindow("000000.raw.tif");

//