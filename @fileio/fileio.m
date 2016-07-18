classdef fileio < matlab.mixin.SetGet
%% classdef fileio
% author:  jdv
% create date: 24-May-2016 23:39:23

	%% -- object properties -- %%
	properties
	end

	%% -- dependent properties -- %%
	properties (Dependent)
	end

	%% -- developer properties -- %%
	properties (Access = private)
	end

	%% -- dynamic methods-- %%
	methods
		%% -- constructor -- %%
		function obj = fileio()
        end
        
        function read_xls(obj,fname,tab)
            % fname = full file path
            % tname = tab name
            % name/value indices -> 1, 2
            % error screens null tab entry, i.e. tab input is optional
            % autocorrects missing file extension
            fname = obj.chk_ext(fname,'.xlsx');
            if nargin < 3, tab = 'Sheet1'; end
            names = fieldnames(obj);
            nInd = 1; % name index
            vInd = 2; % value index
            uInd = 3; % units index
            % read excel file
            [~,~,raw] = xlsread(fname,tab);
            % loop for compatable inputs
            %   variable names must be same name as obj property
            tot = 0; % total load counter
            fprintf('Reading from file... \n');
            for ii = 1:size(raw,1)
                for jj = 1:length(names)
                    if strcmp(names{jj}, raw{ii,nInd})
                        % save matched name/value pair
                        obj.(raw{ii,nInd}) = raw{ii,vInd};
                        % update user
                        fprintf('\tLoaded: %s as %s %s \n', ...
                            raw{ii,nInd},...
                            num2str(raw{ii,vInd}),...
                            raw{ii,uInd});
                        tot = tot+1;
                    end
                end
            end
            fprintf('Total fields read: %i. Done. \n',tot);
        end
        
        function read_csv(obj,fname)
            % fname = full file path
            % tname = tab name
            % name/value indices -> 1, 2
            % auto corrects missing file extension
            fname = obj.chk_ext(fname,'.csv');
            names = fieldnames(obj);
            nInd = 1; % name index 
            vInd = 2; % value index
            uInd = 3; % units index
            % read excel file
            [~,~,raw] = xlsread(fname);
            % loop for compatable inputs
            %   variable names must be same name as obj property
            tot = 0; % total load counter
            fprintf('Reading from file... \n');
            for ii = 1:size(raw,1)
                for jj = 1:length(names)
                    if strcmp(names{jj}, raw{ii,nInd})
                        % save matched name/value pair
                        obj.(raw{ii,nInd}) = raw{ii,vInd};
                        % update user
                        fprintf('\tLoaded: %s as %s %s \n', ...
                            raw{ii,nInd},...
                            num2str(raw{ii,vInd}),...
                            raw{ii,uInd});
                        tot = tot+1;
                    end
                end
            end
            fprintf('Total fields read: %i. Done. \n',tot);
        end
         
        function write_xls(obj,fname,tab)
            % fname = fullfile path
            % tab = optional tab for xls sheets
            if nargin < 3, tab = 'Sheet1'; end % error screen null tab
            [name,value] = obj.get_strings(); % serialize data
            fprintf('Writing to file... ');
            % error screen null tab entry (for csv files, etc)
            xlswrite(fname,[name value],tab);
            fprintf('Done.\n'); 
        end
        
        function write(obj,fname,del)
            % low level file write. optional delimiter field
            % del [comma default]
            %  options: 
            %   ',' or 'comma' for comma 
            %   'tab' 't' or '\t' for tab
            if nargin < 3, del = ','; end % comma del. default
            if strcmp(del,'comma'), del = ','; end
            if strcmp(del,'t') || strcmp(del,'tab'), del = '\t'; end 
            tk = 0; % write counter
            [name,value]= obj.get_strings();
            fprintf('Writing to file... ');
            fid = fopen(fname,'w');
            for ii = 1:length(name)
                fprintf(fid,sprintf('%s%s%s\n',name{ii},del,value{ii}));
                tk = tk+1;
            end
            fclose(fid);
            fprintf('Done. Total fields written: %i.\n',tk);
        end            
        
        function [name,value] = get_strings(obj)
            % raw{1,1} = {'fieldname1','value1'};
            name = fieldnames(obj);
            value = cell(size(name));
            for ii = 1:length(name)
                value{ii} = num2str(obj.(name{ii}));
            end
        end             

		%% -- dependent methods -- %%

	end

	%% -- internal methods -- %%
	methods (Access = private)
        
        function fid = open(obj,perm)
        % open file with error screening capability. 
        % this function is meant to be a catch-all for catching errors (for
        % lack of a better word) and aid in scalability
        % 
        % perm = optional permissions, defaults to read only
        %    
            if nargin < 2 % error screen null perm entry
                perm = 'r'; % default to read only
            end
            % open file with permissions
            [fid, errmsg] = fopen(obj.fullname,perm);
            if ~isempty(errmsg)
                error(errmsg);
            end
        end

        function fname = chk_ext(obj,fname,ext)
            % checks file name for extension, if not present it is added
            if ~strcmp(fname(end+1-length(ext):end),ext)
                fname = [fname ext];
            end
        end
    end
end
