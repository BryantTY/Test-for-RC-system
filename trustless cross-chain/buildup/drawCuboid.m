function h = drawCuboid(position,varargin)
% DRAWCUBOID - draw a 3D-cuboid in the current axes
%
%   drawCuboid(position) draws a cuboid at the specified position.
%
%       position:       1x6 vector [xmin ymin zmin width depth height]
%
%   drawCuboid(position,param,value,...) sets the specified
%   cuboid-parameters
%
%       EdgeColor:      - color of the edges (default: black)
%       FaceColor:      - color of the faces (default: white)
%       FaceAlpha:      - opacity of the faces (default: 1)
%       LineWidth:      - width of the edges (default: 0.5)
%
%   h = drawCuboid(...) returns the handles of the faces of the cuboid
%
%   Example:
%       figure, drawCuboid([0 0 0 1 1 1]), axis equal

%   Copyright 2014-2015 by MathWorks, Inc.
    p = inputParser;
    p.addOptional('EdgeColor','k');
    p.addOptional('FaceColor','w');
    p.addOptional('FaceAlpha',1,@isscalar);
    p.addOptional('LineWidth',0.5,@isscalar);
    p.parse(varargin{:});
    
    x = [0 0 1 1 0 0 1 1] * position(4) + position(1);
    y = [0 1 1 0 0 1 1 0] * position(5) + position(2);
    z = [0 0 0 0 1 1 1 1] * position(6) + position(3);
    
    vertices = [x(:) y(:) z(:)];
    faces = [1 2 3 4; 5 6 7 8; 1 2 6 5; 3 4 8 7; 1 4 8 5; 2 3 7 6];
    
    h = patch('Vertices',vertices,'Faces',faces,...
        'EdgeColor',p.Results.EdgeColor,'FaceColor',p.Results.FaceColor,...
        'FaceAlpha',p.Results.FaceAlpha,'LineWidth',p.Results.LineWidth);
end
