classdef lfr < matlab.mixin.SetGet
%% classdef lfr
% author: jdv
% create date: 24-May-2016 21:43:07

	%% -- object properties -- %%
	properties
        % input
%         region = 'pos' % determine compression/tension flange
        
        % outputs
        webStiffened % webstiffener boolean
        Mu_StrengthNeg % 
        Fu_StrengthNeg % 
        Fu_ServiceNeg %
        Vp % plastic shear force
        Vn % shear resistance
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
		function obj = lfr()
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
