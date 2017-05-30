K = 124;                        % liczba klas
p = 0.25;                       % wspolczynnik skalowania obrazu
d = (p*240)^2;                  % liczba pikseli w obrazie GEI

trainData = zeros(K, d);        % dane treningowe
testData = zeros(K, d);         % dane testowe
trainLabels = zeros(K, 1);      % etykiety danych tren. (1..K)
testLabels = zeros(K, 1);       % etykiety danych test. (1..K)

for i = 1:K
    fileindex = sprintf('%3.3d', i);
    filepath = strcat(fileindex, filesep, 'cl-01', filesep, fileindex, '-cl-01-090.png');
    img = imresize(imread(filepath), p);
    trainData(i, :) = reshape(img, [1, d]);
    trainLabels(i) = i;
end

for i = 1:K
    fileindex = sprintf('%3.3d', i);
    filepath = strcat(fileindex, filesep, 'cl-02', filesep, fileindex, '-cl-02-090.png');
    img = imresize(imread(filepath), p);
    testData(i, :) = reshape(img, [1, d]);
    testLabels(i) = i;
end


disp('PCA:')
[W, reducedData] = pca(trainData, K - 1);

correct = 0;
for i = 1:K
    test = testData(i, :) * W;
    predicted = knnsearch(reducedData, test);
    correct = correct + (testLabels(i) == predicted);
end

disp(strcat(int2str(correct), '/', int2str(K)));



disp('LDA:');
[W, reducedData] = lda(trainData, trainLabels, K - 1);

correct = 0;
for i = 1:K
    test = testData(i, :) * W;
    predicted = knnsearch(reducedData, test);
    correct = correct + (testLabels(i) == predicted);
end

disp(strcat(int2str(correct), '/', int2str(K)));



disp('PCA+LDA:');
[W, reducedData] = pca_lda(trainData, trainLabels, d-K, K-1);

correct = 0;
for i = 1:K
    test = testData(i,:) * W;
    predicted = knnsearch(reducedData, test);
    correct = correct + (testLabels(i) == predicted);
end

disp(strcat(int2str(correct), ' /', int2str(K)));
