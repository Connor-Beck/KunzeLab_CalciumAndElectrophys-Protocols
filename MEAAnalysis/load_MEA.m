%% Read Electrode Data
% Prompts the user for the .h5 file containing the MEA data if not provided
% with a filepath to appropriate data. Input 'ask' as the argument.
% Returns a cell array of the electrode data, an associated time vector,
% and the map from labels to their indices in the cell array.

function [E, t, L] = load_MEA(varargin)
    
    switch nargin
        case 0
            [mea_file, mea_path] = uigetfile('*.h5','Select MEA data');
            mea_filename = strcat(mea_path, mea_file);
            Fs=10000;
        case 1
            mea_filename = varargin{1};
            Fs=10000;
        case 2
            mea_filename = varargin{1};
            Fs=varargin{2};
    end
    channelds = '/Data/Recording_0/AnalogStream/Stream_0/ChannelData';
    labelsds = '/Data/Recording_0/AnalogStream/Stream_0/InfoChannel';
        %% Load MEA data
    % Open ui to enable user to select hdf file and then obtain data 
    % for each electrode
    H = waitbar(0,'Reading electrode data...');    
    ChannelData = h5read(mea_filename,channelds);
    %% Preprocess MEA data
    % Creates a map using the labels field from InfoChannel to convert
    % column-row index into linear electrode index in the data
    InfoChannel = h5read(mea_filename,labelsds);
    keySet = InfoChannel.Label;
    valueSet = 1:60;
    L = containers.Map(keySet,valueSet);

    % Create time vector for MEA data and extract the data of the EOI
    t = 0:1/Fs:(size(ChannelData,1)-1)/Fs;
    t = t';
    %Create a cell array that will hold the electrode data
    E = cell(60,1);
    % Obtain conversion factor of data (depends on compression of hdf), then
    % apply it and convert the electrode data from picovolts to microvolts
    ConversionFactor = double(InfoChannel.ConversionFactor(1));
    
    for i = 1:60
        E{i} = ChannelData(:,i);
        E{i} = 10^-6*ConversionFactor*double(E{i});
        waitbar(i/60)
    end 
    delete(H)

end