classdef lrfr < fileio
%% classdef lrfr
% author: jdv
% create date: 24-May-2016 21:43:12

	%% -- object properties -- %%
	properties
        % input
        region = 'pos' % determine compression/tension flange
        Rh = 1.0; % Hybrid factor (AASHTO LRFD Section 6.10.1.10.1)
        Rb = 1.0; % Web Load-Shedding Factor (6.10.1.10.2)
        composite = 1; % composite/non-composite boolean 
        
        % results
        webStiffened % web stiffened boolean 
        ductility % ductile boolean
        compact % compact/non-compact boolean
        Mn_Strength1Pos % 
        Fn_Strength1Pos % 
        Fn_Service2Pos % 
        Fn_Strength1Neg %
        Fn_Service2Neg %
        Vn % shear resistance
        Vp % plastic shear force
	end

	%% -- dependent properties -- %%
	properties (Dependent)

	end

	%% -- developer properties -- %%
	properties (Access = private)
	end

	%% -- dynamic methods-- %%
	methods
		%% -- constructor -- %%
		function obj = lrfr()
            % 
        end

		%% -- dependent methods -- %%

	end

	%% -- static methods -- %%
	methods (Static)        
	end

	%% -- internal methods -- %%
	methods (Access = private)
	end

end
