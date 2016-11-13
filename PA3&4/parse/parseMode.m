function [Mode] = parseMode(filepath, Nvertices, Nmodes)
    Mode = zeros(Nvertices, 3, Nmodes);
    for i=1:Nmodes
        startpoint = (i-1)*(Nvertices+1)+2;
        endpoint = startpoint + Nvertices - 1;
        Mode(:,:,i) = csvread(filepath, ...
            startpoint, 0, [startpoint 0 endpoint 2]);
    end
end