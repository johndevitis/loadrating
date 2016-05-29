function [Vn,Vp] = getShear(s,panel,location)
% [Vn, Vp] = getShear(s,panel,location)
%
% Inputs: 
%  s - section properties
%  panel - interior/end 
%  location - pos/neg - to determine tension/compression flanges
%
% Outputs: 
%  Vn % shear resistance
%  Vp % plastic shear force

    % Define Variables
    dw = s.dw;
    tw = s.tw;
    tf_top  = s.tf_top(1);
    bf_top  = s.bf_top(1);
    tf_bottom = s.tf_bottom(1);
    bf_bottom = s.bf_bottom(1);
    E = s.Es;
    Fy = s.Fy;
    Lb = s.Lb;

    % Determine compression/tension flange
    if strcmp(lower(location),'positive') || strcmp(lower(location),'pos')
        bfc = bf_top; % width compression flange
        tfc = tf_top; % thickness compression flange
        bft = bf_bottom; % width tension flange
        tft = tf_bottom; % thickness tension flange
    elseif strcmp(lower(location),'negative') || strcmp(lower(location),'neg')
        bfc = bf_bottom; % width compression flange
        tfc = tf_bottom; % thickness compression flange
        bft = bf_top; % width tension flange
        tft = tf_top; % thickness tension flange
    end

    % Web stiffened? (6.10.9.1)
    if Lb <= 3*dw % Section is "stiffened"
        webStiffened = 1;
    else
        webStiffened = 0;
    end

    % Shear buckling coefficient, k = 5 (for unstiffened webs)
    if webStiffened
        k = 5 + (5/(Lb/dw)^2); % (6.10.9.3.2-7)
    else
        k = 5;
    end

    % Calculation of C,
    % ratio of the shear-buckling resistance to the shear yield strength
    if dw/tw > 1.40*sqrt((E*k)/Fy)
        C = (1.57/(dw/tw)^2)*((E*k)/Fy); % (6.10.9.3.2-6)
    elseif dw/tw > 1.12*sqrt((E*k)/Fy)
        C = (1.12/(dw/tw))*sqrt((E*k)/Fy); % (6.10.9.3.2-5)
    else
        C = 1; % (6.10.9.3.2-4)
    end

    % Plastic shear force
    Vp = 0.58*Fy*dw*tw; % (6.10.9.3.2-3)

    if webStiffened
        % For Stiffened webs (6.10.9.3)
        if strcmp(panel, 'interior')
            if (2*dw*tw)/(bfc*tfc + bft*tft) <= 2.5 % (6.10.9.3.2-1)
                Vn = Vp*(C+((0.87*(1-C))/sqrt(1+(Lb/dw)^2))); % (6.10.9.3.2-2)
            else
                Vn = Vp*(C+((0.87*(1-C))/sqrt(1+(Lb/dw)^2)+(Lb/dw))); % (6.10.9.3.2-8)
            end
        elseif strcmp(panel, 'end')
            Vn = C*Vp;
        end
    else    
        % For unstiffened webs (6.10.9.2)
        Vn = C*Vp;   
    end
    

end

