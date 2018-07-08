% Indices Comparison, Example 4 "High-dimensional dataset" (Section VI.D)

addpath(genpath('mdcgen'));
addpath(genpath('validity'));
addpath(genpath('processing'));

% For paper figures
%W = 4; H = 3;
%h=figure(1);
%set(h,'PaperUnits','inches')
%set(h,'PaperOrientation','portrait');
%set(h,'PaperSize',[H,W])
%set(h,'PaperPosition',[0,0,W,H])

data=csvread('datasets/dim256_noise.csv');
label=csvread('datasets/dim256_noise_label.csv');
dataset.MN = data;  
dataset.label = label;

% For paper figures
%scatter(data(:,1),data(:,10),2, 'fill'); 
%print(h,'-dpng','-r300', '-opengl','f1f10.png');
%scatter(data(:,11),data(:,43),2, 'fill'); 
%print(h,'-dpng','-r300', '-opengl','f11f43.png');
%scatter(data(:,50),data(:,100),2, 'fill'); 
%print(h,'-dpng','-r300', '-opengl','f50f100.png');
%scatter(data(:,115),data(:,240),2, 'fill'); 
%print(h,'-dpng','-r300', '-opengl','f115f240.png');


% comparison
pclust.orF = 0;
pclust.densC = 0;
pclust.orc = 0;
pclust.fut = 1; % feature under test: algorithm
pclust.futinc = 1;
pclust.futmin = 14;
pclust.futmax = 19;
pclust.algorithm= 2; % kmedoids
result = clustperf_comp (dataset,pclust);

% display "result.best" to see the comparison results