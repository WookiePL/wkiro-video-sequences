function [W, reducedData] = PCA(data, dims)
    disp(strcat('Reducing dimensions by PCA from ', int2str(size(data, 2)), ' to ', int2str(dims)));
    covariances = (data' * data)./(size(data, 1) - 1);
    [W, ~] = eigs(covariances, dims);
    reducedData = data * W;
end