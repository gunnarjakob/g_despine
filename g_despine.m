function [ax,nax] = g_despine(ax,offset)

% G_DESPINE Offset x and y axis away from origin
%
%   [ax,nax] = g_depsine(AX,OFFSET)
%
%   INPUT   ax - axis to despine (optional, default gca)
%           offset - offset (fraction of longer axis, optional,
%                            default 0.01)
%
%   OUTPUT  ax - handle to plot axis
%           nax - handle to spine axis (nax(1:2)) and grid axis (nax(3))
%
%   Gunnar Voet
%   gvoet@ucsd.edu
%
%   Created: 10/22/2015

% Get current axes if none given
if nargin==0
  ax = gca;
end

% Set standard offset
if nargin<2
  offset = 0.01;
end

% Get current figure
fig = gcf;

% Make initial axis invisible
set(ax,'visible','off')

% Get axis properties
XLim   = ax.XLim;
YLim   = ax.YLim;
XDir   = ax.XDir;
YDir   = ax.YDir;
XTick  = ax.XTick;
YTick  = ax.YTick;
XLabel = ax.XLabel.String;
YLabel = ax.YLabel.String;

FontSize = ax.FontSize;

% Get figure properties
Pos = ax.Position;
FPos = fig.PaperPosition;

% Ratio of x to y
fxyratio = (FPos(3)-FPos(1))/(FPos(4)-FPos(2));

% Calculate offset as offset*x or *y, depending on which is larger
xp = Pos(3);
yp = Pos(4);
if xp > yp
xoffset = offset*xp;
yoffset = offset*xp*fxyratio;
else
yoffset = offset*yp;
xoffset = offset*xp/fxyratio;
end

% Create new axes for x and y
nax(1) = axes('position',[Pos(1)-xoffset Pos(2) 0.00001 Pos(4)],...
              'ylim',YLim,'TickDir','out','ydir',YDir);
nax(2) = axes('position',[Pos(1) Pos(2)-yoffset Pos(3) 0.00001],...
              'xlim',XLim,'TickDir','out','xdir',XDir);

% Axis labels
nax(1).YLabel.String = YLabel;
nax(2).XLabel.String = XLabel;

% More axis settings
for i = 1:2
  nax(i).FontSize = FontSize;
  nax(i).TickLength = [0 0];
end

% Grid axis
nax(3) = axes('position',Pos,'visible','off','xlim',XLim,'ylim',YLim,...
              'xdir',XDir,'ydir',YDir);
hold on

% Plot grid
for i = 1:length(XTick)
  h = plot(repmat(XTick(i),1,2),YLim,'color',gr(0),'linewidth',0.25);
  h.Color(4) = 0.3;
end
for i = 1:length(YTick)
  h = plot(XLim,repmat(YTick(i),1,2),'color',gr(0),'linewidth',0.25);
  h.Color(4) = 0.3;
end


% Back to inital axis
axes(ax)

% Bring grid axis to top layer (you can set this to 'bottom' if you like
uistack(nax(3),'top')