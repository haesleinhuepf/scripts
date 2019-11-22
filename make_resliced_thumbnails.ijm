
input_folder = "\\\\fileserver.mpi-cbg.de\\myersspimdata\\IMAGING\\archive_data_good\\2019-07-24-16-01-00-07-Nantes_Tribolium_nGFP_pole\\";
sessionName = "Nantes";

print("\\Clear");
print(sessionName);

datasetname = "C0opticsprefused";

stack_folder = input_folder + "stacks/" + datasetname + "/";

output_folder = input_folder + "processed/side_thumbnails/";

// Init GPU
run("CLIJ Macro Extensions", "cl_device=");
Ext.CLIJ_clear();

// read meta data
table = File.openAsString(input_folder + datasetname + ".index.txt");
lines = split(table, "\n");
columns = split(lines[0]);
//frame = parseInt(columns[0]);
//time = parseFloat(columns[1]);
width = parseInt(replace(columns[2], ",", ""));
height = parseInt(replace(columns[3], ",", ""));
depth = parseInt(columns[4]);

voxelWidth = 0;
voxelHeight = 0;
voxelDepth = 0;

table = File.openAsString(input_folder + datasetname + ".metadata.txt");
lines = split(table, "\n");
firstline = lines[0];
firstline = replace(firstline, "\\{", "");
firstline = replace(firstline, "\\}", "");

columns = split(firstline, ",");
for (i = 0; i < lengthOf(columns); i++) {
	//print(columns[i]);
	splittedLine = split(columns[i], ":");
	key = splittedLine[0];
	value = splittedLine[1];

	if (startsWith(key, "\"VoxelDimX")) {
		voxelWidth = parseFloat(value);
	} else if (startsWith(key, "\"VoxelDimY")) {
		voxelHeight = parseFloat(value);
	} else if (startsWith(key, "\"VoxelDimZ")) {
		voxelDepth = parseFloat(value);
	}
}


//print("frame " + frame);
//print("time " + time);
print("width " + width);
print("height " + height);
print("depth " + depth);
print("voxelWidth " + voxelWidth);
print("voxelHeight " + voxelHeight);
print("voxelDepth " + voxelDepth);

// read image folder and meta data files
stackFiles = getFileList(stack_folder);
Array.sort(stackFiles);




input = "input";
resliced = "resliced";
maxProjected = "maxProjected";
resampled = "resampled";

for (i = 0; i < lengthOf(stackFiles); i++) {
	Ext.CLIJx_readRawImageFromDisc(input, stack_folder + stackFiles[i], width, height, depth, 16);
	Ext.CLIJx_resample(input, resampled, voxelWidth, voxelHeight, voxelDepth, false);
	Ext.CLIJ_resliceLeft(resampled, resliced);
	Ext.CLIJ_maximumZProjection(resliced, maxProjected);
	//Ext.CLIJ_pull(maxProjected);
	Ext.CLIJx_saveAsTIF(maxProjected, output_folder + stackFiles[i] + ".tif");
	break;
	
}

Ext.CLIJ_reportMemory();
Ext.CLIJ_clear();

