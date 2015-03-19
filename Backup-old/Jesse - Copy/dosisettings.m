function varargout = dosisettings(varargin)
% DOSISETTINGS MATLAB code for dosisettings.fig
%      DOSISETTINGS, by itself, creates a new DOSISETTINGS or raises the existing
%      singleton*.
%
%      H = DOSISETTINGS returns the handle to a new DOSISETTINGS or the handle to
%      the existing singleton*.
%
%      DOSISETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DOSISETTINGS.M with the given input arguments.
%
%      DOSISETTINGS('Property','Value',...) creates a new DOSISETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dosisettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dosisettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dosisettings

% Last Modified by GUIDE v2.5 25-Apr-2014 17:07:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dosisettings_OpeningFcn, ...
                   'gui_OutputFcn',  @dosisettings_OutputFcn, ...
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


    function set_diodes()
        global guiVal;
        if (~isempty(guiVal))
            if (guiVal.can_start_fitting == 1)
                chk1 = findobj( 'Tag' , 'check_fdpm' );
                chk2 = findobj( 'Tag' , 'check_spec' );
                % % clearing the "old" list of available diodes
                set( chk1(1:6), 'Visible', 'off', 'Value', 0 ); %changed i to 1 byh 3/3
                set( chk2(1:6), 'Visible', 'off', 'Value', 0 ); %
                
                index = 1;
                %for i = guiVal.num_of_diodes:-1:1           %% making the used diodes visible
                for i = 1:guiVal.num_of_diodes
                    val = num2str( guiVal.list_of_diodes(index) );
                    fval = guiVal.use_diodes_fdpm(i);
                    sval = guiVal.use_diodes_spec(i);
                    set( chk1(i), 'Visible', 'on', 'Value', fval, 'String', val );
                    set( chk2(i), 'Visible', 'on', 'Value', sval, 'String', val );
                    index = index + 1;
                end
            end
        end
    

    function spec_available()
        global guiVal;
        if(guiVal.specAvailable==0)
            fsc=findobj('Tag','check_fitspec');
            set(fsc,'Enable','off');
        else
            fsc=findobj('Tag','check_fitspec');
            set(fsc,'Enable','on','Value',guiVal.doSpecFit);
        end
    

% --- Executes just before dosisettings is made visible.
function dosisettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dosisettings (see VARARGIN)
global guiVal;
set_diodes();
spec_available();

physiofdpm = findobj('Tag','check_physio_fdpm');
set(physiofdpm,'Value',guiVal.doPhysioFdpmFit);
physiospec = findobj('Tag','check_physio_spec');
set(physiospec,'Value',guiVal.doPhysioSpecFit);


% global guiVal;
% if (~isempty(guiVal))
% if (guiVal.can_start_fitting == 1)
% chk1 = findobj( 'Tag' , 'check_fdpm' );
%  chk2 = findobj( 'Tag' , 'check_spec' );
% % % clearing the "old" list of available diodes
%  set( chk1(1:6), 'Visible', 'off', 'Value', 0 ); %changed i to 1 byh 3/3
%  set( chk2(1:6), 'Visible', 'off', 'Value', 0 ); %
% 
%  index = 1;
%  %for i = guiVal.num_of_diodes:-1:1           %% making the used diodes visible
%   for i = 1:guiVal.num_of_diodes 
%      val = num2str( guiVal.list_of_diodes(index) );
%      set( chk1(i), 'Visible', 'on', 'Value', 1, 'String', val );
%      set( chk2(i), 'Visible', 'on', 'Value', 1, 'String', val );
%      index = index + 1;
%   end
% end
% end
% Choose default command line output for dosisettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dosisettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dosisettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in check_fdpm.
function check_fdpm_Callback(hObject, eventdata, handles)
global guiVal;
val = get( gcbo, 'Value' );
% disp( val );
if( val == 0 )
    set( findobj( 'Tag', 'check_spec', 'String', get( gcbo, 'String' ) ), 'Value', val );
end
guiVal.list_of_diodes = zeros( 1, guiVal.num_of_diodes );
guiVal.use_diodes_fdpm = [];         %%can you think of a better to do this?
guiVal.use_diodes_spec = [];         %%preparing the boolean list of which doides to fit for fdpm/spectroscopy
chk2 = findobj( 'Tag', 'check_fdpm' );
chk  = findobj( 'Tag', 'check_spec' );
guiVal.fdpm_diodes=[];
guiVal.use_diodes_spec=[];
for i = 1:guiVal.num_of_diodes;
    idx = guiVal.num_of_diodes - i + 1; %traverse the list backwards
    guiVal.list_of_diodes( i )  = str2num( get( chk(i), 'String') );
    guiVal.use_diodes_fdpm( i ) = get(chk2(i), 'Value' );
    if(guiVal.use_diodes_fdpm(i)==1)
        guiVal.fdpm_diodes=[guiVal.fdpm_diodes guiVal.list_of_diodes(i)];
        temp=get( chk(i), 'Value' );
        guiVal.use_diodes_spec=[guiVal.use_diodes_spec temp];
    end
    %guiVal.use_diodes_spec( idx ) = get( chk(idx), 'Value' );
end

guiVal.numDiodes_fdpm = sum( guiVal.use_diodes_fdpm );
guiVal.numDiodes_spec = sum( guiVal.use_diodes_spec );



% --- Executes on button press in check_spec.
function check_spec_Callback(hObject, eventdata, handles)
global guiVal;
val = get( gcbo, 'Value' );
if( val )
    set( findobj( 'Tag', 'check_fdpm', 'String', get( gcbo, 'String' ) ), 'Value', val );
end
guiVal.list_of_diodes = zeros( 1, guiVal.num_of_diodes );
guiVal.use_diodes_fdpm = [];         %%can you think of a better to do this?
guiVal.use_diodes_spec = [];         %%preparing the boolean list of which doides to fit for fdpm/spectroscopy
chk2 = findobj( 'Tag', 'check_fdpm' );
chk  = findobj( 'Tag', 'check_spec' );
guiVal.fdpm_diodes=[];
guiVal.use_diodes_spec=[];
for i = 1:guiVal.num_of_diodes;
    idx = guiVal.num_of_diodes - i + 1; %traverse the list backwards
    guiVal.list_of_diodes( i )  = str2num( get( chk(i), 'String') );
    guiVal.use_diodes_fdpm( i ) = get(chk2(i), 'Value' );
    if(guiVal.use_diodes_fdpm(i)==1)
        guiVal.fdpm_diodes=[guiVal.fdpm_diodes guiVal.list_of_diodes(i)];
        temp=get( chk(i), 'Value' );
        guiVal.use_diodes_spec=[guiVal.use_diodes_spec temp];
    end
%     guiVal.list_of_diodes( i )  = str2num( get( chk(i), 'String') );
%     guiVal.use_diodes_fdpm( idx ) = get(chk2(idx), 'Value' );
%     guiVal.use_diodes_spec( idx ) = get( chk(idx), 'Value' );
end

guiVal.numDiodes_fdpm = sum( guiVal.use_diodes_fdpm );
guiVal.numDiodes_spec = sum( guiVal.use_diodes_spec );


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
global guiVal;
guiVal.sethandle=0;


% --- Executes on button press in check_fitspec.
function check_fitspec_Callback(hObject, eventdata, handles)
% hObject    handle to check_fitspec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guiVal;
guiVal.doSpecFit = get(hObject,'Value');
% Hint: get(hObject,'Value') returns toggle state of check_fitspec


% --- Executes on button press in check_physio_spec.
function check_physio_spec_Callback(hObject, eventdata, handles)
% hObject    handle to check_physio_spec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guiVal;
guiVal.doPhysioSpecFit = get(hObject,'Value');
% Hint: get(hObject,'Value') returns toggle state of check_physio_spec


% --- Executes on button press in check_physio_fdpm.
function check_physio_fdpm_Callback(hObject, eventdata, handles)
% hObject    handle to check_physio_fdpm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guiVal;
guiVal.doPhysioFdpmFit = get(hObject,'Value');
% Hint: get(hObject,'Value') returns toggle state of check_physio_fdpm



function lowfreqrange_Callback(hObject, eventdata, handles)
% hObject    handle to lowfreqrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lowfreqrange as text
%        str2double(get(hObject,'String')) returns contents of lowfreqrange as a double
global guiVal;
guiVal.lowFreq=str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function lowfreqrange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowfreqrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global guiVal;
set(hObject,'String',num2str(guiVal.lowFreq));



function highfreqrange_Callback(hObject, eventdata, handles)
% hObject    handle to highfreqrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of highfreqrange as text
%        str2double(get(hObject,'String')) returns contents of highfreqrange as a double
global guiVal;
guiVal.highFreq=str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function highfreqrange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to highfreqrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global guiVal;
set(hObject,'String',num2str(guiVal.highFreq));