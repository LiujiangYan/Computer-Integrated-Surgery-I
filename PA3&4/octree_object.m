classdef octree_object < handle
    properties
        Points;
        UpperBoundary;
        LowerBoundary;
        TreeDepth;
        Parent;
    end
    
    methods
        function this = octree_object(points)
            this.Points = points;
            this.UpperBoundary = max(points, [], 2);
            this.LowerBoundary = min(points, [], 2);
            this.TreeDepth = 0;
            this.Parent = [];
            
            this.construct;
        end
        
        function construct(this)
            
        end
    end
end