function CalculateSectionResistance_LFR(Section,location)

% Calculate LFR Resistance
% References: MBE Section 6 Appdneix L6B, AASHTO Standard Specs Section 10


%% Define & Calculate Variables
dw = Section.web_d;
tw = Section.web_t;
tf_tPos  = Section.topflange_t;
bf_tPos  = Section.topflange_w;
tf_bPos = Section.bottomflange_t;
bf_bPos = Section.bottomflange_w;
tf_tNeg  = ;
bf_tNeg  = ;
tf_bNeg = ;
bf_bNeg = ;
ts = Section.deck_t; % Thickness of concrete deck
STnc = Section.STnc;
SBnc = Section.SBnc;
Fy = Section.steel_Fy;
Lb = Section.Lb;
Z = Section.Z;


% Determine beta factor, B
if Fy < 50000 
    B = 0.9; 
else
    B = 0.7; 
end


%% Calculate Moment capcaity at first yield 10.50(c)
Section  = calculateFirstYieldMoment(Section);
My = Section.My;


%% Calculate plastic neutral axis and plastic moment
Section = calculateSectionPlasticMoment(Section);
Dp = Section.Dp;


%% Calculate composite section compactness (pos. moment region)
posRegionCompact = determineCompositeSectionCompactness(Section);


%% Calculate non-composite section compactness (neg. moment region)
if Spans > 1
    negRegionCompact = determineNonCompositeSectionCompactness(Section);
else
    negRegionCompact = 1; % Set to 1 if neg. region does not exist
end


%% Positive Moment Section Capcacity

% MBE AL6B.2.1.2 - Compact/Composite (+), Compact/Non-Composite (-):
% For composite positive moment sections in simple spans that satisfy the 
% following requirements for compact sections, Mu is determined
% using Equations 10-129b or 10-129c.

if posRegionCompact && negRegionCompact 
    
    % for ductility
    D = B*(dw+tf_tPos+tf_bPos+ts+haunch_d)/7.5;

    % AASHTO 10.129b
    if Dp <= D
        Mu_pos = Mp; 
    end
    
    % AASHTO 10.129c
    if Dp <= 5*D && Dp > D
        Mu_pos = 0.25*(5*Mp - 0.85*My) + 0.25*(0.85*My - Mp)*(Dp/D);
    end
    
elseif posRegionCompact && ~negRegionCompact
    
    % AASHTO MBE Appendix L6B.2.1.2
    Fu_pos = Fy;
    
else
    
    % Lambda variable
    if Dc <= D_total/2
        lmbda = 15400;
    else
        lmbda = 12500;
    end
    
    % Flange stress reduction factor, Rb 
    Fcr = (4400*tf_bPos/bf_bPos)^2;
    Rb = 1- 0.002*(Dc*tw/Afc)*((Dc/tw)-(lmbda/sqrt(Fy))); % 10-103b
    
    % AASHTO MBE Appendix L6B.2.1.4
    % For braced Non-compact positie moment section 
    Mu(1) = Fy*STnc; % 10-98
    Mu(2) = Fcr*SBnc*Rb; % 10-99
    Mu_pos = min(Mu);
    
end


%% Negative Moment Section Capacity

% For continuous spans with compact non-composite negative-moment pier sections: 
if Spans > 1
    
    % AASHTO MBE Appendix L6B.2.1.3
    if negRegionCompact
        
        % AASHTO LFD 10-92
        Mu_neg = Fy*Z;
        
    else
        
        % For negative moment section, check if compression flange braced or unbraced
        braced = 1; % Section is braced

        % AASHTO 10.48.2.1(a)
        if bf_bNeg/tf_bNeg > 24
            braced = 0; % Section is unbraced
        end

        % AASHTO 10.48.2.1(c)
        if Lb > (20000000*bf_bNeg*tf_bNeg)/(Fy*(dw+tf_tNeg+tf_bNeg))
            braced = 0; % Section is unbraced
        end
        
        % Lambda variable
        if Dc <= D_total/2
            lmbda = 15400;
        else
            lmbda = 12500;
        end
        
        % Flange stress reduction factor, Rb 
        Fcr = (4400*tf_bNeg/bf_bNeg)^2;
        Rb = 1- 0.002*(Dc*tw/Afc)*((Dc/tw)-(lmbda/sqrt(Fcr))); % 10-103b

        if braced
            
            % For braced Non-compact section at pier if continous (10.48.2)
            Mu_pier(1) = Fy*STnc; % 10-98
            Mu_pier(2) = Fcr*SBnc*Rb; % 10-99
            Mu_neg = min(Mu_pier);
            
        else   
            
            % Calculate lateral torsional buckling moment
            Section = calculateLTBMoment(Section);
            Mr = Section. Mr;

            % For partially braced Non-compact section at pier if continous (10.48.4)
            Mu_neg = min(Mr*Rb, Fcr*SBnc*Rb); % 10-103a
            
        end
    end
end

end

%% COMPACTNESS CHECK - NON-COMPOSITE SECTION 10.48.1.1
function sectionCompact = determineNonCompositeSectionCompactness(Section)

% Define variables

% default
sectionCompact = 1;

% AASHTO LFD 10-93
if bf_bNeg/tf_bNeg > 4110/sqrt(Fy)
    sectionCompact = 0;
end

% AASHTO LFD 10-94
if Dw/tw > 19230/sqrt(Fy)
    sectionCompact = 0;
end

% AASHTO LFD 10-95
prop1 = bf/tf > 0.75*(4110/sqrt(Fy));
prop2 = Dw/tw > 0.75*(19230/sqrt(Fy));
if prop1 && prop2
    if (Dw/tw) + 4.68*(bf/tf) > 33650/sqrt(Fy)
        sectionCompact = 0;
    end
end

% AASHTO LFD 10-96
% Assuming M1 to be 0, and therefore M1/Mu = 0
if Lb/ry > (3.6*10^6)/Fy
    sectionCompact = 0;
end

end


%% COMPACTNESS CHECK - COMPOSITE SECTION 10.50.1.1.2
function sectionCompact = determineCompositeSectionCompactness(Section)

% Check compactness and ductility requirements
sectionCompact = 1;

% Determine beta factor, B
if Fy < 50000 
    B = 0.9; 
else
    B = 0.7; 
end

% AASHTO LFD 10-129 (compactness)
if 2*Dcp/tw > 19230/sqrt(Fy)
    sectionCompact = 0;
end

% AASHTO LFD 10-129a (Ductility)
D = B*(Dw+tf_top+tf_bottom+ts+haunch_d)/7.5;
if (Dp/D) > 5
    sectionCompact = 0;
end

end


%% CALCULATE LATERAL TORSIONAL BUCKLING MOMENT 
function Section = calculateLTBMoment(Section)

if Dc/tw <= lmbda/sqrt(Fy)
    % AASHTO 10-103c
    Mr = 91*(10^6)*Cb*(Iyc/Lb)*sqrt(0.772*(J/Iyc)+9.87*(d/Lb)^2);
else
    Lp = 9500*rt/sqrt(Fy);
    Lr = sqrt((572*(10^6)*Iyc*(dw+tf_tNeg+tf_bNeg))/(Fy*SBnc)); % 10-103f
    if Lb > Lr
        % AASHTO 10-103g
        Mr = Cb*(Fy*SBnc/2)*(Lr/Lb)^2;
    elseif Lb > Lp
        % AASHTO 10-103e
        Mr = Cb*Fy*SBnc*(1-0.5*((Lb-Lp)/(Lr-Lp)));
    else
        % AASHTO 10-103d
        Mr = My;
    end
end
end


%% CALCULATE FIRST YIELD MOMENT
function Section  = calculateFirstYieldMoment(Section, Demands)

% Define variables
Fy = Section.Steel_Fy;
STnc = Section.STnc;
SBnc = Section.SBnc;
STlt = Section.STlt;
SBlt = Section.SBlt;
STst = Section.STst;
SBst = Section.SBst;
MDL_pos = Demands.MDL_pos;
MSDL_pos = Demands.MSDL_pos;
MSDW_pos = Demands.MSDW_pos;

% Determine yield Moment of Composite Section in Positive Flexure for
% Strength Limit State (Appendix D6.2.2)
Section.M_addc = min((Fy -(abs(1.25*MDL_pos)/STnc) - (abs(1.25*MSDL_pos)/STlt) - (abs(1.50*MSDW_pos)/STlt))*STst); % Additional moment needed for first yeild
Section.M_addt = min((Fy -(abs(1.25*MDL_pos)/SBnc) - (abs(1.25*MSDL_pos)/SBlt) - (abs(1.50*MSDW_pos)/SBlt))*SBst); % Additional moment needed for first yeild
Section.Myc = 1.25*(abs(MDL_pos)+abs(MSDL_pos)) + 1.50*(abs(MSDW_pos)) + Section.M_addc; %lb-in, factored for strength
Section.Myt = 1.25*(abs(MDL_pos)+abs(MSDL_pos)) + 1.50*(abs(MSDW_pos)) + Section.M_addt; %lb-in, factored for strength
Section.My = min(Section.Myc, Section.Myt); %lb-in
Section.Myst = Fy*SBst;

end


%% CALCULATE SECTION PLASTIC MOMENT
function Section = calculateSectionPlasticMoment(Section)

% Determine Plastic Moment: AASHTO Specs !0.50.1

% Define Variables
Fy = Section.steel_Fy; % Yeild Strength of flanges and web [psi]
fc = Section.concrete_fc; % Compressive strength of concrete deck
ts = Section.deck_t; % Thickness of concrete deck
tf_top = Section.topflange_t; % Thickness of top flange (compression flange)
tf_bottom = Section.bottomflange_t; % Thickness of bottom flange (tension flange)
bf_top = Section.topflange_w; % Width of top flange (compression flange)
bf_bottom = Section.bottomflange_w; % Width of bottom flange (tension flange)
tw = Section.web_t; % Thickness of the web
Dw = Section.web_d; % Depth of Web
be = Section.deck_be; % Effective width of concrete deck

Ps = 0.85*fc*be*ts; % Force in the concrete slab 
Pc = bf_top*tf_top*Fy; % Force in the compression flange
Pw = Dw*tw*Fy; % Force in web
Pt = bf_bottom*tf_bottom*Fy + 0.625*10.5*Fy; % Force in the tesnion flange

% If Pc+Pw+Pt > Ps, PNA in slab
% elseif Ps+Pc > Pw +Pt, PNA in top flange
% else, PNA in web

if Ps < Pc+Pw+Pt % PNA located in Steel and measured from top of top flange
    
    % comporessive force on top portion of steel section
    C = (Pc+Pw+Pt-Ps)/2; 
    
    if C < Pc % Neutral Axis in top flange
        
        % Plastic neutral axis and depth of web in compression
        Section.PNA = (C/Pc)*tf_top;
        Section.Dcp = 0;
        Section.Dp = ts + PNA;
        
        % Moment Arms
        ds = ts/2 + PNA;
        dc = abs(tf_top/2 - PNA);
        dw = tf_top + Dw/2 - PNA;
        dt = tf_bottom/2 + Dw + (tf_top-PNA);
        
        % Plastic Moment
        Section.Mp = Ps*ds + Pc*dc + Pw*dw + Pt*dt;
        
    else % Neutral Axis in web
        
        % Plastic neutral axis and depth of web in compression
        Section.PNA = tf_top + ((C-Pc)/Pw)*Dw;
        Section.Dcp = PNA;
        Section.Dp = ts + PNA;
        
        % Moment Arms
        ds = ts/2 + PNA;
        dc = PNA - tf_top/2;
        dw = tf_top + Dw/2 - PNA;
        dt = tf_bottom/2 + Dw + (tf_top-PNA);
        
        % Plastic Moment
        Section.Mp = Ps*ds + Pc*dc + Pw*dw + Pt*dt;
        
    end
    
else % PNA located in slab and measured from top slab
    
    % Plastic neutral axis and depth of web in compression
    Section.PNA = ts*((Pc+Pw+Pt)/Ps);
    Section.Dcp = 0;
    Section.Dp = PNA;
    
    % Moment Arms
    ds = abs(ts/2 - PNA);
    dc = tf_top/2 + ts - PNA;
    dw = tf_top + Dw/2 + ts - PNA;
    dt = tf_bottom/2 + Dw + tf_top + ts - PNA;
    
    % Plastic Neutral Axis
    Section.Mp = Ps*ds + Pc*dc + Pw*dw + Pt*dt;
    
end

end

