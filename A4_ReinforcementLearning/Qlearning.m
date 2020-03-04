clc
clear
%% Initialization
%  Initialize the world, Q-table, and hyperparameters
worldnumber = 4;
world=gwinit(worldnumber);
numEpisodes = 4000;
discount_factor = 0.8;
learning_rate = 0.3;
worldSizeX = getfield(gwstate(),'xsize');
worldSizeY = getfield(gwstate(),'ysize');
actions = 4;
Q = rand(worldSizeX,worldSizeY,actions);
Q(1,:,4) = -inf;
Q(worldSizeX,:,3) = -inf;
Q(:,1,2) = -inf;
Q(:,worldSizeY,1) = -inf;
%% Training loop
%  Train the agent using the Q-learning algorithm.
for epsiode = 1:numEpisodes
    world = gwinit(worldnumber);
    while world.isterminal == 0
        position = world.pos;
        [a, oa] = chooseaction(Q, position(2), position(1), [1 2 3 4], [1 1 1 1], 0.8);
        world = gwaction(a);
        valMat = getvalue(Q);
        newMax = valMat(world.pos(2),world.pos(1));
        reward = world.feedback;
        Q(position(2),position(1),a) = (1-learning_rate)*Q(position(2),position(1),a)...
            +learning_rate*(reward+discount_factor*newMax);
        %gwdraw()
        %world.isterminal
        %world.pos
    end
end
policy = getpolicy(Q);
value = getvalue(Q);
gwdraw(0,policy')

%% Test loop
%  Test the agent (subjectively) by letting it use the optimal policy
%  to traverse the gridworld. Do not update the Q-table when testing.
%  Also, you should not explore when testing, i.e. epsilon=0; always pick
%  the optimal action.
world = gwinit(worldnumber);
while world.isterminal == 0
    position = world.pos;
    [a, oa] = chooseaction(Q, position(2), position(1), [1 2 3 4], [1 1 1 1], 0);
    world = gwaction(a);
%     gwdraw()
    gwdraw(0,policy');
end
figure(2)
surf(value)    
