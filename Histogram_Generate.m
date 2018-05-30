%{
Author: Jay Chang
Contact:ruijiezh@usc.edu
Date:   May 30th 2018
%}

%{
Generate Histogram based on the SNR data we get from 'Image_Data_Histogram.m'

Input:  rf_filename      - The excel file that contains SNR data of RF coil
        siemens_filename - Similar to above
        unic_filename    - Similar to above

Output: The histogram figures will be stored as .jpg in the current
        directory. Line 27 to Line 121 generate slice 2 to slice 23.
        Line 124 to the end generate SNR histogram of sum of all slices.
%}

rf_filename = 'D:\Summer Internship\RF Histogram Data.xlsx';
siemens_filename = 'D:\Summer Internship\SIEMENS Histogram Data.xlsx';
unic_filename =  'D:\Summer Internship\UNIC Histogram Data.xlsx';

%Data container for all_slice generating
all_slice_rf(:,:) = 0;
all_slice_unic(:,:) = 0;
all_slice_siemens(:,:) = 0;

%Data container for each slice
rf_slice = cell(1,24);          %in case we want all the slices, we define 24 cells here
siemens_slice = cell(1,24);
unic_slice = cell(1,24);

%read slice 2 to slice 23 one by one
for i = 2:23
    %read data from excel, each cell contains 1 slice data.
    rf_slice{i} = xlsread(rf_filename,i);
    siemens_slice{i} = xlsread(siemens_filename,i);
    unic_slice{i} = xlsread(unic_filename,i);
     
    %for the same slice, no matter RF, SIEMENS or UNIC, the ROI will be the
    %smae.
    [A,B] = size(rf_slice{i});
    
    %get the max value of each slice
    max_rf = max(rf_slice{i}(:));
    max_unic = max(unic_slice{i}(:));
    max_siemens = max(siemens_slice{i}(:));
    MAX    = max(max_rf, max_unic);
    MAX    = max(MAX, max_siemens);

    %define the x axis based on the max value of this slice
    %then use hist function to calculate the distribution of SNR.
    if MAX <= 100
        x = [10,20,30,40,50,60,70,80,90,100];

        distribution_rf = hist(rf_slice{i},x);
        distribution_rf = sum(distribution_rf,2);

        distribution_unic = hist(unic_slice{i},x);
        distribution_unic = sum(distribution_unic,2);

        distribution_siemens = hist(siemens_slice{i},x);
        distribution_siemens = sum(distribution_siemens,2);

    elseif MAX <= 250
        x = [25,50,75,100,125,150,175,200,225,250];

        distribution_rf = hist(rf_slice{i},x);
        distribution_rf = sum(distribution_rf,2);

        distribution_unic = hist(unic_slice{i},x);
        distribution_unic = sum(distribution_unic,2);

        distribution_siemens = hist(siemens_slice{i},x);
        distribution_siemens = sum(distribution_siemens,2);

    elseif MAX <= 500
        x = [50,100,150,200,250,300,350,400,450,500];

        distribution_rf = hist(rf_slice{i},x);
        distribution_rf = sum(distribution_rf,2);

        distribution_unic = hist(unic_slice{i},x);
        distribution_unic = sum(distribution_unic,2);

        distribution_siemens = hist(siemens_slice{i},x);
        distribution_siemens = sum(distribution_siemens,2);

    elseif MAX <= 750
        x = [75,150,225,300,375,450,525,600,675,750];

        distribution_rf = hist(rf_slice{i},x);
        distribution_rf = sum(distribution_rf,2);

        distribution_unic = hist(unic_slice{i},x);
        distribution_unic = sum(distribution_unic,2);

        distribution_siemens = hist(siemens_slice{i},x);
        distribution_siemens = sum(distribution_siemens,2);

    elseif MAX <= 1000
        x = [100,200,300,400,500,600,700,800,900,1000];

        distribution_rf = hist(rf_slice{i},x);
        distribution_rf = sum(distribution_rf,2);

        distribution_unic = hist(unic_slice{i},x);
        distribution_unic = sum(distribution_unic,2);

        distribution_siemens = hist(siemens_slice{i},x);
        distribution_siemens = sum(distribution_siemens,2);

    else
        error('Max value exceeds expections, need to set new x axis in program')
    end

    %draw RF, UNIC and SIEMENS coils in the same graph.
    Y = [distribution_rf, distribution_unic, distribution_siemens];
    b = bar(x,Y,1);
    
    xlabel('SNR','fontsize',16);  
    ylabel('Number of Pixels','fontsize',16); 
    title(['Slice ', num2str(i)],'fontsize',16,'fontweight','bold');

    set(b,{'facecolor'},{'g';'r';'b'});
    legend_h = legend(b,'RF coil','UNIC coil','SIEMENS coil');
    set(legend_h, 'fontsize',8,'fontweight','bold');
    saveas(gcf,['slice_',num2str(i),'.jpg']);   %save as picture in the current directory
    close all;
 
    %we use a fixed x scale in the all_slice histogram
    %similar to above, we use hist function to calculate the distribution
    x = [50,100,150,200,250,300,350,400,450,500,550,600,650,700,750,800];
    rf_dis(:,i)    = sum(hist(rf_slice{i},x),2);
    unic_dis(:,i)  = sum(hist(unic_slice{i},x),2);
    siemens_dis(:,i) = sum(hist(siemens_slice{i},x),2);
    all_slice_rf = all_slice_rf + rf_dis(:,i);
    all_slice_unic = all_slice_unic + unic_dis(:,i);
    all_slice_siemens = all_slice_siemens + siemens_dis(:,i);
end
    
%similar to above, draw RF, UNIC and SIEMENS coils in the same graph.
Y = [all_slice_rf, all_slice_unic, all_slice_siemens];
b = bar(x,Y,1);    
    
set(gca,'xtick',[50 100 150 200 250 300 350 400 450 500 550 600 650 700 750]);
xlabel('SNR','fontsize',16);  
ylabel('Number of Pixels','fontsize',16); 
title('All Slice ','fontsize',16,'fontweight','bold');

set(b,{'facecolor'},{'g';'r';'b'});
legend_h = legend(b,'RF coil','UNIC coil','SIEMENS coil');
set(legend_h, 'fontsize',8,'fontweight','bold');
saveas(gcf,'all_slice.jpg');   %save as picture in the current directory
    
