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
% model.path = 'C:\Users\John\Desktop\brp\1710152';     
model.path = 'C:\Users\John\Desktop\brp';     
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




%% get vector of beam numbers 

% flexure info
flex.beamNums = [45 129 187];
flex.flag = 'BM2'; % load case name flag
flex.truckType = 'LRFR HL-93'; 

% shear info
shear.beamNums = [3 87 1 2];
shear.flag = 'SF2'; % load case name flag
shear.truckType = 'LRFR HL-93'; 

%% mine log file 

% mine result log file for load case names
lcnames = getLoadCaseNames(res.logpath);

% get load case numbers for flexure and shear
flex.lcNums = getLoadCaseNums(flex.truckType,lcnames,flex.beamNums,flex.flag);
shear.lcNums = getLoadCaseNums(shear.truckType,lcnames,shear.beamNums,shear.flag);


%% api

% get beam results
results = getBeamResults(model,res,flex.lcNums,flex.beamNums)





