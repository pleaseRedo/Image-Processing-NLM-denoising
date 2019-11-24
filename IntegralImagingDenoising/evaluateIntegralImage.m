function [patchSum] = evaluateIntegralImage(ii, row, col, patchSize)
% This function should calculate the sum over the patch centred at row, col
% of size patchSize of the integral image ii
%ii = padarray(ii,[1 1]);
%[nrow,ncol,dim] = size(ii);



%padii = padarray(ii,[1 1]);
%padii = padarray(padii,[nrow ncol]);

%p0 = padii(row+nrow-(patchSize-1)/2:row+nrow+(patchSize-1)/2+1,col+ncol-(patchSize-1)/2:col+ncol+(patchSize-1)/2+1,:);
%p0 = ii(row-(patchSize-1)/2:row+(patchSize-1)/2+1,col-(patchSize-1)/2:col+(patchSize-1)/2+1,:)
% +patchSize is the padded amount
% -1 +1 is to gain the extra row/column for compute integral for a
% particular patch.
p0 = ii(row-(patchSize-1)/2+patchSize-1:row+(patchSize-1)/2+1+patchSize-1,col-(patchSize-1)/2+patchSize-1:col+(patchSize-1)/2+1+patchSize-1,:);
% L3 - L2 - L4 + L1
L3 = p0(patchSize+1,patchSize+1,:);
L4 = p0(patchSize+1,1,:);
L2 = p0(1,patchSize+1,:);
L1 = p0(1,1,:);
%REPLACE THIS!
patchSum = L3-L2-L4+L1;
end