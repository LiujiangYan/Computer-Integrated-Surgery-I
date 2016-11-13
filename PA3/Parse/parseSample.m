function [N_samples, P_A, P_B] = parseSample(filepath, N_A, N_B)
    FID = fopen(filepath);
    file = fgetl(FID);
    % get the first line
    header = textscan(file,'%f%f%f%s','delimiter',',');
    
    % extract the numerical data
    N_S = header{1,1};
    N_samples = header{1,2};
    
    fclose(FID);
    
    % get the raw data
    M = csvread(filepath, 1, 0);
    
    P_A = zeros(N_A, 3, N_samples);
    P_B = zeros(N_B, 3, N_samples);
    
    for i=1:N_samples
        startpoint = (i-1)*N_S;
        midpoint = startpoint + N_A;
        endpoint = startpoint + N_A + N_B;
        P_A(:,:,i) = M(startpoint+1:midpoint,:);
        P_B(:,:,i) = M(midpoint+1:endpoint,:);
    end
end