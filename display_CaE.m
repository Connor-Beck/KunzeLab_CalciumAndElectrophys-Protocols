function display_CaE(SpikeTrain,L,Electrode_ID1,Electrode_ID2,SpikeArray)

if size(SpikeArray,2)==1
    Spike(:,2)=find(SpikeArray==1);
    Spike(:,1)=1;
    SpikeArray=Spike;
    CaZ=800;
else
    CaZ=20;
end

max_T=min([max(SpikeTrain{L(Electrode_ID1),1}),max(SpikeTrain{L(Electrode_ID2),1}),max(SpikeArray(:,2))]);

subplot(3,1,1); 
scatter(SpikeTrain{L(Electrode_ID1),1},ones(size(SpikeTrain{L(Electrode_ID1),1},1),1),800,'k','|')
xlim([0,max_T]);
ylabel(strcat('Electrode #',Electrode_ID1));

subplot(3,1,2);
scatter(SpikeArray(:,2),SpikeArray(:,1),CaZ,'k','.')
xlim([0,max_T]);
ylabel('Calcium')

subplot(3,1,3); 
scatter(SpikeTrain{L(Electrode_ID2),1},ones(size(SpikeTrain{L(Electrode_ID2),1},1),1),800,'k','|')
xlim([0,max_T]); 
ylabel(strcat('Electrode #',Electrode_ID2));


end