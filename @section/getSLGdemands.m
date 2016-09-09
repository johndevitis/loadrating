function d = getSLGdemands(s)
%%
% get single line girder demands
% input s -> section classdef
% output d -> demands structure
% default discretization -> 1ft
%
    %% pull data from section class
    nSpans = s.nSpans;
    Es = s.Es; %[psi]
    TotalLength = s.L/12*nSpans; % in -> ft
    d.wDL = s.wDL;
    d.wSDL = s.wSDL;
    d.wSDW = s.wSDW;

    for ii = 1:nSpans
        SpanLength(ii) = round(s.L/12)'; % in -> ft
    end
    
    nElem = sum(SpanLength); % # of beam elements discretized at 1 foot
    nNode = nElem + 1; % number of nodes along entire length
    nDOF = nNode*2; % number of DOFs (deflection/rotation at each node)

    %% Assemble in global stiffness matrix
    % assumimg unit/dimensionless I - in lb/in^5
    l = 12; % [inches], length of beam elements, default discretization
    % Element stiffness matrix
    k = Es/l^3* [12,  6*l,   -12,  6*l;
                6*l, 4*l^2, -6*l, 2*l^2;
                -12, -6*l,  12,   -6*l;
                6*l, 2*l^2, -6*l, 4*l^2];

    % Pre-allocate global stiffness matrix
    K = zeros(nDOF);

    % Fill global stiffness matrix with element stiffness matricies
    for ii = 1:nElem % for each beam element
        Loc = 2*ii-1; % location of element in global matrix        
        K(Loc:Loc+3,Loc:Loc+3) = K(Loc:Loc+3,Loc:Loc+3) + k;
    end

    %% Apply Boundary Conditions
    
    % Determine nodes with fixed DOFs 
    Fixed = zeros(nSpans, 1);
    for ii = 1:nSpans
        Fixed(ii) = sum(SpanLength(1:ii));
    end
    Fixed = [1; 2*Fixed + 1];

    % Remove DOFs at fixed nodes
    kInd = 1:nDOF;
    kInd = removerows(kInd', Fixed);
    K = removerows(K, Fixed);
    K = removerows(K', Fixed)';

    %% Determine displacements for DL and LL 
    % (trucks and lane loads)

    % Run GetDisplacementVector() to find displacements 
    [Delta_Min, Delta_Max, D] = GetDisplacementVector(nDOF, K, kInd, Fixed);

    % Fill 'Delta' Matricies --------------------------------------------------
    % Superimpose lane and truck loading AASHTO 2012 [3.6.1.3], all [in^5]
    % Delta_Min
    Delta_Min(end+(1:3),:) = Delta_Min(padarray(2,1,2),:) + Delta_Min((7:9),:); % Truck_Forward
    Delta_Min(end+(1:3),:) = Delta_Min(padarray(3,1,3),:) + Delta_Min((7:9),:); % Truck_Backward
    Delta_Min(end+(1:3),:) = Delta_Min(padarray(4,1,4),:) + Delta_Min((7:9),:); % Truck_Forward_Dual
    Delta_Min(end+(1:3),:) = Delta_Min(padarray(5,1,5),:) + Delta_Min((7:9),:); % Truck_Backward_Dual
    Delta_Min(end+(1:3),:) = Delta_Min(padarray(6,1,6),:) + Delta_Min((7:9),:); % Tandem
    % Delta_Max
    Delta_Max(end+(1:3),:) = Delta_Max(padarray(2,1,2),:) + Delta_Max((7:9),:); % Truck_Forward
    Delta_Max(end+(1:3),:) = Delta_Max(padarray(3,1,3),:) + Delta_Max((7:9),:); % Truck_Backward
    Delta_Max(end+(1:3),:) = Delta_Max(padarray(4,1,4),:) + Delta_Max((7:9),:); % Truck_Forward_Dual
    Delta_Max(end+(1:3),:) = Delta_Max(padarray(5,1,5),:) + Delta_Max((7:9),:); % Truck_Backward_Dual
    Delta_Max(end+(1:3),:) = Delta_Max(padarray(6,1,6),:) + Delta_Max((7:9),:); % Tandem

    % Determine Member Actions Due to DL and LL -------------------------------
    % (Moment and Shear)

    % Run GetMemberForceVector() to find member actions
    [M_Max, M_Min, V_Max, V_Min, ~, ~] = GetMemberForceVector(D, Es, nElem);

    % Fill 'M' and 'V' matricies ----------------------------------------------
    % Superimpose Moment for lane and truck loading, all [lb.in]
    % M_Min
    M_Min(end+(1:3),:) = M_Min(padarray(2,1,2),:) + M_Min((7:9),:); % Truck_Forward
    M_Min(end+(1:3),:) = M_Min(padarray(3,1,3),:) + M_Min((7:9),:); % Truck_Backward
    M_Min(end+(1:3),:) = M_Min(padarray(4,1,4),:) + M_Min((7:9),:); % Truck_Forward_Dual
    M_Min(end+(1:3),:) = M_Min(padarray(5,1,5),:) + M_Min((7:9),:); % Truck_Backward_Dual
    M_Min(end+(1:3),:) = M_Min(padarray(6,1,6),:) + M_Min((7:9),:); % Tandem
    % M_Max
    M_Max(end+(1:3),:) = M_Max(padarray(2,1,2),:) + M_Max((7:9),:); % Truck_Forward
    M_Max(end+(1:3),:) = M_Max(padarray(3,1,3),:) + M_Max((7:9),:); % Truck_Backward
    M_Max(end+(1:3),:) = M_Max(padarray(4,1,4),:) + M_Max((7:9),:); % Truck_Forward_Dual
    M_Max(end+(1:3),:) = M_Max(padarray(5,1,5),:) + M_Max((7:9),:); % Truck_Backward_Dual
    M_Max(end+(1:3),:) = M_Max(padarray(6,1,6),:) + M_Max((7:9),:); % Tandem 

    % Superimpose Shear for lane and truck loading, all [lb.in]
    % V_Min
    V_Min(end+(1:3),:) = V_Min(padarray(2,1,2),:) + V_Min((7:9),:); % Truck_Forward
    V_Min(end+(1:3),:) = V_Min(padarray(3,1,3),:) + V_Min((7:9),:); % Truck_Backward
    V_Min(end+(1:3),:) = V_Min(padarray(4,1,4),:) + V_Min((7:9),:); % Truck_Forward_Dual
    V_Min(end+(1:3),:) = V_Min(padarray(5,1,5),:) + V_Min((7:9),:); % Truck_Backward_Dual
    V_Min(end+(1:3),:) = V_Min(padarray(6,1,6),:) + V_Min((7:9),:); % Tandem
    % V_Max
    V_Max(end+(1:3),:) = V_Max(padarray(2,1,2),:) + V_Max((7:9),:); % Truck_Forward
    V_Max(end+(1:3),:) = V_Max(padarray(3,1,3),:) + V_Max((7:9),:); % Truck_Backward
    V_Max(end+(1:3),:) = V_Max(padarray(4,1,4),:) + V_Max((7:9),:); % Truck_Forward_Dual
    V_Max(end+(1:3),:) = V_Max(padarray(5,1,5),:) + V_Max((7:9),:); % Truck_Backward_Dual
    V_Max(end+(1:3),:) = V_Max(padarray(6,1,6),:) + V_Max((7:9),:); % Tandem 


    % Save to Parameters
    d.M_Max = M_Max;
    d.M_Min = M_Min;
    d.V_Max = V_Max;
    d.V_Min = V_Min;

    % Find max\min DL and LL for each span ------------------------------------

    for i=1:length(Fixed)-1
        range = (Fixed(i)+1)/2:(Fixed(i+1)+1)/2;
        % Dead Load Moment
        d.maxDLM(i) = max(max(M_Max(range,1))); % in lb.in
        d.minDLM(i) = min(min(M_Min(range,1)));
        % Dead Load Shear
        d.maxDLV(i) = max(max(V_Max(range,1))); % in lb
        d.minDLV(i) = min(min(V_Min(range,1)));
        % Live Load Moment
        d.maxM(i) = max(max(M_Max(range,:))); % in lb.in
        d.minM(i) = min(min(M_Min(range,:))); 
        % Live Load Shear 
        d.maxV(i) = max(max(V_Max(range,:))); % in lb
        d.minV(i) = min(min(V_Min(range,:)));
    end

    % Find max/min DL and LL for points of interest ---------------------------

    % Simple spans: Moment at midspan and shear at supports
    % Continuous spans: Positive moment at midspan for interior spans and 0.4L
    % at exterior spans. Negative moment and shear over supports

    for i=1:nSpans
        range = (Fixed(i)+1)/2:(Fixed(i+1)+1)/2;
        % POI
        if nSpans == 1
            POI = round(0.5*(range(end)-range(1)))+range(1);
        elseif i == 1 
            POI = round(0.4*(range(end)-range(1)))+range(1);
        elseif i == nSpans 
            POI = round(0.6*(range(end)-range(1)))+range(1);
        else
            POI = round(0.5*(range(end)-range(1)))+range(1);
        end
        % Dead Load Moment
        d.minDLM_POI(i,:) = M_Min([(Fixed(i)+1)/2, (Fixed(i+1)+1)/2],1);
        d.maxDLM_POI(i,1) = M_Max(POI,1); % in lb.in  
        % Dead Load Shear
        d.maxDLV_POI(i,:) = abs(V_Max([(Fixed(i)+1)/2, (Fixed(i+1)+1)/2],1)); % in lb
        % Live Load Moment
        d.minM_POI(i,:) = min(M_Min([(Fixed(i)+1)/2, (Fixed(i+1)+1)/2],:)); % [lb.in]
        d.maxM_POI(i,:) = max(M_Max(POI,:)); % [lb.in]
        % Live Load Shear
        d.maxV_POI(i,:) = max(abs(V_Max([(Fixed(i)+1)/2, (Fixed(i+1)+1)/2],:))); % [lb]
    end

    % Get dead load force responses
    d = GetDeadLoadForces(d);
 
end

function [Delta_Min, Delta_Max, D] = GetDisplacementVector(numDOF, condK, condInd, Fixed)
%% construct displacement vector from distributed loading
%
%
    laneLoad = -1; % Dead Load

    % Construct Displacement Vector
    % Distributed Loading
    %**************************************************************************

    L = 12; % in inches
    D = zeros(numDOF,1);   
    FEM = zeros(numDOF,1); %initialize load vector

    % Sum distributed load as resultant shear
    FEM(3:2:end-3) = laneLoad*L;
    FEM(1) = laneLoad*L/2;
    FEM(end-1) = laneLoad*L/2;

    % Sum distributed load as resultant fixed end moment
    FEM(2) = laneLoad*L^2/12;
    FEM(end) = -1*laneLoad*L^2/12;

    % Remove DOFs from force vector and solve for displacement
    ft = removerows(FEM,Fixed);
    dt = condK\ft; % D = K^-1*(F+FEM);
    D(condInd) = dt;

    % Find max at each DOF
    Delta_Max = D;
    Delta_Min = D;
end 

function [M_Max, M_Min, V_Max, V_Min, M, V] = GetMemberForceVector(Delta, E, numEle)
    % Initialize Vectors
    V = zeros(numEle+1, size(Delta,2), size(Delta,3)); 
    M = V; 
    q = -1;
    L = 12; % 12 inch lengths
    eleK=E/L^3*[12,  6*L,   -12,  6*L;
                6*L, 4*L^2, -6*L, 2*L^2;
                -12, -6*L,  12,   -6*L;
                6*L, 2*L^2, -6*L, 4*L^2];
    % Check for distributed loads and populate FEM vector
    eleFEM = [q*L/2; q*L^2/12; q*L/2; -1*q*L^2/12]; 
    % Get local (internal) nodal actions from global displacement matrix
    for i=1:numEle % for each ele 
        for j=1:size(Delta,2) % for each load location (lane loads have a singular value        
            Loc = 2*i-1;        
            K = eleK;        
            V(i,j,:) = K(1,:)*squeeze(Delta(Loc:Loc+3,j,:)) - eleFEM(1,:);
            M(i,j,:) = -1*K(2,:)*squeeze(Delta(Loc:Loc+3,j,:)) + eleFEM(2,:);
            V(i+1,j,:) = -1*K(3,:)*squeeze(Delta(Loc:Loc+3,j,:)) + eleFEM(3,:);
            M(i+1,j,:) = K(4,:)*squeeze(Delta(Loc:Loc+3,j,:)) - eleFEM(4,:);        
        end
    end
    % Find max at each DOF
    M_Max = max(max(M,[],3),[],2);
    M_Min = min(min(M,[],3),[],2);
    V_Max = max(max(V,[],3),[],2);
    V_Min = min(min(V,[],3),[],2);
end

function d = GetDeadLoadForces(d)
    % Dead Load Moment Non-superimposed (Deck, Girder Diaphragms)
    d.MDL_pos = d.wDL.*d.maxDLM_POI;
    d.MDL_neg = min(d.wDL.*d.minDLM_POI,[],2);
    % Dead Load Moment Superimposed (Sidewalk and Barriers)
    d.MSDL_pos = d.wSDL*d.maxDLM_POI;
    d.MSDL_neg = min(d.wSDL*d.minDLM_POI,[],2);
    % Dead Load Moment Superimposed (Future wearing surface)
    d.MSDW_pos = d.wSDW*d.maxDLM_POI;
    d.MSDW_neg = min(d.wSDW*d.minDLM_POI,[],2);
    % Dead Laod Shear (DC1 and DC2)
    d.VDL = max((d.wDL+d.wSDL)*d.maxDLV_POI, [], 2);
    % Dead Load Shear (DW)
    d.VDW = max(d.wSDW*d.maxDLV_POI, [], 2);
end
