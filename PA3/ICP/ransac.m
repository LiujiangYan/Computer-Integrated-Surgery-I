function Fform = ransac(P, p)
    combination_set = nchoosek(1:size(P,1),6);
    
    residual = inf;
    for i=1:size(combination_set,1)
        sub_P = P(combination_set(i,:),:);
        sub_p = p(combination_set(i,:),:);
        [cur_Fform, cur_residual] = registration(sub_P, sub_p);
        if cur_residual < residual
            residual = cur_residual;
            Fform = cur_Fform;
        end
    end
    
end