# This is an experimentally generated python script. Not all commands are supposed to be executable yet.
# If you want to give it a try, create conda environment named te_oki:
#   `conda create --name te_oki` 
# activate the environment: 
#   `conda activate te_oki` 
# install dependencies: 
#   `pip install pyopencl napari ipython matplotlib numpy pyclesperanto_prototype scikit-image` 
# Also make sure conda is part of the PATH variable.
# 
# If you want to run it from Fiji and you're using a different conda environment, you can configure it in Fijis main menu 
# Plugins > ImageJ on GPU (CLIJx-Assistant) > Options >Conda configuration (Te Oki) 
# Furthermore, activate the scripting language Te Oki in Fijis script editor to run this script.

# Stay tuned and check out http://clesperanto.net to learn more.

# Generator version: 0.6.1.2

import pyclesperanto_prototype as cle
from tifffile import imread

import numpy as np
import matplotlib
import matplotlib.pyplot as plt


# Load image
image = imread("C:/Users/rober/AppData/Local/Temp/temp1645017784179.tif")

# Push C4-cell_culture_tom20-bcatenin-dapi-infection-1.tif to GPU memory
image_1 = cle.push_zyx(image)

# Copy
image_2 = cle.create_like(image_1);
cle.copy(image_1, image_2)
# show result
plt.imshow(image_2[46])
plt.show()


# Voronoi Otsu Labeling
image_3 = cle.create_like(image_2);
spot_sigma = 30.0;
outline_sigma = 10.0;
cle.voronoi_otsu_labeling(image_2, image_3, spot_sigma, outline_sigma)
# show result
cmap = matplotlib.colors.ListedColormap ( np.random.rand ( 256,3))
plt.imshow(image_3[49], cmap = cmap)
plt.show()


# Load image
image = imread("C:/Users/rober/AppData/Local/Temp/temp1645017963231.tif")

# Push C2-cell_culture_tom20-bcatenin-dapi-infection-1.tif to GPU memory
image_4 = cle.push_zyx(image)

# Copy
image_5 = cle.create_like(image_4);
cle.copy(image_4, image_5)
# show result
plt.imshow(image_5[45])
plt.show()


# Gaussian Blur3D
image_6 = cle.create_like(image_5);
sigma_x = 8.0;
sigma_y = 8.0;
sigma_z = 8.0;
cle.gaussian_blur(image_5, image_6, sigma_x, sigma_y, sigma_z)
# show result
plt.imshow(image_6[45])
plt.show()


# Threshold Mean
image_7 = cle.create_like(image_6);
cle.threshold_mean(image_6, image_7)
# show result
plt.imshow(image_7[27])
plt.show()


# Binary Fill Holes Slice By Slice
image_8 = cle.create_like(image_7);
cle.binary_fill_holes_slice_by_slice(image_7, image_8)
# show result
plt.imshow(image_8[27])
plt.show()


# Masked Voronoi Labeling
image_9 = cle.create_like(image_3);
cle.masked_voronoi_labeling(image_3, image_8, image_9)
# show result
cmap = matplotlib.colors.ListedColormap ( np.random.rand ( 256,3))
plt.imshow(image_9[49], cmap = cmap)
plt.show()

