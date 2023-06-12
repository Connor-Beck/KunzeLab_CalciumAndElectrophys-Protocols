function corr=discrete_corr(Signal_A,varargin)
    switch nargin
        case 1
            corr=zeros(size(Signal_A,2));
            for i=1:size(Signal_A,2)
                for j=1:size(Signal_A,2)
                    if i~=j && sum(Signal_A(:,i))~=0 && sum(Signal_A(:,j))~=0 
                        corr(i,j) = dice(Signal_A(:,i),Signal_A(:,j));
                    else
                        corr(i,j)=1;
                    end
                end
            end
            imshow(corr,'InitialMagnification', 800)
        case 2
            Signal_B=varargin{1};
            if size(Signal_A,1) ~= size(Signal_B,1)
                if size(Signal_A,1)>size(Signal_B,1)
                    Signal_A(size(Signal_B,1)+1:size(Signal_A,1),:)=[];
                else
                    Signal_B(size(Signal_A,1)+1:size(Signal_B,1),:)=[];
                end
            end
            Merge=cat(2,Signal_A,Signal_B);
            corr=zeros(size(Merge,2));
            for i=1:size(Merge,2)
                for j=1:size(Merge,2)
                    corr(i,j) = dice(Merge(:,i),Merge(:,j));
                end
            end
            if size(corr,1)==2
                corr=corr(1,2);
            end
    end
end