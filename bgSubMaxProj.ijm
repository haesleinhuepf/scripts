rename("original");

run("CLIJ Macro Extensions", "cl_device=[Intel(R) UHD Graphics 620]");
Ext.CLIJ_push("original");

Ext.CLIJ_downsampleSliceBySliceHalfMedian("original", "downsampled");

Ext.CLIJ_blur3DFast("downsampled", "blurred", 10.0, 10.0, 0.0);

Ext.CLIJ_addImagesWeighted("downsampled", "blurred", "backgroundSubtracted", 1, -1);

Ext.CLIJ_maximumZProjection("backgroundSubtracted", "maximum");

Ext.CLIJ_pull("maximum");
