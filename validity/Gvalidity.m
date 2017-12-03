function [ r ] = Gvalidity(k,De,mdDa,mnDa,sdDa,mass)
% GVALIDITY calculates dataset (G) and cluster (oi) overlap indices: strict, relaxed and minimum 

%------------------------------------------------------------------------------------------------------
% GVALIDITY v1.0 (Oct 2016)
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
% k: number of clusters
% mass: cluster mass or cardinality
% mnDa: cluster mean intra distance 
% mdDa: cluster median intra distance 
% sdDa: cluster std-dev intra distance 
% De: cluster inter distance matrix 

% ----------- outputs -----------
% r.
%   oi_st: strict overlap index (cluster) 
%   oi_rx: relaxed overlap index (cluster) 
%   oi_mn: minimum overlap index (cluster) 
%   Gstr: strict overlap index (dataset) 
%   Grex: relaxed overlap index (dataset) 
%   Gmin: minimum overlap index (dataset) 
%   volratio: ratio between extended and core radii

r.Gstr=0;
r.Grex=0;
r.Gmin=0;
oist=0;
oirx=0;

for i=1:k
    rad(i)=mnDa(i)+2*sdDa(i);
    rad2(i)=mdDa(i);
    volratio(i)=rad(i)/rad2(i);
    radm(i)=rad(i)*mass(i);
    radm2(i)=rad2(i)*mass(i);
    
    l=1;  
    for j=1:k
        if j~=i
            oist(l)=De(i,j)-(rad(i))-(mnDa(j)+2*sdDa(j));
            oirx(l)=De(i,j)-mdDa(i)-mdDa(j);
            l=l+1;
        end
    end
    
    r.oi_st(i)=min(oist);
    r.oi_rx(i)=min(oirx);
    r.oi_mn(i)=min(oist)/(mnDa(i)+2*sdDa(i));
    
    r.Gstr=r.Gstr+r.oi_st(i)*mass(i);
    r.Grex=r.Grex+r.oi_rx(i)*mass(i);
end

r.Gstr=r.Gstr/sum(radm);
r.Grex=r.Grex/sum(radm2);
r.Gmin=min(r.oi_mn);
r.volratio=volratio;

end

