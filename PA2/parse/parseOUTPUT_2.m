function [Nf, M] = parseOUTPUT_2(filepath)
    FID = fopen(filepath);
    file = fgetl(FID);
    header = textscan(file,'%f%s','delimiter',',');
    
    Nf = header{1,1};

    M = csvread(filepath, 1, 0);
end