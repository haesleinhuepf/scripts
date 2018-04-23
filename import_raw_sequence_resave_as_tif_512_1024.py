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




folder = 'Y:/Robert/2018-04-23-17-58-32-93-Emsland_HyerDrive_Test/stacks/sequential/';
targetFolder = "F:/xxwing/2018-04-23-17-58-32-93-Emsland_HyerDrive_Test/processed/sequential/";

imageWidth=512;
imageHeight=1024;
imageDepth=81;
pixelWidth=0.52;
pixelHeight=0.52;
pixelDepth=3.0;



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
			    imp.close()
		    