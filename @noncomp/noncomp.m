classdef noncomp < section
%% classdef noncomp < section
%
% class for calculating properties of non-composite steel wide flange
% sections
%
% author: jdv
% create date: 05182016

    %% -- properties -- %%
    properties
        
    end
    
    %% -- dependent properties -- %%
    properties (Dependent)
        dcNC % depth of web in compression in elastic range [in]
        yTnc % distance to top of section
        yBnc % distance to bottom of section 
        STnc % [in^3] Non-composite elastic section modulus measured from top flange
        SBnc % [in^3] Non-composite elastic section modulus measured from bottom flange 
        S2 % [in^3] elastic section modulus for secondary axis           
        Ix % moments of inertia Ix [in^4]
        Iy % moment of intertia Iy [in^4]        
        Z % plastic section modulus        
        A  % section area
        ry % effective radius of gyration for lateral torsional buckling 
    end
    
    %% -- dynamic methods -- %%
    methods
        %% -- constructor -- %
        function obj = noncomp()
            % call superclass constructor
            obj@section();
        end
        
        %% -- dependent methods -- %
        function dcNC = get.dcNC(obj)
        % depth of web in compression in elastic range
            dcNC = obj.dw/2;
        end
        
        function Ix = get.Ix(obj)
        % moment of inertia, strong axis
            Ix = ((1/12)*obj.tw*obj.dw^3)+...
                 (((1/12)*obj.bf_top*obj.tf_top^3)+...
                 ((obj.bf_top*obj.tf_top)*((obj.dw+obj.tf_top)/2)^2))+...
                 (((1/12)*obj.bf_bot*obj.tf_bot^3)+((obj.bf_bot*obj.tf_bot)*...
                 ((obj.dw+obj.tf_bot)/2)^2));            
        end
        
        function Iy = get.Iy(obj)
        % moment of inertia, weak axis
            Iy = (1/12)*((obj.tf_top*obj.bf_top^3)+...
                 (obj.tf_bot*obj.bf_bot^3)+(obj.dw*obj.tw^3));
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
            STnc = obj.Ix/obj.yTnc;
        end
        
        function SBnc = get.SBnc(obj)
        % elastic section modulus, bottom
            SBnc = obj.Ix/obj.yBnc;
        end
        
        function S2 = get.S2(obj)
        % elastic section modulus for seconcary axis
            S2 = obj.Iy/(obj.bf_bot/2);
        end
        
        function A = get.A(obj)
        % section area
            A = (obj.bf_top * obj.tf_top) + (obj.bf_bot * obj.tf_bot) + ...
                (obj.dw*obj.tw);
        end
        
        function ry = get.ry(obj)
        % effective radius of gyration for lateral torsional buckling [in]
            ry = obj.bf_bot/sqrt(12*(1+((obj.dcNC*obj.tw)/...
                (3*(obj.bf_bot * obj.tf_bot)))));
        end
        
        function Z = get.Z(obj)
        % plastic section modulus
            flangeAc = obj.bf_bot * obj.tf_bot;
            flangeYc = obj.tf_bot/2 * obj.dw/2;
            webAc = obj.tw * obj.dw/2;
            webYc = obj.dw/2;
            
            flangeAt = obj.bf_top * obj.tf_top;
            flangeYt = obj.tf_top/2 + obj.dw/2;
            
            webAt = obj.tw * obj.dw/2;
            webYt = obj.dw/2;
            
            Z = (flangeAc * flangeYc) + (webAc * webYc) + ...
                (flangeAt * flangeYt) + (webAt * webYt);
        
        end
    end %/dependent prop methods
end

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
