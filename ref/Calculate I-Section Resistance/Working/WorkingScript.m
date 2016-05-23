% CalculateSectionResistance
% Created by: Nick Romano (nick.p.romano@gmail.com) 

% Script used to calculate section capacities for LRFR and LFR based on
% section dimensiions and other user inputs.

% Error screen inputs

    
% Get user inputs 
Section.Spans = str2double(t.Data(1,2:end));
SpanLength = str2double(t.Data(2,2:end));
Section.L = [SpanLength SpanLength]
Section.LbPos = str2double(t.Data(3,2:end));
Section.LbNeg = str2double(t.Data(4,2:end));
Section.Es = str2double(t.Data(5,2:end));
Section.Fy = str2double(t.Data(6,2:end));
Section.fc = str2double(t.Data(7,2:end));
Section.ts = str2double(t.Data(8,2:end));
Section.be = str2double(t.Data(9,2:end));
Section.dh = str2double(t.Data(10,2:end));
Section.dw  = str2double(t.Data(11,2:end));
Section.tw  = str2double(t.Data(12,2:end));
Section.bf_topPos  = str2double(t.Data(13,2:end));
Section.tf_topPos  = str2double(t.Data(14,2:end));
Section.bf_bottomPos = str2double(t.Data(15,2:end));
Section.tf_bottomPos = str2double(t.Data(16,2:end));
Section.L_cp = 0; % make zero for now
Section.bf_topNeg  = str2double(t.Data(17,2:end));
Section.tf_topNeg  = str2double(t.Data(18,2:end));
Section.bf_bottomNeg = str2double(t.Data(19,2:end));
Section.tf_bottomNeg = str2double(t.Data(20,2:end));


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
                capacityPos = Section.Mu_Pos;
                set(handles.Strength1Units_text,'string','lb-in.');
            elseif Section.PosCompact == 1 && Section.NegCompact == 0
                capacityPos = Section.Fu_pos; 
                set(handles.Strength1Units_text,'string','psi');
            else
                capacityPos = Section.Mu_Pos;
                set(handles.Strength1Units_text,'string','lb-in.');
            end
            
            % Strength I
            set(handles.Strength1_editbox,'string',num2str(capacityPos));
            % Service II
            set(handles.Service2_editbox,'string','NA');
        
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