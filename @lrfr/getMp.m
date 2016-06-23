function [Mp, Dpst, Dcp, id] = getMp(r,s)
%%
% Determine Plastic Moment of Composite Seection
%  - AASHTO LRFD Manual Appendix D6
%
% Plastic forces in steel portions of the cross-section are calculated
% using the yield strengths of the flanges, web, and reinforcing steel, as
% appropriate. 
%
% Compressive stress = 0.85f'c
% Concrete in tension neglected
% Forces in longitudinal reinforcement conservatively ignored
%  
% Mp - plastic moment of the composite section
% Dpst - distance from the top of slab to PNA [in]
% Dcp - depth of the web in compression at the plastic moment
% id - integer case identifier per Table D6.1-1 for PNA location
%
% refactored by jdv 05242016

    % ensure section is composite
    if ~r.composite
        fprintf('Section not composite \n');
        return
    end
    
    % Define Variables
    Fy = s.Fy; % Yeild Strength of flanges and web [psi]
    fc = s.fc; % Compressive strength of concrete deck
    ts = s.ts; % Thickness of concrete deck
    tf_top = s.tf_top(1); % Thickness of top flange (compression flange)
    tf_bot = s.tf_bot(1); % Thickness of both top flange (tension flange)
    bf_top = s.bf_top(1); % Width of top flange (compression flange)
    bf_bot = s.bf_bot(1); % Width of bottom flange (tension flange)
    tw = s.tw; % Thickness of the web
    dweb = s.dw; % Depth of Web
    D = s.D; % [inches] Total depth of composite section   
    be = s.be; % Effective width of concrete deck
    dh = s.dh; % Depth of huanch

    % Calculate plastic forces
    Ps = .85*fc*be*ts; % Plastic Force for slab [lbs]
    Pc = Fy*tf_top*bf_top; % Plastic Force for compression flange [lbs]
    Pw = Fy*tw*dweb; % Plastic Force for web [lbs]
    Pt = Fy*tf_bot*bf_bot; % Plastic Force for tension flange [lbs]

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
            dt = (tf_bot/2)+dweb+tf_top+dh+(ts-PNAst); % [inches] distance from tens. flange NA to PNA
            Mp = (((PNAst^2)*Ps)/(2*ts))+(Pc*dc+Pt*dt+Pw*dw); % [lb-in] 
            id = 7; % Case 3-7 in AD6
            Dpst = PNAst; % [inches] distance from the top of slab to PNA 
            Dcp = 0; % depth of the web in compression at the plastic moment
            
        elseif Ps/ts*(ts+dh+tf_top)+Pc > A 
            PNAst = (Pw+Pt+Pc-Ps*(1+dh/ts))/(Ps/ts+2*Pc/tf_top); % [inches] location of PNA from top of flange 
            ds = (ts+dh+PNAst)/2; % [inches] distance from slab NA to PNA
            dw = (dweb/2)+(tf_top-PNAst); % [inches] distance from web NA to PNA
            dt = (tf_top/2)+dweb+(tf_top-PNAst); % [inches] distance from tens. flange NA to PNA
            Mp = (Pc/(2*tf_top))*(PNAst^2+(tf_top-PNAst)^2)+(Ps/ts*(ts+dh+PNAst)*ds+Pw*dw+Pt*dt); 
            id = 2; % [lb-in] Case 2 in AD6
            Dpst = PNAst+ts+dh; % [inches] distance from the top of slab to PNA 
            Dcp = 0; % depth of the web in compression at the plastic moment
            
        elseif Ps+Pc-Pw/dweb*(dh+tf_top)>Pt+Pw/dweb*(dweb+dh+tf_top) 
            PNAst = (Pw+Pt-Pc-Ps*(1+dh/ts+tf_top/ts))/(Ps/ts+2*Pw/dweb); % [inches] location of PNA from bottom of top flange 
            ds = (ts+dh+tf_top+PNAst)/2; % [inches] distance from slab NA to PNA
            dc = (tf_top/2)+PNAst; % [inches] distance from comp. flange NA to PNA
            dt = (tf_top/2)+dweb-PNAst; % [inches] distance from tens. flange NA to PNA
            Mp = (Pw/(2*dweb))*(PNAst^2+((dweb-PNAst)^2))+(Ps/ts*(ts+dh+tf_top+PNAst)*ds+Pc*dc+Pt*dt); % [lb-in] 
            id = 1; % Case 1 in AD6
            Dpst = PNAst+ts+dh+tf_top; % [inches] distance from the top of slab to PNA 
            Dcp = PNAst; % Depth of web in compression at plastic moment
            
        else
            % In web
            PNAst = (dweb/2)*(((Pt-Pc-Ps)/Pw)+1); % [inches] location of PNA from bottom of top flange 
            ds = (ts/2)+dh+tf_top+PNAst; % [inches] distance from slab NA to PNA
            dc = (tf_top/2)+PNAst; % [inches] distance from comp. flange NA to PNA
            dt = (tf_top/2)+dweb-PNAst; % [inches] distance from tens. flange NA to PNA
            Mp = (Pw/(2*dweb))*(PNAst^2+((dweb-PNAst)^2))+(Ps*ds+Pc*dc+Pt*dt); % [lb-in]
            id = 1; %Case 1 in AD6
            Dpst = PNAst+ts+dh+tf_top; % [inches] distance from the top of slab to PNA 
            Dcp = PNAst; % Depth of web in compression at plastic moment
        end
    else
        % PNA located in slab and measured measured from top of slab
        if Ps > B 
            PNAst = ts*((Pc+Pt+Pw)/Ps); % [inches] location of PNA from top of slab 
            dc = (tf_top/2)+dh+(ts-PNAst); % [inches] distance from comp. flange NA to PNA
            dw = (dweb/2)+tf_top+dh+(ts-PNAst); % [inches] distance from web NA to PNA
            dt = (tf_top/2)+dweb+tf_top+dh+(ts-PNAst); % [inches] distance from tens. flange NA to PNA
            Mp = (((PNAst^2)*Ps)/(2*ts))+(Pc*dc+Pt*dt+Pw*dw); % [lb-in] 
            id = 7; % Case 3-7 in AD6
            Dpst = PNAst; % [inches] distance from the top of slab to PNA 
            Dcp = 0; % depth of the web in compression at the plastic moment
            
        % Is the plastic neutral axis in the top flange?
        elseif C > A % PNA located in top flange and measured from top of flange
            PNAst = (tf_top/2)*(((Pw+Pt-Ps)/Pc)+1); % [inches] location of PNA from top of flange 
            ds = (ts/2)+dh+PNAst; % [inches] distance from slab NA to PNA
            dw = (dweb/2)+(tf_top-PNAst); % [inches] distance from web NA to PNA
            dt = (tf_top/2)+dweb+(tf_top-PNAst); % [inches] distance from tens. flange NA to PNA
            Mp = (Pc/(2*tf_top))*(PNAst^2+(tf_top-PNAst)^2)+(Ps*ds+Pw*dw+Pt*dt); % [lb-in] 
            id = 2; % Case 2 in AD6
            Dpst = PNAst+ts+dh; % [inches] distance from the top of slab to PNA 
            Dcp = 0; % depth of the web in compression at the plastic moment
            
        % Is the plastic neutral axis in the web?
        else % A>C and PNA in web measured from bottom of top flange
            PNAst = (dweb/2)*(((Pt-Pc-Ps)/Pw)+1); % [inches] location of PNA from bottom of top flange 
            ds = (ts/2)+dh+tf_top+PNAst; % [inches] distance from slab NA to PNA
            dc = (tf_top/2)+PNAst; % [inches] distance from comp. flange NA to PNA
            dt = (tf_top/2)+dweb-PNAst; % [inches] distance from tens. flange NA to PNA
            Mp = (Pw/(2*dweb))*(PNAst^2+((dweb-PNAst)^2))+(Ps*ds+Pc*dc+Pt*dt); % [lb-in] 
            id = 1; % Case 1 in AD6
            Dpst = PNAst+ts+dh+tf_top; % [inches] distance from the top of slab to PNA 
            Dcp = PNAst; % Depth of web in compression at plastic moment
        end
    end
end