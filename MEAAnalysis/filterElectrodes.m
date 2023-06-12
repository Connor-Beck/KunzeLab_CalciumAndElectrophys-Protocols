%% Filter Electrode
% Takes a cell array of 60 electrodes and filters out 60 Hz hum
% as well as anything not between the low and high pass frequencies

function fE = filterElectrodes(E, varargin)
   
    switch nargin
        case 1
            sample_rate=10000;
            high_pass=300;
            low_pass=4000;
        case 3
            sample_rate=10000;
            high_pass=varargin{1};
            low_pass=varargin{2};
    end
    H = waitbar(0,'Filtering electrode data...');
    hpass = high_pass; % Highpass freq in Hz
    lpass = low_pass; % Lowpass freq in Hz
    
    fE = cell(60, 1);
    for i = 1:60
        if low_pass < 60
           f1 = filter60Hz(E{i}, sample_rate); 
        else
            f1 = E{i};
        end
        f2 = highpass(f1, hpass, sample_rate);
        fE{i} = lowpass(f2, lpass, sample_rate);
        waitbar(i/60)
    end
    delete(H)
end