# To make this script run in Fiji, please activate 
# the clij and clij2 update sites in your Fiji 
# installation. Read more: https://clij.github.io

# Generator version: 2.5.1.4

from ij import IJ
from ij import WindowManager
from net.haesleinhuepf.clijx import CLIJx

# Init GPU
clijx = CLIJx.getInstance()

# Load image from disc 
imp = IJ.openImage("C:/Users/rober/AppData/Local/Temp/temp1645017784179.tif")
# Push C4-cell_culture_tom20-bcatenin-dapi-infection-1.tif to GPU memory
image_1 = clijx.push(imp);

# Copy
image_2 = clijx.create(image_1)
clijx.copy(image_1, image_2)
image_1.close()

result = clijx.pull(image_2)
result.setDisplayRange(0.0, 28998.54296875)
result.show()

# Voronoi Otsu Labeling
image_3 = clijx.create(image_2)
spot_sigma = 30.0
outline_sigma = 10.0
clijx.voronoiOtsuLabeling(image_2, image_3, spot_sigma, outline_sigma)
image_2.close()

result = clijx.pull(image_3)
result.setDisplayRange(0.0, 4.0)
IJ.run(result, "glasbey_on_dark", "")
result.show()

# Load image from disc 
imp = IJ.openImage("C:/Users/rober/AppData/Local/Temp/temp1645017963231.tif")
# Push C2-cell_culture_tom20-bcatenin-dapi-infection-1.tif to GPU memory
image_4 = clijx.push(imp);

# Copy
image_5 = clijx.create(image_4)
clijx.copy(image_4, image_5)
image_4.close()

result = clijx.pull(image_5)
result.setDisplayRange(6.0, 20871.234375)
result.show()

# Gaussian Blur3D
image_6 = clijx.create(image_5)
sigma_x = 8.0
sigma_y = 8.0
sigma_z = 8.0
clijx.gaussianBlur3D(image_5, image_6, sigma_x, sigma_y, sigma_z)
image_5.close()

result = clijx.pull(image_6)
result.setDisplayRange(195.76840209960938, 6804.9501953125)
result.show()

# Threshold Mean
image_7 = clijx.create(image_6)
clijx.thresholdMean(image_6, image_7)
image_6.close()

result = clijx.pull(image_7)
result.setDisplayRange(0.0, 1.0)
result.show()

# Binary Fill Holes Slice By Slice
image_8 = clijx.create(image_7)
clijx.binaryFillHolesSliceBySlice(image_7, image_8)
image_7.close()

result = clijx.pull(image_8)
result.setDisplayRange(0.0, 1.0)
result.show()

# Masked Voronoi Labeling
image_9 = clijx.create(image_3)
clijx.maskedVoronoiLabeling(image_3, image_8, image_9)
image_3.close()
image_8.close()

result = clijx.pull(image_9)
result.setDisplayRange(0.0, 4.0)
IJ.run(result, "glasbey_on_dark", "")
result.show()
image_9.close()

