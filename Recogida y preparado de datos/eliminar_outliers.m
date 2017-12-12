% This file is part of Detecaid.
% 
%     Detecaid is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     Detecaid is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.

%     You should have received a copy of the GNU General Public License
%     along with Detecaid.  If not, see <http://www.gnu.org/licenses/>.

function [dataset,targets] = eliminar_outliers(dataset,targets,criterio_corte)
%ELIMINAR_OUTLIERS Eliminar datos anómalos.
%   [dataset,targets] = eliminar_outliers(dataset,targets,criterio_corte)
%   elimina los outliers presentes en DATASET. DATASET tiene tantas filas
%   como observaciones y tantas columnas como parámetros. TARGETS es un
%   vector cuyas componentes indican la clase de la respectiva observación
%   en DATASET. CRITERIO_CORTE vale 1.5 para eliminar outliers moderados y 
%   3 para eliminar outliers extremos.

long = size(dataset,2);

for i=1:long
    for j=1:5
        clase_j=dataset(targets==j,:);
        targets_j=targets(targets==j);
        param = clase_j(:,i);
        segundo_percentil = prctile(param,[25 50]);
        tercer_percentil = prctile(param,[50 75]);
        rango_intercuartilico = tercer_percentil(2)-segundo_percentil(1);
        criterio_corte_bajo = segundo_percentil(1)-criterio_corte*rango_intercuartilico;
        criterio_corte_alto = tercer_percentil(2)+criterio_corte*rango_intercuartilico;
    
    posicion_outlier=(param<criterio_corte_bajo | param>criterio_corte_alto);
        clase_j=clase_j(~posicion_outlier,:);
        targets_j=targets_j(~posicion_outlier);
        
        dataset=dataset(targets~=j,:);
        dataset=[dataset;clase_j];
        
        targets=targets(targets~=j,:);
        targets=[targets;targets_j];
            
    
    end
        
end
end

