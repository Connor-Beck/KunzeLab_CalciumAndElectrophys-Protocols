%% Electrode Spike Detection
%   Detects spikes from a single electrode.
%
%   Arguments:
%       * std_dev_thresh : # of std devs to use for spike detection
%       * refract_period : the minimum space between spikes (in seconds) (e.g. 0.002 for 2 ms)

function [SpikeMask, SpikeTrain] = Electrode_SpikeDetection(E,L, t, varargin)
    switch nargin
        case 3
            dev=5;
            refract=2;
        case 4
            dev=varargin{1};
            refract=2;
        case 5
            dev=varargin{1};
            refract=varargin{2};
    end
    r=refract/1000;
    SpikeTrain={};
    H = waitbar(0,'Detecting Electrode Spikes...'); 
    for m=1:size(E,1)
        waitbar(m/size(E,1))
        tMEA = t;
        EOI = E{m};
        % Initialize two time vectors: one that will be used as a binary mask to
        % denote locations of spikes (tspikesMEA) and one that will be used to
        % store spike time stamps for graphing and analysis (xspikesMEA)
        tspikesMEA = zeros(size(t));
        xspikesMEA = zeros(size(t));

        % Calculate standard deviation of electrode of interest. Multiply by 5.5 to
        % obtain threshold per Ide et al. (2010)
        EOIstd = std(EOI);
        EOIthresh = -dev * EOIstd; %-4.75*EOIstd; %-4.5*EOIstd;

        % Initialize below threshold binary variable
        if EOI(1) < EOIthresh
            belowthresh = 1;
        else
            belowthresh = 0;
        end

        % Comb through EOI data. If value is below threshold and data was
        % previously above threshold, mark the time and correct the below threshold 
        % variable. If value is above threshold and data was previously below 
        % threshold, just correct the below threshold variable.
        for i = 1:size(EOI)
            if EOI(i) < EOIthresh && belowthresh == 0
                tspikesMEA(i) = 1;
                belowthresh = 1;
            elseif EOI(i) > EOIthresh && belowthresh == 1
                belowthresh = 0;
            end
        end

        % Use the binary mask to obtain and store spike times
        for i = 1:size(tspikesMEA)
            if tspikesMEA(i) == 1
               xspikesMEA(i) = tMEA(i);
            end
        end

        % Condense spike times vector by deleting all zeros
        xspikesMEA(xspikesMEA == 0) = [];

        % Delete all spike timestamps that fall within <refract_period> ms of a previous spike
        i = 2;
        k = size(xspikesMEA,1);
        while i <= k
            if xspikesMEA(i,1) < xspikesMEA(i-1,1) + r
                xspikesMEA(i,:) = [];
            end
            i = i+1;
            k = size(xspikesMEA,1);
        end
 
        % Assign outputs
        SpikeMask(:,m) = tspikesMEA;
        SpikeTrain{m,1} = xspikesMEA;
    end
    %Set reference electrode to 0
    SpikeMask(:,L('Ref'))=0;
    SpikeTrain{L('Ref'),1}=0;
    delete(H)
end