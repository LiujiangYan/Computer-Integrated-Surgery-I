function [N_markers, P_markers, P_tip] = parseBody(filepath)
    FID = fopen(filepath);
    file = fgetl(FID);
    % get the first line
    header = textscan(file,'%f');
    
    % extract the numerical data
    N_markers = header{1,1};
    
    size = [3, Inf];
    Matrix = transpose(fscanf(FID, '%f\t%f\t%f\n', size));
    
    % markers' coordinates
    P_markers = Matrix(2:N_markers,:);
    
    % tip's coordinate
    P_tip = Matrix(end, :);
    
    fclose(FID);
end
