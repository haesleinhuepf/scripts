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
		    images.append(imp);
		    imp.hide();

# merge all images as channels
merged = RGBStackMerge.mergeChannels(images, False);
merged.show();

# switch channels and frames
IJ.run(merged,"Re-order Hyperstack ...", "channels=[Frames (t)] slices=[Slices (z)] frames=[Channels (c)]");
merged = IJ.getImage()

# fix Lookup table
IJ.run(merged, "Grays", "");

