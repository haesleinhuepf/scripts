// CLIJ example macro: ls_quantifiaction.ijm
//
// Quantitative measurements in light sheet data
// of Tribolium embryos
//
// Author: Robert Haase, Daniela Vorkel
//         November 2019
// ---------------------------------------------

srcFolder = "C:/structure/data/2019-07-24-16-01-00-07-Nantes_Tribolium_nGFP_pole/stacks/C0opticsprefused/";
targetFolder = "C:/Users/rhaase/Desktop/temp2/";

// Init GPU
run("CLIJ Macro Extensions", "cl_device=");
Ext.CLIJ_clear();


resultingCSVFile = targetFolder + "results.csv";

if (File.exists(resultingCSVFile)) {
	File.delete(resultingCSVFile);
}

File.append("boundingBoxX," + 
"boundingBoxY," + 
"boundingBoxZ," + 
"boundingBoxWidth," + 
"boundingBoxHeight," + 
"boundingBoxDepth," + 
"meanIntensity," + 
"maximumIntensity," + 
"varianceIntensity," + 
"pixelCount", resultingCSVFile);


fileList = getFileList(srcFolder);
//for (i = 0; i < lengthOf(fileList); i ++) {
for (i = 0; i < 500; i += 50) {

	run ("Close All");
	run("Clear Results");
	
	run("Raw...", "open=" + srcFolder + fileList[i] + " image=[16-bit Unsigned] width=1024 height=1024 number=1000 little-endian");
	rename("original");
	input = getTitle();
	
	time = getTime();
	
	// push images to GPU
	Ext.CLIJ_push(input);

	binary = "binary";
	Ext.CLIJ_automaticThreshold(input, binary, "Otsu");

	Ext.CLIJx_boundingBox(binary);
	boundingBoxX = getResult("BoundingBoxX", nResults() - 1);
	boundingBoxY = getResult("BoundingBoxY", nResults() - 1);
	boundingBoxZ = getResult("BoundingBoxZ", nResults() - 1);
	boundingBoxWidth = getResult("BoundingBoxWidth", nResults() - 1);
	boundingBoxHeight = getResult("BoundingBoxHeight", nResults() - 1);
	boundingBoxDepth = getResult("BoundingBoxDepth", nResults() - 1);

	Ext.CLIJ_sumOfAllPixels(binary);
	pixelCount = getResult("Sum", nResults() - 1);

	Ext.CLIJ_meanOfAllPixels(input);
	meanIntensity = getResult("Mean", nResults() - 1);

	Ext.CLIJ_maximumOfAllPixels(input);
	maximumIntensity = getResult("Max", nResults() - 1);

	Ext.CLIJx_standardDeviationOfAllPixels(input);
	varianceIntensity = getResult("Variance", nResults() - 1);

	meanProjection = "meanProjection";
	Ext.CLIJ_meanZProjection(input, meanProjection);

	File.append(boundingBoxX + "," + 
				boundingBoxY + "," + 
				boundingBoxZ + "," + 
				boundingBoxWidth + "," + 
				boundingBoxHeight + "," + 
				boundingBoxDepth + "," + 
				meanIntensity + "," + 
				maximumIntensity + "," + 
				varianceIntensity + "," + 
				pixelCount, resultingCSVFile);


	Ext.CLIJx_saveAsTIF(meanProjection, targetFolder + "meanProjection/" + fileList[i] + ".tif");
	
	
	

	break;
}
run("Close All");
print("bye");

// Cleanup by the end
Ext.CLIJ_clear();
