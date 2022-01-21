// === INITIALIZATION =====================================

// Set general options
settingsFile = "Z:/JoanaS/MaMTH_screen/analysis/FINAL HIT IMAGES/hitimages_settings.txt";
print("\\Clear");
print("Dark Frame & Flat Field correction\n");
run("Conversions...", " ");
allowZeroBg = false;
doCrop = true;
preserveUncropped = true;
savepng = false;
closeBgCorr = true;
closeCrop = true;
unit = "um";
Xsize = "0.6496813";
Ysize = "0.6496813";
Zsize = "0.6496813";
targetfolder = "Z:/JoanaS/MaMTH_screen/analysis/FINAL HIT IMAGES/";
setBatchMode(true);

// Correction images
DF_C00 = "Z:/JoanaS/MaMTH_screen/analysis/FINAL HIT IMAGES/FF_DF/DF_C00.tif";
FF_C00 = "Z:/JoanaS/MaMTH_screen/analysis/FINAL HIT IMAGES/FF_DF/FF_C00.tif";
DF_C01 = "Z:/JoanaS/MaMTH_screen/analysis/FINAL HIT IMAGES/FF_DF/DF_C01.tif";
FF_C01 = "Z:/JoanaS/MaMTH_screen/analysis/FINAL HIT IMAGES/FF_DF/FF_C01.tif";
DF_C02 = "Z:/JoanaS/MaMTH_screen/analysis/FINAL HIT IMAGES/FF_DF/DF_C02.tif";
FF_C02 = "Z:/JoanaS/MaMTH_screen/analysis/FINAL HIT IMAGES/FF_DF/FF_C02.tif";
windowTitle_DF_C00 = File.getName(DF_C00);
windowTitle_FF_C00 = File.getName(FF_C00);
windowTitle_DF_C01 = File.getName(DF_C01);
windowTitle_FF_C01 = File.getName(FF_C01);
windowTitle_DF_C02 = File.getName(DF_C02);
windowTitle_FF_C02 = File.getName(FF_C02);

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
roiWidth = 300;
roiHeight = 300;
arrayBg = newArray(n);				// Array with the background value
LUTmin_C00 = 0;
LUTmax_C00 = 5;
LUTmin_C01 = 0;
LUTmax_C01 = 0.55;
LUTmin_C02 = 0;
LUTmax_C02 = 0.0435;

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

// Open correction images
print("Opening correction images");
open(DF_C00);
open(FF_C00);
open(DF_C01);
open(FF_C01);
open(DF_C02);
open(FF_C02);


// Open and process images
print("Processing images\n");
for(i=0; i<n; i++){

	print("Processing image " + arrayFnames[i]);
	open(arrayFnames[i]);
	picname = arrayWindowtitles[i];

	// Determine channel
	channel = replace(picname, "^.*--(C..)\\.ome\\.tif$", "$1");

	if(channel == "C00"){
		applyFFDF(arrayWindowtitles[i], DF_C00, FF_C00, false);
		setMinAndMax(LUTmin_C00, LUTmax_C00);
	}

	if(channel == "C01"){
		applyFFDF(arrayWindowtitles[i], DF_C01, FF_C01, false);
		setMinAndMax(LUTmin_C01, LUTmax_C01);
	}

	if(channel == "C02"){
		applyFFDF(arrayWindowtitles[i], DF_C02, FF_C02, false);
		setMinAndMax(LUTmin_C02, LUTmax_C02);
	}
	if(arrayBg[i] == 0 && !allowZeroBg) waitForUser;
	// Subtract background
	run("Subtract...", "value=" + arrayBg[i]);

	// additional image corrections
	run("Properties...", "unit=" + unit + " pixel_width=" + Xsize + " pixel_height=" + Ysize + " voxel_depth=" + Zsize);

	// Save result
	saveAs("Tiff", targetfolder + "bgCorr_" + picname);
	if(savepng) saveAs("PNG", targetfolder + "bgCorr_" + picname);
	rename(picname);
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
		saveAs("Tiff", targetfolder + "bgCorr_crop_" + arrayWindowtitles[i]);
		if(savepng) saveAs("PNG", targetfolder + "bgCorr_crop_" + arrayWindowtitles[i]);
		
	}
}






// === FINISHING =====================================

// Close unnecessary windows
close(windowTitle_DF_C00);
close(windowTitle_FF_C00);
close(windowTitle_DF_C01);
close(windowTitle_FF_C01);
close(windowTitle_DF_C02);
close(windowTitle_FF_C02);

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

print("The End!");
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