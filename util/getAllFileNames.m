function fileNames = getAllFileNames(pname,ext)
%% getAllFileNames
%
% returns a cell array all file names in given path pname with given 
% extension ext. includes subdirectories
%
% example: 
%   files = getAllFileNames(pwd,'csv')
%
% jdv 07142016   

    %% generate path list 
        delim = ';';             % matlab path delimiter
        pnames = genpath(pname); % get all sub dirs

        % error screen end path sep
        if isequal(pnames(end),';')  
            pnames = pnames(1:end-1);
        end
        % missing dot in ext
        if ext(1) ~= '.'
            ext = ['.' ext];
        end

        % parse paths
        pathList = strread(pnames,'%s','delimiter',';');
        

    %% iterate pathList and look for .ext files
        fileNames = [];             % preallocate        
        for ii = 1:length(pathList) % loop sub directories
            
            % list all *.ext files
            fnames = dir(fullfile(pathList{ii},['*' ext])); 

            % save if populated
            if ~isempty(fnames)
                % concat path and name to vector of cellarrays
                fnamesFull = fullfile(pathList{ii},{fnames.name}');

                % concat to found names to fileNames array
                fileNames = [fileNames; fnamesFull];
            end
        end        
        
end
