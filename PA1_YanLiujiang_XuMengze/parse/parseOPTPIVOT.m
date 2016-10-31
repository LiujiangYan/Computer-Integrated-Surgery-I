function [Nd, Nh, Nframes, M] = parseOPTPIVOT(filepath)
    
    FID = fopen(filepath);
    file = fgetl(FID);
    header = textscan(file,'%f%f%f%s','delimiter',',');
    
    Nd = header{1,1};
    Nh = header{1,2};
    Nframes = header{1,3};
    
    M = csvread(filepath, 1, 0);
end