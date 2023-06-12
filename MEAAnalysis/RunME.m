[E, t, L] = load_MEA();
fE = filterElectrodes(E); %<- Will filter Hp=300; LP=4000;

[SpikeMask, SpikeTrain] = Electrode_SpikeDetection(fE,L, t,4); %<- '4' is the standard deviation value. You can use this or change!
display_ElectrodeSpikes(SpikeTrain)


%% Limit to minute interval
%Use minute value (0.0001-60s = 1, 60s-120 = 2 ...)
Minute=3;
Timerange=[ 1          , 10000*60; 
            10000*60+1 , 10000*120; 
            10000*120+1 , 10000*180;
            10000*180+1 , 10000*240;];

% SpikeMask(1:size(SpikeMask,1)/2,:)=[];
% SpikeMask(size(SpikeMask,1)/2:end,:)=[];

SubSpikes=SpikeMask(Timerange(Minute,1):Timerange(Minute,2),:);

%%
[ts,id]=find(SubSpikes~=0);
scatter(ts./10000+Minute*60-60,id,10,'fill','k');

xlabel('Time'+" "+'(s)');
ylabel('Electrode'+" "+'ID');