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




folder = "C:/structure/data/2018-04-30-17-06-18-03-MexicoCity_multisample_imaging/stacks/sequential/";
targetFolder = "C:/structure/data/2018-04-30-17-06-18-03-MexicoCity_multisample_imaging/processed/sequential/";

imageWidth=1024;
imageHeight=1024;
imageDepth=65;
pixelWidth=0.52;
pixelHeight=0.52;
pixelDepth=5.0;

File(targetFolder).mkdirs();

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
		    