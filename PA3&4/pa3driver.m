clear;
clc;
format compact;

addpath('PA234 - Student Data/');
addpath('parse/');

body_A_filepath = 'PA234 - Student Data/Problem3-BodyA.txt';
[N_A, PA_markers, PA_tip] = parseBody(body_A_filepath);

body_B_filepath = 'PA234 - Student Data/Problem3-BodyB.txt';
[N_B, PB_markers, PB_tip] = parseBody(body_B_filepath);

mesh_filepath = 'PA234 - Student Data/Problem3MeshFile.sur';
[N_vertices, P_vertices, N_tri, I_tri] = parseMesh(mesh_filepath);

sample_filepath = 'PA234 - Student Data/PA3-A-Debug-SampleReadingsTest.txt';
[N_samples, P_A, P_B] = parseSample(sample_filepath, N_A, N_B);