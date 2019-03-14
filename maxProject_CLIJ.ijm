sourceFolder = "Y:/Robert/2019-01-24-16-26-33-24-Cansas_moe_GFP/stacks/C0L2/";
targetFolder = "F:/temp/fly3/";
targetMaxFolder = "F:/temp/fly3_max/";


run("CLIJ Macro Extensions", "cl_device=[TITAN Xp]");
Ext.CLIJ_clear();

for (i = 0; i < 1778; i +=1 ) {

	if (i % 3 != 2 ) {
		if (i < 10) {
			targetfile = targetMaxFolder + "00000" + i + ".tif";
		} else if (i < 100) {
			targetfile = targetMaxFolder + "0000" + i + ".tif";
		} else if (i < 1000) {
			targetfile = targetMaxFolder + "000" + i + ".tif";
		} else {
			targetfile = targetMaxFolder + "00" + i + ".tif";
		}
		
		if ( !File.exists(targetfile)) {
			run("Close All");
		
			if (i < 10) {
				run("Raw...", "open=" + sourceFolder + "00000" + i + ".raw image=[16-bit Unsigned] width=1024 height=2048 number=10000 little-endian");
			} else if (i < 100) {
				run("Raw...", "open=" + sourceFolder + "0000" + i + ".raw image=[16-bit Unsigned] width=1024 height=2048 number=10000 little-endian");
			} else if (i < 1000) {
				run("Raw...", "open=" + sourceFolder + "000" + i + ".raw image=[16-bit Unsigned] width=1024 height=2048 number=10000 little-endian");
			} else {
				run("Raw...", "open=" + sourceFolder + "00" + i + ".raw image=[16-bit Unsigned] width=1024 height=2048 number=10000 little-endian");
			}
			
			//run("Properties...", "channels=1 slices=101 frames=1 unit=um pixel_width=0.26 pixel_height=0.26 voxel_depth=1");
		
			//if (i < 10) {
			//	saveAs("Tiff", targetFolder + "00000" + i + ".tif");
			//} else if (i < 100) {
			//	saveAs("Tiff", targetFolder + "0000" + i + ".tif");
			//} else {
			//	saveAs("Tiff", targetFolder + "000" + i + ".tif");
			//}
			
			rename("original");
			
			//run("Brightness/Contrast...");
			Ext.CLIJ_push("original");
			
			Ext.CLIJ_downsampleSliceBySliceHalfMedian("original", "temp");
			Ext.CLIJ_downsampleSliceBySliceHalfMedian("temp", "downsampled");
			
			Ext.CLIJ_blur3DFast("downsampled", "background", 5.0, 5.0, 0.0);
			
			Ext.CLIJ_addImagesWeighted("downsampled", "background", "backgroundSubtracted", 1.0, -1.0);
			
			Ext.CLIJ_maximumZProjection("backgroundSubtracted", "maximumProjected");
			
			Ext.CLIJ_pull("maximumProjected");
			
			run("Enhance Contrast", "saturated=0.35");
	
			saveAs("Tiff", targetfile);
		
		}
	}
}

