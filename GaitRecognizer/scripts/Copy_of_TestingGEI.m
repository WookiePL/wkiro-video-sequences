outputName='resultsA_60x50.txt';
file = fopen(outputName,'w');

fprintf(file, '%5s %6s %7s %6s\r\n', 'angle','method','correct' , 'result in %');

angles = [ '00'; '90';'45'];
sets = [ 'bg-01';'bg-02';'nm-01';'nm-02';'nm-03';'nm-04';'bg-01';'bg-02';'bg-01';'bg-02'];

x = size(angles);
for j = 1:size(angles)
    disp(strcat('angle:',angles(j,:)));
    ang = angles(j,:);
    
    K = 20;
    p = 0.15;                       % wspolczynnik skalowania obrazu
    d = (p*240)^2;                  % liczba pikseli w obrazie GEI

    notUsed=0;
    trainK = 1:K;
    for i = 1:K
        fileindex = sprintf('%3.3d', i);
        filepath = strcat(fileindex, filesep, angles(j,:),'_1.png');
        if ~exist(filepath,'file')
            trainK(:,i) = 0;
            notUsed = notUsed+1;
        end   
    end
   
    for i = 1:K
        fileindex = sprintf('%3.3d', i);
        filepath = strcat(fileindex, filesep, angles(j,:),'_3.png');
        if ~exist(filepath,'file')
            trainK(:,i) = 0;
            notUsed = notUsed+1;
        end   
    end
    notUsed = 0;
    for i = 1:K
        if trainK(:,i) == 0
            notUsed=notUsed+1;
        end
    end
    trainData = zeros(K-notUsed, d);        % dane treningowe
    testData = zeros(K-notUsed, d);         % dane testowe
    trainLabels = zeros(K-notUsed, 1);      % etykiety danych tren. (1..K)
    testLabels = zeros(K-notUsed, 1);       % etykiety danych test. (1..K)
    
    notUsed = 0;
    for i = 1:K
        if trainK(:,i) == 0
            notUsed=notUsed+1;
        else
            fileindex = sprintf('%3.3d',i);
            filepath = strcat(fileindex, filesep, angles(j,:),'_1.png');
            img = imresize(imread(filepath), p);
            trainData(i-notUsed, :) = reshape(img, [1, d]);
            trainLabels(i-notUsed) = i-notUsed;
        end
           
    end
    disp(strcat('TRAIN:',int2str(K-notUsed)));
    
    notUsed = 0;
    for i = 1:K
        if trainK(:,i) == 0
            notUsed=notUsed+1;
        else
            fileindex = sprintf('%3.3d',i);
            filepath = strcat(fileindex, filesep, angles(j,:),'_3.png');
            img = imresize(imread(filepath), p);
            testData(i-notUsed, :) = reshape(img, [1, d]);
            testLabels(i-notUsed) = i-notUsed;
        end
        
    end
    disp(strcat('TEST:',int2str(K-notUsed)));
    
    method='PCA';
    disp('PCA:')
    [W, reducedData] = PCA(trainData, K-notUsed-1);
    
    plot(reducedData);
    
    correct = 0;
    for i = 1:K-notUsed
        test = testData(i, :) * W;
        predicted = knnsearch(reducedData, test);
        correct = correct + (testLabels(i) == predicted);
    end

    disp(strcat(int2str(correct), '/', int2str(K-notUsed)));
    fprintf(file, '%5s %6s %7d %3.2f\r\n', ang, method, correct, (correct/(K-notUsed))*100);

    method = 'LDA';
    disp('LDA:');
    [W, reducedData] = LDA(trainData, trainLabels, K-notUsed - 1);

    correct = 0;
    for i = 1:K-notUsed
        test = testData(i, :) * W;
        predicted = knnsearch(reducedData, test);
        correct = correct + (testLabels(i) == predicted);
    end
    
    disp(strcat(int2str(correct), '/', int2str(K-notUsed)));
    fprintf(file, '%5s %6s %7d %3.2f\r\n', ang, method, correct, (correct/(K-notUsed))*100);
    
    method = 'PCA_LDA';
    disp('PCA+LDA:');
    [W, reducedData] = PCA_LDA(trainData, trainLabels, d-K-notUsed, K-notUsed-1);

    correct = 0;
    for i = 1:K-notUsed
        test = testData(i,:) * W;
        predicted = knnsearch(reducedData, test);
        correct = correct + (testLabels(i) == predicted);
    end

    disp(strcat(int2str(correct), ' /', int2str(K-notUsed)));
    fprintf(file, '%5s %6s %7d %3.2f\r\n', ang, method, correct, (correct/(K-notUsed))*100);

end


fclose(file);