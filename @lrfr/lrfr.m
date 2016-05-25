classdef lrfr
%% classdef lrfr
% author: 
% create date: 24-May-2016 21:43:12

	%% -- object properties -- %%
	properties
	end

	%% -- dependent properties -- %%
	properties (Dependent)
        Mn_Strength1Pos % 
        Fn_Strength1Pos % 
        Fn_Service2Pos % 
        Vn % shear resistance
        webStiffened % logical -> 6.10.9.1
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
        function webStiffened = get.webStiffened(obj)
            % determine if stiffener was required per 6.10.9.1
            if obj.Lb <= 3*obj.dw
                webStiffened = 1;
            else
                webStiffened = 0;
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
