function getBeamResults(model,res,lcNums,beamNums)
%%
%
% returns:
% [beamNum, beamDesc, beamID]
% 
% jdv 06152016

    uID = 1;         % st7 model id
    InitializeSt7(); % load api

    % Open model file
    St7OpenModelFile(uID, model.path,model.name,model.scratch)

    % Open result file
%     St7OpenResultFile(uID, res.fullpath)

    % loop beam numbers
    for ii = 1:length(beamNums)
        % loop columns for min and max
        for jj = 1:size(lcNums,2)
            [proprNum,propName] = getBeamInfo(uID,beamNums(ii))
        end
    end
    % Close and Unload
    CloseAndUnload(uID);

            
%             % Get Beam Element Results
%             if lcNums.Flex(ii,jj) ~= 0
%                 beamRes(:,jj) = St7GetBeamEndResults(uID, beamNum, resultCaseNum);
%             else
%                 continue
%             end        
%         end    
%         % Filter absolute maximum response
%         beamResults(:,ii) = max(abs(beamRes(:,1)), abs(beamRes(:,2)));    
%     end


% 
%     % Filter Beam Results
%     M1 = max(abs(beamResults(4,:)),abs(beamResults(10,:)))';
%     P = max(abs(beamResults(1,:)),abs(beamResults(7,:)))';
%     V = max(abs(beamResults(5,:)),abs(beamResults(9,:)))';

end

function [propNum,propName] = getBeamInfo(uID,bnum)
% get beam info from beam number
    global tyBEAM ptBEAMPROP
    
    % get beam property number
    [iErr,propNum] = calllib('St7API', 'St7GetElementProperty',uID,tyBEAM,...
        bnum,1);
    HandleError(iErr);
    
    % get beam prop name
    [iErr,propName] = calllib('St7API','St7GetPropertyName',uID, ptBEAMPROP,...
        propNum,'',50);
    HandleError(iErr);    
end



















