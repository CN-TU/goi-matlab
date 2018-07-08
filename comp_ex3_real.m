%Indices Comparison, Example 3 "Real, multi-dimensional dataset with overlapped, non-globular clusters" (Section VI.C)

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


data=csvread('datasets/seeds.csv');
label=csvread('datasets/seeds_label.csv');

dataset.MN = data; 
dataset.label = label;

% For paper figures
%data1=data(label==1,:);
%data2=data(label==2,:);
%data3=data(label==3,:);
%scatter(data1(:,1),data1(:,2),'*'); hold on;
%scatter(data2(:,1),data2(:,2),'o'); 
%scatter(data3(:,1),data3(:,2),'+'); 
%print(h,'-dpng','-r300', '-opengl','f1f2.png');
%hold off;
%scatter(data1(:,3),data1(:,4),'*'); hold on;
%scatter(data2(:,3),data2(:,4),'o'); 
%scatter(data3(:,3),data3(:,4),'+'); 
%print(h,'-dpng','-r300', '-opengl','f3f4.png');
%hold off;
%scatter(data1(:,5),data1(:,6),'*'); hold on;
%scatter(data2(:,5),data2(:,6),'o'); 
%scatter(data3(:,5),data3(:,6),'+'); 
%print(h,'-dpng','-r300', '-opengl','f5f6.png');
%hold off;
%scatter(data1(:,1),data1(:,7),'*'); hold on;
%scatter(data2(:,1),data2(:,7),'o'); 
%scatter(data3(:,1),data3(:,7),'+'); 
%print(h,'-dpng','-r300', '-opengl','f1f7.png');

% comparison
pclust.orF = 0;
pclust.densC = 0;
pclust.orc = 0;
pclust.fut = 2; % feature under test: algorithm
pclust.futinc = 1;
pclust.futmin = 1;
pclust.futmax = 4;
pclust.k = 3;
result = clustperf_comp (dataset,pclust);

% display "result.best" to see the comparison results