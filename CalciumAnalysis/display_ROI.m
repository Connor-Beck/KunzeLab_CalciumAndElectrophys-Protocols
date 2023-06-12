function display_ROI(S)
    figure('Name','ROI')
    subplot(2,2,1); imshow(S.threshold.bw1); title('Standard Threshold'); 
    subplot(2,2,2); imshow(S.threshold.bw2); title('Deviation Threshold');
    subplot(2,2,3); imshowpair(S.threshold.bw1,S.threshold.bw2);  title('Combined Threshold');
    subplot(2,2,4); 
    imshow(mat2gray(S.threshold.FrameZero)); title('Detected Regions');
    hold on;
    colors=['b' 'g' 'r' 'c' 'm' 'y'];
    for k=1:S.ROI.Length
        boundary = S.ROI.edges{k,1};
        plot(boundary(:,2), boundary(:,1),...
        'Color','b','LineWidth',3);
    end
    for k = 1:S.ROI.Length
        boundary = S.ROI.edges{k,1};
        rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
        col = boundary(rndRow,2); row = boundary(rndRow,1);
        h = text(col+3, row-3, num2str(S.ROI.Indexed_Img(row,col)));
       set(h,'Color','r','FontSize',6,'FontWeight','bold');
    end
end 