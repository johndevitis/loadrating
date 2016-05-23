function s = CalculatePositiveSectionResistance_LFR(s,d)

% Calculate LFR Resistance
% References: MBE Section 6 Appdneix L6B, AASHTO Standard Specs Section 10


%% Define & Calculate Variables
Spans = s.nSpans;
haunch_d = s.dh;
dw = s.dw;
tw = s.tw;
tf_tPos  = s.tf_top(1);
bf_tPos  = s.bf_top(1);
tf_bPos = s.tf_bottom(1);
bf_bPos = s.bf_bottom(1);
if Spans > 1
    tf_tNeg  = s.tf_top(2);
    bf_tNeg  = s.bf_top(2);
    tf_bNeg = s.tf_bottom(2);
    bf_bNeg = s.bf_bottom(2);
end
ts = s.ts; % Thickness of concrete deck
STnc = s.STnc(1);
SBnc = s.SBnc(1);
Fy = s.Fy;
Lb = s.Lb(1);
Z = s.Z(1);


% Determine beta factor, B
if Fy < 50000 
    B = 0.9; 
else
    B = 0.7; 
end


%% Calculate Moment capcaity at first yield 10.50(c)
s  = calculateFirstYieldMoment(s,d);
My = s.My;


%% Calculate plastic neutral axis and plastic moment
s = calculateSectionPlasticMoment(s);
Dp = s.Dp;
Mp = s.Mp;


%% Calculate composite section compactness (pos. moment region)
posRegionCompact = determineCompositeSectionCompactness(s);
s.PosCompact = posRegionCompact;

%% Calculate non-composite section compactness (neg. moment region)
if Spans > 1
    negRegionCompact = determineNonCompositeSectionCompactness(s);   
else
    negRegionCompact = 1; % Set to 1 if neg. region does not exist
end
s.NegCompact = negRegionCompact;


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
        s.Mu_pos = Mp; 
    end
    
    % AASHTO 10.129c
    if Dp <= 5*D && Dp > D
        s.Mu_StrentghPos = 0.25*(5*Mp - 0.85*My) + 0.25*(0.85*My - Mp)*(Dp/D);
    end
    
elseif posRegionCompact && ~negRegionCompact
    
    % AASHTO MBE Appendix L6B.2.1.2
    s.Fu_StrengthPos = Fy;
    
else
    
    % Lambda variable
    if Dc <= D_total/2
        lmbda = 15400;
    else
        lmbda = 12500;
    end
    
    % Flange stress reduction factor, Rb 
    Fcr = (4400*tf_bPos/bf_bPos)^2;
    Rb = 1 - 0.002*(Dc*tw/Afc)*((Dc/tw)-(lmbda/sqrt(Fy))); % 10-103b
    
    % AASHTO MBE Appendix L6B.2.1.4
    % For braced Non-compact non-compositie moment section 
    Mu(1) = Fy*STnc; % 10-98
    Mu(2) = Fcr*SBnc*Rb; % 10-99
    s.Mu_StrentghPos = min(Mu);
    
end

% Service II
s.Fu_ServicePos = 0.95*Fy;

end

%% COMPACTNESS CHECK - NON-COMPOSITE SECTION 10.48.1.1
function sectionCompact = determineNonCompositeSectionCompactness(Section)

% Define variables
Fy = Section.Fy;
dw = Section.dw;
tw = Section.tw;
Lb = Section.Lb;
ry = Section.ry;
tf_tNeg  = Section.tf_top(2);
bf_tNeg  = Section.bf_top(2);
tf_bNeg = Section.tf_bottom(2);
bf_bNeg = Section.bf_bottom(2);

% default
sectionCompact = 1;

% AASHTO LFD 10-93
if bf_bNeg/tf_bNeg > 4110/sqrt(Fy)
    sectionCompact = 0;
end

% AASHTO LFD 10-94
if dw/tw > 19230/sqrt(Fy)
    sectionCompact = 0;
end

% AASHTO LFD 10-95
prop1 = bf_bNeg/tf_bNeg > 0.75*(4110/sqrt(Fy));
prop2 = dw/tw > 0.75*(19230/sqrt(Fy));
if prop1 && prop2
    if (dw/tw) + 4.68*(bf_bNeg/tf_bNeg) > 33650/sqrt(Fy)
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

% Define Variables
Fy = Section.Fy;
Dcp = Section.Dcp;
tw = Section.tw;
D = Section.D;
Dp = Section.Dp;

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
D = B*(D)/7.5;
if (Dp/D) > 5
    sectionCompact = 0;
end

end


%% CALCULATE FIRST YIELD MOMENT
function s  = calculateFirstYieldMoment(s, d)

% Define variables
Fy = s.Fy;
STnc = s.STnc(1);
SBnc = s.SBnc(1);
STlt = s.STlt(1);
SBlt = s.SBlt(1);
STst = s.STst(1);
SBst = s.SBst(1);
MDL_pos = d.MDL_pos;
MSDL_pos = d.MSDL_pos;
MSDW_pos = d.MSDW_pos;

% Determine yield Moment of Composite Section in Positive Flexure for
% Strength Limit State (Appendix D6.2.2)
M_addc = min((Fy -(abs(1.25*MDL_pos)/STnc) - (abs(1.25*MSDL_pos)/STlt) - (abs(1.50*MSDW_pos)/STlt))*STst); % Additional moment needed for first yeild
M_addt = min((Fy -(abs(1.25*MDL_pos)/SBnc) - (abs(1.25*MSDL_pos)/SBlt) - (abs(1.50*MSDW_pos)/SBlt))*SBst); % Additional moment needed for first yeild
Myc = 1.25*(abs(MDL_pos)+abs(MSDL_pos)) + 1.50*(abs(MSDW_pos)) + M_addc; %lb-in, factored for strength
Myt = 1.25*(abs(MDL_pos)+abs(MSDL_pos)) + 1.50*(abs(MSDW_pos)) + M_addt; %lb-in, factored for strength
s.My = min(Myc, Myt); %lb-in
% Myst = Fy*SBst;

end

function s = calculateSectionPlasticMoment(s)

% Determine Plastic Moment: AASHTO Specs !0.50.1

% Define Variables
Fy = s.Fy; % Yeild Strength of flanges and web [psi]
fc = s.fc; % Compressive strength of concrete deck
ts = s.ts; % Thickness of concrete deck
tf_top = s.tf_top(1); % Thickness of top flange (compression flange)
tf_bottom = s.tf_bottom(1); % Thickness of bottom flange (tension flange)
bf_top = s.bf_top(1); % Width of top flange (compression flange)
bf_bottom = s.bf_bottom(1); % Width of bottom flange (tension flange)
tw = s.tw; % Thickness of the web
dw = s.dw; % Depth of Web
be = s.be; % Effective width of concrete deck
dh = s.dh; % Depth of huanch

Ps = 0.85*(fc*be*ts + dh*bf_top); % Force in the concrete slab including haunch
Pc = bf_top*tf_top*Fy; % Force in the compression flange
Pw = dw*tw*Fy; % Force in web
Pt = bf_bottom*tf_bottom*Fy + 0.625*10.5*Fy; % Force in the tesnion flange

% If Pc+Pw+Pt > Ps, PNA in slab
% elseif Ps+Pc > Pw +Pt, PNA in top flange
% else, PNA in web

% Distance from top of top flange to NA of steel
A_bottom = bf_bottom*tf_bottom;
y_bottom = bf_bottom/2+dw+tf_top;
A_web = dw*tw;
y_web = dw/2+tf_top;
A_top = bf_top*tf_top;
y_top = tf_top/2;
y_steel = (A_bottom*y_bottom+A_web*y_web+A_top*y_top)/(A_bottom+A_web+A_top);

% Distance from top of slab to NA of slab/haunch
A_slab = be*ts;
y_slab = ts/2;
A_haunch = dh*bf_top;
y_haunch = ts + dh/2;
y_conc = (A_slab*y_slab+A_haunch*y_haunch)/(A_slab+A_haunch);

if Ps < Pc+Pw+Pt % PNA located in Steel and measured from top of top flange
    
    % comporessive force on top portion of steel section
    C = (Pc+Pw+Pt-Ps)/2; 
    
    if C < Pc % Neutral Axis in top flange
        
        % Plastic neutral axis and depth of web in compression
        PNA = (C/Pc)*tf_top;
        Dcp = 0;
        Dp = ts + PNA;
        
        % Moment Arms
        ds = ts/2 + PNA;
        dc = abs(tf_top/2 - PNA);
        dw = tf_top + dw/2 - PNA;
        dt = tf_bottom/2 + dw + (tf_top-PNA);
        
        % Plastic Moment
        Mp = Ps*ds + Pc*dc + Pw*dw + Pt*dt;
        
    else % Neutral Axis in web
        
        % Plastic neutral axis and depth of web in compression
        PNA = tf_top + ((C-Pc)/Pw)*dw;
        Dcp = PNA;
        Dp = ts + PNA;
        
        % Moment Arms
        ds = ts/2 + PNA;
        dc = PNA - tf_top/2;
        dw = tf_top + dw/2 - PNA;
        dt = tf_bottom/2 + dw + (tf_top-PNA);
        
        % Plastic Moment
        Mp = Ps*ds + Pc*dc + Pw*dw + Pt*dt;
        
    end
    
else % PNA located in slab and measured from top slab
    
    % Plastic neutral axis and depth of web in compression
    PNA = ts*((Pc+Pw+Pt)/Ps);
    Dcp = 0;
    Dp = PNA;
    
    % Moment Arms
    ds = abs(ts/2 - PNA);
    dc = tf_top/2 + ts - PNA;
    dw = tf_top + dw/2 + ts - PNA;
    dt = tf_bottom/2 + dw + tf_top + ts - PNA;
    
    % Plastic Neutral Axis
    Mp = Ps*ds + Pc*dc + Pw*dw + Pt*dt;
    
end

% Assign
% Section.PNA = PNA;
% Section.Dcp = Dcp;
s.Mp = Mp;
s.Dp = Dp;

end