function InitializeSt7()

St7APIConst();

% Load the api of not already loaded
fprintf('Loading ST7API.DLL... ');
if ~libisloaded('St7API')
    loadlibrary('St7API.dll', 'St7APICall.h');
    iErr = calllib('St7API', 'St7Init');
    HandleError(iErr);
end
fprintf('Done \n');


end