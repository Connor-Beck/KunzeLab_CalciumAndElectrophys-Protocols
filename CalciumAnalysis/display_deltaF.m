function display_deltaF(A)
    dFdt=zeros( size(A(1).Fluorescence,2)-1,size(A,2));
    for i=1:size(A,2)
        dFdt(:,i)=[A(i).DeltaF.DF]';
    end
    plot(linspace(0, size(A(1).Fluorescence,2)-1, size(A(1).Fluorescence,2)-1),dFdt','Color','k');
    xlim([0, size(A(1).Fluorescence,2)])
    ylim ([-1.1*max(dFdt,[],'all'),1.1*max(dFdt,[],'all')])
end