% Adaptive management cycle 
fig = figure('Color','w','Units','pixels','Position',[100 100 660 520]);
ax  = axes('Parent',fig,'Position',[0 0 1 1]);
hold(ax,'on'); axis(ax,'equal'); axis(ax,'off');
xlim(ax,[-1.95 1.95]); ylim(ax,[-1.55 1.55]);

% geometry
R = 1.00; shaftHW = 0.090; barb = 0.085;   % ring radius, shaft half-width, wing
headDeg = 18; gapDeg = 24; nStage = 5;      % head length, gap at labels, # stages
col = [0 0 0]; d2r = pi/180;
segDeg = 360/nStage;                         % 72 deg per stage
anchor = 90 - (0:nStage-1)*segDeg;           % label angles, clockwise from top
Ro = R + shaftHW; Ri = R - shaftHW; n = 50;

% arrows (clockwise)
for k = 1:nStage
    thS = (anchor(k)          - gapDeg/2) * d2r;   % start, just CW of label k
    thE = (anchor(k) - segDeg + gapDeg/2) * d2r;   % tip, before next label
    thB = thE + headDeg*d2r;                       % base of arrowhead
    aO = linspace(thS,thB,n);                      % outer shaft edge
    aI = linspace(thB,thS,n);                      % inner shaft edge
    X = [ Ro.*cos(aO), (R+shaftHW+barb)*cos(thB), R*cos(thE), ...
          (R-shaftHW-barb)*cos(thB), Ri.*cos(aI) ];
    Y = [ Ro.*sin(aO), (R+shaftHW+barb)*sin(thB), R*sin(thE), ...
          (R-shaftHW-barb)*sin(thB), Ri.*sin(aI) ];
    fill(ax,X,Y,col,'EdgeColor','none');
end

% labels
text(ax, 0.00, 1.30,{'Assess Problems and','Objectives'},'HorizontalAlignment','center','VerticalAlignment','bottom','FontName','Helvetica','FontSize',13,'Color',col);
text(ax, 1.26, 0.45,{'Design','Management','Actions'},'HorizontalAlignment','left','VerticalAlignment','middle','FontName','Helvetica','FontSize',13,'Color',col);
text(ax, 0.80,-1.20,{'Implement','Actions'},'HorizontalAlignment','center','VerticalAlignment','top','FontName','Helvetica','FontSize',13,'Color',col);
text(ax,-0.80,-1.20,{'Monitor and','Evaluate','Results'},'HorizontalAlignment','center','VerticalAlignment','top','FontName','Helvetica','FontSize',13,'Color',col);
text(ax,-1.26, 0.45,{'Adjust and','Plan Again'},'HorizontalAlignment','right','VerticalAlignment','middle','FontName','Helvetica','FontSize',13,'Color',col);