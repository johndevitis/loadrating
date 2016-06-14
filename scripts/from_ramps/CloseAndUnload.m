function CloseAndUnload(uID)
% Close any open files associated with uID and unload the St7API.
try
    calllib('St7API', 'St7CloseResultFile', uID);
catch
end

try
    calllib('St7API','St7CloseFile',uID);
catch
end

try
    unloadlibrary('St7API');
catch
end
end      % CloseAndUnload()
