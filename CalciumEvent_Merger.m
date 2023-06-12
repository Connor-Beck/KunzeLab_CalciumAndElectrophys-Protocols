function CA_Merged = CalciumEvent_Merger(A,percent)
    Spikes=zeros(size(A(1).DeltaF,2),size(A,2));
    for i=1:size(A,2)
        if ~isempty(A(i).Spikes)
            for j=1:size(A(i).Spikes.Frame,2)
                Spikes(A(i).Spikes.Frame(j).Frame,i)=1;
            end
        end
    end    
    CA_Merged=sum(Spikes,2);
    CA_Merged(CA_Merged./size(A,2)<percent/100)=0;
    CA_Merged(CA_Merged>0)=1;            
end