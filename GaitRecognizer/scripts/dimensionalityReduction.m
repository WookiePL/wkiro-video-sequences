function [W, reducedData] = pca(data, dims)
    disp(strcat('Reducing dimensions by PCA from ', int2str(size(data, 2)), ' to ', int2str(dims)));
    covariances = (data' * data)./(size(data, 1) - 1);
    [W, ~] = eigs(covariances, dims);
    reducedData = data * W;
end


function [W, reducedData] = lda(data, labels, dims)
    disp(strcat('Reducing dimensions by LDA from ', int2str(size(data, 2)), ' to ', int2str(dims)));
    dataWithLabels = horzcat(labels, data);
    [reducedData, ~] = compute_mapping(dataWithLabels, 'LDA', dims);
    reducedData = real(reducedData);
    W = linsolve(data, reducedData);
end

function [W, reducedData] = pca_lda(data, labels, dimsPCA, dimsLDA)
    [~, reducedDataPCA] = pca(data, dimsPCA);
    [~, reducedData] = lda(reducedDataPCA, labels, dimsLDA);
    W = linsolve(data, reducedData);
end