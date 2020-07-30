input_folder = "C:/structure/data/2018-05-23-16-18-13-89-Florence_multisample/processed/tif/";
output_folder = "C:/structure/data/2018-05-23-16-18-13-89-Florence_multisample/processed/";

// Initialize GPU
run("CLIJ2 Macro Extensions", "cl_device=[Intel(R) UHD Graphics 620]");
Ext.CLIJ2_clear();

// go through all files in the input folder
filelist = getFileList(directory) 
for (i = 0; i < lengthOf(filelist); i++) {
    
    // if the file is a TIF, open them
    if (endsWith(filelist[i], ".tif")) { 
        // open image
        open(input_folder + File.separator + filelist[i]);

		// push image to GPU
		image1 = getTitle();
		Ext.CLIJ2_push(image1);
		close();
	
		// generate Maximum-Z-Projection 
		Ext.CLIJ2_maximumZProjection(image1, image2);

		// save result to disc
		Ext.CLIJ2_saveAsTIF(image2, output_folder + File.separator + filelist[i]);
		Ext.CLIJ2_clear();
    } 
}
