function getNegFlex(r,s)
%% LFR Negative Flexure 
%
% References: 
%   MBE Section 6 Appendix L6B
%   AASHTO Standard Specs Section 10
%
% refactored by jdv 06242016


    % Define & Calculate Variables
    Spans = s.nSpans;
    dw = s.dw;
    tw = s.tw;
    tf_tNeg  = s.tf_top;
    bf_tNeg  = s.bf_top;
    tf_bNeg = s.tf_bot;
    bf_bNeg = s.bf_bot;
    ts = s.ts; % Thickness of concrete deck
    STnc = s.STnc;
    SBnc = s.SBnc;
    dcNC = s.dcNC;
    D = s.D;
    Fy = s.Fy;
    Lb = s.Lb;
    Z = s.Z;

    % Calculate non-composite section compactness (neg. moment region)
    negRegionCompact = determineNonCompositeSectionCompactness(s);
    % s.NegRegionCompact = negRegionCompact;

    % Negative Moment Section Capacity
    % For continuous spans with compact non-composite negative-moment pier sections: 

    % AASHTO MBE Appendix L6B.2.1.3
    if negRegionCompact
        % AASHTO LFD 10-92
        r.Mu_StrengthNeg = Fy*Z;
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
        if dcNC <= D/2
            lmbda = 15400;
        else
            lmbda = 12500;
        end

        % Flange stress reduction factor, Rb 
        Fcr = (4400*tf_bNeg/bf_bNeg)^2;
        Afc = tf_bNeg*bf_bNeg;
        Rb = 1- 0.002*(dcNC*tw/Afc)*((dcNC/tw)-(lmbda/sqrt(Fcr))); % 10-103b

        if braced
            % For braced Non-compact section at pier if continous (10.48.2)
            Mu_pier(1) = Fy*STnc; % 10-98
            Mu_pier(2) = Fcr*SBnc*Rb; % 10-99
            r.Fu_StrengthNeg = min(Mu_pier)/SBnc;
        else   
            % Calculate lateral torsional buckling moment
            Mr = calculateLTBMoment(s);

            % For partially braced Non-compact section at pier if continous (10.48.4)
            r.Fu_StrengthNeg = min(Mr*Rb, Fcr*SBnc*Rb)/SBnc; % 10-103a
        end
    end

    % Service
    r.Fu_ServiceNeg = 0.8*Fy;

end


function sectionCompact = determineNonCompositeSectionCompactness(s)
%% COMPACTNESS CHECK - NON-COMPOSITE SECTION 10.48.1.1
    % Define variables
    Fy = s.Fy;
    dw = s.dw;
    tw = s.tw;
    Lb = s.Lb;
    ry = s.ry;
    tf_tNeg  = s.tf_top;
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


% FIX ME PLEASE! - updated 06242016, did that do it? 
function Mr = calculateLTBMoment(s)
%% CALCULATE LATERAL TORSIONAL BUCKLING MOMENT 

    % Define variables
    dcNC = s.dcNC;
    tw = s.tw;
    Fy = s.Fy;
    Iyc = s.Iyc;
    Lb = s.Lb;
    J = s.J;
    d = s.d;
    ry = s.ry; % NOTE: radius of gyration comes from LRFR - verify for LFR
    SBnc = s.SBnc;
    Cb = 1.0;  % NOTE: Cb is statically defined, need to change
    D = s.D;
    tf_tNeg = s.tf_top;
    tf_bNeg = s.tf_bot;

    % Moment at first yield
    My = Fy*SBnc;

    % Lambda variable
    if dcNC <= D/2
        lmbda = 15400;
    else
        lmbda = 12500;
    end

    if dcNC/tw <= lmbda/sqrt(Fy)
        % AASHTO 10-103c
        Mr = 91*(10^6)*Cb*(Iyc/Lb)*sqrt(0.772*(J/Iyc)+9.87*(d/Lb)^2);
    else
        Lp = 9500*ry/sqrt(Fy); % NOTE: changed rt -> ry
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







