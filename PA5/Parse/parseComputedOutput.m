function [lambda, s_set, c_set, dist_set] = ...
    parseComputedOutput(filepath)

    dataset = csvread(filepath);
    lambda = dataset(1,2:7);
    s_set = dataset(2:end,1:3);
    c_set = dataset(2:end,4:6);
    dist_set = dataset(2:end,7);
    
end