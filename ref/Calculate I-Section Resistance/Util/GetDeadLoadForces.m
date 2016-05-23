function Demands = GetDeadLoadForces(Demands)

% Dead Load Moment Non-superimposed (Deck, Girder Diaphragms)
Demands.MDL_pos = Demands.wDL.*Demands.maxDLM_POI;
Demands.MDL_neg = min(Demands.wDL.*Demands.minDLM_POI,[],2);

% Dead Load Moment Superimposed (Sidewalk and Barriers)
Demands.MSDL_pos = Demands.wSDL*Demands.maxDLM_POI;
Demands.MSDL_neg = min(Demands.wSDL*Demands.minDLM_POI,[],2);

% Dead Load Moment Superimposed (Future wearing surface)
Demands.MSDW_pos = Demands.wSDW*Demands.maxDLM_POI;
Demands.MSDW_neg = min(Demands.wSDW*Demands.minDLM_POI,[],2);

% Dead Laod Shear (DC1 and DC2)
Demands.VDL = max((Demands.wDL+Demands.wSDL)*Demands.maxDLV_POI, [], 2);

% Dead Load Shear (DW)
Demands.VDW = max(Demands.wSDW*Demands.maxDLV_POI, [], 2);

end