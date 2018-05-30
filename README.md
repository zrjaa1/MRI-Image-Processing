# MRI Image Processing

This is the MRI Image Processing code. The program will import the MRI images and calculate SNR based on the border conditions you set. 

What you need to run this code:

1. a directory that contains MRI Images (usually .dcm files or .ima files).
2. an excel file that contains the border conditions of the MRI Image that you desire. see 'Border_Data_modified.xlsx' as an example(the MAX values on the right can be ignored.)
3. create a excel file. (create multiple sheets in excel if you need to deal with more than 1 image at a time)
4. open 'Image_Data_Histogram.m' in Matlab. 
5. In the code, change the parameter 'pathfile' to the directory path in step1.
6. In the code, change the parameter 'setfile' to the excel file path in step2.
7. In the code, change the parameter 'filename' to the excel file path in the step3.
8. In the code, line 40, change the i's loop range so that you can control which images you want to process. (Note that for each image, one sheet is used to store the data, you should create it in advance in step 3)
9. Run the code, you should see the calculated SNR data in the excel in step 3. (It might take several minutes to write data in the excel, depending on how many images you want to process. If you open the file during excuting the code, the code will stop and you need to run it again until it finishes).
10. open 'Histogram_Generate.m' in Matlab.
11. In the code, change the xx_filename to the excel file path in step 3. 
12. In the code, Line 29-31, change the cell number that you need. (for example, you have 24 sheets in the excel, you need 24 cells)
13. In the code, Line 34, change the i's loop range so that you can control which sheets you want to deal with.
14. You may want to change the x axis to suit your case. For the single image SNR graph, it is set in the Line 53, Line 65, Line 77 and so on. For the all_image graph, it is set in the Line 133 and Line 146. 
15. You may want to change other parameters such as xlabel, title and picture's name you want to store. Shoudln't be difficult.
16. run the code, you should see SNR Histogram pictures in the current directory. (It It might take several minutes to write data in the excel, depending on how many images you want to generate.)
