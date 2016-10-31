clc;
clear;
format compact;

addpath('PA1');
addpath('PA12-StudentData');
addpath('parse');

% record the error between computed and output data
EM_pivot_error = [];
OPT_pivot_error = [];
C_expected_error = [];

count = 0;
for char = 'a':'g'
    count = count + 1;
    
    original_filename = strcat('pa1-debug-',char,'-output1.txt');
    computed_filename = strcat('pa1output/pa1-debug-',char,'-output1.txt');
    
    % get the data
    m_original = csvread(original_filename, 1, 0);
    m_computed = csvread(computed_filename, 1, 0);
    
    % get the error of each part of data
    EM_pivot_error(count,:) = m_original(1,:)-m_computed(1,:);
    OPT_pivot_error(count,:) = m_original(2,:)-m_computed(2,:);
    C_expected_error(:,:,count) = m_original(3:end,:)-m_computed(3:end,:);
end

% compute the norm of the error term
EM_pivot_error_norm = sum(abs(EM_pivot_error).^2,2).^(1/2);
OPT_pivot_error_norm = sum(abs(OPT_pivot_error).^2,2).^(1/2);
C_expected_error_norm = sum(abs(C_expected_error).^2,2).^(1/2);