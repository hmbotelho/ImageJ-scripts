//
//   Hugo M Botelho
//   hmbotelho@fc.ul.pt
//
//   Configure Leica Multipositions
//   v 1.0
//   July 2014
// 
//
//   This macro assists the user finding optimal parameters for setting up multiposition imaging
//   on the Leica DMI 6000B microscope.
//
//   This macro offers a visual representation of where the imaging fields will be placed
//   within the each well of a multiwell plate. It also allows examining the effects of
//   changing the number of imaging filds and field spacing.


FieldWidth = 1330.55;
FieldHeight = 1330.55;
FieldsX = 4;
FieldsY = 4;
WellSizeX = 6312.575;
WellSizeY = 6320.6975;
FieldSpaceX = 100;
FieldSpaceY = 100;
shapes = newArray ("Circle","Rectangle");
WellShape = shapes[0];
print("\\Clear");


	do {
		Dialog.create("This is one well");
		Dialog.addMessage("All measures must be in microns.");
		Dialog.addRadioButtonGroup("Well shape", shapes, 2, 1, WellShape);

		Dialog.addMessage("Well size:");
		Dialog.addNumber("Width",WellSizeX);
		Dialog.addNumber("Height",WellSizeY);

		Dialog.addMessage("Size of your image field:");
		Dialog.addNumber("Width",FieldWidth);
		Dialog.addNumber("Height",FieldHeight);

		Dialog.addMessage("Number of fields:");
		Dialog.addSlider("X", 1, 2*FieldsX-1, FieldsX);
		Dialog.addSlider("Y", 1, 2*FieldsY-1, FieldsY);

		Dialog.addMessage("Field separation:");
		Dialog.addSlider("X", 1, 2*FieldSpaceX-1, FieldSpaceX);
		Dialog.addSlider("Y", 1, 2*FieldSpaceY-1, FieldSpaceY);

		Dialog.show();

		WellShape = Dialog.getRadioButton();
		WellSizeX = Dialog.getNumber();
		WellSizeY = Dialog.getNumber();
		FieldWidth = Dialog.getNumber();
		FieldHeight = Dialog.getNumber();
		FieldsX = Dialog.getNumber();
		FieldsY = Dialog.getNumber();
		FieldSpaceX = Dialog.getNumber();
		FieldSpaceY = Dialog.getNumber();
	
		
		close("This is one well");
		newImage("Untitled", "RGB Color", WellSizeX, WellSizeY, 1);
		rename("This is one well");
		run("Select All");
		setForegroundColor(0, 0, 0);
		run("Fill", "slice");
		if (WellShape == "Circle"){
			makeOval(0, 0, WellSizeX, WellSizeY);
		} else{
			makeRectangle(0, 0, WellSizeX, WellSizeY);
		}
		
		setForegroundColor(255, 255, 255);
		run("Fill", "slice");
		setForegroundColor(200, 100, 50);

		for (y=0 ; y<FieldsY ; y++){
			if (isEven(FieldsY)){
				Y0 = 0.5*WellSizeY - 0.5*FieldSpaceY - FieldHeight - 0.5*(FieldsY-2)*(FieldHeight+FieldSpaceY) + y*(FieldHeight+FieldSpaceY);
			}else{
				Y0 = WellSizeY/2 - 0.5*FieldHeight - 0.5*(FieldsY-1)*(FieldHeight+FieldSpaceY) + y*(FieldHeight+FieldSpaceY);
			}

			for (x=0 ; x<FieldsX ; x++){
				if (isEven(FieldsX)){
					X0 = 0.5*WellSizeX - 0.5*FieldSpaceX - FieldWidth - 0.5*(FieldsX-2)*(FieldWidth+FieldSpaceX) + x*(FieldWidth+FieldSpaceX);
				}else{
					X0 = WellSizeX/2 - 0.5*FieldWidth - 0.5*(FieldsX-1)*(FieldWidth+FieldSpaceX) + x*(FieldWidth+FieldSpaceX);
				}
		
				makeRectangle(X0, Y0, FieldWidth, FieldHeight);
				run("Fill", "slice");
				run("Select None");
			}
		}
	
		print("______________________________");
		print("Fields per well:  ", FieldsX, "x", FieldsY);
		print("Scan Field Distance (X):  ", (FieldSpaceX+FieldWidth));
		print("Scan Field Distance (Y):  ", (FieldSpaceY+FieldHeight));
	
	
	} while (true);











function isEven (number){
	if (number%2 == 0){
		return true;
	}else{
		return false
	}
}