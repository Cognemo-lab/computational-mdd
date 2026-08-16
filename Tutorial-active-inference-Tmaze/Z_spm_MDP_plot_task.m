function Q = Z_spm_MDP_plot_task(MDP)
% auxiliary plotting routine for spm_MDP_VB - multiple trials
% FORMAT Q = spm_MDP_VB_game(MDP)
%
% MDP.P(M,T)      - probability of emitting action 1,...,M at time 1,...,T
% MDP.Q(N,T)      - an array of conditional (posterior) expectations over
%                   N hidden states and time 1,...,T
% MDP.X           - and Bayesian model averages over policies
% MDP.R           - conditional expectations over policies
% MDP.O(O,T)      - a sparse matrix encoding outcomes at time 1,...,T
% MDP.S(N,T)      - a sparse matrix encoding states at time 1,...,T
% MDP.U(M,T)      - a sparse matrix encoding action at time 1,...,T
% MDP.W(1,T)      - posterior expectations of precision
%
% MDP.un  = un    - simulated neuronal encoding of hidden states
% MDP.xn  = Xn    - simulated neuronal encoding of policies
% MDP.wn  = wn    - simulated neuronal encoding of precision
% MDP.da  = dn    - simulated dopamine responses (deconvolved)
% MDP.rt  = rt    - simulated dopamine responses (deconvolved)
%
% returns summary of performance:
%
%     Q.X  = x    - expected hidden states
%     Q.R  = u    - final policy expectations
%     Q.S  = s    - initial hidden states
%     Q.O  = o    - final outcomes
%     Q.p  = p    - performance
%     Q.q  = q    - reaction times
%
% please see spm_MDP_VB
%__________________________________________________________________________
% Copyright (C) 2005 Wellcome Trust Centre for Neuroimaging

% Karl Friston, Philipp Schwartenbeck (07/09/2018)
% $Id: spm_MDP_VB_game.m 6763 2016-04-04 09:24:18Z karl $

% numbers of transitions, policies and states
%--------------------------------------------------------------------------
if iscell(MDP(1).X)
    Nf = numel(MDP(1).B);                 % number of hidden state factors
    Ng = numel(MDP(1).A);                 % number of outcome factors
else
    Nf = 1;
    Ng = 1;
end

% graphics
%==========================================================================
Nt    = length(MDP);               % number of trials
Ne    = size(MDP(1).V,1) + 1;      % number of epochs per trial
Np    = size(MDP(1).V,2) + 1;      % number of policies
for i = 1:Nt
    
    % assemble expectations of hidden states and outcomes
    %----------------------------------------------------------------------
    for j = 1:Ne
        for k = 1:Ne
            for f = 1:Nf
                try
                    x{f}{i,1}{k,j} = gradient(MDP(i).xn{f}(:,:,j,k)')';
                catch
                    x{f}{i,1}{k,j} = gradient(MDP(i).xn(:,:,j,k)')';
                end
            end
        end
    end
    s(:,i) = MDP(i).s(:,1);
    o(:,i) = MDP(i).o(:,end);
    u(:,i) = MDP(i).R(:,end);
    a(:,i) = MDP(i).u(1);
    w(:,i) = mean(MDP(i).dn,2);    
    
    % assemble context learning
    %----------------------------------------------------------------------
    for f = 1:Nf
        try
            try
                D = MDP(i).d{f};
            catch
                D = MDP(i).D{f};
            end
        catch
            try
                D = MDP(i).d;
            catch
                D = MDP(i).D;
            end
        end
        d{f}(:,i) = D/sum(D);
    end
    
    % assemble performance
    %----------------------------------------------------------------------
    p(i)  = 0;
    for g = 1:Ng
        try
            U = spm_softmax(MDP(i).C{g});
        catch
            U = spm_softmax(MDP(i).C);
        end
        
        for t = 1:Ne
            p(i) = p(i) + log(U(MDP(i).o(g,t),t))/Ne;
        end
    end
    q(i)   = sum(MDP(i).rt(2:end));
    
end

% assemble output structure if required
%--------------------------------------------------------------------------
if nargout
    Q.X  = x;            % expected hidden states
    Q.R  = u;            % final policy expectations
    Q.S  = s;            % inital hidden states
    Q.O  = o;            % final outcomes
    Q.p  = p;            % performance
    Q.q  = q;            % reaction times
    return
end

%% Now plot stuff

if isfield(MDP,'d')
    %n_rows = 5; % number of rows in subplot
    n_rows = 3;
else
    n_rows = 2;
end

% Initial states and expected policies (habit in red)
%--------------------------------------------------------------------------
choice_prob = [];
for i = 1:Nt
    choice_prob = [choice_prob MDP(i).P(:,1)]; 
end

col         = {'b.','m.','g.','r.','c.','k.'};
col_context = {[0.1, 0.6, 0],[0.6, 0.1, 0]};

cols = [0:1/32:1; 0:1/32:1; 0:1/32:1]';
t     = 1:Nt;
figure('WindowStyle','docked'), set(gcf,'color','white')

subplot(n_rows,1,1)

if Nt < 64
    MarkerSize = 24;
else
    MarkerSize = 16;
end

im = imagesc((1 - choice_prob)); colormap(cols); hold on
choice_conflict = sum(choice_prob.*log(choice_prob+eps));

plot(a,col{1},'MarkerSize',MarkerSize)

try
    plot(Np*(1 - u(Np,:)),'r')
end

try
    E = spm_softmax(spm_cat({MDP.e}));
    plot(Np*(1 - E(end,:)),'r:')
end

title('The first chosen action')
set(gca, 'XTick', [0:Nt], 'YTick', 1:4, ...
    'YTickLabel', {'Stay','Safe','Risky' 'Cue'})
xlabel('Trial'),ylabel('Action')


% Performance
%--------------------------------------------------------------------------
subplot(n_rows,1,2); hold on

% utility of outcome (closer to zero = higher utility)
bar(p,'k') 
  
% outcomes
for i = 1:max(o(1,:))            
    j = find(o(1,:) == i);
    plot(t(j),j-j+2,col{i},'MarkerSize',MarkerSize)
end

% contexts
for i = 1:max(s(1,:))            
    j = find(s(1,:) == i);
    plot(t(j),j-j,'.','Color',col_context{i},'MarkerSize',MarkerSize)
end

title('Current context and final outcome')
xlabel('Trial'); ylabel(''); spm_axis tight
set(gca, 'XTick', [0:Nt], 'YTick', [0,2], ...
    'YTickLabel', {'Context','Outcome'})

if length(unique(o(1,:)))==3 && length(unique(s(1,:)))==2
    legend({'utility','small R','high R','no R','Context high R','Context low R'})
end

% plot learning in D
if isfield(MDP,'d')
    
    subplot(n_rows,1,3); hold on
    plot(t, d{1}(1,:),'-o', 'Color', col_context{1},'LineWidth',3)
    plot(t, d{1}(2,:),'-o', 'Color', col_context{2},'LineWidth',3)
    
    title('Initial beliefs about the context (D)')
    xlabel('Trial'), ylabel('Probability')
end

hold off

end
