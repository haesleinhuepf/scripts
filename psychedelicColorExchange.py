# this example ImageJ/Fiji jython script shows how to apply a
# custom OpenCL kernel to an image where channels are mixed
# in psychodelic ways
#
# Author: Robert Haase (@haesleinhuepf)
#         February 2020


from net.haesleinhuepf.clij import CLIJ;
from ij import IJ;
import os;
import inspect
from ij.plugin import HyperStackConverter;

IJ.run("Close All");

# retrieve the folder where this script is located (thanks to @mountain_man from the ImageJ forum)
filesPath = os.path.dirname(os.path.abspath(inspect.getsourcefile(lambda:0))) + "/"

# open an example image
imp = IJ.openImage("https://clij.github.io/clij-benchmarking/plotting_jmh/images/imagesize/clij_ij_comparison_BinaryAnd2D.png");
IJ.run(imp, "RGB Stack", "");
imp.show();
IJ.run(imp, "Make Composite", "display=Composite");

# initialize ClearCL context and convenience layer
clij = CLIJ.getInstance();
# initialize again to reset cached OpenCL kernels; 
# actually just necesssary if former execution crashed
clij.close();
clij = CLIJ.getInstance();

# convert ImagePlus image to CL images (ready for the GPU)
magic_number = 27 * 5;

input = clij.push(imp);
output = clij.create(input);
slice = clij.create([input.getWidth(), input.getHeight()], input.getNativeType());
stack = clij.create([input.getWidth(), input.getHeight(), input.getDepth() * magic_number], input.getNativeType());


for shift in range(0, magic_number):
	
	# apply a filter to the image using ClearCL / OpenCL
	parameters = {
		"src":input,
		"dst":output
,
		"shift":shift
	};
	clij.execute(filesPath + "psychedelicColorExchange.cl", "psychedelicColorExchange", parameters);

	for c in range(0, 3):
		clij.op().copySlice(output, slice, c);
		for d in range(0, 5):
			clij.op().copySlice(slice, stack, shift * 3 * 5 + d * 3 + c);
		
# convert the result back to ImagePlus and show it
result = clij.pull(stack);
result = HyperStackConverter.toHyperStack(result, 3, result.getNSlices() / 3, 1);
IJ.run(result, "Gaussian Blur 3D...", "x=0 y=0 z=1");

result.show();
IJ.run(result, "Make Composite", "display=Composite");

# clean up
input.close();
output.close();
slice.close();
stack.close();

clij.close();
