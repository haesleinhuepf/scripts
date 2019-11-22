

//relevant_start_frame = 615;
//input_folder = "C:/structure/data/2019-10-28-17-22-59-23-Finsterwalde_Tribolium_nGFP/";

//relevant_start_frame = 280;
//input_folder = "C:/structure/data/2019-11-13-12-26-11-88-Wolgast_Tribolium_nGFP_TMR/";


relevant_start_frame = 280;
input_folder = "\\\\fileserver.mpi-cbg.de\\myersspimdata\\IMAGING\\archive_data_good\\2019-11-13-12-26-11-88-Wolgast_Tribolium_nGFP_TMR\\";
sessionName = "Wolgast";

datasetname = "C0opticsprefused";

frame_delay_in_seconds = 10 * 60;
number_of_frames = 100;

tolerance_in_seconds = 1;

// determine 
thumbnails_folder = input_folder + "stacks/thumbnails_sb_text/";

// Init GPU
run("CLIJ Macro Extensions", "cl_device=");
Ext.CLIJ_clear();

// initialisation
slice_count = 0;
stack = "stack";
slice = "slice";
start_time = 0;

// read image folder and meta data files
thumbnails = getFileList(thumbnails_folder);
Array.sort(thumbnails);
table = File.openAsString(input_folder + datasetname + ".index.txt");
lines = split(table, "\n");
for (l = relevant_start_frame; l < lengthOf(lines); l += 1) {
	columns = split(lines[l]);
	frame = parseInt(columns[0]);
	time = parseFloat(columns[1]);
	width = parseInt(replace(columns[2], ",", ""));
	height = parseInt(replace(columns[3], ",", ""));
	depth = parseInt(columns[4]);

	//print("frame " + frame);
	//print("time " + time);
	//print("width " + width);
	//print("height " + height);
	//print("depth " + depth);
	
	if (slice_count == 0) {
		Ext.CLIJ_create3D(stack, width / 2, height / 2, number_of_frames, 8);
		start_time = time;
	}

	currently_searched_time = start_time + slice_count * frame_delay_in_seconds;

	// if frame is from right time, put it in the stack
	if (time > currently_searched_time || abs(time - currently_searched_time) < tolerance_in_seconds ) {
		filename = thumbnails[l];
		// print(thumbnails_folder + filename);
		Ext.CLIJx_readImageFromDisc(slice, thumbnails_folder + filename);
		Ext.CLIJ_copySlice(slice, stack, slice_count);
		Ext.CLIJ_release(slice);
		
		slice_count = slice_count + 1;
		print(slice_count);
		if (slice_count >= number_of_frames) {
			break;
		}
	}
	//break;
}

Ext.CLIJ_pull(stack);
rename(sessionName + "_temp_aligned";

Ext.CLIJ_clear();

