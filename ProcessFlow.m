%% Micro-electrode Processing
%% ----------------------------------------------------------------------------------------------------------%%

%Load in the micro-electrode data stored in the '.h5' file using the load_MEA() function
[E, t, L] = load_MEA();

%Plot the data using
display_Electrodes(t,E,L);

%%
%Plot two electrodes
display_Electrodes(t,E,L,'54','55');

%% __________________________________________________________________________________________________________%%
%Filter Electrodes
fE = filterElectrodes(E);

%display filtered signals
display_Electrodes(t,fE,L);

%% __________________________________________________________________________________________________________%%
%Detect Electrical spikes based on falling edge:
[SpikeMask, SpikeTrain] = Electrode_SpikeDetection(fE,L,t);

%Plot Electrical spikes
display_ElectrodeSpikes(SpikeTrain)


%% Calcium Video Processing
%% ----------------------------------------------------------------------------------------------------------%%

%Load in the calcium video stored in the '.tiff' file using the load_video() function
V = load_video();

%Show a frame using
imshow(mat2gray(V.Frame(1).I))


%% __________________________________________________________________________________________________________%%
%Segment the image using standard threshold
S = segmentation(V,0.5,0);

%display segmented image
display_ROI(S)

%% __________________________________________________________________________________________________________%%
%Segment the image using differential threshold
S = segmentation(V,0,0.28);

%display segmented image
display_ROI(S)


%% __________________________________________________________________________________________________________%%
%Segment the image using combined thresholding
S = segmentation(V,0.5,0.28);

%display segmented image
display_ROI(S)


%% __________________________________________________________________________________________________________%%
%Analyze the calcium data within the segmented regions
[A,Export]=analysis(V,S);

%plot the average fluorescence for each cell
display_F(A);

%% __________________________________________________________________________________________________________%%
%plot the numerical derivative of average fluorescence for each cell

display_dFdt(A);

%% __________________________________________________________________________________________________________%%
%plot the detected calcium events from the numerical derivative

display_CalciumEvents(A);


%% Signal Correlation
%% ----------------------------------------------------------------------------------------------------------%%
%Electrical Signal Correlation

%Correlate the electrical signals using the continuous correlation function
E_corr=continuous_corr(SpikeMask);

%% __________________________________________________________________________________________________________%%
%Correlate the electrical signals using the continuous correlation function
Ca_corr=discrete_corr(Export.SpikeTrain);

%% __________________________________________________________________________________________________________%%
%Downsample Micro-Electrode array to match Calcium Sampling rate
[ds_SpikeMask,ds_SpikeTrain]=Downsample_MEA(t,SpikeMask,1);

%Observe Calcium Spikes and Electrodes 54 and 55
display_CaE(SpikeTrain,L,'54','55',Export.SpikeArray)
%%
%Combine Calcium Signals into one
CA_Merged = CalciumEvent_Merger(A,1.2);

display_CaE(SpikeTrain,L,'54','55',CA_Merged)
%%

%Synchronous correlation of the Calcium Signal to Electrode 54 and 55
Ca_E54_Synch_corr=discrete_corr(CA_Merged,ds_SpikeMask(:,L('54')));
Ca_E55_Synch_corr=discrete_corr(CA_Merged,ds_SpikeMask(:,L('55')));

