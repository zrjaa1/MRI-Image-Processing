%{
Author: Maggie
Note:   The code is originally wrote by Maggie, Jay added some lines and comments. 
Contact:ruijiezh@usc.edu
Date:   May 30th 2018
%}

%{
Process MRI Images
Input:  pathfile - The directory that contains MRI images
        filename - The designed excel file. The SNR data of MRI images we 
                   calculated in this program will be stored in this
                   file.
        setfile  - The excel file that defines border
                   conditions for each slice.
Output: SNR -           24 cells, each cell contains SNR data for each slice.
        ReverseSRN -    24 cells, similar to SNR, but used to generate
                        heatmap due to the Prism's setting needed.
        MAX -           1x24 array, each column contains the MAX value of 
%}

clc; clear all; close all;

% need to be changed according to the directory location on the computer.
pathfile = ['D:\Summer Internship\ImageProcessing for Grant Proposal\RF_ONLY_TOP_PLATE_TG283_0007']; 
filename = 'D:\Summer Internship\RF Histogram Data.xlsx';
setfile = ['D:\Summer Internship\Border_Data_modified.xlsx'];

%read the directory information
addpath(pathfile);
list = dir(pathfile);
f = length(list);

%Set up area boundaries for signal/noise rectangles
%Signal X and Y lower and upper		
border = xlsread(setfile);

%Read each image individualy (i = 1 means present directory, i = 2 means
%root directory, so we starts from i = 3).
for i = 3:f
    I = dicominfo(list(i).name);        %Read Image
    Y = dicomread(I);                   %reads pixels
    Y = double(Y);                      %converts to double 
    [row, column, depth] = size(Y);

    %read defined borders
    Nx_low = border(i-2,2);
    Nx_up  = border(i-2,3);
    Ny_low = border(i-2,4);
    Ny_up  = border(i-2,5);
    
    Sx_low = border(i-2,7);
    Sx_up  = border(i-2,8);
    Sy_low = border(i-2,9);
    Sy_up  = border(i-2,10);
        
    width = (Sx_up - Sx_low) + 1;
    length = (Sy_up - Sy_low) + 1;
    %reset data to 0 for each new image
    s = 1;             n = 1;           %s and n keep track of the number of points
    S(Sx_up-Sx_low,Sy_up-Sy_low) = 0;    N(550,550) = 0;   %S and N are holder arrays for data
    SNR = cell(1,24);                   %contains the original cell information, by default, we read slice 1 to slice 24
    ReverseSNR = cell(1,24);            %contains the Reverse data that used to generate heatmap in Prism7
    MAX(24)=0;                          %contains the max value of each slice

    %read data by pixel
    for k = 1:row
        for l = 1:column
            %inside the signal box
            if k >= Sx_low && k <= Sx_up && l >= Sy_low && l <= Sy_up && Y(k,l)>10      %inside the Signal box
                m = (k - Sx_low)+1;
                z = (l - Sy_low)+1;
                S(m,z) = Y(k,l);  %stores data
                s = s + 1; %makes sure you get all data
            elseif (k < Nx_low || k > Nx_up || l < Ny_low || l > Ny_up) && Y(k,l) < 10 %less than 10 = NOISE
                N(n) = Y(k,l); %Stores data in the holder array
                n = n + 1;
            end
        end
    end

    Noise(1:n-1) = N(1:n-1);
    NOISE = std(Noise);

    SNR{i-2} = S/NOISE;
    slice_max1 = max(SNR{i-2});
    slice_max2 = max(slice_max1);
    MAX(i-2) = slice_max2;
 
    ReverseSNR{i-2} = MAX(i-2)-SNR{i-2};
    xlswrite(filename,SNR{i-2},i-2);
end
