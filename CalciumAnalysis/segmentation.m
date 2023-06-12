function S = segmentation(V,varargin)
    switch nargin
        case 1
            t_S=0.5;
            t_D=0.2;
        case 3
            t_S=varargin{1};
            t_D=varargin{2};
    end
    S.threshold.FrameZero=V.Frame(1).I;
    %scale threshold
    t_S=t_S*256;
    %threshold case
    S.threshold.img = zeros(V.Height,V.Width);
    H_segmentation = waitbar(0,'Thresholding Video - Standard');
    if t_S==0
        S.threshold.bw1=S.threshold.img;
    else
        for k = 1:V.Length
            waitbar(k/V.Length)
            Frame=im2double(V.Frame(k).I);
            Frame(Frame<t_S)=0;
            S.threshold.img=S.threshold.img+Frame;
        end
        S.threshold.img=S.threshold.img./(V.Length);
        S.threshold.bw1=mat2gray(imbinarize(S.threshold.img,2*t_S/3));
    end
    delete(H_segmentation)   
    %differential case
    H_segmentation = waitbar(0,'Thresholding Video - Differential');
    S.threshold.SSD=zeros(V.Height,V.Width);
    if t_D==0
        S.threshold.bw2=S.threshold.SSD;
    else
        for i=1:V.Length-1
            waitbar(i/V.Length)
            S.threshold.SSD=S.threshold.SSD+(im2double(V.Frame(i+1).I-V.Frame(i).I));
        end
        S.threshold.SSD=S.threshold.SSD./(V.Length-1);
        S.threshold.bw2=imbinarize(S.threshold.SSD,t_D*max(S.threshold.SSD,[],'all'));
        S.threshold.bw2=mat2gray(imfill(S.threshold.bw2,'holes'));
    end
    delete(H_segmentation)
    %%Combine identified pixels of bw1 & bw2
    S.threshold.binary=S.threshold.bw1+S.threshold.bw2;
    S.threshold.binary(S.threshold.binary~=0)=1;
    %
    [S.ROI.edges,S.ROI.Indexed_Img]=bwboundaries(S.threshold.binary);
    Centroid = regionprops(S.ROI.Indexed_Img,'centroid');
    S.ROI.centroids = cat(1, Centroid.Centroid);
    S.ROI.Length=size(S.ROI.edges,1);
    delete(H_segmentation)
    
    H_segmentation = waitbar(0,'Segmenting Regions of Interest');
    for x = 1:S.ROI.Length
        waitbar(x/S.ROI.Length)
        ROI = S.ROI.edges{x};
        %Find the minimum and maximums of coordinates for each ROI 
        minXY = [min(ROI(:,2)),min(ROI(:,1))];
        maxXY = [max(ROI(:,2)),max(ROI(:,1))];
        %Create a box just larger than the min and max and project the ROI
        %edges onto it
        ROIadj = zeros(length(S.ROI.edges{x}),2);
        ROIadj(:,1) = ROI(:,1)-minXY(1,2)+1;
        ROIadj(:,2) = ROI(:,2)-minXY(1,1)+1;
        SingleBoundary = zeros(maxXY(1,2)-minXY(1,2)+2,maxXY(1,1)-minXY(1,1)+2);
        for i = 1:size(ROIadj,1)
            SingleBoundary(ROIadj(i,1),ROIadj(i,2)) = 1;
        end
        %Use imfill to fill all holes in the cell where a coordinate of 1
        %indicates a pixel within ROI and 0 is not within ROI
        FilledCell = imfill(SingleBoundary(:,:),'holes');
        num = 1;
        %Scan over the resulting ROI and find coordinates of all pixels equal
        %to 1 and project coordinates back onto the total frame.
        for i = 1:size(FilledCell,1)
            for j = 1:size(FilledCell,2)
                if FilledCell(i,j) == 1
                    Cell{num,:} = [i+minXY(1,2)-1,j+minXY(1,1)-1];
                    num = num+1;
                end
            end
        end
        S.ROI.Coords(x).Coords = Cell;
        clear Cell
    end
    delete(H_segmentation)
end