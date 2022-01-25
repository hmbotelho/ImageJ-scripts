// === INITIALIZATION =====================================

//	 Hugo M Botelho, Pau Rubio Costa
//   hmbotelho@fc.ul.pt, prcosta@fc.ul.pt
//
//   Widefield FF & DF display
//
//   v 2.0
//   January 2022


//Set general options
#@ String (visibility=MESSAGE, value="Dark frame & Flat field correction") msg1
#@ String (visibility=MESSAGE, value="This macro allows you to apply dark frame and flat field background corrections to a specified set of images. It must have the correct syntax. See the readme file for more info.") msg2
#@ File (style="file", label="Settings file", description="Needs to have correct syntax: see the readme file and the example settings file") settingsFile
#@ File (style="file", label="Image correction file",  description="Needs to have correct syntax: see the readme file and the example correction file") imageFFDFfile
#@ File (style="directory", label="Saving folder", description="Here, your corrected files will be stored") targetfolder
#@ boolean (label="Allow zero background", description="If the background value in the settings file is 0 and this setting is selected, the macro will stop and let you measure the background value, so you can manually write it in the settings file and procced with the correction") allowZeroBg
#@ boolean (label="Save as PNG", description="Save a copy of your corrected images and/or crops in PNG format") savepng
#@ boolean (label="Crop", description="Crop your corrected images with the specified coordinates and dimensions") doCrop
#@ boolean (label="Preserve uncropped", description="Keep the uncropped background correction images") preserveUncropped
#@ boolean (label="Close crop", description="Close the cropped images at the end of the macro") closeCrop
#@ boolean (label="Close background correction", description="Close the corrected full images at the end of the macro") closeBgCorr
#@ boolean (label="Create a settings summary", description="Create a settings summary in the saving folder") settingsSummary

//aditional image corrections
Dialog.create("Additional image corrections");
Dialog.addMessage("Define image properties", 12);
Dialog.addString("Unit", "µm");
Dialog.addNumber("Pixel width", 1);
Dialog.addNumber("Pixel height", 1);
Dialog.addNumber("Voxel depth", 1);
Dialog.show();
unit = Dialog.getString();
Xsize = Dialog.getNumber();
Ysize = Dialog.getNumber();
Zsize = Dialog.getNumber();
//convert the size str to float
Xsize = parseFloat(Xsize);
Ysize = parseFloat(Ysize);
Zsize = parseFloat(Zsize);

//Crop dialog
	
Dialog.create("Crop settings");
Dialog.addMessage("Define your crop dimensions", 12);
Dialog.addNumber("ROI width", 100);
Dialog.addNumber("ROI Height", 100);
Dialog.show();
roiWidth = Dialog.getNumber();
roiHeight = Dialog.getNumber();

//process folder names
targetfolder = replace(targetfolder, "\\\\", "/");
if(!endsWith(targetfolder, "/")){
	targetfolder = targetfolder + "/";
}

// Also process other folder names
//Resulting images folder

imagefolder = targetfolder + File.separator + "Corrected_images";
File.makeDirectory(imagefolder);

//Cropped images folder
if (doCrop) {
	cropfolder = targetfolder + File.separator + "Crops";
	File.makeDirectory(cropfolder);		
}

//set batch mode
setBatchMode(false);
//Conversions
run("Conversions...", " ");	

//Read image correction DF and FF file
//open  and get info
print("\nStarting...");
ifilestring = File.openAsString(imageFFDFfile);
irows = split(ifilestring, "\n");
// Remove header
irows = Array.slice(irows,1,irows.length);


//Number of channels
nchannels = lengthOf(irows);
print(nchannels + " channels founded");

//preparete correction images arrays
DFarray = newArray();
FFarray = newArray();
WTDFarray = newArray();
WTFFarray = newArray();
LUTmins = newArray();
LUTmaxs= newArray();

//read file
for (j = 0; j < nchannels; j++) {
	linefields = split(irows[j], "\t");
	DFarray = Array.concat(DFarray, linefields[0]);
	FFarray = Array.concat(FFarray, linefields[1]);
	LUTmins = Array.concat(LUTmins, linefields[2]);
	LUTmaxs = Array.concat(LUTmaxs, linefields[3]);
}

//open all correction files 
for (d = 0; d < lengthOf(DFarray); d++) {
	open(DFarray[d]);
	windowtitle = File.getName(DFarray[d]);
	WTDFarray = Array.concat(WTDFarray,windowtitle);
}

for (f = 0; f < lengthOf(FFarray); f++) {
	open(FFarray[f]);
	windowtitle = File.getName(FFarray[f]);
	WTFFarray = Array.concat(WTFFarray,windowtitle);
}

// Read settings
filestring=File.openAsString(settingsFile); 
rows=split(filestring, "\n");
rows = Array.slice(rows,1,rows.length);	// Remove header

// Number of images
n = rows.length;

// Initialize arrays
arrayFnames = newArray(n);			// Array with image file names
arrayWindowtitles = newArray(n);	// Array with window names
arrayRoix = newArray(n);			// Array with the X coordinate of recatangular ROI
arrayRoiy = newArray(n);			// Array with the Y coordinate of recatangular ROI
arrayBg = newArray(n);				// Array with the background value


// Populate arrays
for(i=0; i<rows.length; i++){
	columns=split(rows[i],"\t"); 
	path = replace(columns[0], "\\\\", "/");
		
	arrayFnames[i] = path;
	arrayWindowtitles[i] = substring(path, lastIndexOf(path, "/")+1 , lengthOf(path));
	arrayRoix[i] = parseInt(columns[1]);
	arrayRoiy[i] = parseInt(columns[2]);
	arrayBg[i] = parseFloat(columns[3]);
} 

// Show arrays
//Array.show(arrayFnames);
//Array.show(arrayWindowtitles);
//Array.show(arrayRoix);
//Array.show(arrayRoiy);
//Array.show(arrayBg);


// === IMAGE PROCESSING =====================================

// Open and process images
print("Processing images\n");

//counter
c = 0;
for(i=0; i<n; i++){
	
	if (c == nchannels) {
		c = 0;
	}
	print("Processing image " + arrayFnames[i]);
	open(arrayFnames[i]);
	picname = arrayWindowtitles[i];

	//DF and FF
	applyFFDF(arrayWindowtitles[i], DFarray[c], FFarray[c], false);
	setMinAndMax(LUTmins[c], LUTmaxs[c]);
	
	if(arrayBg[i] == 0 && !allowZeroBg) waitForUser;
	// Subtract background
	run("Subtract...", "value=" + arrayBg[i]);

	// additional image corrections
	run("Properties...", "unit=" + unit + " pixel_width=" + Xsize + " pixel_height=" + Ysize + " voxel_depth=" + Zsize);

	// Save result
	saveAs("Tiff", imagefolder + File.separator + "bgCorr_" + picname);
	if(savepng) saveAs("PNG", imagefolder + File.separator + "bgCorr_" + picname);
	rename(picname);

	//channel counter + 1
	c++;
}
print("Finished correcting images\n");

if(doCrop){
	
	print("Applying crop");
	
	for(i=0; i<n; i++){
	
		print("Cropping image " + arrayWindowtitles[i]);
		selectWindow(arrayWindowtitles[i]);
		cropWindowTitle = "crop_" + arrayWindowtitles[i];
		makeRectangle(arrayRoix[i], arrayRoiy[i], roiWidth, roiHeight);
	
		if(preserveUncropped){
			run("Duplicate...", "title=[" + cropWindowTitle + "]");
		} else{
			run("Crop");
			rename(cropWindowTitle);
		}
		
		// Save result
		saveAs("Tiff", cropfolder + File.separator + "bgCorr_crop_" + arrayWindowtitles[i]);
		if(savepng) saveAs("PNG", cropfolder +  File.separator + "bgCorr_crop_" + arrayWindowtitles[i]);
		picname = "bgCorr_crop_" + arrayWindowtitles[i];
		rename(picname);
	}
}

// === FINISHING =====================================

//close correction files
for (i = 0; i < lengthOf(WTDFarray); i++) {
	selectWindow(WTDFarray[i]);
	close();
}

for (i = 0; i < lengthOf(WTFFarray); i++) {
	selectWindow(WTFFarray[i]);
	close();
}

// If requested, close uncropped images
if(closeBgCorr){
	imagesToClose = newArray();
	for (i = 1; i <= nImages; i++) {
    	selectImage(i);
    	imgTitle = getTitle();
    	if(matches(imgTitle, "^bgCorr_.*$") & matches(imgTitle, "^bgCorr_crop_.*$") == false){
    		imagesToClose = Array.concat(imagesToClose, imgTitle);
    	}
	}
	for(i=0; i<lengthOf(imagesToClose);i++){
		close(imagesToClose[i]);
	}
}

// If requested, close cropped images
if(closeCrop){
	imagesToClose = newArray();
	for (i = 1; i <= nImages; i++) {
    	selectImage(i);
    	imgTitle = getTitle();
    	if(matches(imgTitle, "^bgCorr_crop_.*$")){
    		imagesToClose = Array.concat(imagesToClose, imgTitle);
    	}
	}
	for(i=0; i<lengthOf(imagesToClose);i++){
		close(imagesToClose[i]);
	}
}

//Create a settings file if selected
if (settingsSummary == true) { 
	settingsfile(targetfolder, allowZeroBg, doCrop, preserveUncropped, savepng, unit, Xsize, Ysize, Zsize, roiWidth, roiHeight);
}


print("\nThe End!");
waitForUser("Finished!");
setBatchMode(false);


///////////////////////////////////////////////////////
//                 FUNCTIONS                         //
///////////////////////////////////////////////////////

// Flat field dark frame correction
function applyFFDF(name_img, name_DF, name_FF, autoLUT){
	// name_img		Name of the raw image
	// name_DF		Name of the dark field image
	// name_FF		Name of the flat field image
	// autoLUT		Apply auto LUT? (boolean)

	imageCalculator("Subtract", name_img, File.getName(name_DF));
	imageCalculator("Divide create 32-bit", name_img, File.getName(name_FF));

	if(autoLUT) run("Enhance Contrast", "saturated=0.35");
		
	selectWindow(name_img);
	run("Conversions...", " ");
	run("16-bit");
	close();
	selectWindow("Result of " + name_img);
	rename(name_img);
}

//settings file function
function settingsfile(path, allowbg, crop, presuncrop, png, unit, X, Y, Z, Width, Height) { 
// function descriptionThis functions creates a settings file from the selected options 
	setsum = File.open(path + File.separator + "Setting summary.txt"); //needs path 
	print(setsum, "\tSettings \n\n" + "Saving folder: " + targetfolder + "\n" + "Settings file: " + settingsFile + "\nImage correction file: " + imageFFDFfile + "\n");
	
	if (allowbg == true) {
		print(setsum, "Allow zero background: True");
		
	} else {

		print(setsum, "Allow zero background: False");

	}

	if (crop == true) {
		print(setsum, "Crop: True");
		print(setsum, "Crop Width: " + Width);
		print(setsum, "Crop Height: " + Height);
		
	} else {
		print(setsum, "Crop: False");

	}

	if (presuncrop == true) {
		print(setsum, "Preserve uncropped: True");

	} else {
		print(setsum, "Preserve uncropped: False");
		
	}

	if (png ==  true) {
		print(setsum, "Save PNG: True");
		
	} else {
		print(setsum, "Save PNG: False");
		
	}

	print(setsum, "Unit: " + unit);

	print(setsum, "Pixel width: " + X);
	print(setsum, "Pixel height: " + Y);
	print(setsum, "Voxel depth: " + Z);
}
