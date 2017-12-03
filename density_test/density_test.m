function [ r ] = density_test( seed )
% DENSITY_TEST checks dependency between relative-density and dimensionality

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
% seed: random seed

% ----------- outputs -----------
% r
%    .yf: array with mean(rel-density) of all clusters generated for dimension Ni
%    .sf: array with std(rel-density) of all clusters generated for dimension Ni
%    .corrNy: Pearson correlation between yf and N
%    .MI: Mutual Information between yf and N
%    .MNI: Normalized Mutual Information between yf and N
%    .log: matrix with experiment/dataset details. row_i contains:
%              "[seed,dimensions,objects,k,distribution-type,
%                compactness-coeff,Global-density,cluster-density-mean,
%                cluster-density-stdev]"



%clear all;

if exist('seed')==0, seed=100;end

p.sd=seed;
p.cp=0.1;
MNin=2;Ninc=1;MNax=101;
Mmin=1000;Minc=1000;Mmax=5000;
kmin=2;kinc=1;kmax=10;

rng(p.sd);
N=MNin:Ninc:MNax;N=N';
j=1;

for i=1:length(N)
    m=1;
    for d=1:5
        fprintf('\n Dimensions (N): %d >> dist type: %d..... ',i,d);
        for M=Mmin:Minc:Mmax
            fprintf('\n M: %d, k: ',M);
            for k=kmin:kinc:kmax
                fprintf('%d,',k);
                MN=[];label=[];
                p.d=d; p.M=M; p.N=N(i); p.k=k;
                [ dataset ] = mdcgen( p );
                [Odens kdens] = rdensity ( dataset.MN, dataset.label, k );
                y(m)=mean(kdens);
                s(m)=std(kdens);
                flog(j,:)=[p.sd,N(i),M,k,d,p.cp,Odens,y(m),s(m)];
                m=m+1;j=j+1;
            end
        end
    end
    yf(i)=mean(y);
    sf(i)=mean(s);
end

[MI,Nbias,sigma,descriptor] = information(N',yf);
[e1,Nbias,sigma,descriptor] = information(N',N');
[e2,Nbias,sigma,descriptor] = information(yf,yf);
MNI=MI/min(e1,e2);
corrNy=corr(N, yf');    

r.yf=yf;
r.sf=sf;
r.corrNy=corrNy;
r.MI=MI;
r.MNI=MNI;
r.log=flog;

end