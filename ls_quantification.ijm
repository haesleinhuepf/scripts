// CLIJ example macro: ls_quantifiaction.ijm
//
// Quantitative measurements in light sheet data
// of Tribolium embryos
//
// Author: Robert Haase, Daniela Vorkel
//         November 2019
// ---------------------------------------------

srcFolder = "X:/IMAGING/archive_data_good/2019-07-16-13-30-14-91-Pau_Tribolium_nGFP_pole_/stacks/C0opticsprefused/";
targetFolder = "D:/2019-07-16-13-30-14-91-Pau_Tribolium_nGFP_pole_/processed/";

// Init GPU
run("CLIJ Macro Extensions", "cl_device=");
Ext.CLIJ_clear();


resultingCSVFile = targetFolder + "results.csv";

if (File.exists(resultingCSVFile)) {
	File.delete(resultingCSVFile);
}

File.append("i," +
"filenane," + 
"boundingBoxX," + 
"boundingBoxY," + 
"boundingBoxZ," + 
"boundingBoxWidth," + 
"boundingBoxHeight," + 
"boundingBoxDepth," + 
"meanIntensity," + 
"maximumIntensity," + 
"standardDeviationIntensity," + 
"pixelCount", resultingCSVFile);


fileList = getFileList(srcFolder);
Array.sort(fileList);
for (i = 0; i < lengthOf(fileList); i += 1) {
//for (i = 0; i < 500; i += 1) {

	run ("Close All");
	run("Clear Results");
	Ext.CLIJ_clear();
	
	run("Raw...", "open=" + srcFolder + fileList[i] + " image=[16-bit Unsigned] width=1024 height=1024 number=1000 little-endian");
	run("32-bit");
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
	standardDeviationIntensity = getResult("StandardDeviation", nResults() - 1);

	meanProjection = "meanProjection";
	Ext.CLIJ_meanZProjection(input, meanProjection);

	File.append("" + i + "," + 
		        fileList[i] + "," + 
		        boundingBoxX + "," + 
				boundingBoxY + "," + 
				boundingBoxZ + "," + 
				boundingBoxWidth + "," + 
				boundingBoxHeight + "," + 
				boundingBoxDepth + "," + 
				meanIntensity + "," + 
				maximumIntensity + "," + 
				standardDeviationIntensity + "," + 
				pixelCount, resultingCSVFile);


	Ext.CLIJx_saveAsTIF(meanProjection, targetFolder + "meanProjection/" + fileList[i] + ".tif");
	
	
	

	//break;
}
run("Close All");
print("bye");

// Cleanup by the end
Ext.CLIJ_clear();
