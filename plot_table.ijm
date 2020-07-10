// Example macro for drawing plots out of results tables
// The plots are made as video which builds up the plot
//
// Author: Robert Haase, rhaase@mpi-cbg.e
//         July 2020
// License: Public domain
// -----------------------------------------------------

// get some measuremnts in the results table
run("Blobs (25K)");
setAutoThreshold("Huang");
//run("Convert to Mask");
run("Set Measurements...", "mean redirect=None decimal=3");
run("Clear Results");
run("Analyze Particles...", "display");

// determine a temporary directory
temp_dir = getDirectory("temp");
temp_dir = temp_dir + "/mytemp" + getTime() + "/";
File.makeDirectory(temp_dir);
print(temp_dir);

// generate two arrays with the full table content to plot in X and Y
all_y_values = Table.getColumn("Mean");
all_x_values = newArray(lengthOf(all_y_values));
for (i = 0; i < lengthOf(all_x_values); i++) {
	all_x_values[i] = i;
}

// determine axes min/max
Array.getStatistics(all_x_values, min_x, max_x);
Array.getStatistics(all_y_values, min_y, max_y);

// go through the table and plot it
for (t = 1; t < nResults(); t++ ) {
	x_values = Array.slice(all_x_values, 0, t);
	y_values = Array.slice(all_y_values, 0, t);

	// draw the plot
	Plot.create("Title", "X-axis Label", "Y-axis Label", x_values, y_values);
	Plot.setLimits(min_x, max_x, min_y, max_y);
	Plot.show();

	// generate a numeric filename
	filename = "00000" + t;
	filename = substring(filename, lengthOf(filename) - 6);
	filename = temp_dir + filename + ".tif";

	// save the image
	saveAs("Tif", filename);

	// clean up
	close();
}

// reopen all plots as image sequence
run("Image Sequence...", "open=[" + temp_dir + "] sort");

// clean up temporary directory
filelist = getFileList(temp_dir) 
for (i = 0; i < lengthOf(filelist); i++) {
    File.delete(temp_dir + filelist[i]); 
}
File.delete(temp_dir);



