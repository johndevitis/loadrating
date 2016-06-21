function results = getBeamResults(model,res,lcNums,beamNums)
%%
%
% returns:
% [beamNum, beamDesc, beamID]
% 
% jdv 06152016

    uID = 1;     % default st7 model id      
    results = []; % make sure this exists
    
    %-- API Execution Wrapper --%
    try
        results = Main(uID,model,res,lcNums,beamNums);
    catch   
        % force close errthang
        fprintf('Force close!\n');
        CloseAndUnload(uID);
        rethrow(lasterror);
    end
end

function results = Main(uID,model,res,lcNums,beamNums)
    % load libs and model   
    InitializeSt7(); % load api           
    St7OpenModelFile(uID, model.path, model.name, model.scratch)      
    
    % preal
    propNum = cell(length(beamNums),1);
    propName = cell(length(beamNums),1);
    
    % loop beam numbers
    for ii = 1:length(beamNums)
        % call api fcns
        [propNum,propName] = getBeamInfo(uID,beamNums(ii));
        
        % save to results
        results.beamNum{ii} = beamNums(ii);
        results.propNum{ii} = propNum;
        results.propName{ii} = propName;
    end
    
    % Close and Unload
    CloseAndUnload(uID);        
end

function [propNum,propName] = getBeamInfo(uID,bnum)
    % get beam info from beam number
    global tyBEAM ptBEAMPROP
    
    % get beam property number
    [iErr,propNum] = calllib('St7API', 'St7GetElementProperty',uID,tyBEAM, ...
        bnum,1);
    HandleError(iErr);
    
    % get beam prop name
    maxLen = 128;
    propName = char(ones(1,maxLen));
    [iErr,propName] = calllib('St7API','St7GetPropertyName',uID, ptBEAMPROP,...
    propNum,propName,maxLen);
    HandleError(iErr);   
    
end

