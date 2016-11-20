function [Nb, M] = parseCTFIDUCIALS(filepath)
    FID = fopen(filepath);
    file = fgetl(FID);
    header = textscan(file,'%f%s','delimiter',',');
    
    Nb = header{1,1};

    M = csvread(filepath, 1, 0);
end