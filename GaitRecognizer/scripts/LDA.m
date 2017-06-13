function [W, reducedData] = LDA(data, labels, dims)
    disp(strcat('Reducing dimensions by LDA from ', int2str(size(data, 2)), ' to ', int2str(dims)));
    dataWithLabels = horzcat(labels, data);
    [reducedData, ~] = compute_mapping(dataWithLabels, 'LDA', dims);
    reducedData = real(reducedData);
    W = linsolve(data, reducedData);
end