function display_F(A)
    F=zeros( size(A(1).Fluorescence,2),size(A,2));
    for i=1:size(A,2)
        F(:,i)=[A(i).Fluorescence.F]';
    end
    plot(linspace(0, size(A(1).Fluorescence,2), size(A(1).Fluorescence,2)),F','Color','k');
    xlim([0, size(A(1).Fluorescence,2)])
    ylim ([0,1.1*max(F,[],'all')])
end