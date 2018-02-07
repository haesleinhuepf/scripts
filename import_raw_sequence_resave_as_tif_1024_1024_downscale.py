# This script allows importing an image sequence of raw files 
# from a folder. The user just needs to know/enter image width,
# height and depth.
#
# Author: Robert Haase, http://github.com/haesleinhuepf
# October 2017
#


from ij import IJ;
from ij import ImageJ;
from ij import ImagePlus;
from ij.plugin import RGBStackMerge;

from java.io import File;
from java.util import ArrayList;

import os




folder = 'Y:/Robert/2018-02-07-14-45-13-50-Robert_Cross_moving_agarose_through_FOV_in_X_withLED/stacks/C0L3/';
targetFolder = "F:/xxwing/2018-02-07-14-45-13-50-Robert_Cross_moving_agarose_through_FOV_in_X_withLED/processed/tif/C0L3/";
topProjectFolder = "F:/xxwing/2018-02-07-14-45-13-50-Robert_Cross_moving_agarose_through_FOV_in_X_withLED/processed/topMaxProject/C0L3/";

imageWidth=1024;
imageHeight=2048;
imageDepth=61;
pixelWidth=0.26;
pixelHeight=0.26;
pixelDepth=0.98360;



print(folder)

images = [];

# load all images, collect them in a list
for root, directories, filenames in os.walk(folder):
    filenames.sort();
    for filename in filenames:
	    print(filename)
	    if (filename.endswith(".raw")):
		    if (not File(os.path.join(targetFolder, filename + ".tif")).exists()):
				IJ.run("Raw...", "open=[" + os.path.join(folder, filename) + "] image=[16-bit Signed] width=" + str(imageWidth) + " height=" + str(imageHeight) + " number=" + str(imageDepth) + " little-endian");
				imp = IJ.getImage();
				imp.getCalibration().pixelWidth = pixelWidth
				imp.getCalibration().pixelHeight = pixelHeight
				imp.getCalibration().pixelDepth = pixelDepth
				
				IJ.saveAsTiff(imp, os.path.join(targetFolder, filename + ".tif") )
				
				IJ.run(imp,"Scale...", "x=0.25 y=0.25 z=1.0 width=" + str(imageWidth / 4) + " height=" + str(imageHeight / 4) + " depth=" + str(imageDepth) + " interpolation=Bilinear average process create");
				imp = IJ.getImage()
				
				IJ.run(imp, "Reslice [/]...", "output=" + str(pixelDepth) + " start=Top");
				imp = IJ.getImage()
				
				run("Z Project...", "projection=[Max Intensity]");
				imp = IJ.getImage()
				
				IJ.saveAsTiff(imp, os.path.join(topProjectFolder, filename + ".tif") );
				IJ.run("Close All");
print("bye");