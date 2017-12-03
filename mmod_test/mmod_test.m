function [ r ] = mmod_test( seed )
% MMOD_TEST creates datasets with k clusters and checks if multimodality
% (mm) is correctly detected by using kernel density estimations. I.e.,
% k=1, mm=0 --> GOOD detection (TN)
% k>1, mm=0 --> WRONG detection (FN)
% k>1, mm>0 --> GOOD detection (TP)
% k=1, mm>0 --> WRONG detection (FP)

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
% r.
%   tabtrue: table of truth, Positive when mm==1
%              [TN, FN;
%               FP, TP]
%   acc: accuracy
%   prec: precission
%   rec: recall
%   log: matrix with experiment/dataset details. row_i contains:
%              "[seed,objects,dimensions,distribution-type,
%                compactness-coeff,k,dimensions-with-mm,mm-detected,
%                fp-or-fn-occured,rate-of-well-clustered-objects]"

%clear all;

exp=10000; ct=0;

if exist('seed')==0, seed=100;end
p.sd=seed;
rng(p.sd);

p.dflag=1;
p.mv=0;
p.corr=0;
p.alphaN=1;
p.scale=1;
p.out=0;
p.rot=0;
p.Nnoise=0;

M=100+floor(1901*rand(exp,1));
N=2+floor(19*rand(exp,1));
k=1+floor(5*rand(exp,1));
d=1+floor(5*rand(exp,1));
cp=0.01+0.09*rand(exp,1);

TP=0;FP=0;TN=0;FN=0;

for i=1:exp
    MN=[];label=[];
    p.d=d(i); p.M=M(i); p.N=N(i); p.k=k(i); p.cp=cp(i); 
    if d(i)==5, p.mv=-1; else, p.mv=0; end
    dataset = mdcgen( p );
    MN=dataset.MN; label=dataset.label;
    mm(i) = multimod( MN );
    if (k(i)>1) %if k==1, clustering is not necessary
        [class,centers,A,D] = kmeans(MN,k(i),'start','uniform', 'emptyaction','singleton');
        % -- forcing orig. labels and clust. classes use the same symbols ---- 
        labelF=zeros(length(label),1);
        for j=1:k(i)
            in_lab=ismember(label,j);
            inlab_class=in_lab.*class;
            inlab_class=inlab_class(inlab_class>0);
            val_class=mode(inlab_class);
            labeli=in_lab*val_class;
            labelF=labelF+labeli;
        end 
        % --------------------------------------------------------------------
        comp(i)=sum((class-labelF)==0)/length(class); % rate of well-clustered objects
    else
        comp(i)=1; %if k==1, clustering is not necessary -> comp=1
    end
    tn=(k(i)==1 & mm(i)==0);    TN=TN+tn;
    fp=(k(i)==1 & mm(i)>0);     FP=FP+fp;
    fn=(k(i)>1 & mm(i)==0);     FN=FN+fn;
    tp=(k(i)>1 & mm(i)>0);      TP=TP+tp;
    flog(i,:)=[p.sd,M(i),N(i),d(i),cp(i),k(i),mm(i),mm(i)>0,fp|fn,comp(i)];
    if fn==1
        fprintf('N');
    elseif fp==1
        fprintf('P');
    else
        fprintf('.');
    end
    if (mod(i,50)==0) 
        fprintf('%d\n',ct);
        ct=ct+1;
    end
end

r.acc=(TN+TP)/(TN+TP+FN+FP);
r.prec=TP/(TP+FP);
r.rec=TP/(FN+TP);
r.tab_true=[TN FN; FP TP];
r.log=flog;

end