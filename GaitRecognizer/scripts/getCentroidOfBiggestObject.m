function cent = getCentroidOfBiggestObject(bin_image)
    [blim, numRegions] = bwlabel(bin_image);
    props = regionprops(blim, 'all');
    
    if numRegions > 0 
        currentMax=0;
        for k = 1 : numRegions
            thisBlobsBoundingBox =  props(k).BoundingBox;
            field = thisBlobsBoundingBox(3)*thisBlobsBoundingBox(4);
            if field > currentMax
                currentMax=field;
                cent = props(k).Centroid;
            end
        end
    elseif numRegions == 0
        cent = props(1).Centroid;
    end
end