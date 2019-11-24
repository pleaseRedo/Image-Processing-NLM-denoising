function [result] = nonLocalMeans(image, sigma, h, patchSize, windowSize)
%image = imread('images/alleyNoisy_sigma20.png');
%im = double(image);
%sigma = 20;
%h = 0.55;
%patchSize = 2;
%windowSize = 8;
%REPLACE THIS
result = zeros(size(image));
[nrow,ncol,dim] = size(image);
%deNoised = image;
weightSize = (windowSize-patchSize)*2 +1;
im = double(image);


%excerpts from templateMatchingIntegral
fullwindowSize = 1+ windowSize + windowSize;
fullpatchSize = 1+ patchSize + patchSize; 
offsetLimit = (fullwindowSize - fullpatchSize)+1;
%distances = zeros(offsetLimit,offsetLimit);
offsetIndex = [-(offsetLimit-1)/2:(offsetLimit-1)/2];
paddImg = padarray(im,[fullwindowSize fullwindowSize],'symmetric'); 
paddP0  = padarray(im,[fullpatchSize fullpatchSize],'symmetric');
[prow pcol pdim] = size(paddP0);
%weightSize = (windowSize*2+1-fullpatchSize)*2 +1;
%resultantIntImg = zeros([prow*pcol length(offsetIndex)^2]);
resultantIntImg = zeros([prow pcol length(offsetIndex)^2]);

channelOne = zeros([1 length(offsetIndex)*length(offsetIndex)]);
channelTwo = zeros([1 length(offsetIndex)*length(offsetIndex)]);
channelThree = zeros([1 length(offsetIndex)*length(offsetIndex)]);


% This is the nonLocalMeans using the integral image.
%  so we first compute the integral of the difference image
%  difference image: (offsetImage) - (originalImage).
% I don't calling the function directly instead I take out part of the line
% from templateMatchingIntegralImage and insert them here.
% The main reason is that function consists padding which is slow.
for i= 1:length(offsetIndex)
    for j = 1:length(offsetIndex)        
        offsetImg = paddImg(fullwindowSize+1+offsetIndex(i)-fullpatchSize:end-fullwindowSize+offsetIndex(i)+fullpatchSize,fullwindowSize+1+offsetIndex(j)-fullpatchSize:end-fullwindowSize+offsetIndex(j)+fullpatchSize,:);
        %dis = computeIntegralImage((im - offsetImg).^2);
        dis = cumsum(cumsum((paddP0 - offsetImg).^2),2);
        % This time I stored the distances to resultanIntImg, because we
        % are nolong compute one offset but whole combination of offset.
        resultantIntImg(:,:,i*length(offsetIndex)+j-length(offsetIndex)) = sum(dis,3);
        
    end
end
% excerpts end

% Now to compute the non-local means
% the basic idea of non-local means is to compute the weight for each
% offset(patch), then use centre patch pixel times its correspoding weight
% and average them.
for i=1:nrow
    %fprintf('current i is %i\n', i);
    for j = 1:ncol
        
        %[offsetsRows, offsetsCols, currentD] = templateMatchingNaive(i,j,patchSize, windowSize);
        % Using evaluateIntegralImage to instantly get the offset
        % difference(SSD).
        curPatchD = evaluateIntegralImage(resultantIntImg, i, j, fullpatchSize);

        currentWeighttemp = computeWeighting(curPatchD, h, sigma, patchSize);
        
        currentWeight = reshape(currentWeighttemp,1,weightSize^2);     
        C = sum(currentWeight);
        %a*length(offsetIndex)+b-length(offsetIndex) is the same as tenth
        %digits and unit digits.
        % the following for loop will get the centre pixel for each offset.
        for a = 1:length(offsetIndex)
           for b = 1:length(offsetIndex)
            channelOne(a*length(offsetIndex)+b-length(offsetIndex)) = paddImg(i+fullwindowSize+offsetIndex(a),j+fullwindowSize+offsetIndex(b),1);
            channelTwo(a*length(offsetIndex)+b-length(offsetIndex)) = paddImg(i+fullwindowSize+offsetIndex(a),j+fullwindowSize+offsetIndex(b),2);
            channelThree(a*length(offsetIndex)+b-length(offsetIndex)) = paddImg(i+fullwindowSize+offsetIndex(a),j+fullwindowSize+offsetIndex(b),3);
           end         
        end
        result(i,j,1) = (channelOne * currentWeight')/C;
        result(i,j,2) = (channelTwo * currentWeight')/C;
        result(i,j,3) = (channelThree * currentWeight')/C;
    end

    
end

result = uint8(result);

end
