targetZPosition = 46;

pixelSizeX = 0.52;
pixelSizeY = 0.52;
pixelSizeZ = 2;

maxTimePoint = 500;

sourcePath =  "F:/xxwing/2018-01-18-16-30-25-11-Robert_CalibZAP_Wfixed/stacks/default/";
targetZPath = "F:/xxwing/2018-01-18-16-30-25-11-Robert_CalibZAP_Wfixed/processed/z" + targetZPosition + "/";


setBatchMode(true);

fileList = getFileList(sourcePath);

for (i = 0; i < lengthOf(fileList); i++) {
	print("" + i + ":" + sourcePath + fileList[i]);
	//open(sourcePath + fileList[i]);
	run("Raw...", "open=" + sourcePath + fileList[i] + " image=[16-bit Unsigned] width=512 height=1024 number=10000 little-endian");
	run("Properties...", "channels=1 slices=111 frames=1 unit=um pixel_width=" + pixelSizeX + " pixel_height=" + pixelSizeY + " voxel_depth=" + pixelSizeZ );
	
	
	setSlice(targetZPosition);
	run("Duplicate...", " ");
	saveAs("Tiff", targetZPath + fileList[i] + ".tif");
	close();

	close();

	if (i > maxTimePoint) {
		break;
	}
}

//selectWindow("000000.raw.tif");

//