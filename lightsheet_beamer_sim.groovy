import ij.IJ
import ij.gui.NewImage;

imp = NewImage.createByteImage("Demo", 160, 100, 160, NewImage.FILL_BLACK)
imp.show()



for (int x = 0; x < 160; x++) {
	imp.setZ(x + 1);
	ip = imp.getProcessor()	
	for (int y = 0; y < imp.getHeight(); y++) {
		ip.putPixelValue(x, y, 255);	
		ip.putPixelValue(x+1, y, 255);	
	}
}



















