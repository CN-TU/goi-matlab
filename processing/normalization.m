function [new norm] = normalization(data, type, inv, normi)
% NORMALIZATION performs data (de)normalization based on range, z-score
% quartile(0.25-0.75) or weight transformations

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
% type: 1:range, 2:z-score, 3:quartile
% inv: 0:norm, 1:denorm
% normi: parameters for denormalization if applicable

% ----------- outputs -----------
% new: (de)normalized dataset
% norm: parameters for posterior denormalization

if exist('normi')==0, normi=[];end
norm=normi;

if inv==0
    switch type
        case 1 % range [0,1]
            norm.min=min(data);
            norm.max=max(data);
            new=bsxfun(@minus, data, norm.min);
            aux=norm.max-norm.min;
            new=bsxfun(@rdivide, new, aux);

        case 2 % z-score
            [new,norm.mu,norm.sigma] = zscore(data);
            
        case 3 % 0.25-0.75 quantiles
            norm.th025=quantile(data,0.25);
            norm.th075=quantile(data,0.75);
            new=bsxfun(@minus, data, norm.th025);
            aux=norm.th075-norm.th025;
            new=bsxfun(@rdivide, new, aux); 
        
        case 4 % weight normalization
            [m,n]=size(data);
            norm.n=sqrt(n)*rms(data')';
            new=bsxfun(@rdivide, data, norm.n); 
            
        otherwise     
            new=data;       
    end
else
    switch type
        case 1 % range [0,1]
             aux=normi.max-normi.min;
             new=bsxfun(@times, data, aux);
             new=bsxfun(@plus, new, normi.min);  
             
        case 2 % z-score
             new=bsxfun(@times, data, normi.sigma);
             new=bsxfun(@plus, new, normi.mu);  
             
        case 3 % 0.25-0.75 quantiles
             aux=normi.th075-normi.th025;
             new=bsxfun(@times, data, aux);
             new=bsxfun(@plus, new, normi.th025); 
             
        case 4 % weight normalization
            [m,n]=size(data);
            new=bsxfun(@times, data, normi.n); 
             
        otherwise
            new=data;
    end
end
end



