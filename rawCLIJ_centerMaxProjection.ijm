targetZStartPosition = 45;
targetZEndPosition = 55;

pixelSizeX = 0.26;
pixelSizeY = 0.26;
pixelSizeZ = 3;

frame_delay = 5; //sec

sourcePath =  "C:/structure/data/2018-05-09-15-51-17-81-Manila_multisample/stacks/sequential/";
targetMaxPath = "C:/structure/data/temp/";

width = 1024;
height = 1024;

inputImage = "inputImage";
cropImage = "cropImage";

//setBatchMode(true);

fileList = getFileList(sourcePath);


run("CLIJ Macro Extensions", "cl_device=[]");
Ext.CLIJ_clear();


for (i = 0; i < lengthOf(fileList); i++) {
	print("" + i + ":" + sourcePath + fileList[i]);
	//open(sourcePath + fileList[i]);
	run("Raw...", "open=" + sourcePath + fileList[i] + " image=[16-bit Unsigned] width=" + width + " height=" + height + " number=10000 little-endian");
	rename(inputImage);
	
	getDimensions(width, height, channels, slices, frames);
	
	Ext.CLIJ_push(inputImage);	
	Ext.CLIJ_crop3D(inputImage, cropImage, 0, 0, targetZStartPosition, width, height, targetZEndPosition - targetZStartPosition + 1);
	
	Ext.CLIJ_downsampleSliceBySliceHalfMedian(cropImage, "downsampled1");
	Ext.CLIJ_downsampleSliceBySliceHalfMedian("downsampled1", "downsampled");
	
	Ext.CLIJ_blur3DFast("downsampled", "blurred", 10.0, 10.0, 0.0);
	
	Ext.CLIJ_addImagesWeighted("downsampled", "blurred", "backgroundSubtracted", 1, -1);
	
	Ext.CLIJ_maximumZProjection("backgroundSubtracted", "maximum");
	
	Ext.CLIJ_pull("maximum");

	saveAs("Tiff", targetMaxPath + fileList[i] + ".tif");	

	close();
	if (i > 10) {
		break;	
	}
}

//selectWindow("000000.raw.tif");

//