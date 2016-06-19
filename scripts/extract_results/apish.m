%% --- API Execution Wrapper --- %%
function model = apish(model)
% function model = apish(model)
% jdv 09212015; 10281015; 10292015

% default session id
uID = 1; 

    % execute main fcn in try/catch
    try 
        % load libs and models
        apiInit(uID,model.sys); 
        
        % main fcn
        model = main(uID,model);
        
        % close model file
        CloseAndUnload(uID);      
        
    catch
        % force close close all refs
        CloseAndUnload(uID);
        rethrow(lasterror);
    end
end % /apish

%% --- Initialize Function --- %%
function apiInit(uID,para)
    % initialize api
    fprintf('Initializing API... \n'); % update UI
    
    % load api files
    fprintf('\tLoading ST7API.DLL... ');
    St7APIConst(); % load constants
    if ~libisloaded('St7API')
        loadlibrary('St7API.dll', 'St7APICall.h');
        iErr = calllib('St7API', 'St7Init');
        HandleError(iErr);
    end
    fprintf('Done. \n'); 
    
    % open st7 model file
    fname = fullfile(para.pathname, para.filename); 
    sname = para.scratchpath;
    iErr = calllib('St7API', 'St7OpenFile', uID, fname, sname);
    HandleError(iErr);
    
    % update
    fprintf('Done. \n');
end % /apiInit


%% --- Main Function --- %%
function model = main(uID,model)
% beware, dragons ahead 

    % Extract and index plane of nodes 
    %   at z = 0 (RAMPS deck nodes)
    dof = get_nodes(uID,0);    
    % save dof struct to model struct
    model.dof = dof;
    
    % Perform A-Priori NFA
    if isfield(model,'nfa')
        nfa = model.nfa;
        % check coords
        nfa = snapcoords(dof,nfa);
        % call api fcn
        [U, freq] = get_nfa(uID,nfa.resultname,nfa.nmodes,nfa.ind);
        % append to nfa struct
        nfa.U = U;
        nfa.freq = freq;
        % save to model struct 
        model.nfa = nfa;
    end
        
    % Perform LSA Static Solver
    if isfield(model,'lsa')        
        lsa = model.lsa;
        loads = lsa.loads;
        resps = lsa.resps;
        % check coords in load and response structs
        loads = snapcoords(dof,loads);
        resps = snapcoords(dof,resps);
        % call lsa solver
        res = get_lsa(uID,lsa.resultname, ...
                          loads.lc, loads.ind, loads.force,...
                          resps.lc, resps.ind);
        % save to stuct
        resps.disp = res; 
        lsa.loads = loads; 
        lsa.resps = resps;
        model.lsa = lsa;
    end
end