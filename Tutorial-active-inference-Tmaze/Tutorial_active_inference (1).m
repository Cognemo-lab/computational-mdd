% A tutorial on active inference for Psychological Science Skills, UofT
% Povilas Karvelis, Toronto, 2022

% Adapted from Philipp Schwartenbeck Computational Psychiatry course in 
% Zurich, 2018

%--------------------------------------------------------------------------
% This routine uses a Markov decision process formulation of active
% inference (with variational Bayes) to model foraging for information in a
% three arm maze. 
%
% In this example, the agent starts at the centre of a three way maze with 
% a safe (left) and a risky (right) option, where the risky option either 
% has a high (75%) or low (25%) reward probability. However, the reward 
% probability changes from trial to trial.  Crucially, the agent can 
% identify the current reward probability by accessing a cue in the lower 
% arm. This tells the agent whether the reward probability of this trial is
% high or low. 
%
% This means the optimal policy would first involve maximising information 
% gain (epistemic value) by moving to the lower arm and then choosing the
% safe or the risky option. Here, there are eight hidden states 
% (four locations times high or low reward context), four control states
% (that take the agent to the four locations) and six outcomes (neutral, 
% safe, risky win, risky loss, cue 1 and cue 2.   
%--------------------------------------------------------------------------
 
%% Set up model structure

% We start by specifying the probabilistic mapping from hidden states
% to outcomes (A)
%--------------------------------------------------------------------------
a = .75;
b = 1 - a;

A{1}   = [1 1 0 0 0 0 0 0;    % ambiguous starting position (centre)
          0 0 1 1 0 0 0 0;    % safe arm selected and rewarded
          0 0 0 0 a b 0 0;    % risky arm selected and rewarded
          0 0 0 0 b a 0 0;    % risky arm selected and not rewarded
          0 0 0 0 0 0 1 0;    % informative cue - high reward prob
          0 0 0 0 0 0 0 1];   % informative cue - low reward prob
 
      
% Next, we have to specify the probabilistic transitions of hidden states
% under each action or control state. Here, there are four actions taking 
% the agent directly to each of the four locations.
%--------------------------------------------------------------------------

% move to/stay in the middle
B{1}(:,:,1) = [1 0 0 0 0 0 1 0;
               0 1 0 0 0 0 0 1;
               0 0 1 0 0 0 0 0;
               0 0 0 1 0 0 0 0;
               0 0 0 0 1 0 0 0;
               0 0 0 0 0 1 0 0;
               0 0 0 0 0 0 0 0;
               0 0 0 0 0 0 0 0];
           
% move up left to safe        
B{1}(:,:,2) = [0 0 0 0 0 0 0 0;
               0 0 0 0 0 0 0 0;
               1 0 1 0 0 0 1 0;
               0 1 0 1 0 0 0 1;
               0 0 0 0 1 0 0 0;
               0 0 0 0 0 1 0 0;
               0 0 0 0 0 0 0 0;
               0 0 0 0 0 0 0 0];

% move up right to risky            
B{1}(:,:,3) = [0 0 0 0 0 0 0 0;
               0 0 0 0 0 0 0 0;
               0 0 1 0 0 0 0 0;
               0 0 0 1 0 0 0 0;
               1 0 0 0 1 0 1 0;
               0 1 0 0 0 1 0 1;
               0 0 0 0 0 0 0 0;
               0 0 0 0 0 0 0 0];

% move down to see the cue           
B{1}(:,:,4) = [0 0 0 0 0 0 0 0;
               0 0 0 0 0 0 0 0;
               0 0 1 0 0 0 0 0;
               0 0 0 1 0 0 0 0;
               0 0 0 0 1 0 0 0;
               0 0 0 0 0 1 0 0;
               1 0 0 0 0 0 1 0;
               0 1 0 0 0 0 0 1];           

% Finally, we have to specify the prior preferences in terms of log
% probabilities. Here, the agent prefers rewarding outcomes. 
% C{1} = [staying, safe, reward, no reward, cue 1, cue 2]
%--------------------------------------------------------------------------
cs =  2; % safe option
cr =  4; % risky option reward
cn =  -2; % risky option no reward

C{1}  = [0 cs cr cn 0 0]';

% Now specify prior beliefs about initial state
%--------------------------------------------------------------------------
D{1}  = kron([1/2 0 0 0],[1 1])';

% Allowable policies pi (sequences of actions). Note, 2 and 3 are absorbing 
% states
%--------------------------------------------------------------------------
V  = [1  1  1  1  2  3  4  4  4  4
      1  2  3  4  2  3  1  2  3  4];
 
 
% Define MDP Structure
%--------------------------------------------------------------------------

mdp.V = V;                    % allowable policies
mdp.A = A;                    % observation model
mdp.B = B;                    % transition probabilities
mdp.C = C;                    % preferred states
mdp.D = D;                    % prior over initial states
mdp.s = 1;                    % initial state
mdp.eta = 0.5;                % learning rate

% Check if all matrix-dimensions are correct:
%--------------------------------------------------------------------------
mdp = spm_MDP_check(mdp);

rng('default')

%% 1 Fairly precise behaviour WITH information-gain:

% set up and simulate behavior
%--------------------------------------------------------------------------
n          = 32;               % number of trials
i          = rand(1,n) > 1/2;  % randomise hidden states over trials    

MDP        = mdp;             % assign mdp 
[MDP(1:n)] = deal(MDP);       % restructure mdp
[MDP(i).s] = deal(2);         % assign randomized trials

[MDP(1:n).beta]  = deal(1);   % policy stochasticity prior
[MDP(1:n).alpha] = deal(16);  % precision of action selection

MDP  = Z_spm_MDP_VB_X(MDP);

% illustrate behavioural responses to single trial
%--------------------------------------------------------------------------
spm_figure('GetWin','Figure 1a'); 
Z_spm_MDP_plot_trial(MDP(1)); 

% illustrate behavioural responses over trials
%--------------------------------------------------------------------------
Z_spm_MDP_plot_task(MDP); pause(0.5);


%% 2 Fairly precise behaviour WITHOUT information-gain:

% set up and simulate behavior
%--------------------------------------------------------------------------
% n          = 32;               % number of trials
% i          = rand(1,n) > 1/2;  % randomise hidden states over trials

MDP        = mdp;             % assign mdp 
[MDP(1:n)] = deal(MDP);       % restructure mdp
[MDP(i).s] = deal(2);         % assign randomized trials


[MDP(1:n).beta]  = deal(1);   % policy stochasticity prior
[MDP(1:n).alpha] = deal(16);  % precision of action selection

[MDP(1:n).ambiguity] = deal(false); % disable information-seeking behavior

MDP  = Z_spm_MDP_VB_X(MDP);

% illustrate behavioural responses for a single trial
%--------------------------------------------------------------------------
spm_figure('GetWin','Figure 1b');
Z_spm_MDP_plot_trial(MDP(1)); 

% illustrate behavioural responses over trials
%--------------------------------------------------------------------------
Z_spm_MDP_plot_task(MDP); pause(0.5);

%% 3 Imprecise behaviour WITH information-gain:

% set up and simulate behavior
%--------------------------------------------------------------------------
% n          = 32;               % number of trials
% i          = rand(1,n) > 1/2;  % randomise hidden states over trials

MDP        = mdp;             % assign mdp 
[MDP(1:n)] = deal(MDP);       % restructure mdp
[MDP(i).s] = deal(2);         % assign randomized trials


[MDP(1:n).beta]  = deal(1);  % policy stochasticity prior
[MDP(1:n).alpha] = deal(2);  % precision of action selection (LOW)

MDP  = Z_spm_MDP_VB_X(MDP);

% illustrate behavioural responses for a single trial
%--------------------------------------------------------------------------
spm_figure('GetWin','Figure 1c'); 
Z_spm_MDP_plot_trial(MDP(1));

% illustrate behavioural responses over trials
%--------------------------------------------------------------------------
Z_spm_MDP_plot_task(MDP); pause(0.5);


%% 4 Learning about D with a non-random trial structure

% set up and simulate behavior
%--------------------------------------------------------------------------
n          = 32;               % number of trials
i          = true(ones(1,n));  % make the states over trials uniform
MDP        = mdp;              % assign mdp 
[MDP(1:n)] = deal(MDP);        % restructure mdp
[MDP(i).s] = deal(1);          % make all trials with 75% reward prob.
 
[MDP(1:n).d]  = deal(mdp.D);  % indicate to update d after every trial

[MDP(1:n).beta]  = deal(1);   % policy stochasticity prior
[MDP(1:n).alpha] = deal(16);  % precision of action selection 

MDP  = Z_spm_MDP_VB_X(MDP);

% illustrate behavioural responses for a single trial
%--------------------------------------------------------------------------
spm_figure('GetWin','Figure 1d'); 
Z_spm_MDP_plot_trial(MDP(1)); 

% illustrate behavioural responses over trials
%--------------------------------------------------------------------------
Z_spm_MDP_plot_task(MDP);
