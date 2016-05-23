function s = CalculatePositiveSectionResistance_LRFR(s,d)

% Created by NPR (nick.p.romano@gmail.com) 03/20/2016
% 
% *This version does not support negative haunch depths
%
%
%

% Define Variables
Spans = s.nSpans;
Fy = s.Fy; % Yeild Strength of flanges and web [psi]
Es = s.Es; % Young's Modulus [psi]   
tw = s.tw; % Thickness of the web
dw = s.dw; % Depth of Web
D = s.D; % [inches] Total depth of composite section   
STnc = s.STnc(1); % [in^3] Non-composite elastic section modulus measured from top flange
SBnc = s.SBnc(1); % [in^3] Non-composite elastic section modulus measured from bottom flange 
STlt = s.STlt(1); % [in^3] Long term composite elastic section modulus measured from top flange
SBlt = s.SBlt(1); % [in^3] Non-composite elastic section modulus measured from bottom flange
STst = s.STst(1); % [in^3] Short term composite elastic section modulus measured from top flange
SBst = s.SBst(1); % [in^3] Short term composite elastic section modulus measured from bottom flange
Rh = 1.0; % Hybrid factor (AASHTO LRFD Section 6.10.1.10.1)
Rb = 1.0; % Web Load-Shedding Factor (6.10.1.10.2)

MDL_pos = d.MDL_pos; % Design non-composite dead load contribution (non-superimposed)
MSDL_pos = d.MSDL_pos; % Design Composite dead laod contribution (superimposed)
MSDW_pos = d.MSDW_pos; % Superimposed dead load fro wearing surface

% Determine plastic moment and location of plastic netral axis
s = calculateSectionPlasticMoment(s);
Dcp = s.Dcp; % Depth of web in compression at plastic moment    
Dp = s.Dpst; % [inches] distance from the top of slab to PNA 

% Check Ductility
if s.Dpst <= 0.42*D
    Ductility = 'Ok';
else
    Ductility = 'No Good';
end

% Check if section is considered compact or non-compact. Compact sections shall satisfy the requirements of
% Article 6.10.7.1. Otherwise, the section shall be considered noncompact and shall satisfy the requirements
% of Article 6.10.7.2.
   
% Determine yield Moment of Composite Section in Positive Flexure for
% Strength Limit State (Appendix D6.2.2)
M_addc = min((Fy -(abs(1.25*MDL_pos)/STnc) - (abs(1.25*MSDL_pos)/STlt) - (abs(1.50*MSDW_pos)/STlt))*STst); % Additional moment needed for first yeild
M_addt = min((Fy -(abs(1.25*MDL_pos)/SBnc) - (abs(1.25*MSDL_pos)/SBlt) - (abs(1.50*MSDW_pos)/SBlt))*SBst); % Additional moment needed for first yeild
Myc = 1.25*(abs(MDL_pos)+abs(MSDL_pos)) + 1.50*(abs(MSDW_pos)) + M_addc; %lb-in, factored for strength
Myt = 1.25*(abs(MDL_pos)+abs(MSDL_pos)) + 1.50*(abs(MSDW_pos)) + M_addt; %lb-in, factored for strength
My = min(Myc, Myt); %lb-in

% Define nominal flexural resistence variables for Non-Compact Case
Fnc_pos = Rb*Rh*Fy; % nominal flexural resistance of the compression flange determined as specified in Article 6.10.7.2.2 
Fnt_pos = Rh*Fy; % nominal flexural resistance of the tension flange determined as specified in Article 6.10.7.2.2

% Is section compact?
CompCheck1= dw/tw;
CompCheck2 = 2*Dcp/tw;
CompCheck3 = 3.76*sqrt(Es/Fy);

if CompCheck1 <= 150 && CompCheck2 <= CompCheck3 % Section is Compact (AASHTO LRFD 6.10.6.2.2)
    if Spans == 1
        if Dp <= 0.1*D % AASHTO LRFD 6.10.7.1.2
           s.Mn_Strength1Pos = s.Mp;               
        else
           s.Mn_Strength1Pos = s.Mp*(1.07-(0.7*Dp/D)); 
        end
    else
        if Dp <= 0.1*D % AASHTO LRFD 6.10.7.1.2
           s.Mn_Strength1Pos = min(s.Mp, min(1.3*Rh*My));               
        else
           s.Mn_Strength1Pos = min(s.Mp*(1.07-0.7*Dp/D),min(1.3*Rh*My)); 
        end
    end
    Compact = 'Compact';
else
    Compact = 'Non-Compact';
    % Section is non-compact
    s.Fn_Strength1Pos = min(Fnc_pos, Fnt_pos);
end

% Service II
s.Fn_Service2Pos = 0.95*Fy;

% Assign
s.Ductility = Ductility;
s.Compact = Compact;

end

function s = calculateSectionPlasticMoment(s)

% Determine Plastic Moment: AASHTO LRFD Manual Appendix D6

% Define Variables
Fy = s.Fy; % Yeild Strength of flanges and web [psi]
fc = s.fc; % Compressive strength of concrete deck
ts = s.ts; % Thickness of concrete deck
tf_top = s.tf_top(1); % Thickness of top flange (compression flange)
tf_bottom = s.tf_bottom(1); % Thickness of both top flange (tension flange)
bf_top = s.bf_top(1); % Width of top flange (compression flange)
bf_bottom = s.bf_bottom(1); % Width of bottom flange (tension flange)
tw = s.tw; % Thickness of the web
dweb = s.dw; % Depth of Web
D = s.D; % [inches] Total depth of composite section   
be = s.be; % Effective width of concrete deck
dh = s.dh; % Depth of huanch

% Calculate plastic forces
Ps = .85*fc*be*ts; % Plastic Force for slab [lbs]
Pc = Fy*tf_top*bf_top; % Plastic Force for compression flange [lbs]
Pw = Fy*tw*dweb; % Plastic Force for web [lbs]
Pt = Fy*tf_bottom*bf_bottom; % Plastic Force for tension flange [lbs]

% Calculate plastic moment and location of plastic neutral axis.
% (Reference AASHTO Appendix D6)
A = Pt + Pw;
B = Pc + Pw + Pt;
C = Pc + Ps;

if dh < 0
    % Is plastic neutral axis located in the slab?
    if Ps/ts*(ts+dh) > B % PNA located in slab and measured measured from top of slab
        PNAst = ts*((Pc+Pt+Pw)/Ps); % [inches] location of PNA from top of slab 
        dc = (tf_top/2)+dh+(ts-PNAst); % [inches] distance from comp. flange NA to PNA
        dw = (dweb/2)+tf_top+dh+(ts-PNAst); % [inches] distance from web NA to PNA
        dt = (tf_bottom/2)+dweb+tf_top+dh+(ts-PNAst); % [inches] distance from tens. flange NA to PNA
        Mp = (((PNAst^2)*Ps)/(2*ts))+(Pc*dc+Pt*dt+Pw*dw); % [lb-in] Case 3-7 in AD6
        s.Mp = Mp; %Plastic moment of the composite section
        s.Dpst = PNAst; % [inches] distance from the top of slab to PNA 
        s.Dcp = 0; % depth of the web in compression at the plastic moment
    elseif Ps/ts*(ts+dh+tf_top)+Pc > A 
        PNAst = (Pw+Pt+Pc-Ps*(1+dh/ts))/(Ps/ts+2*Pc/tf_top); % [inches] location of PNA from top of flange 
        ds = (ts+dh+PNAst)/2; % [inches] distance from slab NA to PNA
        dw = (dweb/2)+(tf_top-PNAst); % [inches] distance from web NA to PNA
        dt = (tf_top/2)+dweb+(tf_top-PNAst); % [inches] distance from tens. flange NA to PNA
        Mp = (Pc/(2*tf_top))*(PNAst^2+(tf_top-PNAst)^2)+(Ps/ts*(ts+dh+PNAst)*ds+Pw*dw+Pt*dt); % [lb-in] Case 2 in AD6
        s.Mp = Mp; %Plastic moment of the composite section
        s.Dpst = PNAst+ts+dh; % [inches] distance from the top of slab to PNA 
        s.Dcp = 0; % depth of the web in compression at the plastic moment
    elseif Ps+Pc-Pw/dweb*(dh+tf_top)>Pt+Pw/dweb*(dweb+dh+tf_top) 
        PNAst = (Pw+Pt-Pc-Ps*(1+dh/ts+tf_top/ts))/(Ps/ts+2*Pw/dweb); % [inches] location of PNA from bottom of top flange 
        ds = (ts+dh+tf_top+PNAst)/2; % [inches] distance from slab NA to PNA
        dc = (tf_top/2)+PNAst; % [inches] distance from comp. flange NA to PNA
        dt = (tf_top/2)+dweb-PNAst; % [inches] distance from tens. flange NA to PNA
        Mp = (Pw/(2*dweb))*(PNAst^2+((dweb-PNAst)^2))+(Ps/ts*(ts+dh+tf_top+PNAst)*ds+Pc*dc+Pt*dt); % [lb-in] Case 1 in AD6
        s.Mp = Mp; %Plastic moment of the composite section
        s.Dpst = PNAst+ts+dh+tf_top; % [inches] distance from the top of slab to PNA 
        s.Dcp = PNAst; % Depth of web in compression at plastic moment
    else % In web
        PNAst = (dweb/2)*(((Pt-Pc-Ps)/Pw)+1); % [inches] location of PNA from bottom of top flange 
        ds = (ts/2)+dh+tf_top+PNAst; % [inches] distance from slab NA to PNA
        dc = (tf_top/2)+PNAst; % [inches] distance from comp. flange NA to PNA
        dt = (tf_top/2)+dweb-PNAst; % [inches] distance from tens. flange NA to PNA
        Mp = (Pw/(2*dweb))*(PNAst^2+((dweb-PNAst)^2))+(Ps*ds+Pc*dc+Pt*dt); % [lb-in] Case 1 in AD6
        s.Mp = Mp; %Plastic moment of the composite section
        s.Dpst = PNAst+ts+dh+tf_top; % [inches] distance from the top of slab to PNA 
        s.Dcp = PNAst; % Depth of web in compression at plastic moment
    end
else
    if Ps > B % PNA located in slab and measured measured from top of slab
        PNAst = ts*((Pc+Pt+Pw)/Ps); % [inches] location of PNA from top of slab 
        dc = (tf_top/2)+dh+(ts-PNAst); % [inches] distance from comp. flange NA to PNA
        dw = (dweb/2)+tf_top+dh+(ts-PNAst); % [inches] distance from web NA to PNA
        dt = (tf_top/2)+dweb+tf_top+dh+(ts-PNAst); % [inches] distance from tens. flange NA to PNA
        Mp = (((PNAst^2)*Ps)/(2*ts))+(Pc*dc+Pt*dt+Pw*dw); % [lb-in] Case 3-7 in AD6
        s.Mp = Mp; %Plastic moment of the composite section
        s.Dpst = PNAst; % [inches] distance from the top of slab to PNA 
        s.Dcp = 0; % depth of the web in compression at the plastic moment
    % Is the plastic neutral axis in the top flange?
    elseif C > A % PNA located in top flange and measured from top of flange
        PNAst = (tf_top/2)*(((Pw+Pt-Ps)/Pc)+1); % [inches] location of PNA from top of flange 
        ds = (ts/2)+dh+PNAst; % [inches] distance from slab NA to PNA
        dw = (dweb/2)+(tf_top-PNAst); % [inches] distance from web NA to PNA
        dt = (tf_top/2)+dweb+(tf_top-PNAst); % [inches] distance from tens. flange NA to PNA
        Mp = (Pc/(2*tf_top))*(PNAst^2+(tf_top-PNAst)^2)+(Ps*ds+Pw*dw+Pt*dt); % [lb-in] Case 2 in AD6
        s.Mp = Mp; %Plastic moment of the composite section
        s.Dpst = PNAst+ts+dh; % [inches] distance from the top of slab to PNA 
        s.Dcp = 0; % depth of the web in compression at the plastic moment
    % Is the plastic neutral axis in the web?
    else % A>C and PNA in web measured from bottom of top flange
        PNAst = (dweb/2)*(((Pt-Pc-Ps)/Pw)+1); % [inches] location of PNA from bottom of top flange 
        ds = (ts/2)+dh+tf_top+PNAst; % [inches] distance from slab NA to PNA
        dc = (tf_top/2)+PNAst; % [inches] distance from comp. flange NA to PNA
        dt = (tf_top/2)+dweb-PNAst; % [inches] distance from tens. flange NA to PNA
        Mp = (Pw/(2*dweb))*(PNAst^2+((dweb-PNAst)^2))+(Ps*ds+Pc*dc+Pt*dt); % [lb-in] Case 1 in AD6
        s.Mp = Mp; %Plastic moment of the composite section
        s.Dpst = PNAst+ts+dh+tf_top; % [inches] distance from the top of slab to PNA 
        s.Dcp = PNAst; % Depth of web in compression at plastic moment
    end
end

end