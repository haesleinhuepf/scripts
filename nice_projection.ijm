// ImageJ macro making a tilted movie out of stack
// uses shear transform + rotation
// This is the GPU-accelerated version of the original. 
// Activate the clij update site to get GPU support and 
// make this macro run.
// 
// Eugene Katrukha katpyxa at gmail.com
// Robert Haase rhaase at mpi-cbg.de
requires("1.48h");

sTitle=getTitle();
sMovieTitle=sTitle+"_tilt_movie";
setBatchMode(true);

//Dialog

	Dialog.create("Tilt parameters:");
	Dialog.addNumber("Tilt angle in X (deg):", 20);
	Dialog.addNumber("Tilt angle in Y (deg):", -20);
	Dialog.addNumber("Rotation angle (deg):", 15); 
	Dialog.addNumber("Number of movie frames:", 40); 	
	sZChoice=newArray("Last frame is top","First frame is top");
	Dialog.addChoice("Z direction:", sZChoice); 
	Dialog.show();
	nCurrStepX=Dialog.getNumber();
	nCurrStepY=Dialog.getNumber();
	nCurrRotAngle=0.5*Dialog.getNumber();
	nSteps=Dialog.getNumber();
	sChoice=Dialog.getChoice();


nStepX=(-2)*nCurrStepX/nSteps;
nStepY=(-2)*nCurrStepY/nSteps;
//nRotationRange = 20;

nRotStep = (-2.0)*nCurrRotAngle/nSteps;

init=getTitle();

// reserve the right amount of memory for the result image
getDimensions(width, height, channels, depth, frames);
newImage("target", "32-bit black", width, height, nSteps);
newImage("plane1", "32-bit black", width, height, 1);
newImage("plane2", "32-bit black", width, height, 1);
newImage("tempStack", "32-bit black", width, height, depth);


// init GPU
run("CLIJ Macro Extensions", "cl_device=");
Ext.CLIJ_clear();

Ext.CLIJ_push(init);
Ext.CLIJ_push("target");
Ext.CLIJ_push("plane1");
Ext.CLIJ_push("plane2");
Ext.CLIJ_push("tempStack");


bNotFirstIt=false;
print("Starting movie generation...");
for (i=0;i<nSteps;i++)
{
	
	for (j=0;j<nSlices;j++)
	{
		//making shear transform with respect to stack center
		dx=2.*((j-nSlices*0.5)*nCurrStepX/nSlices);
		dy=2.*((j-nSlices*0.5)*nCurrStepY/nSlices);
		
		// cut out slice
		Ext.CLIJ_copySlice(init, "plane1", j);
		// translate the plane
		Ext.CLIJ_translate2D("plane1", "plane2", dx, dy);
		// copy slice back
		Ext.CLIJ_copySlice("plane2", "tempStack", j);
	}
	//Ext.CLIJ_affineTransform(init, "tempStack", "center rotateX=" + nCurrStepX + " rotateY=" + nCurrStepY + " -center");
	
	//adding some rotation
	Ext.CLIJ_maximumZProjection("tempStack", "plane1");
	Ext.CLIJ_rotate2D("plane1", "plane2", nCurrRotAngle, true);

	// copy the slice in the result stack
	Ext.CLIJ_copySlice("plane2", "target", i);

	nCurrStepX=nCurrStepX+nStepX;
	nCurrStepY=nCurrStepY+nStepY;
	nCurrRotAngle= nCurrRotAngle+nRotStep;
	
	print("Frame " +toString(i+1) +" out of "+toString(nSteps));
}
Ext.CLIJ_pull("target");
setBatchMode(false);
print("Done");