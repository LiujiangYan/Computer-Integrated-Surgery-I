function [Nc, Nf, pEM, pOptical, M] = parseOUTPUT_1(filepath)
    FID = fopen(filepath);
    file = fgetl(FID);
    header = textscan(file,'%f%f%s','delimiter',',');
    
    Nc = header{1,1};
    Nf = header{1,2};

    M = csvread(filepath, 1, 0);
    pEM = M(1,:);
    pOptical = M(2,:);
    M = M(3:end,:);
end