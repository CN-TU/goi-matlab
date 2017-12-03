function success = check_partition(labin,labout)
% CHECK_PARTITION compares two clustering partitions: % internal (labin) 
% and external (labout), and returns de degree of coincidence (success)

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
%   labin: labels of internal partition
%   labout: labels of external partition

% ----------- outputs -----------
%   success: degree of matching [0,1], '0': no match, '1': perfect match 

    ki=max(labin);
    ko=max(labout);
    k=max(ki,ko);
    for i=1:k
            Li(:,i)=(labin==i);
            Lo(:,i)=(labout==i);
    end 
    Li=double(Li);
    Lo=double(Lo);
    r=pdist2(Li',Lo');
    [v ind]=min(r);
    final=zeros(length(labin),1);
    for i=1:k
        final(labout==i)=ind(i);
    end
        success=sum((labin-final)==0)/length(labout); % rate of well-clustered objects
end

