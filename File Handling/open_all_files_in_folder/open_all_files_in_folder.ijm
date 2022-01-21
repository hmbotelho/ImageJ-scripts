#@ File (label = "Input directory", style = "directory") input
#@ String (label = "Open files matching (regex)", value = ".tif") regex
#@ Boolean (label = "Make stack?", value = true) makestack

// Open all files in folder (recursive, pattern matching)

processFolder(input);
if(makestack)  run("Images to Stack");

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(matches(list[i], regex))
			open(input + File.separator + list[i]);
	}
}
