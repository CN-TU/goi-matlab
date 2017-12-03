function [Odens kdens] = rdensity( data, cl, k )
% RDENSITY calculates dataset density (Odens) based on relaxed volumes 
% and cluster relative densities (kdens) based on strict volumes

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
% data: MxN-dataset; 'M' are objects, 'N' are dimensions
% cl: Mx1-array with dataset labels, from 1 to k
% k: number of clusters 

% ----------- outputs -----------
% Odens: Global/Overall density
% kdens: kx1-array with cluster relative densities 

    center=mean(data);
    centD=dist(data,center');
    Odens=1/((mean(centD)+2*std(centD))/length(data));
    for i=1:k
        kcenter=mean(data(cl==i,:));
        kcentD=dist(data(cl==i,:),kcenter');
        mdDa(i)=median(kcentD);
        kdens(i)=-1+(sum(cl==i)/mdDa(i))/Odens;
end

