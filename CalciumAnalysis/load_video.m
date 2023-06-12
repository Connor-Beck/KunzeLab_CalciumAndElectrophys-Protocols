function V = load_video(varargin)
    switch nargin
        case 0
            [file,filepath]=uigetfile({'*.tiff*','All Files'},'Select Video File');
            filename=strcat(filepath,file);
        case 1
            filename=varargin{1};
    end
    
    

    %Obtain values for the image stack that will be used throughout the code     
    tiff_info = imfinfo(filename); 
    %Create Structure Vid with the image details for easy access
    V.Width=tiff_info.Width;
    V.Height=tiff_info.Height;
    V.Length=numel(tiff_info);
    %load in the Video frame by frame into Vid.Frame(#).Image
    H = waitbar(0,'Loading Images');
    for k = 1:V.Length
        waitbar(k/V.Length)
        Image = imread(filename,'Index', k);
        V.Frame(k).I = sum(Image,3);
    end
    delete(H)
end