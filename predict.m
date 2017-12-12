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

function [yfit,pos_picos_max] = predict(mod_log, timestamp, handles)
%PREDICT Predecir si el registro presentado corresponde o no a una caída.
%   [yfit,pos_picos_max] = predict(mod_log, timestamp, handles) busca el
%   pico máximo en MOD_LOG, calcula sus parámetros y se los pasa al modelo
%   que debe de encontrarse en el directorio actual. TIMESTAMP es el lapso
%   de tiempo en el que ha transcurrido MOG_LOG. HANDLES se usa para pasar
%   variables dentro de una GUI en Matlab.

%% Calculamos los parámetros
% Obtengo al amplitud, la duración en muestras y la posición de los
% picos ordenados de mayor a menor por la amplitud
[peaks,pos,w,~]  = findpeaks(mod_log,'SortStr','descend');

% Me quedo con el máximo
amp_picos_max = peaks(1);
pos_picos_max = pos(1);
w_picos_max = w(1);

% Calculo la duración del máximo
w_lado = ceil(w_picos_max/2);
t_ini = timestamp(pos_picos_max-w_lado);
t_fin = timestamp(pos_picos_max+w_lado);
dur = t_fin-t_ini;

% Calculo el punto de inicio y de fin de la curva que contiene al pico
tamano=size(mod_log,1);
punto_ant = pos(1)-ceil(w(1));
punto_post = pos(1)+ceil(w(1));
if (punto_ant < round(tamano/5*0.3)+1)
    amp_ant = mean(mod_log(1:punto_ant));
else
    amp_ant = mean(mod_log(punto_ant-round(tamano/5*0.3):punto_ant));
end

if (punto_post > tamano-round(tamano/5*2-1))
    if  (punto_post > tamano-round(tamano/5*1-1))
        amp_post = mean(mod_log(punto_post:end));
    else
        amp_post = mean(mod_log(punto_post+round(tamano/5*1):end));
    end
else
    amp_post = mean(mod_log(punto_post+round(tamano/5*1):punto_post+round(tamano/5*2)));
end

amp_ant=abs(amp_ant-9.8); %El parámetro de la amplitud anterior al pico tendrá un valor menor cuanto 
                          % más próximo sea el valor a la aceleración de la gravedad (9.8 m/s^2)

data = [amp_picos_max dur amp_ant amp_post];

%% Pasamos los parámetros la modelo
yfit = handles.modelo.predictFcn(data);


end

