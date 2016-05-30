classdef lrfr < section
%% classdef lrfr
% author: 
% create date: 24-May-2016 21:43:12

	%% -- object properties -- %%
	properties
        location = 'positive' % determine compression/tension flange
	end

	%% -- dependent properties -- %%
	properties (Dependent)
        Mn_Strength1Pos % 
        Fn_Strength1Pos % 
        Fn_Service2Pos % 
        Vn % 
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
