{\rtf1\ansi\ansicpg1252\cocoartf1404\cocoasubrtf470
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 Computer Integrated Surgery I Programming Assignment 3 \
Liujiang Yan, Mengzi Xu,\
\
1. Please make \\PA3 as the workspace.\
\
2. The driver file is \\PA3\\PA3driver.m\
The driver script will compute all the debug and unknown files, and record the results in \\PA3\\PA3output. The finding closest point in mesh process can be done by different methods: linear search by brute force, octree, bounding spheres and bound boxes. To check another methods\'92 result, please uncomment line 94 to 96.\
\
3. \\PA3\\Validation has three validation script, please keep the workspace as \\PA3, and the scripts will include essential file path.\
\
4. \\PA3\\Parse includes some essential parsing files for reading the data files.\
\
5. \\PA3\\ICP contains a straight registration function, a ransac based registration function.\
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 6. \\PA3\\ICP contains a function to find the closest point in triangle, and a brute force linear search function to find the closest point in mesh.\
\
7. \\PA3\\ICP\\BoundingSphere&Box contains functions to perform finding closest point in mesh by bounding sphere and bounding box.\
\
8. \\PA3\\ICP\\Octree contains a class defined in octree_object.m and search method in octree_search.m, with other helpful functions.\
}