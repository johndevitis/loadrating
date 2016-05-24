function d = GetDeadLoadForces(d)

    % Dead Load Moment Non-superimposed (Deck, Girder Diaphragms)
    d.MDL_pos = d.wDL.*d.maxDLM_POI;
    d.MDL_neg = min(d.wDL.*d.minDLM_POI,[],2);

    % Dead Load Moment Superimposed (Sidewalk and Barriers)
    d.MSDL_pos = d.wSDL*d.maxDLM_POI;
    d.MSDL_neg = min(d.wSDL*d.minDLM_POI,[],2);

    % Dead Load Moment Superimposed (Future wearing surface)
    d.MSDW_pos = d.wSDW*d.maxDLM_POI;
    d.MSDW_neg = min(d.wSDW*d.minDLM_POI,[],2);

    % Dead Laod Shear (DC1 and DC2)
    d.VDL = max((d.wDL+d.wSDL)*d.maxDLV_POI, [], 2);

    % Dead Load Shear (DW)
    d.VDW = max(d.wSDW*d.maxDLV_POI, [], 2);

end