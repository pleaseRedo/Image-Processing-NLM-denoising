function [offsetsRows, offsetsCols, distances] = templateMatchingNaivedeprecate(row, col,...
    patchSize, searchWindowSize)

    %row = 1;
    %col = 1;
    %patchSize = 2;
    %searchWindowSize = 8;
% This function should for each possible offset in the search window
% centred at the current row and col, save a value for the offsets and
% patch distances, e.g. for the offset (-1,-1)
% offsetsRows(1) = -1;
% offsetsCols(1) = -1;
% distances(1) = 0.125;

% The distance is simply the SSD over patches of size patchSize between the
% 'template' patch centred at row and col and a patch shifted by the
% current  

%REPLACE THIS
offsetsRows = zeros(10,1);
offsetsCols = zeros(10,1);
image = imread('images/alleyNoisy_sigma20.png');
%distances = randn(10*10, 1);
% test = zeros(200,200,3);
% test(:,:,1) = magic(200);
% test(:,:,2) = magic(200);
% test(:,:,3) = magic(200);
patchSize = 1+patchSize+patchSize;
searchWindowSize = 1+searchWindowSize+searchWindowSize;
im = double(image);
[nrow,ncol,dim] = size(im);

paddImg = padarray(im,[searchWindowSize searchWindowSize],'symmetric');

offsetLimit = (searchWindowSize - patchSize)+1;
distances = zeros(offsetLimit,offsetLimit);
framedImage = paddImg(row+searchWindowSize-(searchWindowSize-1)/2:row+searchWindowSize+(searchWindowSize-1)/2,col+searchWindowSize-(searchWindowSize-1)/2:col+searchWindowSize+(searchWindowSize-1)/2,:);

p0 = paddImg(row+searchWindowSize-(patchSize-1)/2:row+searchWindowSize+(patchSize-1)/2,col+searchWindowSize-(patchSize-1)/2:col+searchWindowSize+(patchSize-1)/2,:);
% L3 - L2 - L4 + L1
windowCentre = (searchWindowSize-1)/2+1;

offsetIndex = [-(offsetLimit-1)/2:(offsetLimit-1)/2];

for i = 1:length(offsetIndex)
    for j = 1:length(offsetIndex)
        distances(i,j) = sum(sum(sum((framedImage(windowCentre+offsetIndex(i)-(patchSize-1)/2:windowCentre+offsetIndex(i)+(patchSize-1)/2,windowCentre+offsetIndex(j)-(patchSize-1)/2:windowCentre+offsetIndex(j)+(patchSize-1)/2,:) - p0).^2)));       
            
    end
    
end

%distances= distances/ (3*patchSize*patchSize);
offsetsRows = offsetIndex;
offsetsCols = offsetIndex;
%end