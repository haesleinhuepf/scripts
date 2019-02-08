//ImageJ macro making a tilted movie out of stack
//uses shear transform + rotation
//Eugene Katrukha katpyxa at gmail.com
requires("1.48h");

sTitle=getTitle();
sMovieTitle=sTitle+"_tilt_movie";
setBatchMode(true);

//Dialog

	Dialog.create("Tilt parameters:");
	Dialog.addNumber("Tilt radius in X (px):", 20);
	Dialog.addNumber("Tilt radius in Y (px):", -20);
	Dialog.addNumber("Rotation angle:", 15); 
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

init=getImageID();

bNotFirstIt=false;
print("Starting movie generation...");
for (i=0;i<nSteps;i++)
{
	run("Duplicate...", "duplicate");
	copyx=getImageID();

	for (j=0;j<nSlices;j++)
	{
		if(startsWith(sChoice, "Last"))
		{	setSlice(nSlices-j);}
			else {
		setSlice(j+1);}
		//making shear transform with respect to stack center
		dx=2.*((j-nSlices*0.5)*nCurrStepX/nSlices);
		dy=2.*((j-nSlices*0.5)*nCurrStepY/nSlices);
		
		runstring="x="+toString(dx)+" y="+toString(dy)+" interpolation=Bilinear slice";
		run("Translate...", runstring);

	}
	
	//adding some rotation
	run("Z Project...", "projection=[Max Intensity]");
	runstring="angle="+toString(nCurrRotAngle)+" grid=1 interpolation=Bicubic";
	run("Rotate... ", runstring);
	if(bNotFirstIt)
	{
			sCurrTitle=sTitle+"_frame"+toString(i);
			rename(sCurrTitle);
			run("Concatenate...", "  title=["+sMovieTitle+"] image1=["+sMovieTitle+"] image2=["+sCurrTitle+"]");
			sMovieID=getImageID();
	}
	else
	{
		rename(sMovieTitle);
		sMovieID=getImageID();
		bNotFirstIt=true;
	}
	//updating rotate/shear counters
	nCurrStepX=nCurrStepX+nStepX;
	nCurrStepY=nCurrStepY+nStepY;
	nCurrRotAngle= nCurrRotAngle+nRotStep;
	
	selectImage(copyx);
	close();
	selectImage(init);
	print("Frame " +toString(i+1) +" out of "+toString(nSteps));
}
selectImage(sMovieID);
setBatchMode(false);
print("Done");