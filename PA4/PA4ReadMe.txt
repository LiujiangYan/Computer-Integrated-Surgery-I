Computer Integrated Surgery I Programming Assignment 4
Liujiang Yan, Mengzi Xu

instruction about how to execute:
1. Please make \PA4 as the workspace
2. The driver file is \PA4\PADriver.m. The script will compute all the debug and unknown data files, record the output results in PA4OutputData. Also the ICP process will be recorded in \PA4OutputFig.
3. The validation file is \PA4Validation which will show the difference of sample points closest points and closest distance.
4. The results for PA4 is in \PA4OutputData

what files includes in the folder:
1. ICP - all needed iterative closest points algorithm implementation functions are including in this folder.
2. LogFile - the log file of three different search methods (bounding sphere, bounding box, octree).
3. Parse - essential parse functions for reading the data files.
4. BarPlot - plot some essential information of PA4 (please do not clear the workspace after running PA4Driver.m)

% The driver script introduces ‘parfor’ for paralleling programming which may sometimes cause error. To fix it you could replace parlor for ‘for’ or relaunch MATLAB.