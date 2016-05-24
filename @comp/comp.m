classdef comp < section
%% classdef comp
% author: jdv
% create date: 19-May-2016 14:54:23

	%% -- object properties -- %%
	properties
	end

	%% -- dependent properties -- %%
	properties (Dependent)
        N % modulous ratio                          
        beLT % long-term effective width
        beST % short-term effective width
        AeLT % long-term effective area               
        AeST % short-term effective area               
        D % total depth of composite section [in]
        yBst % distance to bottom of section from elastic neutral axis
        yTst % distance of E.N.A. to top of top flange
        yDst % distance of E.N.A. to top of deck
        yBlt % distance to bottom of section from elastic neutral axis
        yTlt % distance of E.N.A. to top of top flange
        yDlt % distance of E.N.A. to top of deck      
        ena_st_loc % location of short term ena (deck or steel)       
        ena_lt_loc % location of long term ena (deck or steel)
        Ist % short term elastic moment of inertia 
        Ilt % long term elastic moment of intertia   
        SDst % short term section modoulus         
        STst % short term section modulus              
        SBst % short term section modulus              
        SDlt % long term section modulus              
        STlt % long term section modulus              
        SBlt % long term section modulus     
	end

	%% -- developer properties -- %%
	properties (Access = private)
	end

	%% -- dynamic methods-- %%
	methods
		%% -- constructor -- %%
		function obj = comp()
            % call superclass constructor
            obj@section();
		end

		%% -- dependent methods -- %%

		function N = get.N(obj)
		% modulous ratio
            N = obj.Es/obj.Ec;
		end

		function beLT = get.beLT(obj)
		% long-term effective width
            beLT = obj.be/(3*obj.N);
		end

		function beST = get.beST(obj)
		% short-term effective width
            beST = obj.be/obj.N;
		end

		function AeLT = get.AeLT(obj)
		% long-term effective area
            AeLT = obj.ts*obj.beLT;
		end

		function AeST = get.AeST(obj)
		% short-term effective area
            AeST = obj.ts*obj.beST;
		end

		function D = get.D(obj)
		% total depth of composite section
            D = obj.d + obj.ts + obj.dh;
		end

		function yBst = get.yBst(obj)
		% distance to bottom of section from elastic neutral axis
        %  formula to find centroid: y = sum(Ai*yi)/sum(Ai)
            yBst = (obj.Ast*(obj.ts/2 + obj.dh + obj.d) + ...
                obj.A * obj.yBnc)/(obj.Ast + obj.A);
		end

		function yTst = get.yTst(obj)
		% distance of E.N.A. to top of top flange
            
		end

		function yDst = get.yDst(obj)
		% distance of E.N.A. to top of deck
            
		end

		function yBlt = get.yBlt(obj)
		% distance to bottom of section from elastic neutral axis
        %  formula to find centroid: y = sum(Ai*yi)/sum(Ai)
            yBlt = (obj.Alt * (obj.ts/2 + obj.dh + obj.d) + ...
                obj.A * obj.yBcn) / (obj.Alt + obj.A);
		end

		function yTlt = get.yTlt(obj)
		% distance of E.N.A. to top of top flange
            
		end

		function yDlt = get.yDlt(obj)
		% distance of E.N.A. to top of deck
            
		end

		function ena_st_loc = get.ena_st_loc(obj)
		% where yBst is? (deck or steel?)
            if obj.yBst > obj.d 
                % elastic netural axis is in the deck
                ena_st_loc = 'deck';
                obj.yTst = obj.yBst - d;
                obj.yDst = obj.D - obj.yBst;
            elseif obj.yBst < d 
                % elastic neutral axis is in the steel
                ena_st_loc = 'steel';
                obj.yTst = obj.d - obj.yBst;
                obj.yDst = obj.D - obj.yBst;
            end            
		end

		function ena_lt_loc = get.ena_lt_loc(obj)
		% where yBst is? (deck or steel?)
            if obj.yBlt > d
                % ena is in deck
                ena_lt_loc = 'deck';
                obj.yTlt = obj.yBlt - obj.d;
                obj.yDlt = obj.D - obj.yBlt;
            elseif obj.yBlt < d 
                % ena is in steel
                ena_lt_loc = 'steel';
                obj.yTlt = obj.d - obj.yBlt;
                obj.yDlt = obj.D -obj.yBlt;
            end            
		end

		function Ist = get.Ist(obj)
		% short term elastic moment of inertia
            
		end

		function Ilt = get.Ilt(obj)
		% long term elastic moment of intertia
            
		end

		function SDst = get.SDst(obj)
		% short term section modoulus
            
		end

		function STst = get.STst(obj)
		% short term section modulus
            
		end

		function SBst = get.SBst(obj)
		% short term section modulus
            
		end

		function SDlt = get.SDlt(obj)
		% long term section modulus
            
		end

		function STlt = get.STlt(obj)
		% long term section modulus
            
		end

		function SBlt = get.SBlt(obj)
		% long term section modulus
            
		end

	end

	%% -- static methods -- %%
	methods (Static)
	end

	%% -- internal methods -- %%
	methods (Access = private)
	end

end
