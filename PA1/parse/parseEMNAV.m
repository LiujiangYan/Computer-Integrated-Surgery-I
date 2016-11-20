function [Ng, Nf, M] = parseEMNAV(filepath)
    FID = fopen(filepath);
    file = fgetl(FID);
    header = textscan(file,'%f%f%s','delimiter',',');
    
    Ng = header{1,1};
    Nf = header{1,2};

    M = csvread(filepath, 1, 0);
end