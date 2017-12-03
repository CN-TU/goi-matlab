function r = clustval(data,k,c)
% CLUSTVAL calculates diverse validity indices:
%   Dunn's Index (DI)
%   Silhouette (S)
%   Calinski-Harabasz (CH)
%   Davies-Bouldin (DB)     
%   Partition Coefficient (PC)
%   Classification Entropy (CE)
%   Xie and Beni's index (XB)
%   G overlap family (Gstr, Grex, Gmin)

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
% data: MxN-dataset (M: objects, N: features/dimensions)
% k: number of clusters
% c: cluster solution structure (see "algorihms" folder)

% ----------- outputs ----------- 
% r: structure with validity indices (see below)

V=c.cluster.V;
D=c.data.D;
W=c.data.W;
minDe=c.cluster.minDe; 
De=c.cluster.De; 
mnDa=c.cluster.mnDa;
mdDa=c.cluster.mdDa;
sdDa=c.cluster.sdDa;
mass=c.cluster.mass;
cl=c.data.cl;

[M,N]=size(data);

% Dunn's Index (DI)
DI=min(minDe)/max(mnDa);

% Silhouette (S)
S=mean(silhouette(data,cl,'Euclidean'));

% Calinski-Harabasz (CH)
eva = evalclusters(data,cl,'CalinskiHarabasz');
CH=eva.CriterionValues;

% Davies-Bouldin (DB)
eva = evalclusters(data,cl,'DaviesBouldin');
DB=eva.CriterionValues;
        
% partition coefficient (PC)
PC = 1/M*sum(sum(W.^2));

% classification entropy (CE)
LW = (W).*log(W);
CE = -1/M*sum(sum(LW));    

% Xie and Beni's index (XB)
XB = sum((sum(D.*W.^2))./(M*min(minDe)));

% G overlap family (Gstr, Grex, Gmin)
[ g ] = Gvalidity(k,De,mdDa,mnDa,sdDa,mass);

r.S = S;
r.DI = DI;    
r.CH = CH;  
r.DB = DB;  
r.PC = PC;
r.CE = CE;    
r.XB = XB;          
r.Gstr=g.Gstr;
r.Grex=g.Grex;
r.Gmin=g.Gmin;
r.oi_st=g.oi_st;
r.oi_rx=g.oi_rx;
r.oi_mn=g.oi_mn;
r.volratio=g.volratio;

end
