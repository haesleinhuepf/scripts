
targetZPosition = 30
targetXPosition = 256


sourcePath = "D:\\xxwing\\2017-11-29-15-42-38-92-Robert_nextsample_a_good_one\\tif\\";
targetZPath = "D:/xxwing/2017-11-29-15-42-38-92-Robert_nextsample_a_good_one/z" + targetZPosition + "/";
targetXPath = "D:/xxwing/2017-11-29-15-42-38-92-Robert_nextsample_a_good_one/x" + targetXPosition + "/";

setBatchMode(true);

fileList = getFileList(sourcePath);

for (i = 0; i < lengthOf(fileList); i++) {
	print("" + i + ":" + sourcePath + fileList[i]);
	open(sourcePath + fileList[i]);
	setSlice(targetZPosition);
	run("Duplicate...", " ");
	saveAs("Tiff", targetZPath + fileList[i]);
	close();

	getDimensions(width, height, _, _, _);
	makeLine(targetXPosition, 0, targetXPosition, height - 1);

	run("Reslice [/]...", "output=2.490 slice_count=1");

	saveAs("Tiff", targetXPath + fileList[i]);
	close();

	close();

	//if (i > 3) {
	//	break;
	//}
}

//selectWindow("000000.raw.tif");

//

