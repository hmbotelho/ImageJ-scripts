/* Simple ImageJ progress bar
 * 
 * Hugo Botelho
 * 8-Mar-2024
 * hugobotelho@gmail.com
 *
 */




// Let us consider 50 simulated images
numImages = 50;

// Do some silly processing on images
// Update a progress bar as that is done
for (i=1; i<=numImages; i++) {
    process_image(128);
    progress = i/numImages;
    update_progressbar(progress);
}



/*
 *   HELPER FUNCTIONS
 */
 
 
// Create or update a simple text progress bar
// pct		percentage of conclusion (0~1)
function update_progressbar(pct){
	
	// Check if a progress bar window already exists
	if(!isOpen("Progress bar")){
		run("Text Window...", "name=[Progress bar] width=95 height=1");
	}
	
	// Determine how many asterisks to draw
	nchar = 100;						// Number of characters in the progress bar
	n_aster = floor(pct * nchar);		// Number of asteriss
	n_spaces = nchar - n_aster;			// Number of spaces
	
	// Create progress bar
	pct_pretty = round(pct*1000)/10;
	aster = "";
	spaces = "";
	for(i=0; i<n_aster; i++) aster = aster + "*";
	for(i=0; i<n_spaces; i++) spaces = spaces + " ";
	pbar = "|" + aster + spaces + " | " + pct_pretty + "%";
	
	// Draw progress bar
	print("[Progress bar]", "\\Update:" + pbar);
}


// Do some silly image processing
// pixels	image widhth and height, in pixels
function process_image(pixels) { 
	newImage("test", "8-bit white", pixels, pixels, 1);
	run("Salt and Pepper");
	run("Gaussian Blur...", "sigma=2");
	run("Fire");
	setMinAndMax(0, 10);
	run("Enhance Contrast", "saturated=0.35");
	run("Apply LUT");
	for(i=0; i<45; i++){
		run("Rotate... ", "angle=2 grid=1 interpolation=None");
	}
	close();
}