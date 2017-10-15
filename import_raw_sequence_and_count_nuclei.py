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
			IJ.run("Raw...", "open=[" + os.path.join(folder.getAbsolutePath(), filename) + "] image=[16-bit Signed] width=" + str(imageWidth) + " height=" + str(imageHeight) + " number=" + str(imageDepth) + " little-endian");
			imp = IJ.getImage();
			
			IJ.run(imp, "Subtract Background...", "rolling=20 stack");
			IJ.run(imp, "Gaussian Blur...", "sigma=3 stack");
			IJ.run(imp, "HMaxima local maximum detection (2D, 3D)", "minimum=3 threshold=5");

			labelMap = IJ.getImage();
			print(labelMap.getTitle())
			imp.changes = False
			imp.close()
			labelMap.close()

			