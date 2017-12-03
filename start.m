
clear all; clc;
addpath(genpath('../CVTbed'));

disp('-----------------------------------------------------------');
disp('Initialization for Clust Val Indices comparison');
disp('-----------------------------------------------------------');
disp('Select dataset (2 dimensions):');
disp('[0] - simple.csv ');
disp('[1] - noisy.csv ');
disp('[2] - a1.csv ');
disp('[3] - a2.csv ');
disp('[4] - a3.csv ');
disp('[5] - unbalance.csv ');
disp('[6] - basic.csv ');
disp('[7] - simple_out.csv ');disp(' ');
disp('  [2,3,4,5] have been downloaded from "Joensuu clustering datasets":');
disp('  https://cs.joensuu.fi/sipu/datasets');
prompt='?';
pclust.l=0; %default
x = input(prompt);

switch x
    case 0
        dataset.MN=csvread('datasets/simple.csv');
        disp('Loading [0] ...')
    case 1
        dataset.MN=csvread('datasets/noisy.csv');
        disp('Loading [1] ...')
    case 2
        dataset.MN=csvread('datasets/a1.csv');
        disp('Loading [2] ...')
    case 3
        dataset.MN=csvread('datasets/a2.csv');
        disp('Loading [3] ...')
    case 4
        dataset.MN=csvread('datasets/a3.csv');
        disp('Loading [4] ...')
    case 5
        dataset.MN=csvread('datasets/unbalance.csv');
        disp('Loading [5] ...')
    case 6
        dataset.MN=csvread('datasets/basic.csv');
        disp('Loading [6] ...')
    case 7
        dataset.MN=csvread('datasets/simple_out.csv');
        disp('Loading [7] ...')
    otherwise
        disp('Selected [0] by default')
        disp('Loading [1] ...')
        dataset.MN=csvread('datasets/simple.csv');
end
pclust.l=x;

disp('Select algorithm');
disp('[1] - kmeans ');
disp('[2] - kmedoids ');
disp('[3] - agglomerative ');
disp('[4] - fuzzy-fcm ');
prompt='?';
x = input(prompt);

switch x
    case 1
        pclust.algorithm=1;
        disp('Selected: [1] kmeans')
    case 2
        pclust.algorithm=2;
        disp('Selected: [2] kmedoids')
    case 3
        pclust.algorithm=3;
        disp('Selected: [3] agglomerative')
    case 4
        pclust.algorithm=4;
        disp('Selected: [4] fuzzy-fcm')
    otherwise
        pclust.algorithm=1;
        disp('Selected: [1] kmeans')
end

prompt='With outlier rejection ([0]-no [1]-yes)? ';
x = input(prompt);

if (x==1)
    disp('Outlier rejection (selected)')
    pclust.orF = 1;
else
    disp('Outlier rejection (not selected)')
    pclust.orF = 0;
end

prompt='With dk-est correction ([0]-no [1]-yes)? ';
x = input(prompt);

if (x==1)
    disp('dke correction (selected)')
    pclust.densC = 1;
else
    disp('dke correction (not selected)')
    pclust.densC = 0;
end

pclust.fut=1; %feat-under-test: k
pclust.futinc=1;

prompt='k min? ';
pclust.futmin = input(prompt);

prompt='k max? ';
pclust.futmax = input(prompt);

pclust.plot2DF=1;
pclust.logF=1;
disp('solution plots and log files will be generated')

disp('-------------------------------------------------------------------------------');
disp('Run [r = clustperf_comp (dataset,pclust)] to start Clust Val Indices comparison');
disp('Run [plotting_vi (r.vi)] to display results');
disp('-------------------------------------------------------------------------------');
clear x
clear prompt
