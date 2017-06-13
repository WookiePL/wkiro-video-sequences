function [W, reducedData] = PCA_LDA(data, labels, dimsPCA, dimsLDA)
    [~, reducedDataPCA] = PCA(data, dimsPCA);
    [~, reducedData] = LDA(reducedDataPCA, labels, dimsLDA);
    W = linsolve(data, reducedData);
end