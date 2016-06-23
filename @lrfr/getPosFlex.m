function r = getPosFlex(r,s,d)
% r = getPosFlex(s,d)
%
% *This version does not support negative haunch depths
%
% returned rating structure, r, contains:
% 
%
% Mn_Strength1Pos
% Fn_Service2Pos
% ductility
% compat % check if section is compact or not per 6.10.6.2.2
% 
%
% Originally created by NPR (nick.p.romano@gmail.com) 03/20/2016
% Refactored by jdv 05242016
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

    Rb = r.Rb; % hybrid factor from class lrfr
    Rh = r.Rh; % web load-shedding factor from class lrfr

    MDL_pos = d.MDL_pos; % Design non-composite dead load contribution (non-superimposed)
    MSDL_pos = d.MSDL_pos; % Design Composite dead laod contribution (superimposed)
    MSDW_pos = d.MSDW_pos; % Superimposed dead load fro wearing surface

    % Determine plastic moment and location of plastic netral axis
    [Mp, Dpst, Dcp, id] = r.getMp(s); % 
    
    Dp = Dpst; 
    
    % assign to r struct
%     r.Mp = Mp; r.Dpst = Dpst; r.Dcp =Dcp; r.id = id;
        
    % Check Ductility
    if Dpst <= 0.42*D
        r.ductility = 1;
    else
        r.ductility = 0;
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
               r.Mn_Strength1Pos = Mp;               
            else
               r.Mn_Strength1Pos = Mp*(1.07-(0.7*Dp/D)); 
            end
        else
            if Dp <= 0.1*D % AASHTO LRFD 6.10.7.1.2
               r.Mn_Strength1Pos = min(Mp, min(1.3*Rh*My));               
            else
               r.Mn_Strength1Pos = min(Mp*(1.07-0.7*Dp/D),min(1.3*Rh*My)); 
            end
        end
        r.compact = 1;
    else
        r.compact = 0;
        % Section is non-compact
        r.Fn_Strength1Pos = min(Fnc_pos, Fnt_pos);
    end

    % Service II
    r.Fn_Service2Pos = 0.95*Fy;
   

end

