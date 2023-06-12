% run Granger first
% Then run this;
%% Uncomment this section if you just want to run random data
% clear
% clc 
% 
% corr=rand(59)/80; %<- Use to generate random correlation values

%%

Electrodes=500:500:4000;
count=1;
% Create storage array for Electrode information
%Generates the electrode coordinates from the multichannel layout
radius=100;
for i = 1:length(Electrodes)
    for j=1:length(Electrodes)
        if i==1 && j==1 || i==1 && j==5|| i==1 &&j==8 || i==8 && j==1 || i==8 && j==8
        else
            centerX = Electrodes(j);
            centerY = Electrodes(i);
            for x = min(Electrodes)-radius:max(Electrodes)+radius
                for y = min(Electrodes)-radius:max(Electrodes)+radius
                    dX = abs(x-centerX);
                    dY = abs(y-centerY);
                    pixelrad = (dX)^2 + (dY)^2;
                    if pixelrad <= radius^2
                        Image(x,y) = 0;
                    end
                end
            end
            MC_label(count,1)=strcat(string(i),string(j));
            Centroid(count,:)=[Electrodes(i),Electrodes(j)];
            count=count+1;
        end
    end
end
Centroid(Centroid==0)=[];
CentroidX=Centroid(:,1);
CentroidY=Centroid(:,2);
MC_label = rmmissing(MC_label);

%Removes reference electrode from the Map
for i=1:59
    if L(MC_label(i))<15
        MAT_label(i,1)=L(MC_label(i));
    else
        MAT_label(i,1)=L(MC_label(i))-1;
    end
end

%Create table for storing information
eKey=table(MAT_label,MC_label,CentroidX,CentroidY);
%% Locate causation pairs
%locates the electrode IDs for the from (f) and to (t) high causation

count=1;
figure(1);
f=double.empty(1,0);
t=double.empty(1,0);
weights=double.empty(1,0);
for i = 1:59
    for j=1:59
        correlation_value=corr(eKey.MAT_label(i),eKey.MAT_label(j));
        if correlation_value>0
            f(count,1)=i;
            t(count,1)=j;
            weights(count,1) = correlation_value;
            x1=eKey.CentroidX(i);x2=eKey.CentroidX(j);
            y1=eKey.CentroidY(i);y2=eKey.CentroidY(j);
            pl=plot([x1,x2],[y1,y2],'k','LineWidth',2*correlation_value/13);
            pl.Color(4)=correlation_value/26;
            count=count+1;
            hold on
        end
    end
end

scatter(eKey.CentroidX,eKey.CentroidY,100,'fill','k');
xlim([0,4500]);
ylim([0,4500]);
set(gca,'XTick',[], 'YTick', []);
set(gca, 'YDir','reverse');

