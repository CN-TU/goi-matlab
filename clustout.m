function r = clustout(data,k,algorithm, orF, orc, densC)
% CLUSTOUT performs clustering with outlier correction and/or density
% correction if selected

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
% data: MxN matrix (M:samples, N:features)
% k: number of clusters
% algorithm: clustering algorithm (see below)
% orF: outlier removal FLAG
% orc: outlier removal coefficient
% densC: density correction FLAG

% ----------- outputs -----------
% r.
%   cluster.
%       V: centroids
%       mass: cluster masses (aka cardinality, objects per cluster) 
%       masswo: cluster masses previous to removing outliers 
%       mnDa: cluster mean intra distance 
%       mdDa: cluster median intra distance 
%       sdDa: cluster std-dev intra distance 
%       De: cluster inter distance matrix 
%       minDe: distance to the closest cluster of cluster_i 
%       closest: closest cluster of cluster_i
%       outliers: total number of outliers 
%   data.
%       W: fuzzy partition matrix
%       D: squared-distance matrix
%       B: bin-centroid-index matrix
%       cl: corresponding cluster (including outliers) 
%       cldo: corresponding cluster (outliers are marked with '-' sign)
%       mind: object distance to the closest centroid 
%       out: outlier detector bit per object
%       Odensity: overall dataset density
%   validity.
%       mm: multimodality detector bit per cluster
%       mmk: number of clusters with detected multimodality

addpath(genpath('algorithms'));
addpath(genpath('processing'));

[M,N]=size(data);
        
switch algorithm
    case 1,        r = al_kmeans(data,k);
    case 2,        r = al_kmedoids(data,k);
    case 3,        r = al_agglom(data,k);
    case 4,        r = al_fcm(data,k);
    otherwise,     r = al_kmeans(data,k);        
end

V=r.cluster.V;
D=r.data.D;
cl=r.data.cl;
W=r.data.W;
B=r.data.B;
mass=r.cluster.mass;	
mind=r.data.mind;
    
% multimod detection and density correction
mm(1:k)=0;
for i=1:k
    subset=data(r.data.cl==i,:);
    if isempty(subset)==0
        for j=1:N
            [f,xi] = ksdensity(subset(:,j));
            [val ind]=max(f);
            f=f/max(f);
            [pks,locs,w,p] = findpeaks(f,'MinPeakProminence',0.1);
            if length(pks)>1
                mm(i)=1;
            end
            if (densC)
                V(i,j)=xi(ind);
            end
        end
    end
end
r.validity.mm=mm;
r.validity.mmk=sum(mm);

% if density correction is applied, clustering outputs are recalculated
if (densC)
    D=power(dist(data,V'),2);
    W=partition_matrix(data,V,k,2);
    B=floor(bsxfun(@rdivide,min(D')',D));
    mass=nansum(B);	
    [aux cl]=nanmax(B');cl=cl';
    mind=sqrt(nanmin(D')');
end

% calclulating outlier detection thresholds per cluster
tol(1:k)=0;
cldo=cl;
if orF
    for i=1:k
        mindk=mind(cl==i);
        tol(i) = out_threshold( mindk, orc );
    end
    out=mind>tol(cl)';
    cldo=cldo-2*cl.*out;
else
    out=zeros(1,M);
end

% recalculating inter- and intra-distances after outlier removal
for j=1:k
        r.cluster.mdDa(j)=0;
        r.cluster.mnDa(j)=0;
        r.cluster.sdDa(j)=0;
        massNo(j)=length(mind(cldo==j));
        if isempty(mind(cldo==j))==0
            r.cluster.mdDa(j)=median(mind(cldo==j));
            r.cluster.mnDa(j)=mean(mind(cldo==j));
            r.cluster.sdDa(j)=std(mind(cldo==j));
        end
end
De=dist(V');
[minDe closest]=min(De+(max(max(De))+1)*eye(k)); 

    
%global density
center=sum(bsxfun(@times, V,mass'))/sum(mass);
Dcent=dist(data,center');
r.data.Odensity=2*(mean(Dcent(cldo>0))+2*std(Dcent(cldo>0)))/sum(mass); 


r.data.out=out;
r.cluster.outliers=sum(out);
r.data.cldo=cldo;
r.cluster.masswo=mass;

r.cluster.V=V;
r.data.D=D;
r.data.cl=cl;
r.data.W=W;
r.data.B=B;
r.cluster.mass=massNo;	
r.data.mind=mind;
r.cluster.De=De;
r.cluster.minDe=minDe; 
r.cluster.closest=closest; 
