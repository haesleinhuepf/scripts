
__kernel void psychodelicColorExchange(
       DTYPE_IMAGE_IN_3D src,
       DTYPE_IMAGE_OUT_3D dst, 
	   int shift
)
{
    const sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_NEAREST;

    int4 posR = {get_global_id(0), get_global_id(1), 0, 0};
    int4 posG = {get_global_id(0), get_global_id(1), 1, 0};
    int4 posB = {get_global_id(0), get_global_id(1), 2, 0};

    float r = READ_IMAGE_3D(src, sampler, posR).x;
    float g = READ_IMAGE_3D(src, sampler, posG).x;
    float b = READ_IMAGE_3D(src, sampler, posB).x;
	
	
	float ir = 255 - r;
	float ig = 255 - g;
	float ib = 255 - b;
	
	float arr[] = {ir, ig, ib};
	int index1 = 0;
	int index2 = 1;
	int index3 = 2;
	
	for (int i = 0; i < shift; i++) {
		index1 ++;
		if (index1 > 2) {
			index1 = 0;
			index2++;
			if (index2 > 2) {
				index2 = 0;
				index3++;
				if( index3 > 2) {
					index3 = 0;
				}
			}
		}
	}
	
	r = arr[index1];
	g = arr[index2];
	b = arr[index3];

	WRITE_IMAGE_3D(dst, posR, CONVERT_DTYPE_OUT(r));
	WRITE_IMAGE_3D(dst, posG, CONVERT_DTYPE_OUT(g));
	WRITE_IMAGE_3D(dst, posB, CONVERT_DTYPE_OUT(b));
}
