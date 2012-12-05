    % Get filename and path with "uigetfile"
    [filename, pathname] = uigetfile({'*.mat'}, 'Select mat file');
    if ( filename == 0 )
        disp('Error! No (or wrong) file selected!')
        return
    end
    % Load the mat file
    full_filename = [ pathname, filename ];
    load(full_filename);
    
    % Gather the dot counts
    dots = zeros(1, size(DETECT.rawData, 3)/2);
    i = 1;
    for ind=1:2:size(DETECT.rawData, 3)
        temp = DETECT.rawData(:, :, ind);
        temp2 = find(temp>0);
        temp2(end) = [];
        dots(i) = length(temp2)-1;
        i = i+1;
    end
    
    dots'
    
    