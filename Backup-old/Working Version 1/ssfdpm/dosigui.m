function varargout = dosigui(varargin)
% DOSIGUI M-file for dosigui.fig
%      DOSIGUI, by itself, creates a new DOSIGUI or raises the existing
%      singleton*.
%
%      H = DOSIGUI returns the handle to a new DOSIGUI or the handle to
%      the existing singleton*.
%
%      DOSIGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DOSIGUI.M with the given input arguments.
%
%      DOSIGUI('Property','Value',...) creates a new DOSIGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dosigui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dosigui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dosigui

% Last Modified by GUIDE v2.5 12-May-2014 11:23:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dosigui_OpeningFcn, ...
                   'gui_OutputFcn',  @dosigui_OutputFcn, ...
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


% --- Executes just before dosigui is made visible.
function dosigui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dosigui (see VARARGIN)

% Choose default command line output for dosigui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global guiVal;
guiVal.sethandle=0;
guiVal.lowFreq=50;
guiVal.highFreq=400;
guiVal.sphereList={};

% UIWAIT makes dosigui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% Add ssfdpmPro to path (and warn if already in there)
current_path = path;
if ~isempty(strfind(current_path,'ssfdpmPro'))
    uiwait(msgbox('WARNING: ssfdpmPRO is already in the MATLAB path. You should check that it matches the expected version.','Check Path','modal'));
end
pathroot=which('dosigui.m');
pathroot=pathroot(1:end-9);
path(path,[pathroot]);
path(path,[pathroot '\guifunctions']);
path(path,[pathroot '\ssfdpmPro']);
path(path,[pathroot '\ssfdpmPro\bw']);
path(path,[pathroot '\ssfdpmPro\bw\specdata']);
path(path,[pathroot '\ssfdpmPro\chromophore_files']);
path(path,[pathroot '\ssfdpmPro\models']);
path(path,[pathroot '\ssfdpmPro\phantoms']);


% --- Outputs from this function are returned to the command line.
function varargout = dosigui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loaddir.
function loaddir_Callback(hObject, eventdata, handles)
% hObject    handle to loaddir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guiVal;
tempdir = uigetdir;
id = findobj( 'Tag', 'txtDataDir' );
if(tempdir~=0)
    set( id, 'String', tempdir);
    guiVal.dataDir=tempdir;
    txtDataDir_Callback( id, eventdata, handles);
end

% --- Executes on selection change in lstFiles.
function lstFiles_Callback(hObject, eventdata, handles)
% hObject    handle to lstFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lstFiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstFiles
global guiVal;

list = get( gcbo, 'String' );
guiVal.prefixList = list( get(gcbo,'Value') )';

% --- Executes during object creation, after setting all properties.
function lstFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lstPhantoms.
function lstPhantoms_Callback(hObject, eventdata, handles)
% hObject    handle to lstPhantoms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lstPhantoms contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstPhantoms
global guiVal;

list = get( gcbo, 'String' );
guiVal.phantomList = list( get(gcbo, 'Value') )';


% --- Executes during object creation, after setting all properties.
function lstPhantoms_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstPhantoms (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lstSpheres.
function lstSpheres_Callback(hObject, eventdata, handles)
% hObject    handle to lstSpheres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns lstSpheres contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lstSpheres
global guiVal;
list = get( gcbo, 'String' );
guiVal.sphereList = list( get(gcbo, 'Value') );

% --- Executes during object creation, after setting all properties.
function lstSpheres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstSpheres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fileall.
function fileall_Callback(hObject, eventdata, handles)
% hObject    handle to fileall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guiVal;

prefixes = findobj( 'Tag', 'lstFiles' );
list=get(prefixes,'String');
set(prefixes,'Value',[1:size(list,1)]);
guiVal.prefixList=list(get(prefixes,'Value'))';

% --- Executes on button press in phantomall.
function phantomall_Callback(hObject, eventdata, handles)
% hObject    handle to phantomall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guiVal;

phantoms = findobj( 'Tag', 'lstPhantoms' );
list=get(phantoms,'String');
set(phantoms,'Value',[1:size(list,1)]);
guiVal.phantomList=list(get(phantoms,'Value'))';


function txtDataDir_Callback(hObject, eventdata, handles)
% hObject    handle to txtDataDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtDataDir as text
%        str2double(get(hObject,'String')) returns contents of txtDataDir as a double
global guiVal;

id=findobj('Tag','txtDataDir');
guiVal.dataDir = get( id, 'String' );

[ temp, numOfChars ] = size( guiVal.dataDir );
if ~isequal( guiVal.dataDir( numOfChars ), '\' )
    guiVal.dataDir( numOfChars + 1 ) = '\';
end

guiVal.rootDir = guiVal.dataDir;

%%%RETRIEVEING LIST OF PATIENTS!!!!!
try,
    cd( guiVal.dataDir );
    temp = dir( '*' );
catch,
    msgbox( 'You have entered an invalid directory', 'Data Directory' , 'modal' );
end

lst = {};
lst = { temp.name };
lst = lst( 3:length(lst) );

if isequal( lst{ length(lst) }, 'PROCESSED' )
    lst = lst( 1: length(lst) -1 );
end

guiVal.private.listOfPatients = lst;
id = findobj( 'Tag', 'popPatientID' );
set( id, 'String', lst, 'Visible', 'on' );

popPatientID_Callback( id, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function txtDataDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtDataDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pshStart.
function pshStart_Callback(hObject, eventdata, handles)
% hObject    handle to pshStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guiVal;
id = findobj( 'Tag', 'txtDataDir' );
txtDataDir_Callback( id, eventdata, handles);


function txtPrefix_Callback(hObject, eventdata, handles)
% hObject    handle to txtPrefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtPrefix as text
%        str2double(get(hObject,'String')) returns contents of txtPrefix as a double


% --- Executes during object creation, after setting all properties.
function txtPrefix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPrefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popDates.
function popDates_Callback(hObject, eventdata, handles)
% hObject    handle to popDates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popDates contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popDates
global guiVal;
zzz = 'zzzz';   tis = '-tis';   sph = 'sph';    phantom = 'ph'; %string constants that will be used in this function

index = get( findobj( 'Tag' ,'popDates' ) , 'Value' );
guiVal.date = guiVal.private.listOfDates{ index };%%skip 2 becuase first two directories are '.' and '..'
guiVal.dateindex=index;
cd( [ guiVal.dataDir guiVal.patientID '\' guiVal.date ] );

guiVal.consolidated_data = determine_old_system( cd ); %determining which filiing system was used. New/Consolidated OR old

%%GET LIST OF MEASUREMENT FILES in guiVal.dataDir
temp = dir( '*.asc' );  files = {temp.name};    array=files;
if length( array ) == 0
    msgbox( 'There is no data in this directory!!!', 'No Data', 'modal' );
    return;
end

% initializing the different lists that will be utilized
guiVal.ave.none  = {}; guiVal.ave.pre =  {}; guiVal.ave.post = {};
guiVal.base_list = {}; guiVal.phantom_list_base = {}; guiVal.measurement_list_base = {};    
guiVal.sph_list_base = {};

%%determine which source was used!!!
guiVal.source = find_source( 'sources.txt', array );


%%SEPARATE THE LIST INTO MEASUREMENTS, PHANTOM, AND SPHERE FILES
[ mlist, plist, slist,blist,alist ] = separate_base_list_filter( array );

%% phantom analysis to be finished - look at differences byh 20120502
% for i=1:size(plist,2)
%     phfile=strcat(guiVal.rootDir,'\',guiVal.patientID,'\',guiVal.date,'\',plist{i});
%     dat(i)=readFDPMData(phfile);
% end
% figure(5);
% for a=1:dat(1).nDiodes
%     subplot( dat(1).nDiodes, 2, 1 + 2*(a-1));
%     for b=1:size(plist,2)
%         plot(dat(b).freq,dat.AC);
%         hold on
%     end
%     subplot( dat(1).nDiodes, 2, 2 + 2*(a-1));
%     for b=1:size(plist,2)
%         plot(dat(b).freq,dat.phase);
%         hold on
%     end
% end

[ rep, none, ave ] = getMeasurementList( mlist );
mlist = validate_list( mlist, cd );

% % REMOVE SOURCE NAME FROM LISTS
guiVal.phantom_list_base     = remove_source( plist, guiVal.source );
guiVal.blist     = remove_source( blist, guiVal.source );
guiVal.alist     = remove_source( alist, guiVal.source );
guiVal.phantom_list_base     = remove_source( guiVal.phantom_list_base, tis );
guiVal.measurement_list_base = none;%remove_source( mlist, guiVal.source );
guiVal.sph_list_base         = remove_source( slist, guiVal.source );

if( isempty(plist) )
    msgbox( ['There are no Phantom Files for the data taken on ' guiVal.date ' for patient ' guiVal.patientID], ...
        'Phantom Files', 'modal' );
    return;
end

guiVal.phantomList = guiVal.phantom_list_base;
guiVal.ave.none    = none;%guiVal.measurement_list_base;
guiVal.ave.post    = guiVal.ave.none;
guiVal.ave.pre     = ave;

reps = {};
for i = 1:rep+1      %generate a list of number {0...N_REP} so the user can choose how many repetitions they want to fit.
    reps{i} = num2str(i-1);
end

% guiVal.n_rep = 0;
% set( findobj( 'Tag', 'popRepetitions' ), 'String', reps, 'Value', guiVal.n_rep + 1, 'Visible', 'on' );

prefixes = guiVal.ave.none;      phantoms = guiVal.phantom_list_base;

if ~isempty( prefixes ) && isequal( prefixes( length(prefixes) ), {zzz} )
    prefixes( length(prefixes) ) = '';
elseif length( phantoms ) == 0
    phantoms( length(phantoms) ) = '';
elseif isequal( phantoms(length(phantoms) ), {zzz} )
    phantoms( length(phantoms) ) = '';
end

guiVal.spec.norm = {};  guiVal.spec.sub_black = {}; guiVal.spec.sub_black_norm = {};

[ guiVal.spec.norm, guiVal.spec.sub_black, guiVal.spec.sub_black_norm ] = separateSpectroscopy( guiVal.sph_list_base );

guiVal.spec.norm = unique( guiVal.spec.norm );
if isempty( guiVal.spec.norm ) || isempty( guiVal.spec.norm{1} )
    guiVal.spec.norm = guiVal.spec.norm(2:length(guiVal.spec.norm));
end

asc = 'asc';                %cropping the measurement names
guiVal.spec.sub_black_norm = remove_source( guiVal.spec.sub_black_norm, asc );
guiVal.spec.sub_black = remove_source( guiVal.spec.sub_black, asc );
guiVal.spec.norm = remove_source( guiVal.spec.norm, asc );

%%displaying measurements on the GUI
prefixes=sort_nat(prefixes);
guiVal.prefixList = prefixes(1); 
guiVal.phantomList = phantoms(1);
guiVal.excludedMeasurements = {}; 
if(~isempty(guiVal.spec.norm))
    guiVal.sphereList=guiVal.spec.norm(1);
    sph = findobj( 'Tag', 'lstSpheres' );       set( handles.lstSpheres, 'String', guiVal.spec.norm, 'Value', 1);
    %% displaying Spectroscopy measurements on the GUI
    sph = findobj( 'Tag', 'lstSpheres' );       set( sph, 'String', guiVal.spec.norm,      'Value', 1, 'Visible', bool_to_on_off( length( guiVal.spec.norm      ) ) );
    guiVal.spec.white = guiVal.spec.norm{1};
    guiVal.doSpecFit=1;
    guiVal.specAvailable=1;
else
    guiVal.doSpecFit=0;
    guiVal.specAvailable=0;
    sph = findobj( 'Tag', 'lstSpheres' );       set( sph,  'Visible', bool_to_on_off(0) );
end

pfx = findobj( 'Tag', 'lstFiles' );         set( handles.lstFiles   , 'String', prefixes, 'Value', 1 );
pht = findobj( 'Tag', 'lstPhantoms' );      set( handles.lstPhantoms, 'String', phantoms, 'Value', 1 );

gs=findobj('Tag','menuSettings');
set(gs,'Enable','on');

%blk = findobj( 'Tag', 'popSpecBlack' );     %set( blk, 'String', guiVal.spec.sub_black, 'Value', 1, 'Visible', bool_to_on_off( length( guiVal.spec.sub_black ) ) );
%blk_norm = findobj( 'Tag', 'popSpecBlackWhite' );
%set( blk_norm, 'String', guiVal.spec.sub_black_norm, 'Value', 1, 'Visible', bool_to_on_off( length( guiVal.spec.sub_black_norm ) ) );

%set( handles.chkSpecNormailization, 'Value', 1 );   set( handles.chkSpecSubtractBlack,  'Value', 0 );   set( handles.chkSubtractBlackNormalization, 'Value', 1 );
%guiVal.spec.opt.normalization   = 1;	            guiVal.spec.opt.subtract_black  = 0;	            guiVal.spec.opt.sub_black_norm  = 1;
%chkSubtractBlackNormalization_Callback(h, eventdata, handles, varargin);
%chkSpecNormailization_Callback(h, eventdata, handles, varargin);

% if isempty(guiVal.spec.norm) && isempty(guiVal.spec.sub_black) && isempty(guiVal.spec.sub_black_norm)
%     guiVal.specOn = 0;      %if there are no spectroscopy file, then don't even try to fit the spectroscopy.
%     set( handles.tglFitSpec, 'Value', 0, 'String', 'No Spectroscopy' );
%     tglFitSpec_Callback( h, eventdata, handles, varargin );
% end

%the method for figuring out which diodes were used differs between the old & new filing systems.
% if guiVal.consolidated_data          %new filing system
%     guiVal.list_of_diodes = sort( getDiodes3( cd, guiVal.source ) );
% else                                 %old filiing system
%     guiVal.list_of_diodes = sort( getDiodes2( cd ) );
% end
%
guiVal.list_of_diodes = sort(getDiodes(cd,guiVal.source));
guiVal.num_of_diodes = length( guiVal.list_of_diodes );
guiVal.numDiodes_fdpm = guiVal.num_of_diodes;
guiVal.numDiodes_spec = guiVal.num_of_diodes;

guiVal.fdpm_diodes = guiVal.list_of_diodes;
guiVal.use_diodes_fdpm=ones(1,guiVal.num_of_diodes);
guiVal.use_diodes_spec=ones(1,guiVal.num_of_diodes);

guiVal.doPhysioFdpmFit=0;
guiVal.doPhysioSpecFit=1;

chk=findobj('Tag','uipanel6');
set(chk,'Visible','on');

%set_diodes();
% % guiVal.spec.rho = determineRho( cd );       %%determining the source-detctor separation...
% 
%  chk1 = findobj( 'Tag' , 'check_fdpm' );
%  chk2 = findobj( 'Tag' , 'check_spec' );
% % % clearing the "old" list of available diodes
%  set( chk1(1:6), 'Visible', 'off', 'Value', 0 ); %changed i to 1 byh 3/3
%  set( chk2(1:6), 'Visible', 'off', 'Value', 0 ); %
% 
%  index = 1;
%   for i = 1:guiVal.num_of_diodes 
%      val = num2str( guiVal.list_of_diodes(index) );
%      set( chk1(i), 'Visible', 'on', 'Value', 1, 'String', val );
%      set( chk2(i), 'Visible', 'on', 'Value', 1, 'String', val );
%      index = index + 1;
%  end
if(guiVal.sethandle~=0)
    close(guiVal.sethandle);
    guiVal.sethandle=0;
end
guiVal.can_start_fitting = 1;
% check_spec_Callback(findobj('Tag','check_spec'),eventdata,handles);

% --- Executes during object creation, after setting all properties.
function popDates_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popDates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popPatientID.
function popPatientID_Callback(hObject, eventdata, handles)
% hObject    handle to popPatientID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popPatientID contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popPatientID
global guiVal;

id = findobj( 'Tag' ,'popPatientID' );
index = get( id, 'Value' );
guiVal.patientID = char( guiVal.private.listOfPatients( index ) ); 
dates = findobj( 'Tag', 'popDates' );
try,
    cd( [guiVal.dataDir guiVal.patientID] );
    temp = dir( '*.' );
    set( dates, 'String', '', 'Value', 1, 'Visible', 'off' )
catch,
    msgbox( 'You must choose a valid Patient ID', 'Patient ID', 'modal' );
    set( dates, 'String', '', 'Value', 1, 'Visible', 'off' );
    return;
end

guiVal.private.listOfDates = getSubDirectories( cd );
if isempty( guiVal.private.listOfDates )
    msgbox( 'You must choose a valid Patient ID', 'Patient ID', 'modal' );
    set( dates, 'String', '', 'Value', 1, 'Visible', 'off' );
    return;
end

set( dates, 'String', guiVal.private.listOfDates, 'Visible', 'on', 'Value', 1 );
popDates_Callback( findobj( 'Tag', 'popDates') , eventdata, handles);


% --- Executes during object creation, after setting all properties.
function popPatientID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popPatientID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pshFit.
function pshFit_Callback(hObject, eventdata, handles)
% hObject    handle to pshFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guiVal;  %clc;

if( guiVal.can_start_fitting==0 )
    msgbox( 'You must enter more Patient Data before fitting this data set', 'SSFDPM', 'modal' );
    return;
end
prefixhandle = findobj( 'Tag', 'txtPrefix' );
guiVal.filePrefix=get(prefixhandle,'String');
%dosguiscript( guiVal);
%guiVal
dosiguiscript


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
for i = 1:guiVal.num_of_diodes;
    idx = guiVal.num_of_diodes - i + 1; %traverse the list backwards
    guiVal.list_of_diodes( i )  = str2num( get( chk(i), 'String') );
    guiVal.use_diodes_fdpm( idx ) = get(chk2(idx), 'Value' );
    guiVal.use_diodes_spec( idx ) = get( chk(idx), 'Value' );
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
for i = 1:guiVal.num_of_diodes;
    idx = guiVal.num_of_diodes - i + 1; %traverse the list backwards
    guiVal.list_of_diodes( i )  = str2num( get( chk(i), 'String') );
    guiVal.use_diodes_fdpm( idx ) = get(chk2(idx), 'Value' );
    guiVal.use_diodes_spec( idx ) = get( chk(idx), 'Value' );
end

guiVal.numDiodes_fdpm = sum( guiVal.use_diodes_fdpm );
guiVal.numDiodes_spec = sum( guiVal.use_diodes_spec );


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuSettings_Callback(hObject, eventdata, handles)
% hObject    handle to menuSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guiVal;
guiVal.sethandle=dosisettings;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global guiVal;
if(guiVal.sethandle~=0)
    close(guiVal.sethandle);
    guiVal.sethandle=0;
end
% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes when selected object is changed in uipanel6.
function uipanel6_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel6 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
global guiVal;
pfx = findobj( 'Tag', 'lstFiles' );
radiostring = get(eventdata.NewValue,'String');
if strcmp(radiostring,'Phantom')
    set( pfx   , 'String', guiVal.phantom_list_base, 'Value', 1 );
elseif strcmp(radiostring,'Breast')
    set( pfx   , 'String', guiVal.blist, 'Value', 1 );
elseif strcmp(radiostring,'Abdomen')
    set( pfx   , 'String', guiVal.alist, 'Value', 1 );
else
    set( pfx   , 'String', guiVal.measurement_list_base, 'Value', 1 );
end
    
