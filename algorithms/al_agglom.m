function r = al_agglom(data,k)
% AL_AGGLOM is based on the MATLAB linkage algorithm and performs agglomerative clustering. 
% It extracts clustering context information

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

% ----------- outputs -----------
% r.cluster.V: centroids
% r.data.W: fuzzy partition matrix
% r.data.D: squared-distance matrix
% r.data.B: bin-centroid-index matrix
% r.cluster.mass: cluster masses (aka cardinality, objects per cluster) 
% r.data.cl: corresponding cluster 
% r.data.mind: object distance to the closest centroid 
% r.cluster.mnDa: cluster intra distance mean
% r.cluster.mdDa: cluster intra distance median
% r.cluster.sdDa: cluster intra distance std-dev 
% r.cluster.De: cluster inter distance matrix 
% r.cluster.minDe: distance to the closest cluster of cluster_i 
% r.cluster.closest: closest cluster of cluster_i

    Z = linkage(data,'ward','euclidean');
    c = cluster(Z,'maxclust',k);
    for i=1:max(c)
        V(i,:)=mean(data(c==i,:),1);
    end
    D=power(dist(data,V'),2);
    W=partition_matrix(data,V,k,2);
    B=floor(bsxfun(@rdivide,min(D')',D));
    mass=nansum(B);	
    [aux cl]=nanmax(B');
    mind=sqrt(nanmin(D')');
    for j=1:k
        if isempty(mind(cl==j))==0
            r.cluster.mdDa(j)=median(mind(cl==j));
            r.cluster.mnDa(j)=mean(mind(cl==j));
            r.cluster.sdDa(j)=std(mind(cl==j));
        else
            r.cluster.mdDa(j)=0;
            r.cluster.mnDa(j)=0;
            r.cluster.sdDa(j)=0;
        end
    end
    De=dist(V');
    [minDe closest]=min(De+(max(max(De))+1)*eye(k)); 
    
    r.cluster.V=V;
    r.data.D=D;
    r.data.cl=cl';
    r.data.W=W;
    r.data.B=B;
    r.cluster.mass=mass;	
    r.data.mind=mind;
    r.cluster.De=De;
    r.cluster.minDe=minDe; 
    r.cluster.closest=closest; 
end
 

