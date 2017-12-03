function plotting2D (index, data, volF, k, V, cl, mdDa, mnDa, sdDa)
% PLOTTING2D displays 2-dimensional datasets with centroids, outliers, 
% core and extended volumes 

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
% index: figure index
% data: MxN-dataset (M objects, N features/dimensions)
% volF: FLAG for showing centroids, volumes and outliers
% k: number of clusters
% V: MxN-centroids (M centroids, N features/dimensions)
% cl: M-array with cluster labels
% mdDa: M-array with cluster median of intra-distances
% mnDa: M-array with cluster mean of intra-distances
% sdDa: M-array with cluster standard deviatin of intra-distances


[M,N]=size(data);

figure(index);
colTr=ones(M,3)*0.6;
sizeTr=ones(M,1)*5;
if (volF)
    colTr(find(cl>0),3)=1; %blue
    colTr(find(cl>0),1)=0; %blue
    colTr(find(cl>0),2)=0; %blue
    sizeTr(find(cl<0))=10;
    plot(V(:,1),V(:,2),'r*');hold on
    for j=1:k
        mu=mdDa(j);
        mu2=mnDa(j)+2*sdDa(j);
        xp=V(j,1);
        yp=V(j,2);
        rectangle('Position',[xp-mu yp-mu 2*mu 2*mu],'Curvature',[1 1]);
        rectangle('Position',[xp-mu2 yp-mu2 2*mu2 2*mu2],'Curvature',[1 1], 'LineStyle','--');
        text(xp,yp,strcat(' c',int2str(j)),'Color','r');
    end
end
scatter(data(:,1),data(:,2),sizeTr,colTr,'fill');

end