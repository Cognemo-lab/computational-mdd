%% Runtime test for the simple model simulations tutorial
% This test exercises the model cores without opening tutorial figures.

setup = cognemo_setup_paths();
assert(setup.tapasAvailable && setup.spmDemAvailable, ...
    'Required TAPAS or SPM DEM dependency is unavailable.');

task = generate_binary_reversal_task(120, 30, [0.8 0.2], 7);

rw = tapas_simModel(task.outcome, 'tapas_rw_binary', [0.5 0.2]);
assert(isequal(size(rw.traj.vhat), [120 1]), ...
    'Unexpected Rescorla-Wagner trajectory size.');

hgfParameters = [ ...
    NaN 0 1, NaN 0.1 1, NaN 0 0, NaN 1, NaN -3, 0.05];
hgf = tapas_simModel(task.outcome, 'tapas_hgf_binary', hgfParameters);
assert(isequal(size(hgf.traj.muhat), [120 3]), ...
    'Unexpected HGF trajectory size.');

informative = simulate_active_inference_tmaze(16, 10, 16, true);
uninformative = simulate_active_inference_tmaze(16, 10, 16, false);
assert(isequal(size(informative.actionProbability), [4 16]), ...
    'Unexpected active-inference action-probability size.');
assert(mean(informative.actionProbability(4, :)) > ...
       mean(uninformative.actionProbability(4, :)), ...
    'An informative cue should attract more information-seeking.');

fprintf('Simple model simulations runtime test passed.\n');
