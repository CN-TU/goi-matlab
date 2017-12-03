
function [ r ] = clustperf_comp (dataset,pclust)
% CLUSTPERF_COMP carries out comparisons among diverse clustering performances 
% by calculating a set of cluster validity indices for every performance 

%------------------------------------------------------------------------------------------------------
% Author: Félix Iglesias <felix.iglesias.vazquez@nt.tuwien.ac.at>
% License: GPLv3 (2016)
%
% Copyright (C) 2016  Félix Iglesias, TU Wien
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%------------------------------------------------------------------------------------------------------

% ----------- inputs ------------ 
% dataset: dataset with a mdcgen-like structure
% pclust.
%       k: number of clusters
%       algorithm: selected algorithm for clustering: 1:kmeans ,2:kmedoids, 3:,agglom 4:fcm 
%       norm: type of normalization: 0:no-norm, 1:range, 2:z-score, 3:quartile, 4:weight
%       orF: outlier removal FLAG
%       orc: outlier removal coefficient
%       densC: density correction FLAG
%       fut: feature-under-test, 1:k, 2:algorithm, 3:orc, 4:norm
%       futmin: feature-under-test minimum value
%       futmax: feature-under-test maximum value
%       futinc: feature-under-test increment value
%       plot2DF: plot 2-dimensional solutions FLAG 
%       logF: log files FLAG 

% ----------- outputs ----------- 
% r.
%   best:   contains the id of the "best clustering" selected by each
%           validity index, also the best according to the original partition (PART),
%           and the value of the feature-under-test for the original partition case.    
%   featval: array with the checked values of the feature-under-test. 
%   vi:     contains the validity indices values for every run

% -------------- Checking existence of input arguments
if exist('pclust')==0, pclust=[];end
if isfield(pclust,'k')==0, pclust.k = 5; end
if isfield(pclust,'algorithm')==0, pclust.algorithm = 1; end
if isfield(pclust,'orF')==0, pclust.orF= 0; end
if isfield(pclust,'orc')==0, pclust.orc= 0; end
if isfield(pclust,'norm')==0, pclust.norm= 1; end
if isfield(pclust,'densC')==0, pclust.densC= 0; end
if isfield(pclust,'futmin')==0, pclust.futmin= 2; end
if isfield(pclust,'futmax')==0, pclust.futmax= 10; end
if isfield(pclust,'futinc')==0, pclust.futinc= 1; end
if isfield(pclust,'fut')==0, pclust.fut= 1; end
if isfield(pclust,'plot2DF')==0, pclust.plot2DF= 0; end
if isfield(pclust,'logF')==0, pclust.logF= 0; end

addpath(genpath('validity'));

k=pclust.k;
algorithm=pclust.algorithm;
orF=pclust.orF;
orc=pclust.orc;
norm=pclust.norm;
densC=pclust.densC;
futmin=pclust.futmin; 
futmax=pclust.futmax;
futinc=pclust.futinc;
xfut=futmin:futinc:futmax;
fut=pclust.fut;
plot2DF=pclust.plot2DF;
logF=pclust.logF;

if (fut ~= 4)
    [M,N]=size(dataset.MN);
    [dataset.MN normp] = normalization(dataset.MN, norm, 0);
end

for i=1:length(xfut)
    switch fut
        case 1, k=xfut(i);
        case 2, algorithm=xfut(i);
        case 3, orc=xfut(i);
        case 4, norm=xfut(i);
        otherwise, k=xfut(i);
    end
    
    if (fut == 4)
        [M,N]=size(dataset.MN);
        [dataset.MN normp] = normalization(dataset.MN, norm, 0);
    end

    rclust = clustout(dataset.MN,k,algorithm,orF,orc,densC);  
    if (orF)
        rclustNo=rclust;
        datasetNo.MN=dataset.MN(rclust.data.cldo>1,:);
        rclustNo.data.cl=rclust.data.cldo(rclust.data.cldo>1);
        rclustNo.data.W=rclust.data.W(rclust.data.cldo>1,:);
        rclustNo.data.D=rclust.data.D(rclust.data.cldo>1,:);
        val = clustval(datasetNo.MN,k,rclustNo);
    else
        val = clustval(dataset.MN,k,rclust);
    end  
    labclust=rclust.data.cldo;
    labclust(labclust<0)=0;
    if isfield(dataset,'label') 
        val.PART=check_partition(dataset.label,labclust');
    end
    record(i)=val;
    vi.featval(i)=xfut(i);
    if plot2DF
        plotting2D (100+i, dataset.MN, 1, k, rclust.cluster.V, labclust, rclust.cluster.mdDa, rclust.cluster.mnDa, rclust.cluster.sdDa);
    end
    if logF
        name=strcat('logs/cl_log',int2str(xfut(i)),'.txt');
        clust_log(name,rclust,dataset.MN,k,val);
    end
end

for i=1:length(xfut)
       vi.PC(i)=record(i).PC;
       vi.CE(i)=record(i).CE;
       vi.S(i)=record(i).S;
       vi.XB(i)=record(i).XB;
       vi.DI(i)=record(i).DI;
       vi.CH(i)=record(i).CH;
       vi.DB(i)=record(i).DB;
       vi.Gr(i)=record(i).Grex;
       vi.Gs(i)=record(i).Gstr;
       vi.Gm(i)=record(i).Gmin;
       if isfield(dataset,'label'), vi.PART(i)=record(i).PART; end
end
    
[val vi_best.PC]=max(vi.PC); 
[val vi_best.CE]=min(vi.CE);
[val vi_best.S]=max(vi.S); 
[val vi_best.XB]=min(vi.XB); 
[val vi_best.DB]=min(vi.DB); 
[val vi_best.DI]=max(vi.DI); 
[val vi_best.Gs]=max(vi.Gs); 
[val vi_best.CH]=max(vi.CH); 
[val vi_best.Gr]=max(vi.Gr); 
[val vi_best.Gm]=max(vi.Gm); 
if isfield(dataset,'label') 
    [val vi_best.PART]=max(vi.PART); 
    vi_best.featval=xfut(vi_best.PART);
end
r.best=vi_best;
r.featval=vi.featval;
r.vi=vi;
end
