%% Some parameters to set - make sure that your code works at image borders!

% Row and column of the pixel for which we wish to find all similar patches 
% NOTE: For this section, we pick only one patch
row = 100;
col = 100;

% Patchsize - make sure your code works for different values
patchSize = 3;

% Search window size - make sure your code works for different values
searchWindowSize = 7;


%% Implementation of work required in your basic section-------------------

% TODO - Load Image
image = zeros(100, 100);
image = imread('images/alleyNoisy_sigma20.png');
imshow(image);

% TODO - Fill out this function
image_ii = computeIntegralImage(image);

% TODO - Display the normalised Integral Image
% NOTE: This is for display only, not for template matching yet!
figure('name', 'Normalised Integral Image');
[row,col,dim] = size(image_ii);
normalized_ii = double(image_ii);
% value in integral image is a cumulative sum, doing normalization
%  will project the ii into 1 to 255 scale.
%  to achieve this, divided by the highest value so the range becomes (0 1]
%  then times 255.
currentMax = max(max(image_ii(:,:,:)));
normalized_ii(:,:,:) = image_ii(:,:,:) ./ currentMax;
imshow(uint8(normalized_ii*255));

% TODO - Template matching for naive SSD (i.e. just loop and sum)
% I padded the image beforehand, so avoid padding within the loop during
% non local means.
% The use of padding is to make sure the program can handle the situation
% that the current centre is at the border. Or window size are out of the
% image frame.
im = double(image);
fullwindowSize = 1+searchWindowSize+searchWindowSize;
paddImg = padarray(im,[fullwindowSize fullwindowSize],'symmetric'); 

[offsetsRows_naive, offsetsCols_naive, distances_naive] =  templateMatchingNaive(row, col,...
    patchSize, searchWindowSize,paddImg);

% TODO - Template matching using integral images
[offsetsRows_ii, offsetsCols_ii, distances_ii] = templateMatchingIntegralImage(row, col,...
    patchSize, searchWindowSize,im);

%% Let's print out your results--------------------------------------------

% NOTE: Your results for the naive and the integral image method should be
% the same!
for i=1:length(offsetsRows_naive)
    disp(['offset rows: ', num2str(offsetsRows_naive(i)), '; offset cols: ',...
        num2str(offsetsCols_naive(i)), '; Naive Distance = ', num2str(distances_naive(i),10),...
        '; Integral Im Distance = ', num2str(distances_ii(i),10)]);
end