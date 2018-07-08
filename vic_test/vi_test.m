function [ r ] = vi_test ( exp, noise_flag, seed )
% VI_TEST compares cluster validity indices by using a set of 'x' experiments
% (exp) with a different multi-dimensional dataset per experiment

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
% exp: number of experiments
% noise_flag: if 1, up to 10% outliers is added to datasets
% seed: random seed

% ----------- outputs ----------- 
% r.
%   best:   contains the number of correct performances reached by each 
%           validity index (S, CH, PC, etc.) 
%   record: contains the record with the "best clustering" selected by each
%           validity index for each experiment, also the best original 
%           partition (PART)

addpath(genpath('../../CVTbed'));
%clear all; clc;

if exist('exp')==0, exp=1000;end
if exist('noise_flag')==0, noise_flag=0;end
if exist('seed')==0, seed=310716;end

% pd: paramters for dataset
% fixed parameters for testing
pd.sd=seed;
pd.corr=0;
pd.alphaN=1;
pd.scale=1;
pd.rot=0;
pd.mv=1;

%exp=1000;     %number of datasets-experiments
rng(pd.sd); %control random number generation

% variable parameters for testing
M=200+floor(1901*rand(exp,1));
N=3+floor(18*rand(exp,1));
N=3+floor(17*rand(exp,1));
k=2+floor(7*rand(exp,1));
d=1+floor(6*rand(exp,1));
cp=0.05+0.05*rand(exp,1);
alg=1+floor(4*rand(exp,1));
if (noise_flag)
    out=floor(bsxfun(@times,M,0.1*rand(exp,1)));
else
    out=zeros(exp,1); 
end

ct=0;
for i=1:exp  
    data=[];
    pd.d=d(i); pd.M=M(i); pd.N=N(i); pd.k=k(i); pd.cp=cp(i); pd.out=out(i);
    if pd.d==6, mv=-1; else, mv=1; end %to avoid split-clusters 
    [dataset] = mdcgen( pd );
    
    % pc: paramters for comparison
    pc.orF = 0;
    pc.densC = 0;
    pc.k = k(i);
    pc.orc = 0;
    pc.fut = 1; % feature under test: k
    pc.futinc = 1;
    pc.futmin = k(i)-floor(4*rand()+1);
    if (pc.futmin<2) 
        pc.futmin=2;
    end
    pc.futmax = k(i)+floor(4*rand()+1);
    pc.algorithm=alg(i);
    rcp = clustperf_comp (dataset,pc);
    record(i)=rcp.best;
    
    PC(i)=record(i).PC;
    S(i)=record(i).S;
    XB(i)=record(i).XB;
    DB(i)=record(i).DB;
    DI(i)=record(i).DI;
    CE(i)=record(i).CE;
    CH(i)=record(i).CH;
    Gs(i)=record(i).Gs;
    Gr(i)=record(i).Gr;
    Gm(i)=record(i).Gm;
    PART(i)=record(i).PART; %original data partition according to the generator
    
    fprintf('I');
    if (mod(i,20)==0) 
        fprintf('%d x 20\n',ct);
        ct=ct+1;
    end

    
end

best.PC=sum(PC==PART);
best.S=sum(S==PART);
best.XB=sum(XB==PART);
best.DB=sum(DB==PART);
best.DI=sum(DI==PART);
best.CE=sum(CE==PART);
best.CH=sum(CH==PART);
best.Gr=sum(Gr==PART);
best.Gm=sum(Gm==PART);
best.Gs=sum(Gs==PART);

r.best=best;
r.record=record;

end