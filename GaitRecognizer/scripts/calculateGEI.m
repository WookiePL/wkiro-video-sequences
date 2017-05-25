function GEIImage = calculateGEI(sequencesDir, extension)
    fullSearchPath = strcat(sequencesDir,filesep,'*.',extension);
    srcImages = dir(fullSearchPath);
    for i=1 : length(srcImages)
        fileName = strcat(srcImages(i).folder,filesep,srcImages(i).name);
        im = imread(fileName);
        im = im2bw(im);
        pers = localizePerson(im);
        croppedImage = normalizeImage(im, pers);
        croppedImage = im2double(croppedImage);
%         subplot(2,1,1);
%         imshow(im);
%         subplot(2,1,2);
%         imshow(croppedImage);
        imageArray(:,:,i) = croppedImage;
    end
    GEIImage = makeGEI(imageArray);
     
end