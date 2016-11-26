function [lambda, s_set, c_set, dist_set] = ...
    parseOutput(filepath)
    
    % read the file
    FID = fopen(filepath);
    file = fgetl(FID);
    datasize = [1, inf];
    dataset = transpose(fscanf(FID, '%f\t%f\t%f\n', datasize));
    
    % lambda s_set c_set dist_set
    lambda = dataset(1:6)';
    s_c_dist_set = reshape(dataset(7:end), 7, []);
    
    s_set = s_c_dist_set(1:3,:)';
    c_set = s_c_dist_set(4:6,:)';
    dist_set = s_c_dist_set(7,:)';
    
    % close the file
    fclose(FID);
end