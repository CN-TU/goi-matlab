function plotting_vi (vi)
% PLOTTING_VI displays results (validity indices) for tests carried out
% with the "clustperf_comp.m" tool

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
% vi: structure containing arrays of validity indices, obtained from
%     the "clustperf_comp.m" tool
    
    x=1:length(vi.S);
    
    figure(1)
    subplot(3,1,1), plot(x,vi.S,'-*')
    hold on; [v i]=max(vi.S); plot(i,v,'o');
    title('Silhouette (S) - Max')
    subplot(3,1,2), plot(x,vi.CH,'-*')
    hold on; [v i]=max(vi.CH); plot(i,v,'o');
    title('Calinski-Harabasz (CH) - Max')
    subplot(3,1,3), stem(vi.featval,'-*')
    title('Feature Value')
    grid on; grid minor
    
    figure(2)
    subplot(3,1,1), plot(x,vi.PC,'-*')
    hold on; [v i]=max(vi.PC); plot(i,v,'o');
    title('Partition Coefficient (PC) - Max')
    subplot(3,1,2), plot(x,vi.CE,'-*')  
    hold on; [v i]=min(vi.CE); plot(i,v,'o');
    title('Classification Entropy (CE) - Min')
    subplot(3,1,3), plot(x,vi.XB,'-*')
    hold on; [v i]=min(vi.XB); plot(i,v,'o');
    title('Xie and Beni Index (XB) - Min')
    
    figure(4)
    subplot(3,1,1), plot(x,vi.DB,'-*')
    hold on; [v i]=min(vi.DB); plot(i,v,'o');
    title('Davies-Bouldin Index (DB) - Min')
    subplot(3,1,2), plot(x,vi.DI,'-*')
    hold on; [v i]=max(vi.DI); plot(i,v,'o');
    title('Dunn Index (DI) - Max')
    subplot(3,1,3), stem(vi.featval,'-*')
    title('Feature Value')
    grid on; grid minor

    figure(5)
    subplot(3,1,1), plot(x,vi.Gs,'-*')
    hold on; [v i]=max(vi.Gs); plot(i,v,'o');
    title('Overlapping Index Strict (Gstr) - Max')
    subplot(3,1,2), plot(x,vi.Gr,'-*')
    hold on; [v i]=max(vi.Gr); plot(i,v,'o');
    title('Overlapping Index Relaxed (Grex) - Max')
    subplot(3,1,3), plot(x,vi.Gm,'-*')
    hold on; [v i]=max(vi.Gm); plot(i,v,'o');
    title('Overlapping Index Minimum (Gmin) - Max')

end