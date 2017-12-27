targetZPosition = 51;
targetXPosition = 328;

pixelSizeX = 0.26;
pixelSizeY = 0.26;
pixelSizeZ = 2;

maxTimePoint = 200;

sourcePath =  "F:/xxwing/2017-12-22-18-32-38-43-finally_something_alive/stacks/C0L0/";
targetZPath = "F:/xxwing/2017-12-22-18-32-38-43-finally_something_alive/processed/z" + targetZPosition + "/";
targetXPath = "F:/xxwing/2017-12-22-18-32-38-43-finally_something_alive/processed/x" + targetXPosition + "/";

setBatchMode(true);

fileList = getFileList(sourcePath);

for (i = 0; i < lengthOf(fileList); i++) {
	print("" + i + ":" + sourcePath + fileList[i]);
	//open(sourcePath + fileList[i]);
	run("Raw...", "open=" + sourcePath + fileList[i] + " image=[16-bit Unsigned] width=1024 height=2048 number=10000 little-endian");
	run("Properties...", "channels=1 slices=101 frames=1 unit=um pixel_width=" + pixelSizeX + " pixel_height=" + pixelSizeY + " voxel_depth=" + pixelSizeZ );
	
	
	setSlice(targetZPosition);
	run("Duplicate...", " ");
	saveAs("Tiff", targetZPath + fileList[i] + ".tif");
	close();

	getDimensions(width, height, _, _, _);
	makeLine(targetXPosition, 0, targetXPosition, height - 1);

	run("Reslice [/]...", "output=2.490 slice_count=1");

	saveAs("Tiff", targetXPath + fileList[i] + ".tif");
	close();

	close();

	if (i > maxTimePoint) {
		break;
	}
}

//selectWindow("000000.raw.tif");

//