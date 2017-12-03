
addpath(genpath('mdcgen'));
addpath(genpath('validity'));
addpath(genpath('processing'));

% generate dataset
pdata.k=10;
pdata.N=2;
pdata.cp=0.1;
pdata.mv=-1;
pdata.scale=1;
pdata.out=0;
pdata.sd=1000;
[dataset]=mdcgen(pdata);

% plot dataset
figure
scatter(dataset.MN(:,1),dataset.MN(:,2),3,dataset.label,'fill');
axis([0 1 0 1])

% comparison
pclust.orF = 0;
pclust.densC = 0;
pclust.orc = 0;
pclust.fut = 1; % feature under test: k
pclust.futinc = 1;
pclust.futmin = 5;
pclust.futmax = 15;
pclust.algorithm= 3; % agglomerative
result = clustperf_comp (dataset,pclust);

% display "result.best" to see the comparison results