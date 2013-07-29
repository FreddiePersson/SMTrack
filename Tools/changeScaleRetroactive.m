[filename, pathname] = uigetfile({'*.mat'}, 'Select image file (STK or TIF)', 'MultiSelect', 'on');

switch iscell(filename)
    case 1
        numFiles = length(filename);
        if cellfun('isempty', filename)
            disp('Error! No (or wrong) file selected!')
            return
        end
    case 0
        numFiles=1;
%             disp('Batch means that you should choose MULTIPLE files.')
%             return
end


%% Scalingscale
newScale = 64 % nm
oldScale = '106.7' %nm

wrongScale = [];

for fileNum = 1:numFiles
    fileNum
    if iscell(filename)
        full_filename = [pathname, filename{fileNum}];
    else
        full_filename = [pathname, filename];
    end
    load(full_filename);
if isequal(LOCALIZE.scale, oldScale)
    wrongScale = [wrongScale, fileNum];
    sRat = newScale/str2num(LOCALIZE.scale);
    LOCALIZE.xDataOrig = LOCALIZE.xDataOrig.*sRat;
    LOCALIZE.yDataOrig = LOCALIZE.yDataOrig.*sRat;
    LOCALIZE.zDataOrig = LOCALIZE.zDataOrig.*sRat;
    LOCALIZE.xDataCorr = LOCALIZE.xDataCorr.*sRat;
    LOCALIZE.yDataCorr = LOCALIZE.yDataCorr.*sRat;
    LOCALIZE.sigmaxDataOrig = LOCALIZE.sigmaxDataOrig.*sRat;
    LOCALIZE.sigmayDataOrig = LOCALIZE.sigmayDataOrig.*sRat;
    LOCALIZE.xDataDevOrig = LOCALIZE.xDataDevOrig.*sRat;
    LOCALIZE.yDataDevOrig = LOCALIZE.yDataDevOrig.*sRat;
    LOCALIZE.scale = num2str(newScale);
    
    save(full_filename, 'LOCALIZE');
end
end

disp('All files saved sucessfully');