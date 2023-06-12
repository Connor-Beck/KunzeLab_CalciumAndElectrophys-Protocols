%% Calcium Video Processing
%% ----------------------------------------------------------------------------------------------------------%%

%Load in the calcium video stored in the '.tiff' file using the load_video() function
V = load_video();

%% __________________________________________________________________________________________________________%%
%Segment the image using combined thresholding
S = segmentation(V,0.5,0.28); %<---These two values need to be optimized

%display segmented image
display_ROI(S)


%% __________________________________________________________________________________________________________%%
%Analyze the calcium data within the segmented regions
[A,Export]=analysis(V,S,3);

%plot the numerical derivative of average fluorescence for each cell
figure(1);
display_dFdt(A);

%plot the detected calcium events from the numerical derivative
figure(2);
display_CalciumEvents(A);