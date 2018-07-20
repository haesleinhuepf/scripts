List.set("k0", "C:/structure/data/2018-05-08-15-47-34-23-Seoul_Multisample_test/processed/thumbnails_back-1.tif");
//List.set("k1", "C:/structure/data/2018-05-08-15-47-34-23-Seoul_Multisample_test/processed/thumbnails_back-2.tif");
//List.set("k2", "C:/structure/data/2018-05-08-15-47-34-23-Seoul_Multisample_test/processed/thumbnails_back-3.tif");
//List.set("k3", "C:/structure/data/2018-05-08-15-47-34-23-Seoul_Multisample_test/processed/thumbnails_back-4.tif");
List.set("k4", "C:/structure/data/2018-05-08-15-47-34-23-Seoul_Multisample_test/processed/thumbnails_back-5.tif");
List.set("k5", "C:/structure/data/2018-05-08-15-47-34-23-Seoul_Multisample_test/processed/thumbnails_back-6.tif");
List.set("k6", "C:/structure/data/2018-05-09-15-51-17-81-Manila_multisample/processed/thumbnails_back-1.tif");
//List.set("k7", "C:/structure/data/2018-05-09-15-51-17-81-Manila_multisample/processed/thumbnails_back-2.tif");
List.set("k8", "C:/structure/data/2018-05-09-15-51-17-81-Manila_multisample/processed/thumbnails_back-3.tif");
List.set("k9", "C:/structure/data/2018-05-09-15-51-17-81-Manila_multisample/processed/thumbnails_back-4.tif");
//List.set("k10", "C:/structure/data/2018-05-09-15-51-17-81-Manila_multisample/processed/thumbnails_back-5.tif");
//List.set("k11", "C:/structure/data/2018-05-09-15-51-17-81-Manila_multisample/processed/thumbnails_back-6.tif");
//List.set("k12", "C:/structure/data/2018-05-09-19-08-52-44-Karatschi_multisample/processed/thumbnails_back-1.tif");
//List.set("k13", "C:/structure/data/2018-05-09-19-08-52-44-Karatschi_multisample/processed/thumbnails_back-2.tif");
List.set("k14", "C:/structure/data/2018-05-09-19-08-52-44-Karatschi_multisample/processed/thumbnails_back-3.tif");
List.set("k15", "C:/structure/data/2018-05-09-19-08-52-44-Karatschi_multisample/processed/thumbnails_back-4.tif");
//List.set("k16", "C:/structure/data/2018-05-09-19-08-52-44-Karatschi_multisample/processed/thumbnails_back-5.tif");
List.set("k17", "C:/structure/data/2018-05-09-19-08-52-44-Karatschi_multisample/processed/thumbnails_back-6.tif");
List.set("k18", "C:/structure/data/2018-05-11-14-02-47-92-Kairo_multisample_stage_guessing/processed/thumbnails_back-1.tif");
//List.set("k19", "C:/structure/data/2018-05-11-14-02-47-92-Kairo_multisample_stage_guessing/processed/thumbnails_back-2.tif");
List.set("k20", "C:/structure/data/2018-05-11-14-02-47-92-Kairo_multisample_stage_guessing/processed/thumbnails_back-3.tif");
List.set("k21", "C:/structure/data/2018-05-11-14-02-47-92-Kairo_multisample_stage_guessing/processed/thumbnails_back-4.tif");
//List.set("k22", "C:/structure/data/2018-05-18-11-21-38-33-Manchester/processed/thumbnails_back-1.tif");
List.set("k23", "C:/structure/data/2018-05-18-11-21-38-33-Manchester/processed/thumbnails_back-2.tif");
List.set("k24", "C:/structure/data/2018-05-18-11-21-38-33-Manchester/processed/thumbnails_back-3.tif");
//List.set("k25", "C:/structure/data/2018-05-18-11-21-38-33-Manchester/processed/thumbnails_back-4.tif");
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


//postfix = "_1.gif";
//postfix = "_last.gif";
postfix = "_ani.gif";

targetFile = "C:/structure/mpicloud/Projects/201808_Light_sheet_conference/thumbnails_back" + postfix;

for (i = 0; i < 36; i++) {
	title = "";
	if (i > 0) {
		title = getTitle();
	}
	
	filename = List.get("k" + i);
	if ( lengthOf(filename) > 0 ) {
		filename = substring(filename, 0, lengthOf(filename) - 4) + postfix;
		open(filename);
		run("Canvas Size...", "width=420 height=512 position=Center zero");
		
		if (i > 0) {
			run("Combine...", "stack1=[" + title + "] stack2=[" + getTitle() + "]");
		}
	}
}

saveAs("Gif", targetFile);	
close();

