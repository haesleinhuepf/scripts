List.set("k0", "C:/structure/data/2018-05-08-15-47-34-23-Seoul_Multisample_test/processed/thumbnails_back-1.tif");
List.set("k1", "C:/structure/data/2018-05-08-15-47-34-23-Seoul_Multisample_test/processed/thumbnails_back-2.tif");
List.set("k2", "C:/structure/data/2018-05-08-15-47-34-23-Seoul_Multisample_test/processed/thumbnails_back-3.tif");
List.set("k3", "C:/structure/data/2018-05-08-15-47-34-23-Seoul_Multisample_test/processed/thumbnails_back-4.tif");
List.set("k4", "C:/structure/data/2018-05-08-15-47-34-23-Seoul_Multisample_test/processed/thumbnails_back-5.tif");
List.set("k5", "C:/structure/data/2018-05-08-15-47-34-23-Seoul_Multisample_test/processed/thumbnails_back-6.tif");
List.set("k6", "C:/structure/data/2018-05-09-15-51-17-81-Manila_multisample/processed/thumbnails_back-1.tif");
List.set("k7", "C:/structure/data/2018-05-09-15-51-17-81-Manila_multisample/processed/thumbnails_back-2.tif");
List.set("k8", "C:/structure/data/2018-05-09-15-51-17-81-Manila_multisample/processed/thumbnails_back-3.tif");
List.set("k9", "C:/structure/data/2018-05-09-15-51-17-81-Manila_multisample/processed/thumbnails_back-4.tif");
List.set("k10", "C:/structure/data/2018-05-09-15-51-17-81-Manila_multisample/processed/thumbnails_back-5.tif");
List.set("k11", "C:/structure/data/2018-05-09-15-51-17-81-Manila_multisample/processed/thumbnails_back-6.tif");
List.set("k12", "C:/structure/data/2018-05-09-19-08-52-44-Karatschi_multisample/processed/thumbnails_back-1.tif");
List.set("k13", "C:/structure/data/2018-05-09-19-08-52-44-Karatschi_multisample/processed/thumbnails_back-2.tif");
List.set("k14", "C:/structure/data/2018-05-09-19-08-52-44-Karatschi_multisample/processed/thumbnails_back-3.tif");
List.set("k15", "C:/structure/data/2018-05-09-19-08-52-44-Karatschi_multisample/processed/thumbnails_back-4.tif");
List.set("k16", "C:/structure/data/2018-05-09-19-08-52-44-Karatschi_multisample/processed/thumbnails_back-5.tif");
List.set("k17", "C:/structure/data/2018-05-09-19-08-52-44-Karatschi_multisample/processed/thumbnails_back-6.tif");
List.set("k18", "C:/structure/data/2018-05-11-14-02-47-92-Kairo_multisample_stage_guessing/processed/thumbnails_back-1.tif");
List.set("k19", "C:/structure/data/2018-05-11-14-02-47-92-Kairo_multisample_stage_guessing/processed/thumbnails_back-2.tif");
List.set("k20", "C:/structure/data/2018-05-11-14-02-47-92-Kairo_multisample_stage_guessing/processed/thumbnails_back-3.tif");
List.set("k21", "C:/structure/data/2018-05-11-14-02-47-92-Kairo_multisample_stage_guessing/processed/thumbnails_back-4.tif");
List.set("k22", "C:/structure/data/2018-05-18-11-21-38-33-Manchester/processed/thumbnails_back-1.tif");
List.set("k23", "C:/structure/data/2018-05-18-11-21-38-33-Manchester/processed/thumbnails_back-2.tif");
List.set("k24", "C:/structure/data/2018-05-18-11-21-38-33-Manchester/processed/thumbnails_back-3.tif");
List.set("k25", "C:/structure/data/2018-05-18-11-21-38-33-Manchester/processed/thumbnails_back-4.tif");
List.set("k26", "C:/structure/data/2018-05-17-17-23-16-73-Silicon_Valley/processed/thumbnails_back-1.tif");
List.set("k27", "C:/structure/data/2018-05-17-17-23-16-73-Silicon_Valley/processed/thumbnails_back-2.tif");
List.set("k28", "C:/structure/data/2018-05-17-17-23-16-73-Silicon_Valley/processed/thumbnails_back-3.tif");
List.set("k29", "C:/structure/data/2018-05-17-17-23-16-73-Silicon_Valley/processed/thumbnails_back-4.tif");
List.set("k30", "C:/structure/data/2018-05-18-14-43-25-94-Usti_nad_Labem/processed/thumbnails_back-1.tif");
List.set("k31", "C:/structure/data/2018-05-18-14-43-25-94-Usti_nad_Labem/processed/thumbnails_back-2.tif");
List.set("k32", "C:/structure/data/2018-05-18-14-43-25-94-Usti_nad_Labem/processed/thumbnails_back-3.tif");
List.set("k33", "C:/structure/data/2018-05-23-16-18-13-89-Florence_multisample/processed/thumbnails_back-1.tif");
List.set("k34", "C:/structure/data/2018-05-23-16-18-13-89-Florence_multisample/processed/thumbnails_back-2.tif");
List.set("k35", "C:/structure/data/2018-05-23-16-18-13-89-Florence_multisample/processed/thumbnails_back-3.tif");

for (i = 0; i < 36; i++) {
	filename = List.get("k" + i);
	if (lengthOf(filename) > 0) {
		open(filename);
		title = getTitle();
		
	    getDimensions(width, height, channels, slices, frames);
	    run("Properties...", "channels=1 slices=1 frames=" + frames + " unit=microns pixel_width=0.52 pixel_height=0.52 voxel_depth=1");
		run("Enhance Contrast", "saturated=0.35");
		run("8-bit");
		run("Scale...", "x=0.5 y=0.5 z=1.0 width=" + (width / 2) + " height=" + (height / 2) + " depth=" + frames + " interpolation=Bilinear average process create");
		run("Scale Bar...", "width=100 height=2 font=10 color=White background=None location=[Lower Right] bold label");
		
		// save first frame	
		run("Duplicate...", "duplicate range=1-1");
		targetFilename = substring(filename, 0, lengthOf(filename) - 4) + "_1.gif";
		saveAs("Gif", targetFilename);	
		close();
	
		// save last (or 19th) frame
		if (frames > 19) {
			frames = 19;	
		}
		run("Duplicate...", "duplicate range=" + frames + "-" + frames);
		targetFilename = substring(filename, 0, lengthOf(filename) - 4) + "_last.gif";
		saveAs("Gif", targetFilename);
		close();
	
		// save animation
		targetFilename = substring(filename, 0, lengthOf(filename) - 4) + "_ani.gif";
		run("Duplicate...", "duplicate range=1-" + frames);
		run("Animated Gif ... ", "name=" + title + "_ani set_global_lookup_table_options=[Do not use] optional=[] image=[No Disposal] set=500 number=1000 transparency=[No Transparency] red=0 green=0 blue=0 index=0 filename=" + targetFilename);
		close();
		
		run("Close All");

	}	
}
