function gwplotarrow(position, action)
% GWPLOTARROW plots an arrow at a position given the action. Same encoding
% of actions as in gwaction. Useful for plotting the behaviour of an optimal
% policy given a Q-function. This is automatically used by gwplotpolicy and
% there is no need to use this function directly unless you want to draw a
% specific path of the agent.
%
% The position argument is a 2-element vector of coordinates [y,x], and
% the action argumant is a scalar from 1 to 4 according to the encoding
% used in gwaction.
%
% Example:
%     gwdraw();
%     GWPLOTARROW([5,3], 2);
%
% See also: gwaction, gwdraw, gwdrawpolicy

hold on;
if action == 0
    scatter(position(2),position(1),5,'b','filled');
else
    hold on;
    if action == 1
      symb = 'rv';
      next_position = [position(1) position(2)]' + 0.5*[1 0]';
    elseif action == 2
      symb = 'r^';
      next_position = [position(1) position(2)]' + 0.5*[-1 0]';
    elseif action == 3
      symb = 'r>';
      next_position = [position(1) position(2)]' + 0.5*[0 1]';
    elseif action == 4
      symb = 'r<';
      next_position = [position(1) position(2)]' + 0.5*[0 -1]';
    end
   plot([position(2),next_position(2)], [position(1),next_position(1)],'r');
   plot([next_position(2)], [next_position(1)], symb);

    %        scatter(next_position(1),next_position(2),5,'r', 'filled');
end



    
    