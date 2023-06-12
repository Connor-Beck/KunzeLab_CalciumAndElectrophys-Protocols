function [ds_SpikeMask,ds_SpikeTrain]=Downsample_MEA(t,SpikeMask,Hz)

currFreq=1/(t(2,1)-t(1,1));
DSMag=currFreq/Hz;
ds_SpikeMask=zeros(size(SpikeMask,1)/DSMag,60);
for i=1:size(SpikeMask,2)
    for j=1:DSMag:size(SpikeMask,1)
        if any(SpikeMask(j:j+DSMag-1,i)==1)
            ds_SpikeMask((j-1)/DSMag+1,i)=1;
        end
    end
    if any(ds_SpikeMask(:,i))
        ds_SpikeTrain{i,1}=find(ds_SpikeMask==1);
    end
end