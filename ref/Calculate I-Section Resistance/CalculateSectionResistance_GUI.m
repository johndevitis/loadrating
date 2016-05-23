function varargout = CalculateSectionResistance_GUI(varargin)

% Last Modified by GUIDE v2.5 12-Apr-2016 08:38:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalculateSectionResistance_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CalculateSectionResistance_GUI_OutputFcn, ...
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


% OPERATING FUNCTIONS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

% --- Executes just before CalculateSectionResistance_GUI is made visible.
function CalculateSectionResistance_GUI_OpeningFcn(hObject, eventdata, handles, varargin)

% Show Beam Picture
axes(handles.BeamSection_axis);
imshow([pwd '\Data\Composite I-Section.png']);

% Set defaults
calculateSectionResistanceGUIDefaults(handles);

% Choose default command line output for CalculateSectionResistance_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = CalculateSectionResistance_GUI_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
% varargout{1} = handles.output;
varargout{1} = getappdata(0,'Section');

% --- Executes when user attempts to close CalculateSectionResistance_GUI.
function CalculateSectionResistance_GUI_CloseRequestFcn(hObject, eventdata, handles)

% Hint: delete(hObject) closes the figure
delete(hObject);

% --- Executes when CalculateSectionResistance_GUI is resized.
function CalculateSectionResistance_GUI_SizeChangedFcn(hObject, eventdata, handles)

get(handles.Inputs_table,'position');


% CREATION FUNCTIONS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

% --- Executes during object creation, after setting all properties.
function Continuity_dropdown_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function CapacityType_dropdown_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Strength1_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Service2_editbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function ShearPanel_dropdown_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Inputs_table_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% CALLBACK FUNCTIONS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

% --- Executes on button press in LRFR_radiobutton.
function LRFR_radiobutton_Callback(hObject, eventdata, handles)

set(handles.LRFR_radiobutton,'value',1);
set(handles.LFR_radiobutton,'value',0);
set(handles.CapacityType_dropdown,'value',1);
set(handles.Strength1_editbox,'string','');
set(handles.Service2_editbox,'string','');

% Inputs table

inputs = {'Span Length, L',[];...
          'Max Unbraced Length, Lb',[];...
          'Steel Modulous, E',[];...
          'Steel Yield Strength, Fy',[];...
          'Concrete Strength, fc',[];...
          'Deck Thickness, ts',[];...
          'Effective Width, be',[];...
          'Haunch Depth, dh',[];...
          'Web Depth, dw',[];...
          'Web Thickness, tw',[];...
          'Top Flange Width, bf_top',[];...
          'Top Flange Thickness, tf_top',[];...
          'Bot. Flange Width. bf_bot',[];...
          'Bot. Flange Thickness, tf_bot',[];...
          'Non-Superimposed DL, wDL',[];...
          'Superimposed DL, wSDL',[];...
          'Wearing DL, wSDW',[]};
                
set(handles.Inputs_table,'Data',inputs);

% --- Executes on button press in LFR_radiobutton.
function LFR_radiobutton_Callback(hObject, eventdata, handles)

set(handles.LFR_radiobutton,'value',1);
set(handles.LRFR_radiobutton,'value',0);
set(handles.CapacityType_dropdown,'value',1);
set(handles.Strength1_editbox,'string','');
set(handles.Service2_editbox,'string','');

% Inputs table
inputs = {'Span Length, L',[];...
          'Max Unbraced Length, Lb',[];...
          'Steel Modulous, E',[];...
          'Steel Yield Strength, Fy',[];...
          'Concrete Strength, fc',[];...
          'Deck Thickness, ts',[];...
          'Effective Width, be',[];...
          'Haunch Depth, dh',[];...
          'Web Depth, dw',[];...
          'Web Thickness, tw',[];...
          '(+) Top Flange Width, bf_top',[];...
          '(+) Top Flange Thickness, tf_top',[];...
          '(+) Bot. Flange Width. bf_bot',[];...
          '(+) Bot. Flange Thickness, tf_bot',[];...
          '(-) Top Flange Width, bf_top',[];...
          '(-) Top Flange Thickness, tf_top',[];...
          '(-) Bot. Flange Width, bf_bot',[];...
          '(-) Bot. Flange Thickness, tf_bot',[];...
          'Non-Superimposed DL, wDL',[];...
          'Superimposed DL, wSDL',[];...
          'Wearing DL, wSDW',[]};
      
set(handles.Inputs_table,'Data',inputs);

% --- Executes on selection change in Continuity_dropdown.
function Continuity_dropdown_Callback(hObject, eventdata, handles)

if get(hObject,'value') == 2
    string = {'Select Capacity...';'Positive';'Shear'};
    set(handles.CapacityType_dropdown,'String',string,'value',1);
else
    string = {'Select Capacity...';'Positive';'Negative';'Shear'};
    set(handles.CapacityType_dropdown,'String',string,'value',1);
end

% --- Executes on selection change in CapacityType_dropdown.
function CapacityType_dropdown_Callback(hObject, eventdata, handles)

% --- Executes on button press in Calculate_pushbutton.
function Calculate_pushbutton_Callback(hObject, eventdata, handles)

% Error screen inputs
if get(handles.Continuity_dropdown,'value') == 1
    errordlg('Please select continuity.');
    return
end

if get(handles.CapacityType_dropdown,'value') == 1
    errordlg('Please select capacity type');
    return
end
    
% Get user inputs ---------------------------------------------------------
inputs = get(handles.Inputs_table,'Data');

% Number of Spans
Spans = get(handles.Continuity_dropdown,'value')-1;
Section.Spans = Spans;

% Span Length
Section.L = str2num(inputs{1,2});
SpanLength = Section.L;

% Unbraced Length
Section.Lb = str2num(inputs{2,2});

% Material Properties
Section.Es = str2num(inputs{3,2});
Section.Fy = str2num(inputs{4,2});
Section.fc = str2num(inputs{5,2});

% Deck Dimensions
Section.ts = str2num(inputs{6,2});
Section.be = str2num(inputs{7,2});
Section.dh = str2num(inputs{8,2});

% Steel Dimensions
Section.dw  = str2num(inputs{9,2});
Section.tw  = str2num(inputs{10,2});
Section.bf_top  = str2num(inputs{11,2});
Section.tf_top  = str2num(inputs{12,2});
Section.bf_bottom = str2num(inputs{13,2});
Section.tf_bottom = str2num(inputs{14,2});

Section.L_cp = 0; % make zero for now

if get(handles.LFR_radiobutton,'value')
    Section.bf_top  = [str2num(inputs{11,2}),str2num(inputs{15,2})];
    Section.tf_top  = [str2num(inputs{12,2}),str2num(inputs{16,2})];
    Section.bf_bottom = [str2num(inputs{13,2}),str2num(inputs{17,2})];
    Section.tf_bottom = [str2num(inputs{14,2}),str2num(inputs{18,2})];
    ind = 19;
else
    ind = 15;
end

% Capacity Type
capacityType = get(handles.CapacityType_dropdown,'value')-1;

% Shear panel type and location
panelOption = get(handles.ShearPanel_dropdown,'value');
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
    Demands.wDL = str2num(inputs{ind,2});
    Demands.wSDL = str2num(inputs{ind,2});
    Demands.wSDW = str2num(inputs{ind,2});
    % Get section forces from SLG Demands if positive or shear capacity
    Demands = GetDeadLoadForces(Demands);
end

% Calculate section capacities and populate fields
switch capacityType
    case 0
        errordlg('Please select capacity type');
        return
    case 1 % Positive
        
        if get(handles.LRFR_radiobutton,'value') % LRFR
            
            Section = CalculatePositiveSectionResistance_LRFR(Section,Demands,Spans);
            
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
            
        else % LFR
        
            Section = calculatePositiveSectionResistance_LFR(Section,Demands);
            
            if Section.PosCompact == 1 && Section.NegCompact == 1
                capacityPos = Section.Mu_StrengthPos;
                set(handles.Strength1Units_text,'string','lb-in.');
            elseif Section.PosCompact == 1 && Section.NegCompact == 0
                capacityPos = Section.Fu_StrengthPos; 
                set(handles.Strength1Units_text,'string','psi');
            else
                capacityPos = Section.Mu_StrengthPos;
                set(handles.Strength1Units_text,'string','lb-in.');
            end
            
            % Strength I
            set(handles.Strength1_editbox,'string',num2str(capacityPos));
            
            % Service II
            capacityPos = Section.Fu_ServicePos;
            set(handles.Service2_editbox,'string',num2str(capacityPos));
        
        end          
       
    case 2 % Negative
        
        if get(handles.LRFR_radiobutton,'value') % LRFR
            
            Section = CalculateNegativeSectionResistance_LRFR(Section);
            
            % Strength I
            set(handles.Strength1Units_text,'string','psi');
            set(handles.Strength1_editbox,'string',num2str(Section.Fn_Strength1Neg));
            % Service II
            set(handles.Service2_editbox,'string',num2str(Section.Fn_Service2Neg));
            
        else % LFR
        
            Section = calculateNegativeSectionResistance_LFR(Section);
            
            if Section.NegRegionCompact
                % Strength I
                set(handles.Strength1Units_text,'string','lb-in.');
                set(handles.Strength1_editbox,'string',num2str(Section.Mu_neg));
            else
                % Strength I
                set(handles.Strength1Units_text,'string','psi');
                set(handles.Strength1_editbox,'string',num2str(Section.Fu_neg));
            end
            
            % Service II
            set(handles.Service2_editbox,'string','NA');
        
        end          
  
    case 3
        
        if get(handles.LRFR_radiobutton,'value') % LRFR
            Section = CalculateShearResistance_LRFR(Section,panel,location);
        else % LFR
            Section = CalculateShearResistance_LFR(Section);
        end
        
        % Strength I
        set(handles.Strength1Units_text,'string','lbs');
        set(handles.Strength1_editbox,'string',num2str(Section.Vn));
        
        % Service II
        set(handles.Service2_editbox,'string','N/A');
end

% save to app data
setappdata(0,'Section',Section);

CalculateSectionResistance_GUI_OutputFcn


% --- Executes on selection change in ShearPanel_dropdown.
function ShearPanel_dropdown_Callback(hObject, eventdata, handles)

function Service2_editbox_Callback(hObject, eventdata, handles)

function Strength1_editbox_Callback(hObject, eventdata, handles)



% GUI FUNCTIONS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
