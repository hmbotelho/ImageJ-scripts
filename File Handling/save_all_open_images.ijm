#@ File (label="Folder to save images", style="directory") targetfolder
#@ String (label="File type", choices={"Tiff", "PNG", "Gif"}, style="radioButtonHorizontal") fileType


while (nImages > 0) {
	ImgTitle = getTitle();

	// Remove forbidden characters
	ImgTitle = replace(ImgTitle, "/", "--");

	// Process gif images
	if(fileType == "Gif"){
		ImgTitleOld = "raw--" + ImgTitle;
		rename(ImgTitleOld);
		run("RGB Color", "frames");
		rename(ImgTitle);
		close(ImgTitleOld);
	}

	// Save images
	targetFile = targetfolder + "/" + ImgTitle;
	saveAs(fileType, targetFile);
	close();
}
