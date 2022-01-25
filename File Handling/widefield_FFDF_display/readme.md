# Widefield_FFDF_display

ImageJ macro  

## Summary

- This macro applies Dark Field and Flat Field corrections to a list of files delimitated in the settings file.

- It can also create crops and save them.

- Needs as input a settings file and a correction images file in text format. 

- Besides, the macro allows you to use the zero background setting: in this case, whenever in the settings file the background value is 0, the macro will stop and let you measure the background value within the image, so you can input the new value and run the macro.

- **Careful**: This macro will only work if the number of channels of the correction background images and the target images is the same. It is also very important that the setting file list and correction file list is ordered: the files must be in order of ascendent channels and image by image. The macro will not work if the file list is messy. You can see the correct syntax on the example settings file and image correction file. 

## Input files preparation

This macro needs 2 files in .txt format:

### A. Settings file

Here, you need to establish which images you want to correct.

This file needs to be in the following format:

Image file path + tab + ROI X coordinate + tab + ROI Y coordinate + tab + Background value

Here you can see the example file, and also the empty example file to fill out yourself. The example file will not work as it is, you need to manually write the path of the images on your computer. 

Notice that the first line must always be the headings line. 

### B. Image correction file

Here, you need to establish where are the image correction files. 

This file needs to be in the following format:

DF file path + tab + FF file path + tab + LUT min + tab + LUT max

Here you can see the example file, and also the empty example file to fill out yourself. The example file will not work as it is, you need to manually write the path of the images on your computer. 

Notice that the first line must always be the headings line. 

## Instructions

1. Open `widefield_FFDF_display` in ImageJ / Fiji (**File > Open...**).

2. Run the macro.

3. Interact with the macro menu: select the aproppiated files and choose the macro options

4. Select the aditional correction settings

5. If *Do crop* was selected, determinate the Width and Height of the Crop

6. In case you selected the zero background option, the macro will stop in any image which its background value on the settings file is 0, so you can manually determine its real value. 

## Example dataset

You can try yourself this macro on the following dataset. 