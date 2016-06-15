function [M1,P,V] = getLLresults(model,res,lcName,beamNums)
%%
%
% jdv 06132016

    % mine result log file for load case names
    lcnames = getLoadCaseNames(res.logpath);

    % get load case numbers for flexure
    [lcNumsFlex,lcNumsShear] = get_lc_nums(lcName,lcnames,beamNums);

    % check for no matches
    if isempty(lcNumsFlex) || isempty(lcNumsShear)
        fprintf('No matches for beam numbers. Sorry. \n');
        return
    end
end


function [lcNumsFlex,lcNumsShear] = get_lc_nums(lcName,lcnames,beamNums)
%%
% searches cell array of load case names and finds each paired load case
% number for the desired array of beamNums.
%
% inputs:
%  lcnames  - cell array vector of raw strings mined from LSL file
%  beamNums - vector of beam numbers to find in results file
% 
%  
% created by nr
% refactored by jdv 06152016

    % search both min and max response
    quantifier = {'Min';'Max'}; 

    % define flexure and shear results flag
    flexFlag = 'BM2'; shearFlag = 'SF2';

    % ensure lcNumsFlex and lcNumsShear exist (in case no pairs)
    lcNumsFlex = [];
    lcNumsShear = [];

    % Get result case numbers
    for ii = 1:length(beamNums)    
        for jj = 1:length(quantifier)        
            try
                % flexure
                resultCaseName = ['Beam(' num2str(beamNums(ii)) ') End 1 ' flexFlag...
                    ' [' lcName '] (' quantifier{jj} ' Response)'];
                lcNumsFlex(ii,jj) = find(strcmp(lcnames,resultCaseName));
                % shear
                resultCaseName = ['Beam(' num2str(beamNums(ii)) ') End 1 ' shearFlag...
                    ' [' lcName '] (' quantifier{jj} ' Response)'];
                lcNumsShear(ii,jj) = find(strcmp(lcnames,resultCaseName));
            catch
                try
                    % flexure
                    resultCaseName = ['Beam(' num2str(beamNums(ii)) ') End 2 ' flexFlag...
                        ' [' lcName '] (' quantifier{jj} ' Response)'];
                    lcNumsFlex(ii,jj) = find(strcmp(lcnames,resultCaseName));
                    % shear
                    resultCaseName = ['Beam(' num2str(beamNums(ii)) ') End 2 ' shearFlag...
                        ' [' lcName '] (' quantifier{jj} ' Response)'];
                    lcNumsFlex(ii,jj) = find(strcmp(lcnames,resultCaseName));
                catch
                    continue
                end
            end        
        end    
    end
end

