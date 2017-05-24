function cropped = normalizeImage(image, boundaryBox)
    tempImage = imcrop(image, boundaryBox);
    
%     figure();
    blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ...
    'MinimumBlobArea', 10, 'MaximumCount', 1);
    bbox = step(blobAnalysis, image);
    imp = im2double(image);
    imp = insertShape(imp, 'Rectangle', bbox, 'Color', 'white', 'LineWidth',5);
    imshow(imp);
    
    
    
    cent = getCentroidOfBiggestObject(tempImage);
    subplot(2,1,1);
    imshow(tempImage);
    hold on;
    plot(cent(1), cent(2), 'bo', 'MarkerSize', 10);
    hold off;
    
    
    
    
    %default size 240x240
    tempImage = imcrop(image, boundaryBox);
    [x y] = size(tempImage);
    columnsToAdd = (x-y)/2;
    diff = (y/2) - cent(1);
    columnsLeft = columnsToAdd+diff;
    columnsRight = columnsToAdd-diff;
    strLeft = zeros(x,uint8(columnsLeft));
    strRight = zeros(x,uint8(columnsRight));
    tempImage = [strLeft tempImage strRight];
    subplot(2,1,2);
    imshow(tempImage);

    
    cropped = imresize(tempImage, [240 240]);
end