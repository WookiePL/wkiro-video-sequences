function GEI = makeGEI(imageArray)
    sum = imageArray(:,:,1);
    [x y n] = size(imageArray);
    
    for i=2:n
        sum = sum + imageArray(:,:,i);
    end
    GEI = sum/n;