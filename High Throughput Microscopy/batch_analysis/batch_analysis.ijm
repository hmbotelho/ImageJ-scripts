//
//   Hugo M Botelho
//   hmbotelho@fc.ul.pt
//
//   Analyze all images in a folder
//   v 1.0
//   September 2016
// 
//
//   This macro performs performs measurements in all images located in a specified folder (recursively).
//   A regular expression is used to define which files are to be analyzed.
//
//   Analysis results are conveninently presented in a table
//   High Throughput Microscopy data: measurements can be annotated with plate name, well number, subposition index, time, etc





// Get image folder
SourceFolder = getDirectory("Where are your images?");


// Set target measurement. Must be the same name that shows up in the results table.
// measurement = "Mean";

// Get REGEX defining the files to be analyzed
// regexpr = "^(?<platePath>.*?)--(?<data1>.*?)--(?<data2>.*?)--W(?<wellNum>.*?)--P(?<posNum>.*?)--T(?<timeNum>.*?)--C00\\.(?<filextension>.*?)$";


// Get settings from user using a dialog box
	Dialog.create("Filename and measurement settings");
	Dialog.addMessage(" === Which files do you want to analyze?");
	Dialog.addMessage("A typical filename looks like:     myplate_01--VX809--3uM--W0001--P001--T0000--C00.tif");
	Dialog.addMessage("If your filenames are in a different format, update this regular expression.");
	Dialog.addString("Regular expression:", "^(?<platePath>.*?)--(?<data1>.*?)--(?<data2>.*?)--W(?<wellNum>.*?)--P(?<posNum>.*?)--T(?<timeNum>.*?)--(?<channel>.*)\\.tif$", 120);
	Dialog.addMessage("If you are not sure what this means, do not change the default.");
	Dialog.addMessage("If present in the regular expression, the following named capture groups will be included in the results table:");
	Dialog.addMessage("    platePath");
	Dialog.addMessage("    wellNum");
	Dialog.addMessage("    posNum");
	Dialog.addMessage("    data1");
	Dialog.addMessage("    data2");
	Dialog.addMessage("    timeNum");
	Dialog.addMessage("=============================================================================================================================");
	Dialog.addString("Which measurement are you interested in?", "Mean", 30);
	Dialog.addMessage("This measurement should be enabled in 'Analyze > Set Measurements...'");
	Dialog.addMessage("=============================================================================================================================");
	Dialog.addMessage("The image analysis macro should .");
	Dialog.addMessage("Be sure to include this statement:          run(\"Measure\");");
	Dialog.show();

	regexpr = Dialog.getString();
	measurement = Dialog.getString();


// Generate an array with all files in all subfolders of 'SourceFolder'
AllFiles = ListFiles(SourceFolder);


// Exclude all items with incorrect extension
OKFiles = AllFiles;
for (i=0; i<lengthOf(OKFiles); i++){
	if (matches(OKFiles[i], regexpr) == false){
		OKFiles = RemoveArrayItem (OKFiles, i);
		i--;
	}
}


// Initialize results table
run("Clear Results");
t="[Results table]"; 
run("New... ", "name="+t+" type=Table"); 
print(t,"\\Headings:Plate\tWell\tPosition\tdata1\tdata2\tTime\t" + measurement + "\tFile\tfileLocation"); 


// Open every single file and perform analysis
for (i=0; i<lengthOf(OKFiles); i++){
	
	// Open file
	open(OKFiles[i]);

	// Get basic file information
	path = getInfo("image.directory");
	filename = getInfo("image.filename");
	fileLocation = path + filename;

	if(matches(regexpr, ".*<platePath>.*")){
		plate = replace(filename, regexpr, "${platePath}");
	} else{
		plate = "NA";
	}

	if(matches(regexpr, ".*<wellNum>.*")){
		well = replace(filename, regexpr, "${wellNum}");
	} else{
		well = "NA";
	}

	if(matches(regexpr, ".*<posNum>.*")){
		position = replace(filename, regexpr, "${posNum}");
	} else{
		position = "NA";
	}

	if(matches(regexpr, ".*<data1>.*")){
		data1 = replace(filename, regexpr, "${data1}");
	} else{
		data1 = "NA";
	}

	if(matches(regexpr, ".*<data2>.*")){
		data2 = replace(filename, regexpr, "${data2}");
	} else{
		data2 = "NA";
	}

	if(matches(regexpr, ".*<timeNum>.*")){
		time = replace(filename, regexpr, "${timeNum}");
	} else{
		time = "NA";
	}




	// Perform image analysis
	PerformImageAnalysis();


	// Grab the measurement obtained at the end of analysis
	quant = getResult(measurement, getValue("results.count")-1);

	
	// Close file
	close();

	// Populate results table
	print(t,plate+"\t"+well+"\t"+position+"\t"+data1+"\t"+data2+"\t"+time+"\t"+quant+"\t"+filename+"\t"+fileLocation); 
}


// Close the results window to declutter the screen
if (isOpen("Results")) { 
	selectWindow("Results"); 
	run("Close"); 
} 











//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


// This function retruns an array listing all files within the "dir" folder and all subfolders
// Recursively
function ListFiles(dir) {
	FilesArray = newArray();		// This array will only contain the filenames
	list = getFileList(dir);		// This array will contain all file + folder names
	list = AppendPrefixArray (list, SourceFolder);
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





//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////




// This functions performs analysis
function PerformImageAnalysis (){

//   *********      YOUR IMAGE ANALYSIS MACRO BELOW   *********
//     *****        YOUR IMAGE ANALYSIS MACRO BELOW     *****
//       *          YOUR IMAGE ANALYSIS MACRO BELOW       *









	run("Measure");


//   *********      YOUR IMAGE ANALYSIS MACRO ABOVE       *
//     *****        YOUR IMAGE ANALYSIS MACRO ABOVE     *****
//       *          YOUR IMAGE ANALYSIS MACRO ABOVE   *********
}
