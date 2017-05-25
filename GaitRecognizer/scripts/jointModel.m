K = 2; % number of classes
Mk = 11; % number of GEIs in one class
d = 3600; % total number of pixels in one GEI

C = zeros(d, Mk, K);
C(:,1,1) = reshape(imresize(imread('001/cl-01/001-cl-01-000.png'), 0.25), [60*60, 1]);
C(:,2,1) = reshape(imresize(imread('001/cl-01/001-cl-01-018.png'), 0.25), [60*60, 1]);
C(:,3,1) = reshape(imresize(imread('001/cl-01/001-cl-01-036.png'), 0.25), [60*60, 1]);
C(:,4,1) = reshape(imresize(imread('001/cl-01/001-cl-01-054.png'), 0.25), [60*60, 1]);
C(:,5,1) = reshape(imresize(imread('001/cl-01/001-cl-01-072.png'), 0.25), [60*60, 1]);
C(:,6,1) = reshape(imresize(imread('001/cl-01/001-cl-01-090.png'), 0.25), [60*60, 1]);
C(:,7,1) = reshape(imresize(imread('001/cl-01/001-cl-01-108.png'), 0.25), [60*60, 1]);
C(:,8,1) = reshape(imresize(imread('001/cl-01/001-cl-01-126.png'), 0.25), [60*60, 1]);
C(:,9,1) = reshape(imresize(imread('001/cl-01/001-cl-01-144.png'), 0.25), [60*60, 1]);
C(:,10,1) = reshape(imresize(imread('001/cl-01/001-cl-01-162.png'), 0.25), [60*60, 1]);
C(:,11,1) = reshape(imresize(imread('001/cl-01/001-cl-01-180.png'), 0.25), [60*60, 1]);
C(:,1,2) = reshape(imresize(imread('002/cl-01/002-cl-01-000.png'), 0.25), [60*60, 1]);
C(:,2,2) = reshape(imresize(imread('002/cl-01/002-cl-01-018.png'), 0.25), [60*60, 1]);
C(:,3,2) = reshape(imresize(imread('002/cl-01/002-cl-01-036.png'), 0.25), [60*60, 1]);
C(:,4,2) = reshape(imresize(imread('002/cl-01/002-cl-01-054.png'), 0.25), [60*60, 1]);
C(:,5,2) = reshape(imresize(imread('002/cl-01/002-cl-01-072.png'), 0.25), [60*60, 1]);
C(:,6,2) = reshape(imresize(imread('002/cl-01/002-cl-01-090.png'), 0.25), [60*60, 1]);
C(:,7,2) = reshape(imresize(imread('002/cl-01/002-cl-01-108.png'), 0.25), [60*60, 1]);
C(:,8,2) = reshape(imresize(imread('002/cl-01/002-cl-01-126.png'), 0.25), [60*60, 1]);
C(:,9,2) = reshape(imresize(imread('002/cl-01/002-cl-01-144.png'), 0.25), [60*60, 1]);
C(:,10,2) = reshape(imresize(imread('002/cl-01/002-cl-01-162.png'), 0.25), [60*60, 1]);
C(:,11,2) = reshape(imresize(imread('002/cl-01/002-cl-01-180.png'), 0.25), [60*60, 1]);

X = zeros(d, 0);
for i = 1:K
    for j = 1:Mk
        X = horzcat(X, C(:,j,i));
    end
end

Sb = zeros(d, d);
Sw = zeros(d, d);
for i = 1:K
    classStartInX = (i-1) * Mk + 1;
    classEndInX = i * Mk;
    class = X(:, classStartInX:classEndInX);
    classMean = mean(class, 2);
    datasetMean = mean(X(:,:), 2);

    diff = classMean - datasetMean;
    Sb = Sb + Mk * diff * diff';

    diff = class - repmat(classMean, 1, Mk);
    Sw = Sw + Mk * diff * diff';
end

[Y, ~] = eigs(Sb, 22);
Db = Y' * Sb_pca * Y;
Z = Y * Db^(-1/2);
U = orth(randn(22, 22));
Dw = U' * Z' * Sw' * Z * U;
A = U' * Z';
Wt = Dw^(-1/2) * A;