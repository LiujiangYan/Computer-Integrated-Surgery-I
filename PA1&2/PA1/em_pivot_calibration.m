function [pivot, g_1st_frame] = em_pivot_calibration(Ng, Nframes, M)
    
    % use the first frame calibration data to define a local coordinate
    G_init = M(1:Ng,:);
    midpoint = sum(G_init)/length(G_init);
    
    % the position of EM markers in the first frame to local cooridnate
    for i=1:Ng
        g_1st_frame(i,:) = G_init(i,:)-midpoint;
    end
    
    % predefine for linear system solving
    A=[];
    b=[];
    
    % loop the data frames
    for i=1:Nframes
        % get the calibration data of each frame
        startpoint = (i-1)*Ng + 1;
        endpoint = i*Ng;
        G = M(startpoint:endpoint,:);
        
        % transform to the local coordinate and get g
        for j=1:3
            g(:,j) = G(:,j) - midpoint(:,j);
        end
        
        % compute the transformation between EM tracker frame and local
        % coordinate for each data frame        
        F = registration(G, g);
        R = F(1:3,1:3);
        p = F(1:3,4);
        
        % construct the matrix for least square problem
        subA = [R, -eye(3)];
        A = [A; subA];
        b = [b; -p];
    end
    
    % solve the linear system and get the pivot value
    pivot = linsolve(A,b);
    
end