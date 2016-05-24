
function s = calculateSectionPlasticMoment(s)
%% get_MP
%
% Determine Plastic Moment: AASHTO LRFD Manual Appendix D6
%
% Plastic forces in steel portions of the cross-section are calculated
% using hte yield strengths of the flanges, web, and reinforcing steel, as
% appropriate. 
%
% Compressive stress = 0.85f'c
% Concrete in tension neglected
% Forces in longitudinal reinforcement conservatively ignored
%  
% 
% 

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