function sil = localizePerson(bin_image)
    [blim, numRegions] = bwlabel(bin_image);
    props = regionprops(bin_image, 'all');
    
    if numRegions > 0 
        currentMax=0;
        for k = 1 : numRegions
            thisBlobsBoundingBox =  props(k).BoundingBox;
            field = thisBlobsBoundingBox(3)*thisBlobsBoundingBox(4);
            if field > currentMax
                currentMax=field;
                sil = thisBlobsBoundingBox;
            end
        end
    elseif numRegions == 0
        sil = props(1).BoundingBox;
    end
end