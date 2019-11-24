function [offsetsRows, offsetsCols, distances] = templateMatchingNaive(row, col,...
    patchSize, searchWindowSize,image)
% Caveat, patchSize, windowSize in my program is actually the radius.


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

%distances = randn(10*10, 1);
% Get the real size of wind and patch.
patchSize = 1+patchSize+patchSize;
searchWindowSize = 1+searchWindowSize+searchWindowSize;

%paddImg = padarray(im,[searchWindowSize searchWindowSize],'symmetric');

offsetLimit = (searchWindowSize - patchSize)+1;
distances = zeros(offsetLimit,offsetLimit);
% framedImage gives the pixel within the current window.
% index within means the centre moves negative/positve with amount of
% patch's radius.
% +serachWIndowsize is the padded amount.
framedImage = image(row+searchWindowSize-(searchWindowSize-1)/2:row+searchWindowSize+(searchWindowSize-1)/2,col+searchWindowSize-(searchWindowSize-1)/2:col+searchWindowSize+(searchWindowSize-1)/2,:);
p0 = image(row+searchWindowSize-(patchSize-1)/2:row+searchWindowSize+(patchSize-1)/2,col+searchWindowSize-(patchSize-1)/2:col+searchWindowSize+(patchSize-1)/2,:);

windowCentre = (searchWindowSize-1)/2+1;
% eg: for patchsize = 3 window size = 7: [-2 -1 0 1 2];
% I don't consider the case when the offset patch hit the border of the
% window.
offsetIndex = [-(offsetLimit-1)/2:(offsetLimit-1)/2];

for i = 1:length(offsetIndex)
    for j = 1:length(offsetIndex)
        % SSD between the current patch with the offset.
        % Need three summation to get the sum of three channels.
        distances(i,j) = sum(sum(sum((framedImage(windowCentre+offsetIndex(i)-(patchSize-1)/2:windowCentre+offsetIndex(i)+(patchSize-1)/2,windowCentre+offsetIndex(j)-(patchSize-1)/2:windowCentre+offsetIndex(j)+(patchSize-1)/2,:) - p0).^2)));             
    end
end

% I put normalization in the computeWeight section.
%distances= distances/ (3*patchSize*patchSize);
offsetsRows = offsetIndex;
offsetsCols = offsetIndex;
end