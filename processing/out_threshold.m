function [ th ] = out_threshold( data, core )
% OUT_THRESHOLD calculates outlier detection thresholds based on detecting
% steps in the increment of intra-distances in the external cluster layers 

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
% data: array with cluster intra-distances
% core: percentage (0,1] included in the internal cluster volume, 
%       if '0' -> "core vol." is used (based on median of distances)
%       if '-1' -> "relaxed vol." is used (based on mean + 2std of dist)

% ----------- outputs -----------
% th: intra-distance threshold

x=1:length(data);
ly=length(data);
y=sort(data);

if core==0
    core=0.5; % core volume
elseif core==-1
    lambda=mean(y)+2*std(y); % extended volume
    ind=find(y>lambda);
    core=length(1:ind(1))/length(data);
end

ya=y(1:(ly-1));
yb=y(2:ly);
dy=yb-ya;
c=round(core*ly)-1;
th_core=max(dy(1:c))+5*mean(dy(1:c));

dytail=dy;
dytail(1:c)=[];

x_steps = x(abs(dy) > th_core);
ind=find(x_steps>th_core);

if isempty (ind)
    th=max(y);
else
    th=y(x_steps(ind(1)));
end

end

