function CloseAndUnload(uID)
% Close any open files associated with uID and unload the St7API.

    % update user
    fprintf('Exiting API... \n');
    try
        calllib('St7API', 'St7CloseResultFile', uID);
    catch
        fprintf('Failed to close St7 result file\n');
    end

    try
        calllib('St7API','St7CloseFile',uID);
    catch
        fprintf('Failed to close St7 file\n');
    end

    try
        unloadlibrary('St7API');
    catch
        fprintf('Failed to unload library\n');
    end
    % update complete
    fprintf('Done.\n');
end      % CloseAndUnload()
