function Section = CalculateNegativeSectionResistance(Section)

% Define Variables

Fy = Section.steel_Fy; % Yeild Strength of flanges and web [psi]
Fyr = 0.7*Fy; % compression-flange stress at the onset of nominal yielding within the cross-section, including residual stress effects, but not including compression-flange lateral bending
E = Section.steel_E; % Young's Modulus [psi]   
bottomflange_t = Section.bottomflange_t; % Thickness of bottom flange (compression flange)
bottomflange_w = Section.bottomflange_w; % Width of bottom flange (tension flange)
web_t = Section.web_t; % Thickness of the web
web_d = Section.web_d; % Depth of Web
web_dcNC = Section.web_dcNC; %in Depth of web in compresstion in elastic range for non-composite section   
Rh = 1.0; % Hybrid factor (AASHTO LRFD Section 6.10.1.10.1)
Rb = 1.0; % Web Load-Shedding Factor (6.10.1.10.2)
Cb = 1.0;

% Compression flange (bottom flange in neg. moment region) is discretely braced for all RAMPS Models

% Web Bend-buckling Resistance (6.10.4.2.2 and 6.10.1.9.1)
k = 9/((web_dcNC/web_d)^2);
Section.Fcrw = (0.9*E*k)/((web_d/web_t)^2);

% Check compression flange local buckling resistence, AASHTO 6.10.8.2.2 (LB =  Local Buckling)
lf = bottomflange_w/(2*bottomflange_t); % slenderness ratio for the compression flange
Section.lf = lf;
lpf = 0.38*sqrt(E/Fy); %limiting slenderness ratio for a compact flange
Section.lpf = lpf;
lrf = 0.56*sqrt(E/Fyr); % limiting slenderness ratio for a noncompact flange
Section.lrf = lrf;

if lf <= lpf % Flange is compact
    Fnc_neg_LB = Rb*Rh*Fy;
else % Flange is non-compact
    Fnc_neg_LB = (1-(1-(Fyr/(Rh*Fy))*((lf-lpf)/(lrf-lpf))))*Rb*Rh*Fy;
end

% Check compression flange Lateral Torsional Buckling, AASHTO 6.10.8.2.3
% (LT = Lateral Torsional Buckling)
rt = bottomflange_w/sqrt(12*(1+((web_dcNC*web_t)/(3*bottomflange_w*bottomflange_t)))); % [inches] effective radius of gyration for lateral torsional buckling
Section.rt = rt;
Lp = 1.0*rt*sqrt(E/Fy); % [inches] limiting unbraced length to achieve the nominal flexural resistance of RbRhFyc under uniform bending
Section.Lp = Lp;
Lr = pi*rt*sqrt(E/Fyr); % [inches] limiting unbraced length to achieve the onset of nominal yielding in either flange under uniform bending with consideration of compressionflange residual stress effects
Section.Lr = Lr;

% Unbraced Length
Lb = Section.Lb;

if Lb <= Lp % Unbraced length is compact
    Fnc_neg_LT = Rb*Rh*Fy;
elseif Lb > Lp && Lb <= Lr % Unbraced Length is Non-Compact
    Fnc_neg_LT = Cb*(1-((1-(Fyr/(Rh*Fy)))*((Lb-Lp)/(Lr-Lp))))*Rb*Rh*Fy;
elseif Lb > Lr % Unbraced length is slender
    Fnc_neg_LT = (Cb*Rb*E*pi^2)/((Lb/rt)^2); % elastic lateral torsional buckling stress
end

% Save capacity without moment gradient modifier to beam
% (conservative)
Section.Fn_Strength1Neg = min(Fnc_neg_LB, Fnc_neg_LT);
Section.Fn_Service2Neg = 0.8*Fy;


end