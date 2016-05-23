classdef demands
%% classdef demands
% author: 
% date: 17-May-2016 12:45:05

	%% -- object properties --%%
	properties
        wDL % nonsuperimposed deadload [lb]
        wSDL % superimposed deadload [lb]
        wSDW % wearing surface deadload [lb]
	end

	%% -- dependent properties --%%
	properties (Dependent)
        POI % point of interest
        MDL_pos % + dl moment non-superimposed (deck, girder, diaphragms)
        MDL_neg % - dl moment non-superimposed (deck, girder, diaphragms)
        MSDL_pos % + dl moment superimposed (sidewalk and barriers)
        MSDL_neg % - dl moment superimposed (sidewalk and barriers)
        MSDW_pos % + dl moment superimposed (future wearing surface)
        MSDW_neg % - dl moment superimposed (future wearing surface)
        VDL % dl shear (dc1 and dc2)
        VDW % dl shear (dw)
	end

	%% -- developer properties --%%
	properties (Access = private)
	end

	%% -- dynamic methods--%%
	methods
		%% -- constructor -- %%
		function obj = demands()
		end

		%% -- dependent methods -- %

	end

	%% -- static methods -- %
	methods (Static)
	end

	%% -- internal methods -- %
	methods (Access = private)
	end

end
