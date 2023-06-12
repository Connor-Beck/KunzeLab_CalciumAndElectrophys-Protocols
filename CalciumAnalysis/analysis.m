function [A,Export]=analysis(V,S,varargin)
    switch nargin
        case 2
            Dev=3;
            Noise=0.05;
        case 3
            Dev=varargin{1};
            Noise=0.05;
        case 4
            Dev=varargin{1};
            Noise=varargin{2};
    end
    Export.SpikeTrain=zeros(V.Length-1,S.ROI.Length);
    H_analysis = waitbar(0,'Analyzing High value areas');
    for i= 1:S.ROI.Length
        waitbar(i/S.ROI.Length)
        Region = S.ROI.Coords(1,i).Coords;
        RegionH = size(Region,1);
        for k = 1:V.Length    
            for j = 1:RegionH
                Intensity=zeros(RegionH,1);
                loc = Region{j,1};
                Intensity(j,1) = V.Frame(k).I(loc(1,1),loc(1,2));
            end
            A(i).Fluorescence(k).F = mean(Intensity);
            if k>1
                A(i).DeltaF(k-1).DF=A(i).Fluorescence(k).F-A(i).Fluorescence(k-1).F;
            end
        end
        %DF Spike Detection
        spike_stop=0;
        count_ST=0;
        DF=[A(i).DeltaF.DF];
        if ~isempty(DF(DF>Dev*std(DF)))
            if ~isempty(DF(DF>Noise))    
                count=0;
                for k = 1:V.Length-1
                        if DF(1,k) >= Dev*std(DF) && DF(1,k) >= Noise && spike_stop==0
                            count=count+1; count_ST=count_ST+1;
                            A(i).Spikes.Frame(count).Frame = k;
                            Export.SpikeTrain(k,i)=1;
                            spike_stop=1;
                        elseif A(i).DeltaF(k).DF < 0 && spike_stop == 1
                            spike_stop=0;
                        end
                end
            end
        end
    end
    for i=1:size(A,2)
        if ~isempty(A(i).Spikes)
            for j=1:size(A(i).Spikes)
                count=count+1;
                Export.SpikeArray(count,1)=i;
                Export.SpikeArray(count,2)=[A(i).Spikes.Frame(j).Frame];
            end
        end
    end
    delete(H_analysis)
end