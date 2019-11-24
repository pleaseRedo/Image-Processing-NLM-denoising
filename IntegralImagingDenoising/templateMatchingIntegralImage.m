function [offsetsRows, offsetsCols, distances] = templateMatchingIntegralImage(row,...
     col,patchSize, searchWindowSize,image)
    %row = 1;
   % col = 1;
    %patchSize = 2;
    %searchWindowSize = 8;
% This function should for each possible offset in the search window
% centred at the current row and col, save a value for the offsets and
% patch distances, e.g. for the offset (-1,-1)
% offsetsX(1) = -1;
% offsetsY(1) = -1;
% distances(1) = 0.125;

% The distance is simply the SSD over patches of size patchSize between the
% 'template' patch centred at row and col and a patch shifted by the
% current offset

% This time, use the integral image method!
% NOTE: Use the 'computeIntegralImage' function developed % calculate your integral images earlier to
% NOTE: Use the 'evaluateIntegralImage' function to calculate patch sums

%REPLACE THIS
offsetsRows = zeros(10,1);
offsetsCols = zeros(10,1);
%distances = randn(10, 1);
%distances = zeros(10,10,3);
patchSize = 1+patchSize+patchSize;
searchWindowSize = 1+searchWindowSize+searchWindowSize;
%image = imread('images/debug/alleyNoisy_sigma20.png');
im = double(image);
[nrow,ncol,dim] = size(im);
offsetLimit = (searchWindowSize - patchSize)+1;

distances = zeros(offsetLimit,offsetLimit);




offsetIndex = [-(offsetLimit-1)/2:(offsetLimit-1)/2];
% padding the image so the index can go to the border of the original
% image.
paddImg = padarray(im,[searchWindowSize searchWindowSize],'symmetric');
paddP0  = padarray(im,[patchSize patchSize],'symmetric');
%(size-1)/2 is radius.

%%%debug use
%[prow pcol pdim] = size(paddP0);%%%%%%%%%%%%%%%%%%%
%resultantIntImg11 = zeros([prow pcol length(offsetIndex)^2]);%%%%%%%%%%%%%%%%%%%%%%%%%



for i= 1:length(offsetIndex)
    for j = 1:length(offsetIndex)
        
        %searchWindowSize+1 gives the relative coordinate of unpadded image.
        % For the integral template matching, we are offsetting the whole
        % image.
        offsetImg = paddImg(searchWindowSize+1+offsetIndex(i)-patchSize:end-searchWindowSize+offsetIndex(i)+patchSize,searchWindowSize+1+offsetIndex(j)-patchSize:end-searchWindowSize+offsetIndex(j)+patchSize,:);
        %dis = computeIntegralImage((paddP0 - offsetImg).^2);
        % I later found the better built-in approach which is cumsum.
        dis = cumsum(cumsum((paddP0 - offsetImg).^2),2);
        % sum the all channels integration.
        distances(i,j) = sum(evaluateIntegralImage(dis, row, col, patchSize));
        
        
        %debug use
        %resultantIntImg11(:,:,i*length(offsetIndex)+j-length(offsetIndex)) = sum(dis,3);%sum(disR,2);
    end
end
%end

%integrationIm = computeIntegralImage(distances);
%L3 = integrationIm()
%distances = 
%distances= distances/ (3*patchSize*patchSize);
offsetsRows = offsetIndex;
offsetsCols = offsetIndex;
end