function [Nd, Na, Nc, Nframes, M] = parseCALREADINGS(filepath)
    
    FID = fopen(filepath);
    file = fgetl(FID);
    header = textscan(file,'%f%f%f%f%s','delimiter',',');
    
    Nd = header{1,1};
    Na = header{1,2};
    Nc = header{1,3};
    Nframes = header{1,4};
    
    M = csvread(filepath, 1, 0);
end