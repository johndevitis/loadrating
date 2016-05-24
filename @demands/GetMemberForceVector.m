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