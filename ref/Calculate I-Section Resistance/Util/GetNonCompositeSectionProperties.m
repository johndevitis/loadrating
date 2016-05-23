function s = GetNonCompositeSectionProperties(s)

% Define Variables
dw = s.dw;
tw = s.tw;
bf_top = s.bf_top;
tf_top = s.tf_top;
bf_bottom = s.bf_bottom;
tf_bottom = s.tf_bottom;

%%%%%%%%%%%%%%%%%% NON-COMPOSITE SECTION PROPERTIES %%%%%%%%%%%%%%%%%%%%

% Depth of web in compression in elastic range for non-composite section
dcNC = dw/2; %in 
s.dcNC = dcNC;

% Depth of steel section
d = dw + tf_top + tf_bottom;
s.d = d;

% Moment Arm
s.yTnc = d/2;
s.yBnc = d/2;

% Moments of Intertia
s.Ix = ((1/12)*tw*dw^3)+(((1/12)*(bf_top.*tf_top).^3)+((bf_top.*tf_top).*((dw+tf_top)/2).^2))+...
    (((1/12)*(bf_bottom.*tf_bottom).^3)+((bf_bottom.*tf_bottom).*((dw+tf_bottom)/2).^2));
s.Iy = (1/12)*(((tf_top.*bf_top).^3)+((tf_bottom.*bf_bottom).^3)+(dw*tw^3));

% Elastic Section Modulus
s.STnc = s.Ix./s.yTnc;
s.SBnc = s.Ix./s.yBnc;
s.S2 = s.Iy./(bf_bottom/2);

% Plastic Section modulous
flange_Ac = bf_bottom.*tf_bottom;
flange_yc = tf_bottom/2 + dw/2;
web_Ac = tw*dw/2;
web_yc = dw/2;

flange_At = bf_top.*tf_top;
flange_yt = tf_top/2 + dw/2;
web_At = tw*dw/2;
web_yt = dw/2;

s.Z = (flange_Ac.*flange_yc)+(web_Ac*web_yc) + (flange_At.*flange_yt)+(web_At*web_yt);

% Section Area
s.A = (bf_top.*tf_top)+(bf_bottom.*tf_bottom)+(dw*tw);

% effective radius of gyration for lateral torsional buckling
ry = bf_bottom./sqrt(12*(1+((dcNC*tw)./(3*(bf_bottom.*tf_bottom))))); % [inches] 
s.ry = ry;

end