function setup = cognemo_setup_paths()
%COGNEMO_SETUP_PATHS Configure MATLAB for the course tutorials.
%   SETUP = COGNEMO_SETUP_PATHS() restores MATLAB's default search path and
%   adds the course code, TAPAS, and the SPM12 root. SPM12 subdirectories are
%   intentionally not added because they can shadow MATLAB core functions.

restoredefaultpath;

projectRoot = fileparts(mfilename('fullpath'));
tapasRoot = fullfile(projectRoot, 'Toolboxes', 'tapas');
spmRoot = fullfile(projectRoot, 'Toolboxes', 'spm12');
spmDemRoot = fullfile(spmRoot, 'toolbox', 'DEM');
smithTutorialRoot = fullfile(projectRoot, ...
    'Tutorial-active-inference-Smith');
simpleSimulationRoot = fullfile(projectRoot, ...
    'Tutorial-simple-model-simulations');

% Course code. Add tutorial-specific subdirectories where custom model and
% plotting functions live, while keeping the bundled toolboxes separate.
addpath(projectRoot);
addpath(fullfile(projectRoot, 'Utils'));
addpath(fullfile(projectRoot, 'RepresentationalCode'));
addpath(genpath(fullfile(projectRoot, 'HGF_tutorial')));
addpath(fullfile(projectRoot, 'Tutorial-active-inference-Tmaze'));

smithTutorialAvailable = isfile(fullfile(smithTutorialRoot, ...
    'Step_by_Step_AI_Guide.m'));
if smithTutorialAvailable
    addpath(smithTutorialRoot);
end

simpleSimulationAvailable = isfile(fullfile(simpleSimulationRoot, ...
    'Tutorial_simple_model_simulations.m'));
if simpleSimulationAvailable
    addpath(genpath(simpleSimulationRoot));
end

if isfolder(tapasRoot)
    addpath(genpath(tapasRoot));
end

if isfolder(spmRoot)
    addpath(spmRoot);
end

% Active-inference MDP routines are contained in SPM's DEM toolbox. Add this
% one directory explicitly; adding every SPM subdirectory can shadow MATLAB
% core functions.
if isfolder(spmDemRoot)
    addpath(spmDemRoot);
end

setup = struct( ...
    'projectRoot', projectRoot, ...
    'tapasAvailable', isfolder(tapasRoot), ...
    'spmAvailable', isfolder(spmRoot), ...
    'spmDemAvailable', isfolder(spmDemRoot), ...
    'smithTutorialAvailable', smithTutorialAvailable, ...
    'simpleSimulationAvailable', simpleSimulationAvailable);

fprintf('Computational MDD course paths configured.\n');
fprintf('  TAPAS: %s\n', availability(setup.tapasAvailable));
fprintf('  SPM12: %s\n', availability(setup.spmAvailable));
fprintf('  SPM12 DEM toolbox: %s\n', availability(setup.spmDemAvailable));
fprintf('  Smith active-inference tutorial: %s\n', ...
    availability(setup.smithTutorialAvailable));
fprintf('  Simple model simulations: %s\n', ...
    availability(setup.simpleSimulationAvailable));
end

function label = availability(isAvailable)
if isAvailable
    label = 'available';
else
    label = 'missing';
end
end
