function getNegFlex(r,s)
%%
%
%
%
% jdv 06222016

    % Define Variables
    Fy = s.Fy; % Yeild Strength of flanges and web [psi]
    Fyr = 0.7*Fy; % compression-flange stress at the onset of nominal yielding within the cross-section, including residual stress effects, but not including compression-flange lateral bending
    Es = s.Es; % Young's Modulus [psi]   
    tf_bot = s.tf_bot; % Thickness of bottom flange (compression flange)
    bf_bot = s.bf_bot; % Width of bottom flange (tension flange)
    % tw = s.tw; % Thickness of the web
    % dw = s.dw; % Depth of Web
    ry = s.ry; % Radius of gyration
    % dcNC = s.dcNC; %in Depth of web in compresstion in elastic range for non-composite section   
    Rh = 1.0; % Hybrid factor (AASHTO LRFD Section 6.10.1.10.1)
    Rb = 1.0; % Web Load-Shedding Factor (6.10.1.10.2)
    Cb = 1.0;
    % Unbraced Length
    Lb = s.Lb;
    
    % Compression flange (bottom flange in neg. moment region) is discretely braced for all RAMPS Models

    % Web Bend-buckling Resistance (6.10.4.2.2 and 6.10.1.9.1)
    % k = 9/((dcNC/dw)^2);
    % Fcrw = (0.9*Es*k)/((dw/tw)^2);

    % Check compression flange local buckling resistence, AASHTO 6.10.8.2.2 (LB =  Local Buckling)
    lf = bf_bot/(2*tf_bot); % slenderness ratio for the compression flange
    lpf = 0.38*sqrt(Es/Fy); %limiting slenderness ratio for a compact flange

    lrf = 0.56*sqrt(Es/Fyr); % limiting slenderness ratio for a noncompact flange

    if lf <= lpf % Flange is compact
        Fnc_neg_LB = Rb*Rh*Fy;
    else % Flange is non-compact
        Fnc_neg_LB = (1-(1-(Fyr/(Rh*Fy))*((lf-lpf)/(lrf-lpf))))*Rb*Rh*Fy;
    end

    % Check compression flange Lateral Torsional Buckling, AASHTO 6.10.8.2.3
    % (LT = Lateral Torsional Buckling)
    Lp = 1.0*ry*sqrt(Es/Fy); % [inches] limiting unbraced length to achieve the nominal flexural resistance of RbRhFyc under uniform bending
    Lr = pi*ry*sqrt(Es/Fyr); % [inches] limiting unbraced length to achieve the onset of nominal yielding in either flange under uniform bending with consideration of compressionflange residual stress effects

    if Lb <= Lp % Unbraced length is compact
        Fnc_neg_LT = Rb*Rh*Fy;
    elseif Lb > Lp && Lb <= Lr % Unbraced Length is Non-Compact
        Fnc_neg_LT = Cb*(1-((1-(Fyr/(Rh*Fy)))*((Lb-Lp)/(Lr-Lp))))*Rb*Rh*Fy;
    elseif Lb > Lr % Unbraced length is slender
        Fnc_neg_LT = (Cb*Rb*Es*pi^2)/((Lb/ry)^2); % elastic lateral torsional buckling stress
    end

    % Save capacity without moment gradient modifier to beam
    % (conservative)
    r.Fn_Strength1Neg = min(Fnc_neg_LB, Fnc_neg_LT);
    r.Fn_Service2Neg = 0.8*Fy;



end