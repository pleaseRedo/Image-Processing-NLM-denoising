function [result] = computeWeighting(d, h, sigma, patchSize)
    %Implement weighting function from the slides
    %Be careful to normalise/scale correctly!
    
    % using patchSize to get the total amount of pixel within the patch.
    % we need this for normalization.
    result = exp(-(max(d./(3*(2*patchSize+1)^2) - 2*sigma^2,0))./h^2);
    %REPLACE THIS
    %result = 0;
    
end