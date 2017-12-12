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


% Este archivo sirve para registrar la actividad del acelerómetro durante t
% segundos. Luego lo guarda en la carpeta Registros con un nombre que
% permite identificar la actividad registrada y el momento en el que se
% registró.

%% Especificar actividad
actividad = 'c';

%% Empezamos.
close all
clc
% Parámetros de registro
dibujar = 1;
t = 5; % Cada registro durará 5 segundos
%% Conecto con el movil
connector on esedede23;
%% Creamos la estructura que usará Matlab para leer los sensores
clear m
m = mobiledev;
%% Habilitamos el acelerómetro 
m.AccelerationSensorEnabled = 1;
%% Leemos durante X segundos
m.Logging = 1;
disp('Registrando...')
pause(t)
m.Logging = 0;
disp('Fin del registro')
m.AccelerationSensorEnabled = 0;
%% Recogemos los registros
[log, timestamp] = accellog(m);

%% Modulo calibrado
%Restamos la componente constante de la aceleración de la gravedad
%(repartida entre los 3 ejes)
mod_log = sqrt(log(:,1).^2+log(:,2).^2+log(:,3).^2)-9.8; 

%% Dibujamos si nos interesa
if dibujar == 1
    figure
    plot(timestamp,mod_log)
    title("Módulo")
    xlabel("Tiempo(s)")
    ylabel("Aceleración(m/s^2)")
    
%     figure
%     subplot(3,1,1); plot(timestamp,log(:,1))
%     title("Eje x")
%     xlabel("Tiempo(s)")
%     ylabel("Aceleración(m/s^2")
% 
%     subplot(3,1,2); plot(timestamp,log(:,2))
%     title("Eje y")
%     xlabel("Tiempo(s)")
%     ylabel("Aceleración(m/s^2)")
% 
%     subplot(3,1,3); plot(timestamp,log(:,3))
%     title("Eje z")
%     xlabel("Tiempo(s)")
%     ylabel("Aceleración(m/s^2)")
%     plot(timestamp,mod_log)
end

nombre_archivo = strcat(actividad,'_', string(datetime('now','format','ddMM_HH_mm_ss')));

cd 'Registros'
save(nombre_archivo,'log','timestamp')
cd ..