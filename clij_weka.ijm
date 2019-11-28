// CLIJ example macro: clij_weka.ijm
//
// This macro shows how to apply a WEKA model using
// clijs plugin mechanism from macro.
//
// Author: Robert Haase
//         November 2019
// ---------------------------------------------
run("Close All");

// Get test data
run("Blobs (25K)");
input = getTitle();
getDimensions(width, height, channels, slices, frames);

wekaResult = "wekaResult";

// Init GPU
run("CLIJ Macro Extensions", "cl_device=");
Ext.CLIJ_clear();

// push images to GPU
Ext.CLIJ_push(input);

// cleanup ImageJ
run("Close All");

Ext.WEKA_applyWEKAModel(input, wekaResult, "C:/structure/models/clij_blobs_classifier.model");

// Get results back from GPU
Ext.CLIJ_pull(wekaResult);

// Cleanup by the end
Ext.CLIJ_clear();
