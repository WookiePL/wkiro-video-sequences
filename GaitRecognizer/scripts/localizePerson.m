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
        im = bwareafilt(bin_image, [0.03 * currentMax, currentMax]);
%         figure();
%         imshow(im);
        [blim, numRegions] = bwlabel(im);
        props = regionprops(im, 'all');
        if numRegions > 1
            xarr = [];
            yarr = [];
            xarr_end = [];
            yarr_end = [];
            for k = 1 : numRegions
                thisBlobsBoundingBox =  props(k).BoundingBox;
                xarr = [xarr thisBlobsBoundingBox(1)];
                yarr = [yarr thisBlobsBoundingBox(2)];
                xarr_end = [xarr_end thisBlobsBoundingBox(1)+thisBlobsBoundingBox(3)];
                yarr_end = [yarr_end thisBlobsBoundingBox(2)+thisBlobsBoundingBox(4)];
            end
            minx = min(xarr);
            miny = min(yarr);
            maxx = max(xarr_end);
            maxy = max(yarr_end);
            sil(1) = minx;
            sil(2) = miny;
            sil(3) = maxx - minx;
            sil(4) = maxy - miny;
        end
    elseif numRegions == 0
        sil = props(1).BoundingBox;
    end
    
    
end