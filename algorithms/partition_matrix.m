function W = partition_matrix(data,v,k,m)
% PARTITION_MATRIX calculates fuzzy membership/partition matrix W
% (mu_i,j coefficients) as introduced in :
%	X. L. Xie and G. Beni, “A validity measure for fuzzy clustering” IEEE
%	Transactions on Pattern Analysis and Machine Intelligence, vol. 13,
%	no. 8, pp. 841–847, 1991.

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
% data: dataset
% v: centroids
% k: number of clusters
% m: fuzzifier coeff 

% ----------- outputs -----------
% W: partition matrix

if m<2
    m=2;
end

DMX=abs(dist(data,v'));

for i=1:size(data,1)
    for j=1:k
        num=DMX(i,j);
        acc=0;
        for l=1:k
            den=DMX(i,l);
            acc=acc+power(num/den,2/(m-1));
        end
        W(i,j)=1/acc;
    end
end
  
end

