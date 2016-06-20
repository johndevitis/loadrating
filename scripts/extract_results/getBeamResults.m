function getBeamResults(model,res,lcNums,beamNums)
%%
%
% returns:
% [beamNum, beamDesc, beamID]
% 
% jdv 06152016

    uID = 1; % default st7 model id      
    
    %-- API Execution Wrapper --%
    try
        Main(uID,model,res,lcNums,beamNums);
    catch   
        % force close errthang
        fprintf('Force close!\n');
        CloseAndUnload(uID);
        rethrow(lasterror);
    end
end

function Main(uID,model,res,lcNums,beamNums)
    % load libs and model   
    InitializeSt7(); % load api           
    St7OpenModelFile(uID, model.path, model.name, model.scratch)      
    
    % loop beam numbers
    for ii = 1:length(beamNums)
        propNum = getBeamInfo(uID,beamNums(ii))
    end
    
    % Close and Unload
    CloseAndUnload(uID);        
end

function propNum = getBeamInfo(uID,bnum)
    % get beam info from beam number
    global tyBEAM 
    
    % get beam property number
    [iErr,propNum] = calllib('St7API', 'St7GetElementProperty',uID,tyBEAM, ...
        bnum,1);
    HandleError(iErr);
    
end

