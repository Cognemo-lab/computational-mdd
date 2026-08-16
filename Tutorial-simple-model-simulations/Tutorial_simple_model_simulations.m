%% Simple model simulations: RL, HGF, and active inference
% This tutorial compares three ways to model adaptive behavior:
%
% 1. Rescorla-Wagner reinforcement learning (RL)
% 2. A three-level hierarchical Gaussian filter (HGF)
% 3. A discrete-state active-inference agent
%
% The goal is conceptual comparison, not formal model comparison. RL and HGF
% see the same binary outcomes. Active inference uses a small T-maze because
% information-seeking requires an action that can reveal a hidden context.
%
% Estimated time: 60-90 minutes

clear variables;
close all;
clc;

setup = cognemo_setup_paths();
assert(setup.tapasAvailable, 'This tutorial requires the bundled TAPAS toolbox.');
assert(setup.spmAvailable, 'This tutorial requires the bundled SPM12 toolbox.');

randomSeed = 7;
rng(randomSeed, 'twister');

%% 1. Generate a probabilistic reversal task
% Outcome 1 means that option 1 was rewarded; outcome 0 means that option 0
% was rewarded. The probability that option 1 is rewarded alternates between
% 0.80 and 0.20. This is a full-feedback design: the agent observes which
% option was rewarded on every trial, regardless of its choice.

nTrials = 120;
blockLength = 30;
rewardProbabilities = [0.80, 0.20];

task = generate_binary_reversal_task( ...
    nTrials, blockLength, rewardProbabilities, randomSeed);

figure('Color', 'white', 'Name', 'Binary reversal task');
plot(task.trial, task.probabilityOption1, 'k-', 'LineWidth', 2);
hold on;
plot(task.trial, task.outcome, '.', 'Color', [0.20 0.55 0.85], ...
    'MarkerSize', 11);
hold off;
ylim([-0.08 1.08]);
xlabel('Trial');
ylabel('Outcome or probability');
title('Probabilistic reversal task');
legend({'True P(option 1 rewarded)', 'Observed outcome'}, ...
    'Location', 'southoutside');

% Question: why will a learner sometimes receive evidence that appears to
% contradict the current block, even when the task has not reversed?

%% 2. Simulate a Rescorla-Wagner reinforcement-learning agent
% The Rescorla-Wagner update is:
%
%   value(t+1) = value(t) + alpha * prediction_error(t)
%
% where prediction_error(t) = outcome(t) - value(t). The learning rate alpha
% is fixed: equally surprising outcomes always have the same proportional
% influence on the next value.

rwInitialValue = 0.50;
rwLearningRate = 0.20;
inverseTemperature = 6;

rw = tapas_simModel(task.outcome, 'tapas_rw_binary', ...
    [rwInitialValue, rwLearningRate]);

rwBelief = rw.traj.vhat;
rwChoiceProbability = 1 ./ (1 + exp( ...
    -inverseTemperature .* (2 .* rwBelief - 1)));

rng(randomSeed + 1, 'twister');
rwChoice = double(rand(nTrials, 1) < rwChoiceProbability);

figure('Color', 'white', 'Name', 'Rescorla-Wagner simulation');
subplot(2, 1, 1);
plot(task.trial, task.probabilityOption1, 'k--', 'LineWidth', 1.5);
hold on;
plot(task.trial, rwBelief, 'Color', [0.85 0.33 0.10], 'LineWidth', 2);
hold off;
ylim([0 1]);
ylabel('P(option 1 rewarded)');
title(sprintf('RL beliefs (learning rate = %.2f)', rwLearningRate));
legend({'True probability', 'RL prediction'}, 'Location', 'best');

subplot(2, 1, 2);
plot(task.trial, rw.traj.da, 'Color', [0.49 0.18 0.56], 'LineWidth', 1.2);
hold on;
plot(task.trial, zeros(nTrials, 1), 'k:');
hold off;
xlabel('Trial');
ylabel('Prediction error');
title('Signed reward-prediction errors');

% Exercise: change rwLearningRate to 0.05 and then to 0.60. Which agent is
% more stable within blocks? Which adapts faster immediately after reversal?

%% 3. Simulate a three-level hierarchical Gaussian filter
% The HGF represents the task at three coupled levels:
%
% x1: the binary outcome observed on the current trial
% x2: the tendency for option 1 versus option 0 to be rewarded
% x3: the volatility of that tendency
%
% Unlike the RL model, the HGF's effective update size depends on uncertainty
% and estimated volatility. The vector below contains native-space parameters:
% initial means, initial variances, drifts, coupling, tonic volatility, and
% meta-volatility. NaN marks quantities undefined at the first level.

hgfParameters = [ ...
    NaN, 0, 1, ...       % initial means at levels 1-3
    NaN, 0.1, 1, ...     % initial variances at levels 1-3
    NaN, 0, 0, ...       % drift at levels 1-3
    NaN, 1, ...          % coupling between levels
    NaN, -3, ...         % tonic log-volatility
    0.05];               % meta-volatility

hgf = tapas_simModel(task.outcome, 'tapas_hgf_binary', hgfParameters);

% muhat(:,1) is the predicted probability of outcome 1 before observing the
% current outcome. mu(:,3) is the posterior expectation of log-volatility.
hgfBelief = hgf.traj.muhat(:, 1);
hgfLogVolatility = hgf.traj.mu(:, 3);
hgfChoiceProbability = 1 ./ (1 + exp( ...
    -inverseTemperature .* (2 .* hgfBelief - 1)));

rng(randomSeed + 2, 'twister');
hgfChoice = double(rand(nTrials, 1) < hgfChoiceProbability);

figure('Color', 'white', 'Name', 'HGF simulation');
subplot(3, 1, 1);
plot(task.trial, task.probabilityOption1, 'k--', 'LineWidth', 1.5);
hold on;
plot(task.trial, hgfBelief, 'Color', [0.00 0.45 0.74], 'LineWidth', 2);
hold off;
ylim([0 1]);
ylabel('Probability');
title('HGF prediction of option 1 reward');
legend({'True probability', 'HGF prediction'}, 'Location', 'best');

subplot(3, 1, 2);
plot(task.trial, hgf.traj.da(:, 1), ...
    'Color', [0.49 0.18 0.56], 'LineWidth', 1.2);
hold on;
plot(task.trial, zeros(nTrials, 1), 'k:');
hold off;
ylabel('Prediction error');
title('Outcome-prediction error');

subplot(3, 1, 3);
plot(task.trial, hgfLogVolatility, ...
    'Color', [0.47 0.67 0.19], 'LineWidth', 2);
xlabel('Trial');
ylabel('Posterior mean');
title('HGF estimate of log-volatility (level 3)');

% Exercise: make the task reverse every 15 trials. Predict how the third-level
% trajectory will change before rerunning the task and HGF sections.

%% 4. Compare RL and HGF on identical observations
% The response rule is intentionally held constant. Any difference between
% agents therefore comes from the perceptual model, not from decision noise.

bestOption = double(task.probabilityOption1 > 0.5);
rwAccuracy = mean(rwChoice == bestOption);
hgfAccuracy = mean(hgfChoice == bestOption);

figure('Color', 'white', 'Name', 'RL and HGF comparison');
subplot(2, 1, 1);
plot(task.trial, task.probabilityOption1, 'k:', 'LineWidth', 1.5);
hold on;
plot(task.trial, rwBelief, 'Color', [0.85 0.33 0.10], 'LineWidth', 1.8);
plot(task.trial, hgfBelief, 'Color', [0.00 0.45 0.74], 'LineWidth', 1.8);
hold off;
ylim([0 1]);
ylabel('P(option 1 rewarded)');
title('Belief trajectories from the same outcomes');
legend({'True probability', 'RL', 'HGF'}, 'Location', 'best');

subplot(2, 1, 2);
windowLength = 12;
plot(task.trial, movmean(rwChoice == bestOption, windowLength), ...
    'Color', [0.85 0.33 0.10], 'LineWidth', 1.8);
hold on;
plot(task.trial, movmean(hgfChoice == bestOption, windowLength), ...
    'Color', [0.00 0.45 0.74], 'LineWidth', 1.8);
hold off;
ylim([0 1]);
xlabel('Trial');
ylabel('Moving accuracy');
title(sprintf('%d-trial moving choice accuracy', windowLength));
legend({'RL', 'HGF'}, 'Location', 'best');

fprintf('\nBinary reversal task summary\n');
fprintf('  RL accuracy:  %.1f%%\n', 100 * rwAccuracy);
fprintf('  HGF accuracy: %.1f%%\n', 100 * hgfAccuracy);

% Interpretation question: accuracy alone cannot tell us whether the HGF is
% a better explanation of behavior. What additional model-fitting and model-
% comparison steps would be needed for data from human participants?

%% 5. Simulate active inference in a cue-safe-risky T-maze
% The agent starts in the center and can stay, choose a safe arm, choose a
% risky arm, or inspect a cue. The cue identifies whether the risky arm has
% high or low reward probability. Active inference scores policies using both
% preferred outcomes (pragmatic value) and expected information gain
% (epistemic value).
%
% We run matched simulations. In the first task, cue outcomes distinguish the
% hidden contexts. In the control task, both cue outcomes are equally likely
% in either context and therefore cannot reduce uncertainty. Both agents use
% the same active-inference policy evaluation. The cue has a small cost, so an
% agent should visit it only when its information can improve a later choice.

activeInferenceTrials = 32;
actionPrecision = 16;

aiInformativeCue = simulate_active_inference_tmaze( ...
    activeInferenceTrials, randomSeed + 3, actionPrecision, true);
aiUninformativeCue = simulate_active_inference_tmaze( ...
    activeInferenceTrials, randomSeed + 3, actionPrecision, false);

figure('Color', 'white', 'Name', 'Active-inference simulation');
subplot(2, 1, 1);
plot(1:activeInferenceTrials, aiInformativeCue.actionProbability(4, :), ...
    'Color', [0.00 0.45 0.74], 'LineWidth', 2);
hold on;
plot(1:activeInferenceTrials, aiUninformativeCue.actionProbability(4, :), ...
    'Color', [0.85 0.33 0.10], 'LineWidth', 2);
hold off;
ylim([0 1]);
ylabel('P(choose cue first)');
title('Policy probability for information seeking');
legend({'Informative cue', 'Uninformative cue'}, ...
    'Location', 'best');

subplot(2, 1, 2);
actionCounts = zeros(2, 4);
for actionIndex = 1:4
    actionCounts(1, actionIndex) = mean( ...
        aiInformativeCue.firstAction == actionIndex);
    actionCounts(2, actionIndex) = mean( ...
        aiUninformativeCue.firstAction == actionIndex);
end
bar(actionCounts');
ylim([0 1]);
set(gca, 'XTick', 1:4, 'XTickLabel', aiInformativeCue.actionNames);
xlabel('First action');
ylabel('Proportion of trials');
title('Simulated first actions');
legend({'Informative cue', 'Uninformative cue'}, ...
    'Location', 'best');

fprintf('\nActive-inference T-maze summary\n');
fprintf('  Cue choices when informative:   %.1f%%\n', ...
    100 * mean(aiInformativeCue.firstAction == 4));
fprintf('  Cue choices when uninformative: %.1f%%\n', ...
    100 * mean(aiUninformativeCue.firstAction == 4));

% Exercise: reduce actionPrecision from 16 to 2. Does the agent's sampled
% behavior become more or less consistent with its policy probabilities?

%% 6. Take-home comparison
% RL:
% - learns cached values from prediction errors;
% - uses a fixed learning rate in this example;
% - does not explicitly represent environmental volatility.
%
% HGF:
% - performs hierarchical Bayesian belief updating;
% - represents outcome tendency and volatility at separate levels;
% - changes effective update size as uncertainty changes.
%
% Active inference:
% - selects policies under a generative model;
% - combines preferred outcomes with uncertainty reduction;
% - can choose actions because they are informative, not only rewarding.
%
% Final question: name one behavioral manipulation that would help distinguish
% these accounts in empirical data. Which parameter or latent trajectory would
% your manipulation be expected to affect?
