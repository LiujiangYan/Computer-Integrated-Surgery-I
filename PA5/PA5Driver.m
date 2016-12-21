%% initialization
clc;
clear;
close all;
format compact;

%% addpath
addpath('PlotFigure/');
addpath('Parse/');
addpath('Solver/');
addpath(genpath('IterativeClosestPoint/'));
addpath('DeformableRegistration/');

%% user defined file path
% here you could define the input/output filepath for reusability
% the filename format and data type should be the same as the instruction

% the input data file path
inputDataFilepath = 'PA234 - Student Data/';
% the output data file will be stored here
outputDataFilepath = 'PA5OutputData/';
% the output figure will be stored here
outputFigureFilepath = 'PA5OutputFig/';
% you could assign data frames here
charlist = ['A':'H','J','K'];

%% read Body A B, mesh and mode files
% body A
body_A_filepath = strcat(inputDataFilepath, '/Problem5-BodyA.txt');
[num_a, a, a_tip] = parseBody(body_A_filepath);
% body B
body_B_filepath = strcat(inputDataFilepath, 'Problem5-BodyB.txt');
[num_b, b, b_tip] = parseBody(body_B_filepath);
% mesh - triangle set and corresponding vertices index
mesh_filepath = strcat(inputDataFilepath, 'Problem5MeshFile.sur');
[triangle_set, triangle_vertices_index] = parseMesh(mesh_filepath);
% mode from 0 to 6
mode_filepath = strcat(inputDataFilepath, 'Problem5Modes.txt');
Nvertices = 1568;
Nmodes = 7;
[Mode] = parseMode(mode_filepath, Nvertices, Nmodes);

%% Deformable Regiatration
% the most efficient as well as accurate method PA5Solver_2_Linear
% is to update two parameters at the same time
% using bounding sphere linear search
% you are also wellcome to test (uncomment) other methods as I listed below

% update rigid transformation and deformable parameter separately
PA5Solver_1;

% update two parameters at the same time (by bounding sphere linear search)
% PA5Solver_2_Linear;

% update two parameters at the same time (by bounding sphere linear search)
% PA5Solver_2_Tree;