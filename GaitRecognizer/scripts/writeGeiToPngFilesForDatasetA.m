

geiPath = 'F:\Projects\wkiro-video-sequences\readyGEIDatasetA';
path = 'F:\Projects\wkiro-video-sequences\';
gaitDatasetA = 'GaitDatasetA-silh\silhouettes\';

filepath = strcat(path, gaitDatasetA);
allFiles = dir(filepath);
dirFlags = [allFiles.isdir];
subFolders = allFiles(dirFlags);

for i = 3 : length(subFolders)
    filepath2 = strcat(filepath, subFolders(i).name, filesep);
    allFiles2 = dir(filepath2);
    dirFlags2 = [allFiles2.isdir];
    subFolders2 = allFiles2(dirFlags2);
    
    newFoldername = strcat(geiPath, filesep, subFolders(i).name);
    mkdir(newFoldername);
    
    for j = 3 : length(subFolders2)
        filepath3 = strcat(filepath2, subFolders2(j).name, filesep);
   
        summary = calculateGEI(filepath3, 'png');
        %figure();
        %imshow(summary);
        geiFilename = strcat(geiPath, filesep, subFolders(i).name, filesep, subFolders2(j).name, '.png');
        
        imwrite(summary, geiFilename);
    end
end
