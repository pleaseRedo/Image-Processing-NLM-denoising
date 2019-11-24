function [result] = nonLocalMeansNaive(image, sigma, h, patchSize, windowSize)
%image = imread('images/debug/alleyNoisy_sigma20.png');
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
fullpatchSize = 1+ patchSize + patchSize; %%%%%%%%%%%%%%%%%% I changed the patchSize here
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

% No longer need to compute the integral image.
% for i= 1:length(offsetIndex)
%     for j = 1:length(offsetIndex)        
%         offsetImg = paddImg(fullwindowSize+1+offsetIndex(i)-fullpatchSize:end-fullwindowSize+offsetIndex(i)+fullpatchSize,fullwindowSize+1+offsetIndex(j)-fullpatchSize:end-fullwindowSize+offsetIndex(j)+fullpatchSize,:);
%         %dis = computeIntegralImage((im - offsetImg).^2);
%         dis = cumsum(cumsum((paddP0 - offsetImg).^2),2);
%         %disR = reshape(dis,[prow*pcol 3]);
%         resultantIntImg(:,:,i*length(offsetIndex)+j-length(offsetIndex)) = sum(dis,3);%sum(disR,2);
%         %resultantIntImg2(:,:,i*length(offsetIndex)+j-length(offsetIndex)) = dis;
%        % resultantIntImg3(:,:,i*length(offsetIndex)+j-length(offsetIndex)) = dis;
%         % This + 1 is to deal the case of col,row +patchSize, So for offsetImg I
%         % extends its size by patchSize
%         %distances(i,j) = sum(evaluateIntegralImage(dis, row+patchSize, col+patchSize, patchSize));
%     end
% end
% excerpts end
%paddedResultant = padarray(paddedResultant,[nrow ncol]);
for i=1:nrow
    fprintf('current i is %i\n', i);
    for j = 1:ncol
        
    % calling the function to get the SSD.
    % The rest are the same for nonLocalMeans(integral image approach)
        [offsetsRows, offsetsCols, distances] = templateMatchingNaive(i, j,...
    patchSize, windowSize,paddImg);
        curPatchD = distances'; % Transpose is due to how I reshape this later.
        currentWeighttemp = computeWeighting(curPatchD, h, sigma, patchSize);
        
        currentWeight = reshape(currentWeighttemp,1,weightSize^2);
      
       % weigthInLine = reshape(currentWeight,1,[]);
        C = sum(currentWeight);
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
