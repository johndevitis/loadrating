function results = getBeamResults(model,res,beamNums,lcNums)
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
        [propNum,propName,sectionName] = getBeamInfo(uID,beamNums(ii));
        
        % save to results
        results.beamNum{ii} = beamNums(ii);
        results.propNum{ii} = propNum;
        results.propName{ii} = propName;
        results.sectionName{ii} = sectionName;
    end
    
    % Close and Unload
    CloseAndUnload(uID);        
end

function extractResults(uID,bnum,lcnum)
end

function [propNum,propName,sectionName] = getBeamInfo(uID,bnum)
% get property number, property name, and section name from beam number

    global tyBEAM ptBEAMPROP
    
    % get beam property number
    [iErr,propNum] = calllib('St7API', 'St7GetElementProperty',uID,tyBEAM, ...
        bnum,1);
    HandleError(iErr);
    
    % get beam prop name
    maxLen = 128; % max length of name
    propName = char(ones(1,maxLen)); % preallocate (don't use zeros!)
    [iErr,propName] = calllib('St7API','St7GetPropertyName',uID, ptBEAMPROP,...
        propNum,propName,maxLen);
    HandleError(iErr);       
    
    % get beam section name
    sectionName = char(ones(1,maxLen)); % pre-al
    [iErr,sectionName] = calllib('St7API','St7GetBeamSectionName',uID,...
        propNum,sectionName,maxLen);
    HandleError(iErr);
end

