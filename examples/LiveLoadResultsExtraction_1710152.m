%% 1710152 LL Results Extraction
%
%
% notes:
%
% make sure all folders and subfolders are added to matlab path. multiple
% functions contained in loadrating/scripts and
% loadrating/scripts/from_ramps are called
%
% make sure the folder C:\Temp exists on your machine 
%
% dependencies:
%  requires the following from ramps general api functions:
%   St7OpenModelFile
%
%
%
% created by NR
% refactored by jdv 06152016

%% inputs

% model info
model.path = 'C:\Users\John\Desktop\brp\1710152';       
model.name = '1710152_LiftSpan_apriori_LRFR_HL93.st7';    
model.scratch = 'C:\Temp'; % make sure this exists on your computer
model.fullpath = fullfile(model.path,model.name); % get full path

% result info 
res.path = model.path; % files in same path as model
res.name = '1710152_LiftSpan_apriori_LRFR_HL93.LSA';
res.fullpath = fullfile(res.path,res.name); % get full path
res.logpath = [res.fullpath(1:end-1) 'L']; % .LSL log file path found using .LSA fullpath

% Define load Case name
%  note: all standard lc names are in ~/data/brp load case names.txt
lcName = 'LRFR HL-93'; 



%% load beam 

beamNums = [3 45 129];

%% 

getLLresults(model,res,lcName,beamNums)

clc
for ii = 1:length(lcnames)
   fprintf('%s %s\n',num2str(ii),lcnames{ii});
end

%% get beam results

% load api
uID = 1;
InitializeSt7(); 

% Open model file
St7OpenModelFile(uID, model.path,model.name,model.scratch)

% Open result file
St7OpenResultFile(uID, res.fullpath)

% Get beam responses
for ii = 1:size(beamNums,1)
    
    % Get beam element number
    beamNum = beamNums(ii); 
    
    % For both min and max
    for jj = 1:size(resultCases,2)        
        % Get Beam Element Results
        resultCaseNum = resultCases(ii,jj);
        if resultCaseNum ~= 0
            beamRes(:,jj) = St7GetBeamEndResults(uID, beamNum, resultCaseNum);
        else
            continue
        end        
    end    
    % Filter absolute maximum response
    beamResults(:,ii) = max(abs(beamRes(:,1)), abs(beamRes(:,2)));    
end

% Close and Unload
CloseAndUnload(uID);

% Filter Beam Results
M1 = max(abs(beamResults(4,:)),abs(beamResults(10,:)))';
P = max(abs(beamResults(1,:)),abs(beamResults(7,:)))';
V = max(abs(beamResults(5,:)),abs(beamResults(9,:)))';






