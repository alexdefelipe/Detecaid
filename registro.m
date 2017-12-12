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

function varargout = registro(varargin)
% REGISTRO MATLAB code for registro.fig
%      REGISTRO, by itself, creates a new REGISTRO or raises the existing
%      singleton*.
%
%      H = REGISTRO returns the handle to a new REGISTRO or the handle to
%      the existing singleton*.
%
%      REGISTRO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGISTRO.M with the given input arguments.
%
%      REGISTRO('Property','Value',...) creates a new REGISTRO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before registro_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to registro_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help registro

% Last Modified by GUIDE v2.5 07-Nov-2017 21:45:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @registro_OpeningFcn, ...
    'gui_OutputFcn',  @registro_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before registro is made visible.
function registro_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to registro (see VARARGIN)

% Choose default command line output for registro
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes registro wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Añadir resto de archivos al search path
addpath('Recogida y preparado de datos')

% --- Outputs from this function are returned to the command line.
function varargout = registro_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in conectar.
function conectar_Callback(hObject, eventdata, handles)
% hObject    handle to conectar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
conectar()

% --- Executes on button press in registro_on.
function registro_on_Callback(hObject, eventdata, handles)
% hObject    handle to registro_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
load modelo
handles.modelo = trainedModel;

clear m
m = mobiledev;
m.AccelerationSensorEnabled = 1;
m.Logging = 1;

data = zeros(100,1);
%initialize plot
p = plot(data);
title("Módulo")
xlabel("Tiempo(s)")
ylabel("Aceleración(m/s^2)")
axis([0 100 0 120]);

handles.exit = 0;
handles.estado = 0;
guidata(hObject,handles);
pause(1)
medir = true;
myURL = 'https://detecaid.000webhostapp.com/index.php';
myURL_leer = 'https://detecaid.000webhostapp.com/leer_var.php';

while (handles.exit ~= 1)
    clear timestamp
    [a,timestamp] = accellog(m);
    mod_log = sqrt(a(:,1).^2+a(:,2).^2+a(:,3).^2);
    
    if length(a) > 100
        data = mod_log(end-99:end);
        timestamp = timestamp(end-99:end);
        
       if (medir==true)
           longitud1=length(mod_log);
           medir=false;
       end
       longitud2=length(mod_log);
       diferencia=longitud2-longitud1;
        if (diferencia>50)
            [yfit, ~] = predict(data, timestamp, handles);
            medir=true;
            if (yfit == 1)
                disp('¡CAÍDA DETECTADA!')
                response = webwrite(myURL,'caida','1');
                handles.estado = 1;
                guidata(hObject,handles);
                while(handles.estado == 1)
                    options = weboptions('Timeout',Inf);
                    handles.estado = str2double(webread(myURL_leer,options));     
                    guidata(hObject,handles);
                end
            end            
        else
            
        end         
    else
        data(1:length(mod_log)) = mod_log(:);
    end
    p.YData = data;
    drawnow
    handles = guidata(hObject);
    
end



% --- Executes on button press in registro_off.
function registro_off_Callback(hObject, eventdata, handles)
% hObject    handle to registro_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.exit = 1;
handles.m.Logging = 0;
handles.m.AccelerationSensorEnabled = 0;
disp('Se ha detenido el registro')
guidata(hObject, handles);


