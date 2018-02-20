

sourcePath = "F:/xxwing/2018-02-14-17-26-57-76-Akanksha_nGFP/processed/tif/";
targetZPath = "F:/xxwing/2018-02-14-17-26-57-76-Akanksha_nGFP/processed/video_green_fire_blue_back/";

setBatchMode(true);

fileList = getFileList(sourcePath);

for (i = 0; i < lengthOf(fileList); i++) {
	if (!File.exists( targetZPath + fileList[i])) {
		print("" + i + ":" + sourcePath + fileList[i]);
		open(sourcePath + fileList[i]);
		
		setSlice(30);
		resetMinAndMax();
		// run("Reverse");
		run("Temporal-Color Code", "lut=[Green Fire Blue] start=76 end=151");
		saveAs("Tiff", targetZPath + fileList[i]);
		close();
		run("Close All");
	}
}
