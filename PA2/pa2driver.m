% programming assignment 1 driver
clc
clear
format compact

addpath('PA1');
addpath('PA2');
addpath('PA12-StudentData');
addpath('parse');

% char for example
for char = 'a':'j'
    % specify the file trype
    if ismember(char, 'a':'f')
        type = 'debug';
    elseif ismember(char, 'g':'j')
        type = 'unknown';
    end
    
    [Nd, Na, Nc, M] = parseCALBODY(strcat('pa2-',type,'-',char,'-calbody.txt'));
    d = M(1:Nd,:);
    a = M(Nd+1:Nd+Na,:);
    c = M(Nd+Na+1:end,:);

    % compute the expected value C_expected for C
    [ND, NA, NC, NFrames, M] = parseCALREADINGS...
        (strcat('pa2-',type,'-',char,'-calreadings.txt'));
    % distorted and expected value of C (combine each data frame)
    C_d = [];
    C_e = [];
    % loop each data frame
    for i=1:NFrames
        start = (i-1)*(ND+NA+NC)+1;
        D = M(start:start+ND-1,:);
        A = M(start+ND:start+ND+NA-1,:);
        C = M(start+ND+NA:start+ND+NA+NC-1,:);
        % get the distorted data
        C_d = [C_d; C];
        % get the expected data by composition rule
        C_expected = c_expected_value(D, d, A, a, c);
        C_e = [C_e; C_expected];
    end
    
    % output C expected to file
    output1_filename = strcat('pa2output/pa2-',type,'-',char,'-output1.txt');
    output1 = zeros(length(C_e)+3,3);
    output1(1,1) = NC;
    output1(1,2) = NFrames;
    output1(4:end,:) = C_e;

    % compute the distortion correction matrix: F(q)C=p
    % the maximum/minimum value for experimental distorted data
    [distortion_matrix, qmax, qmin] = distortion_matrix_compute(C_d, C_e);

    % get the measured distorted data
    [Ng, Nframes, M] = parseEMPIVOT...
        (strcat('pa2-',type,'-',char,'-empivot.txt'));
    % apply distortion correction and pivot calibration for pivot value
    % the local coordinates of first data frame for following use
    [pivot, g_1st_frame] = corrected_em_pivot_calibration...
        (Ng, Nframes, M, distortion_matrix, qmax, qmin);
    
    % record the em tracker pivot value to file
    output1(2,:) = pivot(4:6)';
    csvwrite(output1_filename, output1);

    % get the measurement of markers in probe with respect to EM tracker
    [NG, NB, G_EM] = parseEMFIDUCIALS...
        (strcat('pa2-',type,'-',char,'-em-fiducialss.txt'));
    % compute the fiducials' position with respect to EM tracker
    B = fiducials_in_EM...
        (NG, NB, G_EM, distortion_matrix, pivot, g_1st_frame, qmax, qmin);

    % get the measurement of the fiducials' position with respcet to CT
    [Nb, b] = parseCTFIDUCIALS...
        (strcat('pa2-',type,'-',char,'-ct-fiducials.txt'));
    % get the transformation matrix
    Freg = registration(b, B);

    [Ng, Nf, M] = parseEMNAV...
        (strcat('pa2-',type,'-',char,'-EM-nav.txt'));
    % get the corrected test point pivot value with respect to EM tracker
    V = fiducials_in_EM...
        (Ng, Nf, M, distortion_matrix, pivot, g_1st_frame, qmax, qmin);
    V(:,4) = 1;
    % transform to CT frame
    v = Freg*V';
    v = v(1:3,:)';
    
    % output v to file
    output2_filename = strcat('pa2output/pa2-',type,'-',char,'-output2.txt');
    output2 = zeros(length(v)+1,3);
    output2(1,1) = Nf;
    output2(2:end,:) = v;
    csvwrite(output2_filename, output2);

end