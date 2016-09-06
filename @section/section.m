classdef section < fileio
%% classdef section 
% author: jdv
% date: 04232015 
    properties
        nSpans % number of spans
        trans_loc % longitudinal girder location [interior/exterior]
        panel % panel location of section [interior/end]
        L % span length [in]
        Lb % max unbraced length [in]
        Es % young's modulus, steel [psi]
        Fy % yield strength of flanges and web [psi]
        fc % compressive strength of concrete deck
        ts % thickness of concrete deck [in]
        be % effective width of concrete deck [in]
        dh % depth of haunch [in]
        dw % depth of web
        tw % thickness of web [in]
        bf_top % width of top flange [in]
        tf_top % thickness of top flange [in]
        bf_bot % width of bottom flange [in]
        tf_bot % thickness of bottom flange [in]       
        wDL % nonsuperimposed deadload [lb]
        wSDL % superimposed deadload [lb]
        wSDW % wearing surface deadload [lb]
    end    
    
    properties (Dependent = true)   
        d % total depth of non-composite steel section (wide flange)[in] 
        Ec % deck modulous [psi] -> 57000*sqrt(fc)      
        Ix % moments of inertia Ix [in^4]
        Iy % moment of intertia Iy [in^4] 
        A  % section area
        dcNC % depth of web in compression in elastic range [in]
        yTnc % distance to top of section
        yBnc % distance to bottom of section 
        STnc % [in^3] Non-composite elastic section modulus measured from top flange
        SBnc % [in^3] Non-composite elastic section modulus measured from bottom flange 
        S2 % [in^3] elastic section modulus for secondary axis             
        Z % plastic section modulus        
        ry % effective radius of gyration for lateral torsional buckling 
        Iyc % moment of inertia of the compression flange (assumed to be bottom)
        J % polar moment of inertia (non-composite)
    end    
    
    methods        
        %% -- constructor -- %
        function obj = section()            
        end
               
        %% -- dependent methods -- %
        function J = get.J(obj)
        % polar moment of inertia (non-composite)
            J = obj.Ix + obj.Iy;
        end
        function Iyc = get.Iyc(obj)
        % moment of inertia of the compression flange for non-composite
        % section - this is used for LFR negative flexure rating so it is
        % assumed to be on the bottom
            Iyc = obj.tf_bot * obj.bf_bot^3 / 12;        
        end
        
        function d = get.d(obj)
        % full depth of steel section
            d = obj.dw + obj.tf_top + obj.tf_bot;
        end
        
        function Ec = get.Ec(obj)   
        % deck modulous
        % default is Ec = 57000*sqrt(fc) [psi] instead of LRFD's
        % 1820*sqrt(fc) [ksi] as it is slightly conservative
            Ec = 57000*sqrt(obj.fc);
        end                 
        
        function Ix = get.Ix(obj)
        % moment of inertia, strong axis
        %  uses parallel axis theorem
            dyTop = obj.yTnc - obj.tf_top/2; % distance to top flange centroid
            dyBot = obj.yBnc - obj.tf_bot/2; % distance to bottom flange centroid
            dyWeb = obj.yTnc - obj.dw/2 - obj.tf_top; % distance to web centroid
            ATop = obj.tf_top * obj.bf_top;  % area of top flange
            ABot = obj.tf_bot * obj.bf_bot;  % area of bot flange 
            AWeb = obj.tw * obj.dw;
            % calc order: 
            %   web
            %   top flange
            %   bottom flange
            Ix = (1/12 * obj.tw * obj.dw^3 + AWeb * dyWeb^2) + ...   
                 (1/12 * obj.bf_top * obj.tf_top^3 + ATop * dyTop^2) + ...
                 (1/12 * obj.bf_bot * obj.tf_bot^3 + ABot * dyBot^2);            
        end
        
        function Iy = get.Iy(obj)
        % moment of inertia, weak axis
        %  assumes top and bottom flanges are at center of n.a.
            Iy = (1/12 * obj.dw * obj.tw^3) + ...
                 (1/12 * obj.tf_top * obj.bf_top^3) + ...
                 (1/12 * obj.tf_bot * obj.bf_bot^3);
        end                 
        
        function A = get.A(obj)
        % section area
            A = (obj.bf_top.* obj.tf_top)+(obj.bf_bot.*obj.tf_bot) + ...
                (obj.dw*obj.tw);
        end
        
        function dcNC = get.dcNC(obj)
        % depth of web in compression in elastic range
        % assumes top of web is in compression
            dcNC = obj.yTnc - obj.tf_top;
        end
        
        function yTnc = get.yTnc(obj)
        % distance to top of section from centroid
        % Moment of areas divided by total area
            dyTop = obj.dw/2 + obj.tf_top/2; % distance to top flange centroid
            dyBot = obj.dw/2 + obj.tf_bot/2; % distance to bottom flange centroid
            ATop = obj.tf_top * obj.bf_top;  % area of top flange
            ABot = obj.tf_bot * obj.bf_bot;  % area of bot flange
            yTnc = obj.dw/2 + obj.tf_top - (ATop * dyTop + ABot * -dyBot)/(ATop + ABot);
        end
        
        function yBnc = get.yBnc(obj)
        % distance to bottom of section from centroid
%             dyTop = obj.dw/2 + obj.tf_top/2; % distance to top flange centroid
%             dyBot = obj.dw/2 + obj.tf_bot/2; % distance to bottom flange centroid
%             ATop = obj.tf_top * obj.bf_top;  % area of top flange
%             ABot = obj.tf_bot * obj.bf_bot;  % area of bot flange
%             yBnc = obj.dw/2 + obj.tf_bot + (ATop * dyTop + ABot * -dyBot)/(ATop + ABot);
            yBnc = obj.d-obj.yTnc;
        end
        
        function STnc = get.STnc(obj)
        % elastic section modulus, top
            STnc = obj.Ix./obj.yTnc;
        end
        
        function SBnc = get.SBnc(obj)
        % elastic section modulus, bottom
            SBnc = obj.Ix./obj.yBnc;
        end
        
        function S2 = get.S2(obj)
        % elastic section modulus for secondary axis
            S2 = obj.Iy./(obj.bf_bot/2);
        end
        
        function ry = get.ry(obj)
        % effective radius of gyration for lateral torsional buckling [in]
            ry = obj.bf_bot/sqrt(12*(1+((obj.dcNC*obj.tw)/...
                (3*(obj.bf_bot * obj.tf_bot)))));
        end
        
        function Z = get.Z(obj)
        % plastic section modulus
            flangeAc = obj.bf_bot.*obj.tf_bot;
            flangeYc = obj.yBnc - obj.tf_bot/2;
            webAc = obj.tw * (obj.yBnc - obj.tf_bot);
            webYc = (obj.yBnc - obj.tf_bot)/2;           
            flangeAt = obj.bf_top.*obj.tf_top;
            flangeYt = obj.yTnc - obj.tf_top/2;          
            webAt = obj.tw*(obj.yTnc-obj.tf_top);
            webYt = (obj.yTnc-obj.tf_top)/2;            
            Z = (flangeAc.*flangeYc) + (webAc*webYc) + ...
                (flangeAt.*flangeYt) + (webAt*webYt);        
        end        
    end    
    
    	%% -- internal methods -- %
	methods (Access = private)
    end

end

