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

% Este archivo recorre uno a uno los registros guardados en la carpeta
% Registros y de todos ellos calcula los parámetros del pico máximo. Al
% final genera una matriz llamada inputs con toda esta información, que
% además contiene una columna con los targets.

close all
representar = true;
%% Obtendo los *.mat presentes en directorio actual
rutaAbs = fullfile([pwd '\Registros'], '*.mat'); % ruta absoluta donde se encuentran los registros
archivos = dir(rutaAbs);

%% Inicializando variables
amp_picos_max = zeros(size(archivos,1),1);
pos_picos_max = zeros(size(archivos,1),1);
w_picos_max = zeros(size(archivos,1),1);
w_lado = zeros(size(archivos,1),1);
dur = zeros(size(archivos,1),1);
amp_ant= zeros(size(archivos,1),1);
amp_post= zeros(size(archivos,1),1);

%% Cambiamos el directorio a Registros y calculamos los parámetros sobre cada registro
cd 'Registros'
target=zeros(size(archivos,1),1);
for i = 1:size(archivos,1)
    % Cargo un archivo
    load(archivos(i).name);
    mod_log = abs(sqrt(log(:,1).^2+log(:,2).^2+log(:,3).^2)-9.8);
    % Obtengo al amplitud, la duración en muestras y la posición de los
    % picos ordenados de mayor a menor por la amplitud
    [peaks,pos,w,~]  = findpeaks(mod_log,'SortStr','descend');
    % Me quedo con el máximo
    amp_picos_max(i) = peaks(1);
    pos_picos_max(i) = pos(1);
    w_picos_max(i) = w(1);
    % Calculo la duración del máximo
    w_lado = ceil(w_picos_max(i)/2);
    t_ini = timestamp(pos_picos_max(i)-w_lado);
    t_fin = timestamp(pos_picos_max(i)+w_lado);
    dur(i) = t_fin-t_ini;
    % Calculo el punto de inicio y de fin de la curva que contiene al pico
    tamano=size(mod_log,1);
    punto_ant = pos(1)-ceil(w(1));
    punto_post = pos(1)+ceil(w(1));
    if (punto_ant < round(tamano/5*0.3)+1) 
        amp_ant(i) = mean(mod_log(1:punto_ant));
    else
        amp_ant(i) = mean(mod_log(punto_ant-round(tamano/5*0.3):punto_ant));
    end
    
     if (punto_post > tamano-round(tamano/5*2-1))
        if  (punto_post > tamano-round(tamano/5*1-1))
         amp_post(i) = mean(mod_log(punto_post:end));
        else
        amp_post(i) = mean(mod_log(punto_post+round(tamano/5*1):end));
        end
     else
     amp_post(i) = mean(mod_log(punto_post+round(tamano/5*1):punto_post+round(tamano/5*2)));
     end
  
% Asignamos una etiqueta a cada uno de los registros (1: caida, 0: no caida)   
    if (startsWith(archivos(i).name,'c')||startsWith(archivos(i).name,'C'))
    target(i)=1;
    else
    target(i)=0;   
    end
    
% Representamos el módulo de cada uno de los registros       
    if (representar==true)
    figure
    plot(mod_log)
%     hold on
%     plot(punto_ant,amp_ant(i),'rx',punto_post,amp_post(i),'rx')
    title(archivos(i).name)
    end
end

amp_ant = abs(amp_ant-9.8); % El parámetro de la amplitud anterior al pico tendrá un valor menor cuanto 
                          % más próximo sea el valor a la aceleración de la gravedad (9.8 m/s^2)
%% Guardamos
data = [amp_picos_max dur amp_ant amp_post target ];
cd ..
save('inputs.mat','data');