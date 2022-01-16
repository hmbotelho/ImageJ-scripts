# Analyze all images in a folder

ImageJ macro  

### Summary

* This macro performs performs measurements in all images located in a specified folder (recursively). Analysis results are conveninently presented in a table. 
 
* A regular expression is used to define which files are to be analyzed. This expression can be the HTMrenamer one or another specified by yourself.

* You can select the measurements that you are interested in. 

* If chosen, a log file is created, where you can find the name, the input folder, the output folder.

* If chosen, a code file is created, where the commands applied to the images are stored.

* Analysis results are conveninently presented in a table. If chosen, this results can be saved in a csv file.

* Processed images can be also saved in the desired image format (e.g. Tif, PNG, Gif, Jpeg). 

* High Throughput Microscopy data: measurements can be annotated with its metadata; eg: plate name, well number, subposition index, time, etc. 


### Instructions

1. Define an image analysis macro (_e.g._ using **Plugins > Macros > Record...**).  Do not include a run("Measure") command. 

2. Open `batch_analysis.ijm` in ImageJ / Fiji (**File > Open...**).

3. Run the script.

4. Interact with the Macro menu. Define: 

- Images to analyze

- Saving directory

- Measurements and regular expression

- The files you need to create 

- The macro code that you wrote previously

5. If you selected saving the processed images, select the desired image format.

6. ImageJ will then open every image and perform the analysis. 

7. Finally, the results table will show up. If selected, the created files and processed images will be stored in the output directory.   

### High Throughput Microscopy data

Within the [HTMrenamer](https://github.com/hmbotelho/htmrenamer) regular expression, high throughput microscopy images may be stored in files whose name describes the experiment, such as:  

`myplate_01--compound--3uM--W0001--P001--T0000--C00.tif` 
 
If selected, for each image, the measurement can be annotated with this information:  

- Plate Name 
 
- Well Number  

- Subposition Index  

- Timepoint number (_for timelapse images_)  

- 2 generic data fields (data1 & data2)  

### Sample data and example workflow.

A [sample dataset](https://github.com/hmbotelho/ImageJ-scripts/tree/master/High%20Throughput%20Microscopy/batch_analysis/sample%20data) is included. For example, if we just wanted to apply a median filter to all images in a directory, and then getting some measurements from them, this is how would be:

1. Download the sample data set.

2. Define the image analysis macro. Using the recorder (**Plugins > Macros > Record...**), copy the command which applies the median filter: **"run("Median...", "radius=2");"**

3. Open **"batch_analysis.ijm"**. 

4. Run it.

5. Select the **sample dataset** as "*input*". Choose the directory where you want to save your files as "*saving directory*".

6. Select the initial options as follows and click on *Accept*. 

![image](https://user-images.githubusercontent.com/91415505/149670566-71bd7c67-fd9f-4280-8aff-7212e0274a75.png)

7. Select the following measurements and click on *Ok*. 

![image](https://user-images.githubusercontent.com/91415505/149670602-2b7836af-d331-48c6-9a2d-e45bc096a9f4.png)

8. Select PNG as the processed images saving format and click on *Ok*. 

![image](https://user-images.githubusercontent.com/91415505/149670696-41ff934e-e11a-494d-b2c1-210fe4a66c7b.png)

Finished! The results table will show up. 

In the selected output directory, you will find this files:

![image](https://user-images.githubusercontent.com/91415505/149670845-94125845-3a9c-4f61-ae9e-691f274aaffc.png)

- A folder named "Images", where you will find the processed images.

- A text file named "Codefile", where the applied command will appear.

- A text file named "Logfile", where you will find a file summary, with it's original and final location.

- A CSV file named "Results", with all the data summarized on the results table

