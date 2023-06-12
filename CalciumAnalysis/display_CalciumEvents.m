function display_CalciumEvents(A)
    count=0;
    for i=1:size(A,2)
        if ~isempty(A(i).Spikes)
            for j=1:size(A(i).Spikes)
                count=count+1;
                SpikeArray(count,1)=i;
                SpikeArray(count,2)=[A(i).Spikes.Frame(j).Frame];
            end
        end
    end
    scatter(SpikeArray(:,2),SpikeArray(:,1),'k','.')
end