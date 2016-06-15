function St7OpenModelFile(uID, PathName, FileName, ScratchPath)
% error screen missing file extension
if isempty(regexp(FileName,'.st7'))
   % ext missing, add
   FileName = [FileName '.st7'];   
end
% call fullfile to sort path\name conflicts
ModelPathName = fullfile(PathName, FileName);

% open and handle error
iErr = calllib('St7API', 'St7OpenFile', uID, ModelPathName, ScratchPath);
if iErr == 1
    try
        % close file
        iErr = calllib('St7API','St7CloseFile', uID);
        HandleError(iErr);
    catch
    end
elseif iErr ~= 0 
    HandleError(iErr);
end
end