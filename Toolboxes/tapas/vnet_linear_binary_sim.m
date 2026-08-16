function y = vnet_linear_binary_sim(r, infStates, p)
% Simulates approach:avoid with Gaussian noise
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2022 Andreea Diaconescu, KCNI
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Get parameters
be0  = p(1);
be1  = p(2);
be2  = p(3);
ze   = p(4);

% Number of trials
n = size(infStates,1);

% Inputs
u = r.u(:,1);

% Extract trajectories of interest from infStates
mu1hat = infStates(:,1,1);
sa1hat = infStates(:,1,2);

% Surprise
% ~~~~~~~~
prob_outcome = mu1hat.^u.*(1-mu1hat).^(1-u); % probability of observed outcome
surp = -log2(prob_outcome);

% Bernoulli variance (aka irreducible uncertainty, risk)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bernv = sa1hat;

% Calculate predicted exploration
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
log_explore = be0 +be1.*surp +be2.*bernv;

% Initialize random number generator

rng('shuffle');



% Simulate
y = log_explore+sqrt(ze)*randn(n, 1);

end
