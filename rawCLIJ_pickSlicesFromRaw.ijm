targetZPosition = 51;
targetXPosition = 328;

pixelSizeX = 0.26;
pixelSizeY = 0.26;
pixelSizeZ = 3;

frame_delay = 5; //sec

sourcePath =  "C:/structure/data/sequential/";
targetZPath = "C:/structure/data/z/";
targetXPath = "C:/structure/data/x/";
targetMaxPath = "C:/structure/data/max/";

width = 1024;
height = 1024;

inputImage = "inputImage";

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
	
	run("Properties...", "channels=1 slices=" + slices + " frames=1 unit=um pixel_width=" + pixelSizeX + " pixel_height=" + pixelSizeY + " voxel_depth=" + pixelSizeZ );
	
	setSlice(targetZPosition);
	run("Duplicate...", " ");
	saveAs("Tiff", targetZPath + fileList[i] + ".tif");
	close();

	getDimensions(width, height, _, _, _);
	makeLine(targetXPosition, 0, targetXPosition, height - 1);

	run("Reslice [/]...", "output=" + pixelSizeZ + " slice_count=1");

	saveAs("Tiff", targetXPath + fileList[i] + ".tif");
	close();

	run("Select None");

	
	Ext.CLIJ_push(inputImage);	
	
	Ext.CLIJ_downsampleSliceBySliceHalfMedian(inputImage, "downsampled1");
	Ext.CLIJ_downsampleSliceBySliceHalfMedian("downsampled1", "downsampled");
	
	Ext.CLIJ_blur3DFast("downsampled", "blurred", 10.0, 10.0, 0.0);
	
	Ext.CLIJ_addImagesWeighted("downsampled", "blurred", "backgroundSubtracted", 1, -1);
	
	Ext.CLIJ_maximumZProjection("backgroundSubtracted", "maximum");
	
	Ext.CLIJ_pull("maximum");

	saveAs("Tiff", targetMaxPath + fileList[i] + ".tif");	

	close();
	break;
}

//selectWindow("000000.raw.tif");

//