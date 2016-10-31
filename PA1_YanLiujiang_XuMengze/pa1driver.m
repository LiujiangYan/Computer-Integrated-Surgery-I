% programming assignment 1 driver
clc
clear
format compact

addpath('PA1');
addpath('PA2');
addpath('PA12-StudentData');
addpath('parse');

for char = 'a':'k'
    if ismember(char, 'a':'g')
        type = 'debug';
    elseif ismember(char, 'h':'k')
        type = 'unknown';
    end
    
    % read positions of EM tracker and Optical trakcer
    % that describes the calibration object
    [Nd, Na, Nc, M] = parseCALBODY...
        (strcat('pa1-',type,'-',char,'-calbody.txt'));
    d = M(1:Nd,:);
    a = M(Nd+1:Nd+Na,:);
    c = M(Nd+Na+1:end,:);
    
    % compute the expected value C_expected for C
    [ND, NA, NC, NFrames, M] = parseCALREADINGS...
        (strcat('pa1-',type,'-',char,'-calreadings.txt'));
    C_e = [];
    
    for i=1:NFrames
        start = (i-1)*(ND+NA+NC)+1;
        D = M(start:start+ND-1,:);
        A = M(start+ND:start+ND+NA-1,:);
        C = M(start+ND+NA:start+ND+NA+NC-1,:);
        C_expected = c_expected_value(D, d, A, a, c);
        C_e = [C_e; C_expected];
    end
    
    % pivot calibration for EM tracker
    [Ng, Nframes, M] = parseEMPIVOT...
        (strcat('pa1-',type,'-',char,'-empivot.txt'));
    EMpivot = em_pivot_calibration(Ng, Nframes, M);
    
    % pivot calibration for optical tracker
    [ND, NH, Nframes, M] = parseOPTPIVOT...
        (strcat('pa1-',type,'-',char,'-optpivot.txt'));
    OPTpivot = opt_pivot_calibration(d, ND, NH, Nframes, M);
    
    % output the result
    output = zeros(3 + NC*NFrames,3);
    % number of EM markers on calibration object
    output(1,1) = NC;
    % number of data frames
    output(1,2) = NFrames;
    % Estimated post position with EM probe pivot calibration
    output(2,:) = EMpivot(4:6)';
    % Estimated post position with optical probe pivot calibration
    output(3,:) = OPTpivot(4:6)';
    % expected value for C
    output(4:end,:) = C_e;
    
    % define output file name
    output_filename = strcat('pa1output/pa1-',type,'-',char,'-output1.txt');
    csvwrite(output_filename, output);
end
