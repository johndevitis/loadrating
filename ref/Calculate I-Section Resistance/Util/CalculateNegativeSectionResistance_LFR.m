function s = CalculateNegativeSectionResistance_LFR(s)

% Calculate LFR Resistance
% References: MBE Section 6 Appdneix L6B, AASHTO Standard Specs Section 10


%% Define & Calculate Variables
Spans = s.nSpans;
dw = s.dw;
tw = s.tw;
tf_tNeg  = s.tf_top(2);
bf_tNeg  = s.bf_top(2);
tf_bNeg = s.tf_bottom(2);
bf_bNeg = s.bf_bottom(2);
ts = s.ts; % Thickness of concrete deck
STnc = s.STnc(2);
SBnc = s.SBnc(2);
dcNC = s.dcNC;
D = s.D;
Fy = s.Fy;
Lb = s.Lb(2);
Z = s.Z(2);


%% Calculate non-composite section compactness (neg. moment region)
negRegionCompact = determineNonCompositeSectionCompactness(s);
% s.NegRegionCompact = negRegionCompact;

%% Negative Moment Section Capacity

% For continuous spans with compact non-composite negative-moment pier sections: 

% AASHTO MBE Appendix L6B.2.1.3
if negRegionCompact

    % AASHTO LFD 10-92
    s.Mu_StrengthNeg = Fy*Z;

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
        s.Fu_StrengthNeg = min(Mu_pier)/SBnc;

    else   

        % Calculate lateral torsional buckling moment
        s = calculateLTBMoment(s);
        Mr = s.Mr;

        % For partially braced Non-compact section at pier if continous (10.48.4)
        s.Fu_StrengthNeg = min(Mr*Rb, Fcr*SBnc*Rb)/SBnc; % 10-103a

    end
end

% Service
s.Fu_ServiceNeg = 0.8*Fy;
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


%% CALCULATE LATERAL TORSIONAL BUCKLING MOMENT 
function Section = calculateLTBMoment(Section)

if dcNC/tw <= lmbda/sqrt(Fy)
    % AASHTO 10-103c
    Section.Mr = 91*(10^6)*Cb*(Iyc/Lb)*sqrt(0.772*(J/Iyc)+9.87*(d/Lb)^2);
else
    Lp = 9500*rt/sqrt(Fy);
    Lr = sqrt((572*(10^6)*Iyc*(dw+tf_tNeg+tf_bNeg))/(Fy*SBnc)); % 10-103f
    if Lb > Lr
        % AASHTO 10-103g
        Section.Mr = Cb*(Fy*SBnc/2)*(Lr/Lb)^2;
    elseif Lb > Lp
        % AASHTO 10-103e
        Section.Mr = Cb*Fy*SBnc*(1-0.5*((Lb-Lp)/(Lr-Lp)));
    else
        % AASHTO 10-103d
        Section.Mr = My;
    end
end
end



