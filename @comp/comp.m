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
        belt % long-term effective width
        best % short-term effective width
        Alt % long-term effective area               
        Ast % short-term effective area               
        D % total depth of composite section [in]
        yBst % distance to bottom of section from elastic neutral axis
        yTst % distance of E.N.A. to top of top flange
        yDst % distance of E.N.A. to top of deck
        yBlt % distance to bottom of section from elastic neutral axis
        yTlt % distance of E.N.A. to top of top flange
        yDlt % distance of E.N.A. to top of deck      
        Ist % short term elastic moment of inertia 
        Ilt % long term elastic moment of intertia         
        STst % short term section modulus              
        SBst % short term section modulus                      
        STlt % long term section modulus              
        SBlt % long term section modulus     
        ena_loc_st % location of short-term elastic neutral axis
        ena_loc_lt % location of long-term elastic neutral axis
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

		function belt = get.belt(obj)
		% long-term effective width
            belt = obj.be/(3*obj.N);
		end

		function best = get.best(obj)
		% short-term effective width
            best = obj.be/obj.N;
		end

		function Alt = get.Alt(obj)
		% long-term effective area
            Alt = obj.ts*obj.belt;
		end

		function Ast = get.Ast(obj)
		% short-term effective area
            Ast = obj.ts*obj.best;
		end

		function D = get.D(obj)
		% total depth of composite section
            D = obj.d + obj.ts + obj.dh;
		end

		function yBst = get.yBst(obj)
		% distance to bottom of section from elastic neutral axis
        %  formula to find centroid: y = sum(Ai*yi)/sum(Ai)
            yBst = (obj.Ast.*(obj.ts/2 + obj.dh + obj.d) + ...
                obj.A.*obj.yBnc)./(obj.Ast + obj.A);
		end

		function yTst = get.yTst(obj)
		% distance of E.N.A. to top of top flange
            if strcmp(obj.ena_loc_st,'deck')
                yTst = obj.yBst - obj.d;
            else
                yTst = obj.d - obj.yBst;
            end
		end

		function yDst = get.yDst(obj)
		% distance of E.N.A. to top of deck
            yDst = obj.D - obj.yBst;
		end

		function yBlt = get.yBlt(obj)
		% distance to bottom of section from elastic neutral axis
        %  formula to find centroid: y = sum(Ai*yi)/sum(Ai)
            yBlt = (obj.Alt.*(obj.ts/2 + obj.dh + obj.d) + ...
                obj.A.*obj.yBnc)./(obj.Alt + obj.A);
		end

		function yTlt = get.yTlt(obj)
		% distance of E.N.A. to top of top flange
            if strcmp(obj.ena_loc_lt,'deck')
                yTlt = obj.yBlt - obj.d;
            else
                yTlt = obj.d - obj.yBlt;
            end            
		end

		function yDlt = get.yDlt(obj)
		% distance of E.N.A. to top of deck
            yDlt = obj.D - obj.yBlt;            
		end

		function Ist = get.Ist(obj)
		% short term elastic moment of inertia
            Ist = obj.Ix + obj.A*(obj.yBst - obj.d/2)^2 + ...
                obj.Ast*obj.ts^2/12 + obj.Ast*(obj.yDst - obj.ts/2)^2; 
		end

		function Ilt = get.Ilt(obj)
		% long term elastic moment of intertia
            Ilt = obj.Ix + obj.A*(obj.yBlt - obj.d/2)^2 + ...
                obj.Alt*obj.ts^2/12 + obj.Alt*(obj.yDlt - obj.ts/2)^2;
        end

        function STst = get.STst(obj)
        % short term section modulus
            STst = obj.Ist/obj.yTst;
        end

		function SBst = get.SBst(obj)
		% short term section modulus
            SBst = obj.Ist/obj.yBst;
        end

		function STlt = get.STlt(obj)
		% long term section modulus
            STlt = obj.Ilt/obj.yTlt;
		end

		function SBlt = get.SBlt(obj)
		% long term section modulus
            SBlt = obj.Ilt/obj.yBlt;
        end
        
        function ena_loc_st = get.ena_loc_st(obj)
        % location of short-term elastic neutral axis
        % TODO: add haunch option
            if obj.yBst > obj.d
                ena_loc_st = 'deck';
            elseif obj.yBst < obj.d
                ena_loc_st = 'steel';
            else
                ena_loc_st = 'error';
            end
        end
        
        function ena_loc_lt = get.ena_loc_lt(obj)
        % location of long-term elastic neutral axis
            if obj.yBlt > obj.d
                ena_loc_lt = 'deck';
            elseif obj.yBlt < obj.d
                ena_loc_lt = 'steel';
            else
                ena_loc_lt = 'error';
            end
        end
	end

	%% -- static methods -- %%
	methods (Static)
    end

	%% -- internal methods -- %%
	methods (Access = private)
	end

end
