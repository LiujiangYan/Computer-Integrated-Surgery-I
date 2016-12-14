function savedata(Lambda, s_set, c_set, error_set, ...
    char, method, search, outputDataFilepath)
    
    s_c_error_set = [s_set, c_set, error_set];
    output(1,:) = [1, Lambda];
    output = [output; s_c_error_set];
    
    output_filepath = strcat(outputDataFilepath, 'Method-', method, search, ...
        '/PA5-', char, '-Output-', method, search, '.txt');
    dlmwrite(output_filepath, output, 'precision','% 10.4f', 'delimiter', ',');  
end