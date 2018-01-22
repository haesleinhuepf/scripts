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




folder = 'F:/xxwing/2018-01-18-16-30-25-11-Robert_CalibZAP_Wfixed/stacks/default';

imageWidth=512;
imageHeight=1024;
imageDepth=111;
pixelWidth=0.52;
pixelHeight=0.52;
pixelDepth=1.981981981981982;



print(folder)

images = [];

# load all images, collect them in a list
for root, directories, filenames in os.walk(folder):
    filenames.sort();
    for filename in filenames:
	    print(filename)
	    if (filename.endswith(".raw")):
		    if (not File(os.path.join(folder, filename + ".tif")).exists()):
			    IJ.run("Raw...", "open=[" + os.path.join(folder, filename) + "] image=[16-bit Signed] width=" + str(imageWidth) + " height=" + str(imageHeight) + " number=" + str(imageDepth) + " little-endian");
			    imp = IJ.getImage();
			    imp.getCalibration().pixelWidth = pixelWidth
			    imp.getCalibration().pixelHeight = pixelHeight
			    imp.getCalibration().pixelDepth = pixelDepth
			    IJ.saveAsTiff(imp, os.path.join(folder, filename + ".tif") )
			    imp.close()
		    