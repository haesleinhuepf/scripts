// ImageJ macro making a tilted movie out of stack
// uses shear transform + rotation
// This is the GPU-accelerated version of the original. 
// Activate the clij update site to get GPU support and 
// make this macro run.
// 
// Eugene Katrukha katpyxa at gmail.com
// Robert Haase rhaase at mpi-cbg.de
requires("1.48h");

time = getTime();

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

// save LUT for later
getLut(reds, greens, blues);

// reserve the right amount of memory for the result image
getDimensions(width, height, channels, depth, frames);
newImage(sMovieTitle, "32-bit black", width, height, nSteps);

// init GPU
run("CLIJ Macro Extensions", "cl_device=");
Ext.CLIJ_clear();

// send images to GPU
Ext.CLIJ_push(init);
Ext.CLIJ_push(sMovieTitle);


bNotFirstIt=false;
print("Starting movie generation...");
for (i=0;i<nSteps;i++)
{
	// shearing
	Ext.CLIJ_affineTransform(init, "tempStack", 
				"shearXZ=" + (nCurrStepX / nSlices) +
				" shearYZ=" + (nCurrStepY / nSlices) 
				); 
				
	// maximum projection
	Ext.CLIJ_maximumZProjection("tempStack", "plane1");

	//adding some rotation
	Ext.CLIJ_rotate2D("plane1", "plane2", nCurrRotAngle, true);

	// copy the slice in the result stack
	Ext.CLIJ_copySlice("plane2", sMovieTitle, i);

	nCurrStepX=nCurrStepX+nStepX;
	nCurrStepY=nCurrStepY+nStepY;
	nCurrRotAngle= nCurrRotAngle+nRotStep;
	
	print("Frame " +toString(i+1) +" out of "+toString(nSteps));
}
// get result back grom GPU
Ext.CLIJ_pull(sMovieTitle);

// copy over LUT from original
setLut(reds, greens, blues);
setBatchMode(false);
print("Done");

print("It took " + (getTime() - time) + " msec");