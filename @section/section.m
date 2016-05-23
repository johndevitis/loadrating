classdef section < matlab.mixin.SetGet
%% classdef section 
% author: jdv
% date: 04232015 
    properties
        nSpans % number of spans
        loc % girder location [interior/exterior]
        L % span length [in]
        Lb % max unbraced length [in]
        Es % young's modulus, steel [psi]
        Fy % yield strength of flanges and web [psi]
        fc % compressive strength of concrete deck
        ts % thickness of concrete deck [in]
        be % effective width of concrete deck [in]
        dh % depth of haunch [in]
        dw % depth of web
        tw % thickness of web [in]
        bf_top % width of top flange [in]
        tf_top % thickness of top flange [in]
        bf_bot % width of bottom flange [in]
        tf_bot % thickness of bottom flange [in]
        wDL % nonsuperimposed deadload [lb]
        wSDL % superimposed deadload [lb]
        wSDW % wearing surface deadload [lb]
    end    
    
    properties (Dependent = true)   
        d % total depth of non-composite steel section (wide flange)[in] 
        Ec % deck modulous [psi] -> 57000*sqrt(fc)        
    end    
    
    methods        
        %% -- constructor -- %
        function obj = section()            
        end
        
        %% -- file io -- %
        function read_xls(obj,fname,tname)
            % fname = full file path
            % tname = tab name
            % name/value indices -> 1, 4
            names = fieldnames(obj);
            nInd = 2; % name index 
            uInd = 3; % units index
            vInd = 4; % value index
            % read excel file
            [~,~,raw] = xlsread(fname,tname);
            % loop for compatable inputs
            %   variable names must be same name as obj property
            fprintf('Loading from xls file... \n');
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
                    end
                end
            end
            fprintf('Done.\n');
        end
        
        
        %% -- dependent methods -- %
        function d = get.d(obj)
        % full depth of steel section
            d = obj.dw + obj.tf_top + obj.tf_bot;
        end
        
        function Es = get.Es(obj)   
        % deck modulous
        % default is Ec = 57000*sqrt(fc) [psi] instead of LRFD's
        % 1820*sqrt(fc) [ksi] as it is slightly conservative
            Ec = 57000*sqrt(obj.fc);
        end
        
                
    end    
end