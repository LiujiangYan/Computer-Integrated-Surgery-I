clc;
clear;
format compact;

addpath('PA1');
addpath('PA2');
addpath('PA12-StudentData');
addpath('parse');

% record the error between computed and output data
testpoint_error = [];
EM_pivot_error = [];
C_expected_error = [];

count = 0;
for char = 'a':'f'
    count = count + 1;
    
    original_1_filename = strcat('pa2-debug-',char,'-output1.txt');
    computed_1_filename = strcat('pa2output/pa2-debug-',char,'-output1.txt');
    
    % get the data
    m_original = csvread(original_1_filename, 1, 0);
    m_computed = csvread(computed_1_filename, 1, 0);

    % store the error
    EM_pivot_error(count,:) = m_original(1,:)-m_computed(1,:);
    C_expected_error(:,:,count) = m_original(3:end,:) - m_computed(3:end,:);
    
    original_2_filename = strcat('pa2-debug-',char,'-output2.txt');
    computed_2_filename = strcat('pa2output/pa2-debug-',char,'-output2.txt');
    
    % get the data
    pivot_original = csvread(original_2_filename, 1, 0);
    pivot_computed = csvread(computed_2_filename, 1, 0);

    % store the error
    testpoint_error(:,:,count) = pivot_original - pivot_computed;
end

% compute the norm of the error term
% use max() or mean() command to get the statistical data
EM_pivot_error_norm = sum(abs(EM_pivot_error).^2,2).^(1/2);
testpoint_error_norm = sum(abs(testpoint_error).^2,2).^(1/2);
C_expected_error_norm = sum(abs(C_expected_error).^2,2).^(1/2);
