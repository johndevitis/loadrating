function getShear(r,s)
%% lfr getShear
%
% refactored by jdv 06232016

    % Define Variables
    Fy = s.Fy;
    dw = s.dw;
    tw = s.tw;
    Lb = s.Lb;

    % Plastic Shear Force, Vp
    Vp = 0.58*Fy*dw*tw;

    % Web stiffened? (10.48.8.3)
    if Lb <= 3*dw % Section is "stiffened"
        r.webStiffened = 1;
    else
        r.webStiffened = 0;
    end

    % Shear buckling coefficient, k = 5 (for unstiffened webs)
    if r.webStiffened
        k = 5 + (5/(Lb/dw)^2); % (6.10.9.3.2-7)
    else
        k = 5;
    end

    % Calculation of C,
    % ratio of the shear-buckling resistance to the shear yield strength
    if dw/tw > 7500*sqrt(k)/sqrt(Fy)
        C = (4.5*10^7)*k/(Fy*(dw/tw)^2);
    elseif dw/tw > 6000*sqrt(k)/sqrt(Fy)
        C = (6000*k)/((dw/tw)*sqrt(Fy));
    else
        C = 1;
    end

    if r.webStiffened   
        Vn = Vp*(C+((0.87*(1-C))/sqrt(1+(Lb/dw)^2))); % (AAHSTO 10-114)
    else    
        % For unstiffened webs (AAHSTO 10-113)
        Vn = C*Vp;   
    end

    % Assign to lfr rating structure
    r.Vn = Vn;
    r.Vp = Vp;
    
end
