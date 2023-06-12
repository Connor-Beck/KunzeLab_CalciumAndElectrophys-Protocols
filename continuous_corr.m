function corr=continuous_corr(Signal_A,varargin)
    switch nargin
        case 1
            corr=corrcoef(Signal_A);
            imshow(corr,'InitialMagnification', 800);
        case 2
            Signal_B=varargin{1};
            if size(Signal_A,1) == size(Signal_B,1)
                r=corrcoef(Signal_A,Signal_B);
            elseif size(Signal_A,1)>size(Signal_B,1)
                Signal_A(size(Signal_B,1)+1:size(Signal_A,1),:)=[];
                r=corrcoef(Signal_A,Signal_B);
            else
                Signal_B(size(Signal_A,1)+1:size(Signal_B,1),:)=[];
                r=corrcoef(Signal_A,Signal_B);
            end
            corr=r(1,2);
    end
end