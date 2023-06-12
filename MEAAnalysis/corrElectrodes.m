function corr=corrElectrodes(SpikeMask)

dub=waitbar(0,'correlate');
corr=zeros(60);
for i=1:60
    waitbar(i/60);
    for j=1:60
        if i<j
            C=max(xcorr(SpikeMask(:,i),SpikeMask(:,j)));
            if ~isempty(C)
                corr(i,j)=C;
            else
                corr(i,j)=0;
            end
        end
    end
end
delete(dub);