clear all; close all; clc;

StartingFrame = 1;
EndingFrame = 448;
Xcentroid = [ ];
Ycentroid = [ ];

for k = StartingFrame : EndingFrame-1
    pos1 = imread(['ant/img',sprintf('%2.3d',k),'.jpg']);
    pos2 = imread(['ant/img',sprintf('%2.3d',k+1),'.jpg']);
    diff1 = abs(pos1-pos2);
    hsv = rgb2hsv(diff1);
    I = hsv(:,:,3);
    Ithresh = I > 0.05;

    SE = strel('disk',3,0);
    Iopen = imopen(Ithresh,SE);

    Iclose = imclose(Iopen,SE);

    [labels,number] = bwlabel(Iclose,8);
    if number > 0
        Istats = regionprops(labels,'basic','Centroid');
        [maxVal, maxIndex] = max([Istats.Area]);
    
        Xcentroid = [Xcentroid Istats(maxIndex).Centroid(1)];
        Ycentroid = [Ycentroid Istats(maxIndex).Centroid(2)];
    end
end

%Plot the trail
imshow(pos2);
hold on;
plot(Xcentroid,Ycentroid,'r');
