% 1710152 LL Results Extraction

% Model Path
modelPath = 'C:\Users\Nick\Desktop\1710152\Model\1710152_LiftSpan_apriori_LRFR_Type3S2.st7';

% Result Path
resultPath = 'C:\Users\Nick\Desktop\1710152\Model\1710152_LiftSpan_apriori_LRFR_Type3S2.LSA';

% Get result case names
LSLPath = 'C:\Users\Nick\Desktop\1710152\Model\1710152_LiftSpan_apriori_LRFR_Type3S2.LSL';
ResCaseNames = getResultCaseNames(LSLPath);

% Define load Case name
loadCaseName = 'LRFR Type 3S2';

% Define load case identifiers for each location of interest
response = 'SF2';
quantifier = {'Min';'Max'};





% Get result case numbers
for ii = 1:size(beamNums,1)
    
    for jj = 1:length(quantifier)
        
        % Get beam element number
        beamNum = beamNums(ii);

        try
            resultCaseName = ['Beam(' num2str(beamNum) ') End 1 ' response ' [' loadCaseName '] (' quantifier{jj} ' Response)'];
            resultCases(ii,jj) = find(strcmp(ResCaseNames,resultCaseName));
        catch
            try
                resultCaseName = ['Beam(' num2str(beamNum) ') End 2 ' response ' [' loadCaseName '] (' quantifier{jj} ' Response)'];
                resultCases(ii,jj) = find(strcmp(ResCaseNames,resultCaseName));
            catch
                continue
            end
        end
        
    end
    
end

% Load St7 API
uID = 1;
ScratchPath = 'C:\Temp';
InitializeSt7(); 

% Open model file
St7OpenModelFile2(uID, modelPath, ScratchPath)

% Open result file
St7OpenResultFile(uID, resultPath)

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

% Close and UNload
CloseAndUnload(uID);

% Filter Beam Results
M1 = max(abs(beamResults(4,:)),abs(beamResults(10,:)))';
P = max(abs(beamResults(1,:)),abs(beamResults(7,:)))';
V = max(abs(beamResults(5,:)),abs(beamResults(9,:)))';






