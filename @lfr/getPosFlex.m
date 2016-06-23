function getPosFlex(r,s,sNeg,d)
%% LFR Positive Flexure 
%
% r -> lfr rating structure, implicit w/ dot notation
% s -> section class for positive flexure rating
% sNeg -> corresponding section class for negative rating region (this is
% required for LFR positive flexure ratings 
% d-> demands structure
%
% References: 
%   MBE Section 6 Appendix L6B
%   AASHTO Standard Specs Section 10
%
% refactored by jdv 06242016

    % Define & Calculate Variables
    Spans = s.nSpans;
    dh = s.dh;
    dw = s.dw;
    tw = s.tw;
    tf_tPos  = s.tf_top;
    bf_tPos  = s.bf_top;
    tf_bPos = s.tf_bot;
    bf_bPos = s.bf_bot;
    if Spans > 1
        tf_tNeg  = sNeg.tf_top;
        bf_tNeg  = sNeg.bf_top;
        tf_bNeg = sNeg.tf_bot;
        bf_bNeg = sNeg.bf_bot;
    end
    ts = s.ts; 
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
    My  = calculateFirstYieldMoment(s,d);
    
    
    %% Calculate plastic neutral axis and plastic moment
    [Mp, Dp, Dcp] = calculateSectionPlasticMoment(s);


    %% Calculate composite section compactness (pos. moment region)
    r.compactPos = determineCompositeSectionCompactness(s,Dp,Dcp);

    %% Calculate non-composite section compactness (neg. moment region)
    if Spans > 1
        r.compactNeg = determineNonCompositeSectionCompactness(s);   
    else
        r.compactNeg = 1; % Set to 1 if neg. region does not exist
    end

    %% Positive Moment Section Capcacity

    % MBE AL6B.2.1.2 - Compact/Composite (+), Compact/Non-Composite (-):
    % For composite positive moment sections in simple spans that satisfy the 
    % following requirements for compact sections, Mu is determined
    % using Equations 10-129b or 10-129c.

    if r.compactPos && r.compactNeg

        % for ductility
        D = B*(dw+tf_tPos+tf_bPos+ts+dh)/7.5;

        % AASHTO 10.129b
        if Dp <= D
            r.Mu_StrengthPos = Mp; % 
        end

        % AASHTO 10.129c
        if Dp <= 5*D && Dp > D
            r.Mu_StrengthPos = 0.25*(5*Mp - 0.85*My) + 0.25*(0.85*My - Mp)*(Dp/D);
        end
    
    elseif r.compactPos && ~r.compactNeg

        % AASHTO MBE Appendix L6B.2.1.2
        r.Fu_StrengthPos = Fy;

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
        r.Mu_StrengthPos = min(Mu);
    end

    % Service II
    r.Fu_ServicePos = 0.95*Fy;
end


%% COMPACTNESS CHECK - NON-COMPOSITE SECTION 10.48.1.1
function sectionCompact = determineNonCompositeSectionCompactness(s)

    % Define variables
    Fy = s.Fy;
    dw = s.dw;
    tw = s.tw;
    Lb = s.Lb;
    ry = s.ry;
    tf_tNeg  = s.tf_top; % removed s.tf_top(2) for next 4 vars
    bf_tNeg  = s.bf_top;
    tf_bNeg = s.tf_bot;
    bf_bNeg = s.bf_bot;

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
function sectionCompact = determineCompositeSectionCompactness(s,Dp,Dcp)

    % Define Variables
    Fy = s.Fy;
%     Dcp = s.Dcp;
    tw = s.tw;
    D = s.D;
%     Dp = s.Dp;

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
function My  = calculateFirstYieldMoment(s, d)

    % Define variables
    Fy = s.Fy;
    STnc = s.STnc;
    SBnc = s.SBnc;
    STlt = s.STlt;
    SBlt = s.SBlt;
    STst = s.STst;
    SBst = s.SBst;
    MDL_pos = d.MDL_pos;
    MSDL_pos = d.MSDL_pos;
    MSDW_pos = d.MSDW_pos;

    % Determine yield Moment of Composite Section in Positive Flexure for
    % Strength Limit State (Appendix D6.2.2)
    M_addc = min((Fy -(abs(1.25*MDL_pos)/STnc) - (abs(1.25*MSDL_pos)/STlt) - (abs(1.50*MSDW_pos)/STlt))*STst); % Additional moment needed for first yeild
    M_addt = min((Fy -(abs(1.25*MDL_pos)/SBnc) - (abs(1.25*MSDL_pos)/SBlt) - (abs(1.50*MSDW_pos)/SBlt))*SBst); % Additional moment needed for first yeild
    Myc = 1.25*(abs(MDL_pos)+abs(MSDL_pos)) + 1.50*(abs(MSDW_pos)) + M_addc; %lb-in, factored for strength
    Myt = 1.25*(abs(MDL_pos)+abs(MSDL_pos)) + 1.50*(abs(MSDW_pos)) + M_addt; %lb-in, factored for strength
    My = min(Myc, Myt); %lb-in
    % Myst = Fy*SBst;
end


function [Mp,Dp,Dcp] = calculateSectionPlasticMoment(s)
%% Determine Plastic Moment: AASHTO Specs 10.50.1

    % Define Variables
    Fy = s.Fy; % Yeild Strength of flanges and web [psi]
    fc = s.fc; % Compressive strength of concrete deck
    ts = s.ts; % Thickness of concrete deck
    tf_top = s.tf_top; % Thickness of top flange (compression flange)
    tf_bottom = s.tf_bot; % Thickness of bottom flange (tension flange)
    bf_top = s.bf_top; % Width of top flange (compression flange)
    bf_bottom = s.bf_bot; % Width of bottom flange (tension flange)
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

        % compressive force on top portion of steel section
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
end











