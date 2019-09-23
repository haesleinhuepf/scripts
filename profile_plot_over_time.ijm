
targetFolder = "C:/structure/data/Trib_Akanksha/profile_plot/"
targetImageFolder = "C:/structure/data/Trib_Akanksha/profile_plot_origin/"

getDimensions(width, height, channels, slices, frames)

xAxis = getProfile();
for (i = 0; i < lengthOf(xAxis); i++) {
	xAxis[i] = i;
}
width = lengthOf(xAxis);

for (i = 150; i < 300; i++) {
	Stack.setSlice(i);
	
	data = getProfile();
	
	Plot.create("Distance from center", "x", "Distance from center", xAxis, data);
	Plot.setLimits(0, width, 150, 250);
	Plot.show();
	save(targetFolder + "plot" + i);
	close();

	run("Duplicate...", " ");
	run("Restore Selection");
	run("Flatten");
	run("Scale...", "x=0.5 y=0.5 width=512 height=360 interpolation=Bilinear average create");
	save(targetImageFolder + "img" + i);
	close();
	close();
	close();


	//break;
}
