# Analyze all images in a folder
ImageJ macro  

### Summary
This macro performs performs measurements in all images located in a specified folder (recursively). Analysis results are conveninently presented in a table.  
A regular expression is used to define which files are to be analyzed.  

### Instructions
1. Define an image analysis macro (_e.g._ using **Plugins > Macros > Record...**). This must contain a `run(\"Measure\");` statement where the desired measurement is obtained;  
2. Open script in ImageJ / Fiji (**File > Open...**);  
3. Paste the macro inside this function, located at the very end of the script:  
```java
function PerformImageAnalysis (){
	//   *********      YOUR IMAGE ANALYSIS MACRO BELOW   *********
	//     *****        YOUR IMAGE ANALYSIS MACRO BELOW     *****
	//       *          YOUR IMAGE ANALYSIS MACRO BELOW       *




    run("Measure");

	//       *          YOUR IMAGE ANALYSIS MACRO ABOVE       *
	//     *****        YOUR IMAGE ANALYSIS MACRO ABOVE     *****
	//   *********      YOUR IMAGE ANALYSIS MACRO ABOVE   *********
}
```
4. Run the script;  
5. Interact with the dialog boxes;  
6. ImageJ will then open every image and perform the analysis;  
7. Once the analysis finishes, save the results table (**File > Save As...**).  


### Sample data  
A sample dataset is included. Analysis should work with the default settings. Make sure **Mean gray value** is nabled in **Analyze > Set Measurements...**  

### High Throughput Microscopy data
High throughput microscopy images may be stored in files whose name describes the experiment, such as:  
`myplate_01--compound--3uM--W0001--P001--T0000--C00.tif`  
For each image, the measurement can be annotated with this information:  
- Plate Name  
- Well Number  
- Subposition Index  
- Timepoint number (_for timelapse images_)  
- 2 generic data fields (data1 & data2)  
