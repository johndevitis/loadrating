function Section = CalculatePositiveSectionResistance(Section,Demands,Spans)

% Created by NPR (nick.p.romano@gmail.com) 03/20/2016
% 
% *This version does not support negative haunch depths
%
%
%

% Define Variables
Fy = Section.steel_Fy; % Yeild Strength of flanges and web [psi]
E = Section.steel_E; % Young's Modulus [psi]   
web_t = Section.web_t; % Thickness of the web
web_d = Section.web_d; % Depth of Web
D_total = Section.D_total; % [inches] Total depth of composite section   
STnc = Section.STnc; % [in^3] Non-composite elastic section modulus measured from top flange
SBnc = Section.SBnc; % [in^3] Non-composite elastic section modulus measured from bottom flange 
STlt = Section.STlt; % [in^3] Long term composite elastic section modulus measured from top flange
SBlt = Section.SBlt; % [in^3] Non-composite elastic section modulus measured from bottom flange
STst = Section.STst; % [in^3] Short term composite elastic section modulus measured from top flange
SBst = Section.SBst; % [in^3] Short term composite elastic section modulus measured from bottom flange
Rh = 1.0; % Hybrid factor (AASHTO LRFD Section 6.10.1.10.1)
Rb = 1.0; % Web Load-Shedding Factor (6.10.1.10.2)

MDL_pos = Demands.MDL_pos; % Design non-composite dead load contribution (non-superimposed)
MSDL_pos = Demands.MSDL_pos; % Design Composite dead laod contribution (superimposed)
MSDW_pos = Demands.MSDW_pos; % Superimposed dead load fro wearing surface

% Determine plastic moment and location of plastic netral axis
Section = calculateSectionPlasticMoment(Section);
Dcp = Section.Dcp; % Depth of web in compression at plastic moment    
Dp = Section.Dpst; % [inches] distance from the top of slab to PNA  

% Check if section is considered compact or non-compact. Compact sections shall satisfy the requirements of
% Article 6.10.7.1. Otherwise, the section shall be considered noncompact and shall satisfy the requirements
% of Article 6.10.7.2.
   
% Determine yield Moment of Composite Section in Positive Flexure for
% Strength Limit State (Appendix D6.2.2)
Section.M_addc = min((Fy -(abs(1.25*MDL_pos)/STnc) - (abs(1.25*MSDL_pos)/STlt) - (abs(1.50*MSDW_pos)/STlt))*STst); % Additional moment needed for first yeild
Section.M_addt = min((Fy -(abs(1.25*MDL_pos)/SBnc) - (abs(1.25*MSDL_pos)/SBlt) - (abs(1.50*MSDW_pos)/SBlt))*SBst); % Additional moment needed for first yeild
Section.Myc = 1.25*(abs(MDL_pos)+abs(MSDL_pos)) + 1.50*(abs(MSDW_pos)) + Section.M_addc; %lb-in, factored for strength
Section.Myt = 1.25*(abs(MDL_pos)+abs(MSDL_pos)) + 1.50*(abs(MSDW_pos)) + Section.M_addt; %lb-in, factored for strength
Section.My = min(Section.Myc, Section.Myt); %lb-in
Section.Myst = Fy*SBst;

% Define nominal flexural resistence variables for Non-Compact Case
Section.Fnc_pos = Rb*Rh*Fy; % nominal flexural resistance of the compression flange determined as specified in Article 6.10.7.2.2 
Section.Fnt_pos = Rh*Fy; % nominal flexural resistance of the tension flange determined as specified in Article 6.10.7.2.2

% Is section compact?
CompCheck1= web_d/web_t;
CompCheck2 = 2*Dcp/web_t;
CompCheck3 = 3.76*sqrt(E/Fy);

if CompCheck1 <= 150 && CompCheck2 <= CompCheck3 % Section is Compact (AASHTO LRFD 6.10.6.2.2)
    if Spans == 1
        if Dp <= 0.1*D_total % AASHTO LRFD 6.10.7.1.2
           Section.Mn_Strength1Pos = Section.Mp;               
        else
           Section.Mn_Strength1Pos = Section.Mp*(1.07-(0.7*Dp/D_total)); 
        end
    else
        if Dp <= 0.1*D_total % AASHTO LRFD 6.10.7.1.2
           Section.Mn_Strength1Pos = min(Section.Mp, min(1.3*Rh*Section.My));               
        else
           Section.Mn_Strength1Pos = min(Section.Mp*(1.07-0.7*Dp/D_total),min(1.3*Rh*Section.My)); 
        end
    end
    Section.Compact = 1;
else
    Section.Compact = 0;
end

% Section is non-compact
Section.Fn_Strength1Pos = min(Section.Fnc_pos, Section.Fnt_pos);

% Service II
Section.Fn_Service2Pos = 0.95*Fy;


end

function Section = calculateSectionPlasticMoment(Section)

% Determine Plastic Moment: AASHTO LRFD Manual Appendix D6

% Define Variables
steel_Fy = Section.steel_Fy; % Yeild Strength of flanges and web [psi]
concrete_fc = Section.concrete_fc; % Compressive strength of concrete deck
deck_t = Section.deck_t; % Thickness of concrete deck
topflange_t = Section.topflange_t; % Thickness of top flange (compression flange)
bottomflange_t = Section.bottomflange_t; % Thickness of both top flange (tension flange)
topflange_w = Section.topflange_w; % Width of top flange (compression flange)
bottomflange_w = Section.bottomflange_w; % Width of bottom flange (tension flange)
web_t = Section.web_t; % Thickness of the web
web_d = Section.web_d; % Depth of Web
D_total = Section.D_total; % [inches] Total depth of composite section   
deck_be = Section.deck_be; % Effective width of concrete deck
haunch_d = Section.haunch_d; % Depth of huanch

% Calculate plastic forces
Section.Ps = .85*concrete_fc*deck_be*deck_t; % Plastic Force for slab [lbs]
Section.Pc = steel_Fy*topflange_t*topflange_w; % Plastic Force for compression flange [lbs]
Section.Pw = steel_Fy*web_t*web_d; % Plastic Force for web [lbs]
Section.Pt = steel_Fy*bottomflange_t*bottomflange_w; % Plastic Force for tension flange [lbs]

% Calculate plastic moment and location of plastic neutral axis.
% (Reference AASHTO Appendix D6)
A = Section.Pt + Section.Pw;
B = Section.Pc + Section.Pw + Section.Pt;
C = Section.Pc + Section.Ps;

if haunch_d < 0
    % Is plastic neutral axis located in the slab?
    if Section.Ps/deck_t*(deck_t+haunch_d) > B % PNA located in slab and measured measured from top of slab
        PNAst = deck_t*((Section.Pc+Section.Pt+Section.Pw)/Section.Ps); % [inches] location of PNA from top of slab 
        Section.dc = (topflange_t/2)+haunch_d+(deck_t-PNAst); % [inches] distance from comp. flange NA to PNA
        Section.dw = (web_d/2)+topflange_t+haunch_d+(deck_t-PNAst); % [inches] distance from web NA to PNA
        Section.dt = (bottomflange_t/2)+web_d+topflange_t+haunch_d+(deck_t-PNAst); % [inches] distance from tens. flange NA to PNA
        Mp = (((PNAst^2)*Section.Ps)/(2*deck_t))+(Section.Pc*Section.dc+Section.Pt*Section.dt+Section.Pw*Section.dw); % [lb-in] Case 3-7 in AD6
        Section.Mp = Mp; %Plastic moment of the composite section
        Section.Dpst = PNAst; % [inches] distance from the top of slab to PNA 
        Section.Dcp = 0; % depth of the web in compression at the plastic moment
    elseif Section.Ps/deck_t*(deck_t+haunch_d+topflange_t)+Section.Pc > A 
        PNAst = (Section.Pw+Section.Pt+Section.Pc-Section.Ps*(1+haunch_d/deck_t))/(Section.Ps/deck_t+2*Section.Pc/topflange_t); % [inches] location of PNA from top of flange 
        ds = (deck_t+haunch_d+PNAst)/2; % [inches] distance from slab NA to PNA
        Section.dw = (web_d/2)+(topflange_t-PNAst); % [inches] distance from web NA to PNA
        Section.dt = (topflange_t/2)+web_d+(topflange_t-PNAst); % [inches] distance from tens. flange NA to PNA
        Mp = (Section.Pc/(2*topflange_t))*(PNAst^2+(topflange_t-PNAst)^2)+(Section.Ps/deck_t*(deck_t+haunch_d+PNAst)*ds+Section.Pw*Section.dw+Section.Pt*Section.dt); % [lb-in] Case 2 in AD6
        Section.Mp = Mp; %Plastic moment of the composite section
        Section.Dpst = PNAst+deck_t+haunch_d; % [inches] distance from the top of slab to PNA 
        Section.Dcp = 0; % depth of the web in compression at the plastic moment
    elseif Section.Ps+Section.Pc-Section.Pw/web_d*(haunch_d+topflange_t)>Section.Pt+Section.Pw/web_d*(web_d+haunch_d+topflange_t) 
        PNAst = (Section.Pw+Section.Pt-Section.Pc-Section.Ps*(1+haunch_d/deck_t+topflange_t/deck_t))/(Section.Ps/deck_t+2*Section.Pw/web_d); % [inches] location of PNA from bottom of top flange 
        ds = (deck_t+haunch_d+topflange_t+PNAst)/2; % [inches] distance from slab NA to PNA
        Section.dc = (topflange_t/2)+PNAst; % [inches] distance from comp. flange NA to PNA
        Section.dt = (topflange_t/2)+web_d-PNAst; % [inches] distance from tens. flange NA to PNA
        Mp = (Section.Pw/(2*web_d))*(PNAst^2+((web_d-PNAst)^2))+(Section.Ps/deck_t*(deck_t+haunch_d+topflange_t+PNAst)*ds+Section.Pc*Section.dc+Section.Pt*Section.dt); % [lb-in] Case 1 in AD6
        Section.Mp = Mp; %Plastic moment of the composite section
        Section.Dpst = PNAst+deck_t+haunch_d+topflange_t; % [inches] distance from the top of slab to PNA 
        Section.Dcp = PNAst; % Depth of web in compression at plastic moment
    else % In web
        PNAst = (web_d/2)*(((Section.Pt-Section.Pc-Section.Ps)/Section.Pw)+1); % [inches] location of PNA from bottom of top flange 
        ds = (deck_t/2)+haunch_d+topflange_t+PNAst; % [inches] distance from slab NA to PNA
        Section.dc = (topflange_t/2)+PNAst; % [inches] distance from comp. flange NA to PNA
        Section.dt = (topflange_t/2)+web_d-PNAst; % [inches] distance from tens. flange NA to PNA
        Mp = (Section.Pw/(2*web_d))*(PNAst^2+((web_d-PNAst)^2))+(Section.Ps*ds+Section.Pc*Section.dc+Section.Pt*Section.dt); % [lb-in] Case 1 in AD6
        Section.Mp = Mp; %Plastic moment of the composite section
        Section.Dpst = PNAst+deck_t+haunch_d+topflange_t; % [inches] distance from the top of slab to PNA 
        Section.Dcp = PNAst; % Depth of web in compression at plastic moment
    end
else
    if Section.Ps > B % PNA located in slab and measured measured from top of slab
        PNAst = deck_t*((Section.Pc+Section.Pt+Section.Pw)/Section.Ps); % [inches] location of PNA from top of slab 
        Section.dc = (topflange_t/2)+haunch_d+(deck_t-PNAst); % [inches] distance from comp. flange NA to PNA
        Section.dw = (web_d/2)+topflange_t+haunch_d+(deck_t-PNAst); % [inches] distance from web NA to PNA
        Section.dt = (topflange_t/2)+web_d+topflange_t+haunch_d+(deck_t-PNAst); % [inches] distance from tens. flange NA to PNA
        Mp = (((PNAst^2)*Section.Ps)/(2*deck_t))+(Section.Pc*Section.dc+Section.Pt*Section.dt+Section.Pw*Section.dw); % [lb-in] Case 3-7 in AD6
        Section.Mp = Mp; %Plastic moment of the composite section
        Section.Dpst = PNAst; % [inches] distance from the top of slab to PNA 
        Section.Dcp = 0; % depth of the web in compression at the plastic moment
    % Is the plastic neutral axis in the top flange?
    elseif C > A % PNA located in top flange and measured from top of flange
        PNAst = (topflange_t/2)*(((Section.Pw+Section.Pt-Section.Ps)/Section.Pc)+1); % [inches] location of PNA from top of flange 
        ds = (deck_t/2)+haunch_d+PNAst; % [inches] distance from slab NA to PNA
        Section.dw = (web_d/2)+(topflange_t-PNAst); % [inches] distance from web NA to PNA
        Section.dt = (topflange_t/2)+web_d+(topflange_t-PNAst); % [inches] distance from tens. flange NA to PNA
        Mp = (Section.Pc/(2*topflange_t))*(PNAst^2+(topflange_t-PNAst)^2)+(Section.Ps*ds+Section.Pw*Section.dw+Section.Pt*Section.dt); % [lb-in] Case 2 in AD6
        Section.Mp = Mp; %Plastic moment of the composite section
        Section.Dpst = PNAst+deck_t+haunch_d; % [inches] distance from the top of slab to PNA 
        Section.Dcp = 0; % depth of the web in compression at the plastic moment
    % Is the plastic neutral axis in the web?
    else % A>C and PNA in web measured from bottom of top flange
        PNAst = (web_d/2)*(((Section.Pt-Section.Pc-Section.Ps)/Section.Pw)+1); % [inches] location of PNA from bottom of top flange 
        ds = (deck_t/2)+haunch_d+topflange_t+PNAst; % [inches] distance from slab NA to PNA
        Section.dc = (topflange_t/2)+PNAst; % [inches] distance from comp. flange NA to PNA
        Section.dt = (topflange_t/2)+web_d-PNAst; % [inches] distance from tens. flange NA to PNA
        Mp = (Section.Pw/(2*web_d))*(PNAst^2+((web_d-PNAst)^2))+(Section.Ps*ds+Section.Pc*Section.dc+Section.Pt*Section.dt); % [lb-in] Case 1 in AD6
        Section.Mp = Mp; %Plastic moment of the composite section
        Section.Dpst = PNAst+deck_t+haunch_d+topflange_t; % [inches] distance from the top of slab to PNA 
        Section.Dcp = PNAst; % Depth of web in compression at plastic moment
    end
end

% Check Ductility
if Section.Dpst <= 0.42*D_total
    Section.Ductility = 'Ok';
else
    Section.Ductility = 'No Good';
end

end