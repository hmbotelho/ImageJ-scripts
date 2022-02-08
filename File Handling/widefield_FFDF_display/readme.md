# **Widefield_FFDF_display**

ImageJ macro  

## Summary

- This macro applies **Dark Field and Flat Field corrections** to a list of files delimitated in the settings file.

- It can also create crops and save them.

- Needs as input a settings file and a correction images file in text format. 

- Besides, the macro allows you to use the **zero background** setting: in this case, whenever in the settings file the background value is 0, the macro will stop and let you measure the background value within the image, so you can input the new value and run the macro.

- ***Careful***: This macro will only work if the number of channels of the correction background images and the target images is the same. It is also very important that the setting file list and correction file list is ordered: the files must be in order of ascendent channels and image by image. The macro will not work if the file list is messy. You can see the correct syntax on the [example settings file](https://github.com/prubiocosta/ImageJ-scripts/blob/master/File%20Handling/widefield_FFDF_display/files/Settings_file.txt) and [example image correction file](https://github.com/prubiocosta/ImageJ-scripts/blob/master/File%20Handling/widefield_FFDF_display/files/Correction_file.txt). 

## Input files preparation

This macro needs 2 files in .txt format:

### A. Settings file

Here, you need to establish which images you want to correct.

This file needs to be in the following format:

`Image file path + tab + ROI X coordinate + tab + ROI Y coordinate + tab + Background value`

![image](https://user-images.githubusercontent.com/91415505/150989874-4887b971-0968-43cc-a5cc-08eccfe3d7da.png)

Here you can see the [example file](https://github.com/prubiocosta/ImageJ-scripts/blob/master/File%20Handling/widefield_FFDF_display/files/Settings_file.txt), and also the [empty example file](https://github.com/prubiocosta/ImageJ-scripts/blob/master/File%20Handling/widefield_FFDF_display/files/Settings_file_empty.txt) to fill out yourself. The example file will not work as it is, you need to manually write the path of the images on your computer. 

Notice that the first line **must** always be the headings line. 

### B. Image correction file

Here, you need to establish where are the image correction files. 

This file needs to be in the following format:

`DF file path + tab + FF file path + tab + LUT min + tab + LUT max`

![image](https://user-images.githubusercontent.com/91415505/150989954-141a0d4a-3657-4a16-81db-11e9241ed0bd.png)

Here you can see the [example file](https://github.com/prubiocosta/ImageJ-scripts/blob/master/File%20Handling/widefield_FFDF_display/files/Correction_file.txt), and also the [empty example file](https://github.com/prubiocosta/ImageJ-scripts/blob/master/File%20Handling/widefield_FFDF_display/files/Correction_file_empty.txt) to fill out yourself. The example file will not work as it is, you need to manually write the path of the images on your computer. 

Notice that the first line **must** always be the headings line. 

## Instructions

1. Open `widefield_FFDF_display` in ImageJ / Fiji (**File > Open...**).

2. Run the macro.

3. Interact with the macro menu: select the aproppiated files and choose the macro options.

![image](https://user-images.githubusercontent.com/91415505/150990078-03e65cf0-97f9-4874-8ad0-2b429fb1d552.png)

4. Select the aditional correction settings.

![image](https://user-images.githubusercontent.com/91415505/150990628-3fcc1d13-3252-4a72-8b32-17c87bcdefe8.png)

5. If *Do crop* was selected, determinate the Width and Height of the Crop.

![image](https://user-images.githubusercontent.com/91415505/150990794-adba6246-c22e-4255-a5e1-86575f0afac2.png)

6. In case you selected the zero background option, the macro will stop in any image which its background value on the settings file is 0, so you can manually determine its real value. 

## Example dataset

You can try yourself this macro on the following [dataset](https://github.com/prubiocosta/ImageJ-scripts/tree/master/File%20Handling/widefield_FFDF_display/dataset/Target_images) and its correspondent [background correction files](https://github.com/prubiocosta/ImageJ-scripts/tree/master/File%20Handling/widefield_FFDF_display/dataset/Background_correction_images).
