function [ mm ] = multimod( data )
%MULTIMOD returns the number of dimensions in which multimodality was detected

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
% data: input dataset

% ----------- outputs ----------- 
% mm: number of dimensions with multimodality 

[M N]=size(data);
mm=0; %by default, mm is 0

for i=1:N
    [f,xi] = ksdensity(data(:,i));
    [val ind]=max(f);
    f=f/max(f);
    [pks,locs,w,p] = findpeaks(f,'MinPeakProminence',0.1);
    if length(pks)>1
        mm=mm+1;
    end
end

