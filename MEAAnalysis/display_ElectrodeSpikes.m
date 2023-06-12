function display_ElectrodeSpikes(SpikeTrain)

for i=1:size(SpikeTrain,1)
    scatter(SpikeTrain{i,1},ones(size(SpikeTrain{i,1},1),1)*i,4,'k','filled')
    hold on
end