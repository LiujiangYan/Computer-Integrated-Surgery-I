function F = BernsteinMat(q)   
    % get the number of experiental distorted data points
    [height, ~] = size(q);
    % predefine the size of Bernstein Matrix
    F = zeros(height, 216);
    % row by row
    for n=1:height
        for i=0:5
            for j=0:5
                for k=0:5
                    h = n;
                    w = i*6^2 + j*6 + k + 1;
                    % compute Bx By Bz respectively
                    Bx = nchoosek(5,i)*((1-q(n,1))^(5-i))*q(n,1)^i;
                    By = nchoosek(5,j)*((1-q(n,2))^(5-j))*q(n,2)^j;
                    Bz = nchoosek(5,k)*((1-q(n,3))^(5-k))*q(n,3)^k;
                    
                    % assign the product 
                    F(h,w) = Bx*By*Bz;
                end
            end
        end
    end
end