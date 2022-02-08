//
//   Hugo M Botelho, Pau Rubio Costa
//   hmbotelho@fc.ul.pt, prcosta@fc.ul.pt
//
//   Analyze all images in a folder
//   v 2.0
//   January 2022
// 
//
//   This macro performs performs measurements in all images located in a specified folder (recursively) and applies a processing code to all files.
//   A regular expression is used to define which files are to be analyzed. This expression can be the HTMrenamer one or another specified by yourself. 
//	 You can select the measurements that you are interested in. 
//	 If chosen, a Log file is created, where you can find the name, the input folder, the output folder
//	 If chosen, a code file is created, where the commands applied to the images are stored
//   Analysis results are conveninently presented in a table
//   High Throughput Microscopy data: measurements can be annotated with plate name, well number, subposition index, time, etc


#@ String (visibility=MESSAGE, value="This macro performs performs measurements in all images located in a specified folder (recursively). Analysis results are conveninently presented in a table.") msg
#@ File (style="directory", label="Select the input folder") in
#@ File (style="directory", label="Select the output folder") out
#@ String (choices={"HTMrenamer", "Define..."}, style="radioButtonHorizontal", label="Regular expression", description="Select your regular expression. If you select \"HTMrenamer\", the default expression from the HTMrenamer will be chosen; if you select \"Define...\" you will write your own expression") metadata 
#@ String (choices={"All", "Select..."}, style="radioButtonHorizontal", label="Measurements to export", description="Choose \"All\" to import all kind of measurements; choose \"Select...\" if you want to manually select the measures to export") measurement
#@ Boolean (label="Create a log file", description="Create a text file with the name, original and final location of the images/results") checkboxlog
#@ Boolean (label="Create a code file", description="Create a text file with all the commands that were applied to the images") checkboxcode
#@ Boolean (label="Save processed images", description="Create a directory where all the processed images are stored") checkboximages
#@ Boolean (label="Save results table", description="Create a CSV file with the results") checkboxresults
#@ String (style="text area", label="Image analysis workflow", value="Write your image analysis macro code...", description="Write the Macro statements that you want to perform in your image analysis workflow, always in the ImageJ Macro Language") workflow
#@ Boolean (label="Batch mode", description="Run the analysis without showing the image window/s (increases the macro speed)") batch

//Adjust the in and out string: when you are using script parameters, they return the directory without the final slash. This causes errors. Adding it will avoid them.
in = in + "\\";
out = out + "\\";

//Generalize the in and out file separator style
in = replace(in, "\\", "/");
out = replace(out, "\\", "/");

//batch mode
setBatchMode(false);

//Define and Select
if (metadata == "Define..." && measurement == "Select...") {
	Dialog.create("Settings");
	Dialog.addMessage("Choose the metadata expression");
	Dialog.addString("Expression:", "Write here...", 30);
	Dialog.addMessage("Choose the measurements to export");
	items = newArray("Area", "Standard deviation", "Min & max gray value", "Center of mass", "Bounding rectangle", "Shape descriptors", "Integrated intensity", "Skewness", "Area fraction", "Mean gray value", "Modal gray value", "Centroid", "Perimeter", "Fit Ellipse", "Feret's diameter", "Median", "Kurtosis", "Stack position");
	defaults = newArray(18);
	Dialog.addCheckboxGroup(9, 2, items, defaults);
	Dialog.show();
	
	regexpr = Dialog.getString(); 
	measurements = newArray();
	for (i = 0; i < lengthOf(items); i++) {
		if (Dialog.getCheckbox() == true) {
			measurements = Array.concat(measurements, items[i]);
		}
	}
}

//Define and ALl
if (metadata == "Define..." && measurement == "All") {

	Dialog.create("Settings");
	Dialog.addMessage("Choose the metadata expression that will be used");
	Dialog.addString("Expression:", "Write here...", 30);
	Dialog.show();
	regexpr = Dialog.getString(); 
	measurements =  newArray("Area", "Standard deviation", "Min & max gray value", "Center of mass", "Bounding rectangle", "Shape descriptors", "Integrated intensity", "Skewness", "Area fraction", "Mean gray value", "Modal gray value", "Centroid", "Perimeter", "Fit Ellipse", "Feret's diameter", "Median", "Kurtosis", "Stack position");
}

//HTMrenamer and select
if (metadata == "HTMrenamer" && measurement == "Select...") {
	Dialog.create("Settings");
	Dialog.addMessage("Choose the measurements to export");
	items = newArray("Area", "Standard deviation", "Min & max gray value", "Center of mass", "Bounding rectangle", "Shape descriptors", "Integrated intensity", "Skewness", "Area fraction", "Mean gray value", "Modal gray value", "Centroid", "Perimeter", "Fit Ellipse", "Feret's diameter", "Median", "Kurtosis", "Stack position");
	defaults = newArray(18);
	Dialog.addCheckboxGroup(9, 2, items, defaults);
	Dialog.show();
	measurements = newArray();
	for (i = 0; i < lengthOf(items); i++) {
		if (Dialog.getCheckbox() == true) {
			measurements = Array.concat(measurements, items[i]);
		}
	}
	regexpr = "^(?<platePath>.*?)--(?<data1>.*?)--(?<data2>.*?)--W(?<wellNum>.*?)--P(?<posNum>.*?)--T(?<timeNum>.*?)--(?<channel>.*)\\.tif$"; 
}

//HTMrenamer and All
if (metadata == "HTMrenamer" && measurement == "All") {
	regexpr = "^(?<platePath>.*?)--(?<data1>.*?)--(?<data2>.*?)--W(?<wellNum>.*?)--P(?<posNum>.*?)--T(?<timeNum>.*?)--(?<channel>.*)\\.tif$"; 
	measurements =  newArray("Area", "Standard deviation", "Min & max gray value", "Center of mass", "Bounding rectangle", "Shape descriptors", "Integrated intensity", "Skewness", "Area fraction", "Mean gray value", "Modal gray value", "Centroid", "Perimeter", "Fit Ellipse", "Feret's diameter", "Median", "Kurtosis", "Stack position");
}

//If save images options is selected, a dialog appears to choose the format for saving them
if (checkboximages == true) {
	formats = newArray("Tiff", "PNG", "Gif", "Jpeg");
	Dialog.create("Saving format");
	Dialog.addChoice("In which format do you want to save your images?" , formats);
	Dialog.show();
	format = Dialog.getChoice();
}

// Generate an array with all files in all subfolders of 'SourceFolder'
AllFiles = ListFiles(in);

// Exclude all items with incorrect extension
OKFiles = AllFiles;
for (i=0; i<lengthOf(OKFiles); i++){
	if (matches(OKFiles[i], regexpr) == false){
		OKFiles = RemoveArrayItem (OKFiles, i);
		i--;
	}
}

//If there are no files in the folder, the macro will abort
if (lengthOf(AllFiles) == 0) {
	waitForUser("Error", "No files found");
	exit;
}

//If there are no files matching the regular expression, the macro will abort
if (lengthOf(OKFiles) == 0) {
	waitForUser("Error", "No files matching the regular expression found");
	exit;
}

//Closes the results table if open to avoid errors
if (isOpen("Results table")) {
	selectWindow("Results table");
	run("Close");
}

//Clear the results
run("Clear Results");

//Initialize the code file if selected
if (checkboxcode == true) {
	code = File.open(out+"code.txt");
	print(code, workflow);
	File.close(code);
}

//Creates a directory where the images are saved 
if (checkboximages == true) {
	setBatchMode("hide");
	imagespath = out+"Images/";
	File.makeDirectory(imagespath);
	processFolder(in, imagespath, regexpr);
	setBatchMode(false);
}

//Batch mode 
if (batch == true) {
	setBatchMode("hide");
}
//Initialize the log file if selected
if (checkboxlog == true) {
	logfile = File.open(out+"logfile.txt");
	print(logfile,"Name\tOriginal directory\tFinal directory"); 
}


//Boolean variable: used for opening the results table and populating it in the first cycle of the next for loop
boolean = 1;

// Open every single file and perform analysis
for (i=0; i<lengthOf(OKFiles); i++){
	
	// Open file
	open(OKFiles[i]);

	//Show progress
	showProgress(i, lengthOf(OKFiles));
	
	// Get basic file information
	path = getInfo("image.directory");
	filename = getInfo("image.filename");
	filenamewe = File.getNameWithoutExtension(path + filename);
	fileLocation = path + filename;

	//Populate the log file
	if (checkboxlog == true) {

		print(logfile, filename + "\t" + in + "\t" + out + "\n"); 
		
	}
	//Regular expresion and result table (only will enter in the first cycle)
	if (boolean == 1) {

		//Boolean to 0
		boolean = 0;
		
		//Headings of the results
		measureheadings = ResultsHeaders(measurements);

		//Headings of the regular expression fields
		expheadings = RegularExpression(regexpr, filename);
		
		//Headings array
		headings = Array.concat(expheadings, measureheadings);
		headings = Array.concat("File name" ,headings);
		headings = Array.concat(headings,"File location");
		
		//Headings string
		headstr = String.join(headings, "\t");

		// Initialize results table
		t="[Results table]"; 
		run("New... ", "name="+t+" type=Table"); 
		print(t, "\\Headings:"+headstr); //ALERTA:::: need changes
	
	}

	//Set measurements
	Setmeasurements(measurements, filename);
	
	// Perform image analysis«
	PerformImageAnalysis(workflow);

	//Save processed images if selected
	if (checkboximages == true) {
		filelocwe = replace(fileLocation, ".tif", "");
		save(imagespath+ replace(filelocwe, in, "")+"_processed."+format);
	}
	
	// Grab the measurements obtained at the end of analysis
	resultarray = newArray();
	
	for (r = 0; r < lengthOf(measureheadings); r++) {

		result = getResult(measureheadings[r], getValue("results.count")-1);

		resultarray  = Array.concat(resultarray,result);
	}

	//Transform the result array to string for adding it to the table 
	resultstr = String.join(resultarray, "\t");

	//Grab the regular expression data from file name
	exparray = newArray();
	
	for (e = 0; e < lengthOf(expheadings); e++) {

		field = expheadings[e];
		
		value = replace(filename, regexpr, "${"+ field + "}");

		exparray = Array.concat(exparray, value);
		
	}

	//Transform the exp array for adding it to the table 
	expstr = String.join(exparray, "\t");

	// Close file
	selectWindow(filename);
	close();

	// Populate results table
	if (lengthOf(exparray) > 0) {
	
		print(t, filename+"\t" + expstr + "\t" + resultstr + "\t"+ fileLocation);
		
	} else {
		
		print(t, filename+"\t" + resultstr + "\t"+ fileLocation); 

	}
}

//Close the log file
if (checkboxlog == true) {
	File.close(code);
}

// Close the results window to declutter the screen
if (isOpen("Results")) { 
	selectWindow("Results"); 
	run("Close"); 
} 

//Save results table
if (checkboxresults == true) {
	selectWindow("Results table");
	saveAs("Text", out + "Results.csv");
}

//FUNCTIONS
function ListFiles(dir) {
	FilesArray = newArray();		// This array will only contain the filenames
	list = getFileList(dir);		// This array will contain all file + folder names
	list = AppendPrefixArray (list, in); //here, you can replace sourcefolder with dir
	i = 0;
	while (i < list.length){
		showProgress(i/list.length);
		if (endsWith(list[i], "/")){
			ChildrenFilesFolders = getFileList(list[i]);
			ChildrenFilesFolders = AppendPrefixArray (ChildrenFilesFolders, list[i]);
			list = InsertArray (list, ChildrenFilesFolders, i+1);
		} else{
			FilesArray = Array.concat(FilesArray, list[i]);
		}
		i++;
	}
	return FilesArray;
}

// This function adds a prefix to all elements of an array
function AppendPrefixArray (array, prefix){
	for (k=0; k<lengthOf(array); k++){
		array[k] = prefix + array[k];
	}
	return array;
}

// This function inserts array2 into the specified position of array1
// 0 is the first position of the array
function InsertArray (array1, array2, position){
	beginning = Array.slice (array1, 0, position);
	end = Array.slice (array1, position, lengthOf(array1));
	return Array.concat(beginning, array2, end);
}

// Removes one item from an array, as defined by its postion in the array (0, 1, 2, ...)
// The output array is one unit shorter than the original one
function RemoveArrayItem (array, index){
	beginning = Array.trim(array, index);
	end = Array.slice(array, index + 1, lengthOf(array));
	output = Array.concat(beginning, end);
	return output;
}

//This function applies the chosen code to the images and runs de measure command
function PerformImageAnalysis(commands) {
	eval(commands);
	run("Measure"); 
}

//This function set the desired parammeters in set measurements
function Setmeasurements(array, file) { 
// enablse the measurements selected
// needs an array which contains the measurements to enable by their name and a filename
	list = String.join(array);
	list = list.replace(",", "");
	//goes through the string and replace 
	list = list.replace("Area", "area");
	list = list.replace("Mean gray value", "mean");
	list = list.replace("Standard deviation", "standard");
	list = list.replace("Modal gray value", "modal");
	list = list.replace("Min & max gray value", "min");
	list = list.replace("Centroid", "centroid");
	list = list.replace("Center of mass", "center");
	list = list.replace("Perimeter", "perimeter");
	list = list.replace("Bounding rectangle", "bounding");
	list = list.replace("Fit Ellipse", "fit");
	list = list.replace("Feret's diameter", "feret's");
	list = list.replace("Integrated intensity", "integrated");
	list = list.replace("Median", "median");
	list = list.replace("Skewness", "skewness");
	list = list.replace("Kurtosis", "kurtosis");
	list = list.replace("Area fraction", "area_fraction");
	list = list.replace("Stack position", "stack");
	run("Set Measurements...", list + "redirect="+file+" decimal=3"); 
}

function ResultsHeaders(array) { 
// This function creates an array with the headers of the imagej results table from an array with the names of the measurements of the set measurements menu
	resulthead = newArray();
	for (j = 0; j < lengthOf(array); j++) {
		if (array[j] == "Area") {
			resulthead = Array.concat(resulthead, "Area");
		}
		if (array[j] == "Mean gray value") {
			resulthead = Array.concat(resulthead, "Mean");
		}
		if (array[j] == "Standard deviation") {
			resulthead = Array.concat(resulthead, "StdDev");
		}
		if (array[j] == "Standard deviation") {
			resulthead = Array.concat(resulthead, "Mode");
		}
		if (array[j] == "Min & max gray value") {
			resulthead = Array.concat(resulthead, "Min");
			resulthead = Array.concat(resulthead, "Max");
		}
		if (array[j] == "Centroid") {
			resulthead = Array.concat(resulthead, "X");
			resulthead = Array.concat(resulthead, "Y");
		}
		if (array[j] == "Center of mass") {
			resulthead = Array.concat(resulthead, "XM");
			resulthead = Array.concat(resulthead, "YM");
		}
		if (array[j] == "Perimeter") {
			resulthead = Array.concat(resulthead, "Perim.");
		}
		if (array[j] == "Bounding Rectangle") {
			resulthead = Array.concat(resulthead, "BX");
			resulthead = Array.concat(resulthead, "BY");
			resulthead = Array.concat(resulthead, "Width");
			resulthead = Array.concat(resulthead, "Height");
		}
		if (array[j] == "Fit Ellipse") {
			resulthead = Array.concat(resulthead, "Perim.");
			resulthead = Array.concat(resulthead, "Major");
			resulthead = Array.concat(resulthead, "Minor");
			resulthead = Array.concat(resulthead, "Angle");
		}
		if (array[j] == "Shape Descriptors") {
			resulthead = Array.concat(resulthead, "Circ.");
			resulthead = Array.concat(resulthead, "AR");
			resulthead = Array.concat(resulthead, "Round");
			resulthead = Array.concat(resulthead, "Solidity");
		}
		if (array[j] == "Feret's Diameter") {
			resulthead = Array.concat(resulthead, "Feret");
			resulthead = Array.concat(resulthead, "FeretAngle");
			resulthead = Array.concat(resulthead, "MinFeret");
			resulthead = Array.concat(resulthead, "Feret");
			resulthead = Array.concat(resulthead, "FeretX");
			resulthead = Array.concat(resulthead, "FeretY");
		}
		if (array[j] == "Integrated Density") {
			resulthead = Array.concat(resulthead, "IntDen");
			resulthead = Array.concat(resulthead, "RawIntDen");
		}
		if (array[j] == "Median") {
			resulthead = Array.concat(resulthead, "Median");
		}
		if (array[j] == "Skewness") {
			resulthead = Array.concat(resulthead, "Skew");
		}
		if (array[j] == "Kurtosis") {
			resulthead = Array.concat(resulthead, "Kurt");
		}
		if (array[j] == "Area Fraction") {
			resulthead = Array.concat(resulthead, "%Area");
		}
		if (array[j] == "Stack Position") {
			resulthead = Array.concat(resulthead, "Ch");
			resulthead = Array.concat(resulthead, "Slice");
			resulthead = Array.concat(resulthead, "Frame");
		}	
	}
	return resulthead;
}

function RegularExpression(myregexpr, file) { 
//	This function checks if the regular expression matches with a filename
//	If does, the function will try to find capturing groups; if not, it will abort the macro
//	Then, if capturing groups exits, store them in an array and returns them (nammed or unnamed); if not, it retuns an empty array 
	//array where the headings are stored
	regexphead = newArray();
	//integer where the position of the captured groups will be captured
	position = 0;
	// step 1: find whether the regular expression matches the string
	if (matches(file, myregexpr)){
		// Determine whether there are capturing grups
		if  ((indexOf(myregexpr,"(")) != -1 && (indexOf(myregexpr, ")")) != -1) {	// e.g. find pairs of ()
			//if( find("(?<...>)")){
			if ((indexOf(myregexpr,"<")) != -1 && (indexOf(myregexpr, ">")) != -1) {
				//named capture
				while (position < lengthOf(myregexpr)-12) {
					start = indexOf(myregexpr, "<", position) + 1;
					end = indexOf(myregexpr, ">", position+1); //no -1 porque en substring ya le resta al end
					name = substring(myregexpr, start, end);
					regexphead = Array.concat(regexphead,name);
					position = end;
				}
			} else {
				// Unnamed capture
				//counter variable
				n = 0;
				// Find "field1, field2,...
				while (position < lengthOf(myregexpr)-8) {
					n = n +1;
					start = indexOf(myregexpr, "(", position) + 1;
					end = start + 4; //because of the sintaxis of (.*?)
					name = "Field " + n;
					regexphead = Array.concat(regexphead, name);
					position = end;
				}
			}
		} else {
			//there are no capturing groups
			waitForUser("Warning", "There are no capturing groups");
		}
	} else {
		//The regular expression does not match: the macro is aborted
		waitForUser("Error", "The regular expression does not match with the file name/s: macro will abort");
		exit;
	}
	return regexphead;
}

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input, output, regex) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i], output, regex);
		if(matches(list[i], regex))
			processFile(input, output, list[i], regex);
	}
}

function processFile(input, output, file, regex) {

	// Open image
	sourcepath = input + "/" + file;
	open(sourcepath);

	// Make dirs
	img = getTitle();
	targetpath = replace(input, in, imagespath) + "/" + img;
	dir = File.getDirectory(targetpath);
	makeDirRecursive(dir);
	close("*");
}

// Creates a folder, recursively
// Output: none
//
// dir	character, path to the new folder
function makeDirRecursive(dir){
	folders = split(dir, "/");
	
	if(startsWith(dir, "/")){
		temp = "/";			// macOS
	} else{
		temp = "";			// Windows
	}
	
	for(i=0; i<lengthOf(folders); i++){
		temp = temp + folders[i] + "/";
		if(!File.exists(temp)){
			File.makeDirectory(temp);
		}
	}
}