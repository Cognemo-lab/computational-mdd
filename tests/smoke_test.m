%% Computational MDD repository smoke test
% Run this script from the repository root after cloning the project.

setup = cognemo_setup_paths();

assert(setup.tapasAvailable, 'Bundled TAPAS toolbox was not found.');
assert(setup.spmAvailable, 'Bundled SPM12 toolbox was not found.');

entryPoints = {
    fullfile('HGF_tutorial', 'ModelsofPerception_tutorial_load_task.m')
    fullfile('HGF_tutorial', 'RL_tutorial_load_task.m')
    fullfile('HGF_tutorial', 'vnet_tutorial_generate_task.m')
    fullfile('HGF_tutorial', 'vnet_generate_learners.m')
    fullfile('Tutorial-active-inference-Tmaze', ...
        'Tutorial_active_inference (1).m')
};

for fileIndex = 1:numel(entryPoints)
    absolutePath = fullfile(setup.projectRoot, entryPoints{fileIndex});
    assert(isfile(absolutePath), 'Missing tutorial: %s', entryPoints{fileIndex});
end

assert(exist('tapas_fitModel', 'file') == 2, ...
    'TAPAS functions are not available on the MATLAB path.');
assert(exist('spm', 'file') == 2, ...
    'The SPM12 root is not available on the MATLAB path.');

fprintf('Smoke test passed: setup, toolboxes, and %d tutorials found.\n', ...
    numel(entryPoints));
