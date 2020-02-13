function gwdrawpolicy(P)
% GWDRAWPOLICY draws the policy of the gridworld as an arrow in each state,
% pointing in the direction to move from that state. This should be used
% together with gwdraw. If the policy "P" is provided to the gwdraw
% function, GWDRAWPOLICY will be called automatically.
% 
% Example:
%     P = getpolicy(Q);
%     gwdraw();
%     GWDRAWPOLICY(P);
%
% Example:
%     P = getpolicy(Q);
%     gwdraw(episodeNr, P);
%
% See also: gwdraw

global GWXSIZE;
global GWYSIZE;
global GWFEED;
global GWTERM;

% Using Matlab built-in function (looks worse but is faster)
% [MX,MY] = meshgrid(1:GWXSIZE, 1:GWYSIZE);
% VALID = (GWTERM==0) & ~isnan(GWFEED);
% U = ((P==3)-(P==4)) .* double(VALID);
% V = ((P==1)-(P==2)) .* double(VALID);
% quiver(MX,MY,U,V, 'AutoScaleFactor', 0.45, 'Color', 'r', 'LineWidth', 1);

% Using custom arrows (looks nicer but is slower)
for x = 1:GWXSIZE
  for y = 1:GWYSIZE
    if ~GWTERM(y,x) && ~isnan(GWFEED(y,x))
        gwplotarrow([y x], P(y, x));
    end
  end
end

drawnow;

end

