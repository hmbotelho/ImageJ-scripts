//
//   Hugo M Botelho
//   hmbotelho@fc.ul.pt
//
//   Change LUT to all open images
//   v 1.0
//   July 2014
// 
//
//   This macro allows selecting and applying the same LUT to all open images

if (nImages == 0) {
	exit("There are no open images");
}

LUTs = getList("LUTs");

Dialog.create("Apply the same LUT to all open images");
Dialog.addRadioButtonGroup("Which LUT to apply?", LUTs, 10, 4, LUTs[0]);
Dialog.show();
Target = Dialog.getRadioButton();

for (i = 1; i <= nImages; i++) {
    selectImage(i);
    run(Target);
}