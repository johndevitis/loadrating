function varargout = CalculateFlexuralResistance_gui(varargin)
% CALCULATEFLEXURALRESISTANCE_GUI MATLAB code for CalculateFlexuralResistance_gui.fig
%      CALCULATEFLEXURALRESISTANCE_GUI, by itself, creates a new CALCULATEFLEXURALRESISTANCE_GUI or raises the existing
%      singleton*.
%
%      H = CALCULATEFLEXURALRESISTANCE_GUI returns the handle to a new CALCULATEFLEXURALRESISTANCE_GUI or the handle to
%      the existing singleton*.
%
%      CALCULATEFLEXURALRESISTANCE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCULATEFLEXURALRESISTANCE_GUI.M with the given input arguments.
%
%      CALCULATEFLEXURALRESISTANCE_GUI('Property','Value',...) creates a new CALCULATEFLEXURALRESISTANCE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalculateFlexuralResistance_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalculateFlexuralResistance_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalculateFlexuralResistance_gui

% Last Modified by GUIDE v2.5 28-Mar-2016 11:47:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalculateFlexuralResistance_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @CalculateFlexuralResistance_gui_OutputFcn, ...
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

% OPENING & CLOSING FUNCTIONS ---------------------------------------------

% --- Executes just before CalculateFlexuralResistance_gui is made visible.
function CalculateFlexuralResistance_gui_OpeningFcn(hObject, eventdata, handles, varargin)

% Show Beam Picture
axes(handles.BeamImage_axes);
imshow([pwd '\Data\Composite I-Section.png']);

% Choose default command line output for CalculateFlexuralResistance_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = CalculateFlexuralResistance_gui_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
% varargout{1} = handles.output;
varargout{1} = getappdata(0,'Section');

% --- Executes when user attempts to close FlexuralResistance_gui.
function FlexuralResistance_gui_CloseRequestFcn(hObject, eventdata, handles)

% Hint: delete(hObject) closes the figure
delete(hObject);


% CREATION FUNCTIONS ------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function ConcreteStrength_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function SteelStrength_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function SteelModulous_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function HaunchDepth_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function EffectiveWidth_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function DeckThickness_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function BottomFlangeWidth_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function TopFlangeWidth_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function WebThickness_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function BottomFlangeDepth_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function TopFlangeDepth_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function WebDepth_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Region_dropdown_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Service2_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Strength1_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function SpanLength_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function BeamImage_axes_CreateFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function SDL_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function NSDL_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function WDL_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function UnbracedLength_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function panel_dropdown_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% CALLBACK FUNCTIONS ------------------------------------------------------

function CalculateResistance_pushbutton_Callback(hObject, eventdata, handles)

% Get user inputs ---------------------------------------------------------
% Material Properties
Section.steel_E = str2num(get(handles.SteelModulous_editbox,'string'));
Section.steel_Fy = str2num(get(handles.SteelStrength_editbox,'string'));
Section.concrete_fc = str2num(get(handles.ConcreteStrength_editbox,'string'));

% Deck Dimensions
Section.deck_t = str2num(get(handles.DeckThickness_editbox,'string'));
Section.deck_be = str2num(get(handles.EffectiveWidth_editbox,'string'));
Section.haunch_d = str2num(get(handles.HaunchDepth_editbox,'string'));

% Steel Dimensions
Section.web_d  = str2num(get(handles.WebDepth_editbox,'string'));
Section.web_t  = str2num(get(handles.WebThickness_editbox,'string'));
Section.topflange_t  = str2num(get(handles.TopFlangeDepth_editbox,'string'));
Section.topflange_w  = str2num(get(handles.TopFlangeWidth_editbox,'string'));
Section.bottomflange_t = str2num(get(handles.BottomFlangeDepth_editbox,'string'));
Section.bottomflange_w = str2num(get(handles.BottomFlangeWidth_editbox,'string'));
Section.coverplate_L = 0; % make zero for now

% Span Length
SpanLength = str2num(get(handles.SpanLength_editbox,'string'));

% No. of spans
Spans = length(SpanLength);

% Unbraced Length
Section.Lb = str2num(get(handles.UnbracedLength_editbox,'string'));

% Capacity Type
capacityType = get(handles.Region_dropdown,'value')-1;

% Shear panel type and location
panelOption = get(handles.panel_dropdown,'value');
if panelOption-1 == 1, panel = 'Interior'; location = 'positive';
elseif panelOption-1 == 2, panel = 'Interior'; location = 'negative';
elseif panelOption-1 == 3, panel = 'End'; location = 'positive';
elseif panelOption-1 == 4, panel = 'End'; location = 'negative';
end

% Calculate Section Properties and Capacities -----------------------------

% Get non-composite section properties
Section = GetNonCompositeSectionProperties(Section);

% Get composite section properties
Section = GetCompositeSectionProperties(Section);

% Get SLG DL Demands for positive capacity
if capacityType == 1
    I_diff = []; 
    Demands = GetDeadLoadSLGDemands(Section,Spans,SpanLength,I_diff);
    % Dead Load Demands
    Demands.wDL = str2num(get(handles.NSDL_editbox,'string'));
    Demands.wSDL = str2num(get(handles.SDL_editbox,'string'));
    Demands.wSDW = str2num(get(handles.WDL_editbox,'string'));
    % Get section forces from SLG Demands if positive or shear capacity
    Demands = GetDeadLoadForces(Demands);
end

% Calculate section capacities and populate fields
switch capacityType
    case 0
        errordlg('Please select capacity type');
    case 1
        Section = CalculatePositiveSectionResistance(Section,Demands,Spans);
        if Section.Compact == 1 
            capacityPos = Section.Mn_Strength1Pos;
            set(handles.Strength1Units_text,'string','lb-in.');
        else
            capacityPos = Section.Fn_Strength1Pos; 
            set(handles.Strength1Units_text,'string','psi');
        end
        % Strength I
        set(handles.Strength1_editbox,'string',num2str(capacityPos));
        % Service II
        set(handles.Service2_editbox,'string',num2str(Section.Fn_Service2Pos));
    case 2
        Section = CalculateNegativeSectionResistance(Section);
        % Strength I
        set(handles.Strength1Units_text,'string','psi');
        set(handles.Strength1_editbox,'string',num2str(Section.Fn_Strength1Neg));
        % Service II
        set(handles.Service2_editbox,'string',num2str(Section.Fn_Service2Neg));
    case 3
        Section = CalculateShearResistance(Section,panel,location);
        % Strength I
        set(handles.Strength1Units_text,'string','lbs');
        set(handles.Strength1_editbox,'string',num2str(Section.Vn));
        % Service II
        set(handles.Service2_editbox,'string','N/A');
end

% save to app data
setappdata(0,'Section',Section);

CalculateFlexuralResistance_gui_OutputFcn


function Service2_editbox_Callback(hObject, eventdata, handles)

function Strength1_editbox_Callback(hObject, eventdata, handles)

function Region_dropdown_Callback(hObject, eventdata, handles)

function ConcreteStrength_editbox_Callback(hObject, eventdata, handles)

function SteelStrength_editbox_Callback(hObject, eventdata, handles)

function SteelModulous_editbox_Callback(hObject, eventdata, handles)

function HaunchDepth_editbox_Callback(hObject, eventdata, handles)

function EffectiveWidth_editbox_Callback(hObject, eventdata, handles)

function DeckThickness_editbox_Callback(hObject, eventdata, handles)

function BottomFlangeWidth_editbox_Callback(hObject, eventdata, handles)

function TopFlangeWidth_editbox_Callback(hObject, eventdata, handles)

function WebThickness_editbox_Callback(hObject, eventdata, handles)

function BottomFlangeDepth_editbox_Callback(hObject, eventdata, handles)

function TopFlangeDepth_editbox_Callback(hObject, eventdata, handles)

function WebDepth_editbox_Callback(hObject, eventdata, handles)

function SpanLength_editbox_Callback(hObject, eventdata, handles)

function WDL_editbox_Callback(hObject, eventdata, handles)

function SDL_editbox_Callback(hObject, eventdata, handles)

function NSDL_editbox_Callback(hObject, eventdata, handles)

function UnbracedLength_editbox_Callback(hObject, eventdata, handles)

function panel_dropdown_Callback(hObject, eventdata, handles)
