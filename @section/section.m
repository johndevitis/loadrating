classdef section < fileio
%% classdef section 
% author: jdv
% date: 04232015 
    properties
        nSpans % number of spans
        loc % longitudinal girder location [interior/exterior]
        panel % panel location [interior/end]
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
    end    
    
    methods        
        %% -- constructor -- %
        function obj = section()            
        end
               
        %% -- dependent methods -- %
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
            Ix = ((1/12)*obj.tw*obj.dw^3)+...
                 (((1/12)*(obj.bf_top.*obj.tf_top).^3)+...
                 ((obj.bf_top.*obj.tf_top).*((obj.dw+obj.tf_top)/2)^2))+...
                 (((1/12)*(obj.bf_bot.*obj.tf_bot).^3)+...
                 ((obj.bf_bot.*obj.tf_bot).*((obj.dw+obj.tf_bot)/2).^2));            
        end
        
        function Iy = get.Iy(obj)
        % moment of inertia, weak axis
            Iy = (1/12)*(((obj.tf_top.*obj.bf_top).^3)+...
                 ((obj.tf_bot.*obj.bf_bot).^3)+(obj.dw*obj.tw^3));
        end                 
        
        function A = get.A(obj)
        % section area
            A = (obj.bf_top.* obj.tf_top)+(obj.bf_bot.*obj.tf_bot) + ...
                (obj.dw*obj.tw);
        end
                function dcNC = get.dcNC(obj)
        % depth of web in compression in elastic range
            dcNC = obj.dw/2;
        end
        
        function yTnc = get.yTnc(obj)
        % distance to top of section
            yTnc = obj.d/2;
        end
        
        function yBnc = get.yBnc(obj)
        % distance to bottom of section
            yBnc = obj.d/2;
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
        % elastic section modulus for seconcary axis
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
            flangeYc = obj.tf_bot/2 + obj.dw/2;
            webAc = obj.tw * obj.dw/2;
            webYc = obj.dw/2;           
            flangeAt = obj.bf_top.*obj.tf_top;
            flangeYt = obj.tf_top/2 + obj.dw/2;          
            webAt = obj.tw*obj.dw/2;
            webYt = obj.dw/2;            
            Z = (flangeAc.*flangeYc) + (webAc*webYc) + ...
                (flangeAt.*flangeYt) + (webAt*webYt);        
        end        
    end    
    
    	%% -- internal methods -- %
	methods (Access = private)
    end

end

