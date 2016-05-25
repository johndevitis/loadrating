classdef lrfr
%% classdef lrfr
% author: 
% create date: 24-May-2016 21:43:12

	%% -- object properties -- %%
	properties
	end

	%% -- dependent properties -- %%
	properties (Dependent)
        Mp % plastic moment of the composite section
        Dpst % distance from the top of the slab to PNA [in]
        Dcp % depth of the web in compression at the plastic moment
        id % integer PNA location id per Table D6.1-1
        compact % Compact/Non-Noncompact logical 
        ductility % ductility check logical
        Mn_Strength1Pos % 
        Fn_Strength1Pos % 
        Fn_Service2Pos % 
        
	end

	%% -- developer properties -- %%
	properties (Access = private)
	end

	%% -- dynamic methods-- %%
	methods
		%% -- constructor -- %%
		function obj = lrfr()
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
