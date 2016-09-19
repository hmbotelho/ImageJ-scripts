SERVICES
DOCUMENTS
Untitled Document.md
NEW DOCUMENT
SAVE SESSION
Get the context and insights to defeat all application errors. Learn more.
SAVE TO 
IMPORT FROM 
DOCUMENT NAME


Untitled Document.md
WORDS: 261
MARKDOWN Toggle Zen Mode PREVIEW


1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
# Analyze all images in a folder
ImageJ macro  
v 1.0  
September 2016  
### Summary
This macro performs performs measurements in all images 
located in a specified folder (recursively). Analysis 
results are conveninently presented in a table.  
A regular expression is used to define which files are 
to be analyzed.
### Instructions
1. Define an image analysis macro (_e.g._ using 
**Plugins > Macros > Record...**). This must contain a 
`run(\"Measure\");` statement where the desired 
measurement is obtained;
2. Open script in ImageJ / Fiji (**File > Open...**);
3. Paste the macro inside this function, located at the 
very end of the script:
```java
// This functions performs analysis
function PerformImageAnalysis (){
//   *********      YOUR IMAGE ANALYSIS MACRO BELOW   
*********
//     *****        YOUR IMAGE ANALYSIS MACRO BELOW    
 *****
//       *          YOUR IMAGE ANALYSIS MACRO BELOW    
   *
    run("Measure");
//   *********      YOUR IMAGE ANALYSIS MACRO ABOVE    
   *
//     *****        YOUR IMAGE ANALYSIS MACRO ABOVE    
 *****
//       *          YOUR IMAGE ANALYSIS MACRO ABOVE   
*********
}
```
4. Run the script;
5. Interact with the dialog boxes;
6. ImageJ will then open every image and perform the 
analysis;
6. Once the analysis finishes, save the results table 
(**File > Save As...**).
### Sample data
A sample dataset is included. Analysis should work with 
the default settings. Make sure **Mean gray value** is 
enabled in **Analyze > Set Measurements...**  
### High Throughput Microscopy data
High throughput microscopy images may be stored in 
files whose name describes the experiment, such as:  
`myplate_01--compound--3uM--W0001--P001--T0000--C00.tif
`  
For each image, the measurement can be annotated with 
this information:
- Plate Name
- Well Number
- Subposition Index
- Timepoint number (_for timelapse images_)
- 2 generic data fields (data1 & data2)
Analyze all images in a folder
ImageJ macro
v 1.0
September 2016

Summary
This macro performs performs measurements in all images located in a specified folder (recursively). Analysis results are conveninently presented in a table.
A regular expression is used to define which files are to be analyzed.

Instructions
Define an image analysis macro (e.g. using Plugins > Macros > Record…). This must contain a run(\"Measure\"); statement where the desired measurement is obtained;
Open script in ImageJ / Fiji (File > Open…);
Paste the macro inside this function, located at the very end of the script:
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
Run the script;
Interact with the dialog boxes;
ImageJ will then open every image and perform the analysis;
Once the analysis finishes, save the results table (File > Save As…).
Sample data
A sample dataset is included. Analysis should work with the default settings. Make sure Mean gray value is enabled in Analyze > Set Measurements…

High Throughput Microscopy data
High throughput microscopy images may be stored in files whose name describes the experiment, such as:
myplate_01--compound--3uM--W0001--P001--T0000--C00.tif
For each image, the measurement can be annotated with this information:

Plate Name
Well Number
Subposition Index
Timepoint number (for timelapse images)
2 generic data fields (data1 & data2)