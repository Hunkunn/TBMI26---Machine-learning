function gwdraw(e, P)
% GWDRAW draws gridworld and robot. If the episode number "e" is provided,
% the episode number will be shown in the title. If the policy "P" is
% provided, it will also be drawn on top of the world.
%
% Example:
%     P = getpolicy(Q);
%     e = 10;
%     GWDRAW(e, P);
%
% See also: getpolicy, gwdrawpolicy

global GWWORLD;
global GWXSIZE;
global GWYSIZE;
global GWPOS;
global GWFEED;
global GWTERM;
global GWNAME;

% Draw background and set format
cla;
hold on;
imagesc(GWFEED, 'AlphaData', ~isnan(GWFEED));
xlabel('X');
ylabel('Y');

% Set title
if nargin >= 1
    title(sprintf('Feedback Map, World %i\n%s\nEpisode %i', GWWORLD, GWNAME, e));
else
    title(sprintf('Feedback Map, World %i\n%s', GWWORLD, GWNAME));
end

% Create a gray rectangle for the robot
rectangle('Position',[GWPOS(2)-0.5, GWPOS(1)-0.5, 1, 1], 'FaceColor', [0.5,0.5,0.5]);

% If you want to see the color scale of the world you can uncomment this
% line. This will slow down the drawing significantly.
%colorbar;

% Green circle for the goal
for x = 1:GWXSIZE
  for y = 1:GWYSIZE
    if GWTERM(y,x)
      radius = 0.5;
      rectangle('Position',[x-0.5, y-0.5, radius*2, radius*2],...
                'Curvature',[1,1],...
                'FaceColor','g');
    end
  end
end

% If you want to make the robot move slower (to make it easier to
% understand what it does) you can uncomment this line.
%pause(0.1);

if (nargin >= 2)
    gwdrawpolicy(P);
end

axis image;
axis ij;
drawnow;
end


