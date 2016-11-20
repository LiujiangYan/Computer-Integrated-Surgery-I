function [Nd, Na, Nc, M] = parseCALBODY(filepath)
    FID = fopen(filepath);
    file = fgetl(FID);
    % get the first line
    header = textscan(file,'%f%f%f%s','delimiter',',');
    
    % extract the numerical data
    Nd = header{1,1};
    Na = header{1,2};
    Nc = header{1,3};

    % get the raw data
    M = csvread(filepath, 1, 0);
end