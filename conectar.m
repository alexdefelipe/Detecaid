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

function varargout = conectar(varargin)
% CONECTAR MATLAB code for conectar.fig
%      CONECTAR, by itself, creates a new CONECTAR or raises the existing
%      singleton*.
%
%      H = CONECTAR returns the handle to a new CONECTAR or the handle to
%      the existing singleton*.
%
%      CONECTAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONECTAR.M with the given input arguments.
%
%      CONECTAR('Property','Value',...) creates a new CONECTAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before conectar_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to conectar_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help conectar

% Last Modified by GUIDE v2.5 07-Nov-2017 20:13:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @conectar_OpeningFcn, ...
                   'gui_OutputFcn',  @conectar_OutputFcn, ...
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


% --- Executes just before conectar is made visible.
function conectar_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to conectar (see VARARGIN)

% Choose default command line output for conectar
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes conectar wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = conectar_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function ip_Callback(hObject, eventdata, handles)
% hObject    handle to ip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ip as text
%        str2double(get(hObject,'String')) returns contents of ip as a double


% --- Executes during object creation, after setting all properties.
function ip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pass_Callback(hObject, eventdata, handles)
% hObject    handle to pass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pass as text
%        str2double(get(hObject,'String')) returns contents of pass as a double


% --- Executes during object creation, after setting all properties.
function pass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in conectar.
function conectar_Callback(hObject, eventdata, handles)
% hObject    handle to conectar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clave = get(handles.pass,'string')
connector('on',clave);
close
