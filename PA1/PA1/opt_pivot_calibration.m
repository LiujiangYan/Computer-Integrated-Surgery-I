function pivot = opt_pivot_calibration(d, ND, NH, Nframes, M)
    % use the first frame calibration data to define the local coordinate
    % first get the transformation FD by 3D point registration
    D = M(1:ND,:);
    FD = registration(D,d);
    
    % get the first frame calibration data 
    % and transform the data with respect to EM tracker frame
    H_init = M(ND+1:ND+NH,:);
    H_init(:,4) = 1;
    H_EM_init = FD\H_init';
    H_EM_init = H_EM_init';
    
    % get the midpoint as the origin of the local coordinate
    midpoint = sum(H_EM_init)/length(H_EM_init);
    
    % predefine for linear system solving
    A=[];
    b=[];
    
    % loop the data frames
    for i = 1:Nframes
        
        % read the coordinate D and H respcetively
        D_start = (i-1)*(ND+NH)+1;
        D_end = (i-1)*(ND+NH)+ND;
        H_start = (i-1)*(ND+NH)+ND+1;
        H_end = i*(ND+NH);
        
        D = M(D_start:D_end,:);
        H = M(H_start:H_end,:);
        
        % compute the transformation for each data frame
        FD = registration(D,d);
        
        % transform H with respect to EM tracker frame
        H(:,4) = 1;
        H_EM = (FD\H')';
        H_EM = H_EM(:,1:3);
        
        % transform to the local coordinate and get h
        for j=1:3
            h_EM(:,j) = H_EM(:,j) - midpoint(j);
        end
        
        % compute the transformation between EM tracker frame and local
        % coordinate for each data frame
        F = registration(H_EM, h_EM);
        R = F(1:3,1:3);
        p = F(1:3,4);
        
        % construct the matrix for least square problem
        subA = [R,-eye(3)];
        A = [A; subA];
        b = [b; -p];
    end
    
    % solve the linear system and get the pivot value
    pivot = linsolve(A,b);
end
