# This script allows importing an image sequence of raw files 
# from a folder. The user just needs to know/enter image width,
# height and depth.
#
# Author: Robert Haase, http://github.com/haesleinhuepf
# October 2017
#
#
#@File(style="directory") folder
#@int (value=512) imageWidth
#@int (value=512) imageHeight
#@int (value=101) imageDepth
#@double (value=0.52) pixelWidth
#@double (value=0.52) pixelHeight
#@double (value=2.49) pixelDepth


from ij import IJ;
from ij import ImageJ;
from ij import ImagePlus;
from ij.plugin import RGBStackMerge;

from java.io import File;
from java.util import ArrayList;


import os

print(folder)

images = [];

# load all images, collect them in a list
for root, directories, filenames in os.walk(folder.getAbsolutePath()):
    filenames.sort();
    for filename in filenames:
	    print(filename)
	    if (filename.endswith(".raw")):
		    if (not File(os.path.join(folder.getAbsolutePath(), filename + ".tif")).exists()):
			    IJ.run("Raw...", "open=[" + os.path.join(folder.getAbsolutePath(), filename) + "] image=[16-bit Signed] width=" + str(imageWidth) + " height=" + str(imageHeight) + " number=" + str(imageDepth) + " little-endian");
			    imp = IJ.getImage();
			    imp.getCalibration().pixelWidth = pixelWidth
			    imp.getCalibration().pixelHeight = pixelHeight
			    imp.getCalibration().pixelDepth = pixelDepth
			    IJ.saveAsTiff(imp, os.path.join(folder.getAbsolutePath(), filename + ".tif") )
			    imp.close()
		    