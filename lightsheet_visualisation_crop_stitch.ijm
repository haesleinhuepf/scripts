step = 9 * 420
height = 512

mainImage = getTitle();

makeRectangle(0 * step, 0, step, height);
run("Duplicate...", "duplicate");
tileA = getTitle();

selectWindow(mainImage);
makeRectangle(1 * step, 0, step, height);
run("Duplicate...", "duplicate");
tileB = getTitle();

selectWindow(mainImage);
makeRectangle(2 * step, 0, step, height);
run("Duplicate...", "duplicate");
tileC = getTitle();

//selectWindow(mainImage);
//makeRectangle(3 * step, 0, step, height);
//run("Duplicate...", "duplicate");
//tileD = getTitle();

run("Combine...", "stack1=[" + tileA + "] stack2=[" + tileB + "] combine");
run("Combine...", "stack1=[Combined Stacks] stack2=[" + tileC + "] combine");
//run("Combine...", "stack1=[Combined Stacks] stack2=[" + tileD + "] combine");



