function setup = cognemo_setup_paths()
%COGNEMO_SETUP_PATHS Configure MATLAB for the course tutorials.
%   SETUP = COGNEMO_SETUP_PATHS() restores MATLAB's default search path and
%   adds the course code, TAPAS, and the SPM12 root. SPM12 subdirectories are
%   intentionally not added because they can shadow MATLAB core functions.

restoredefaultpath;

projectRoot = fileparts(mfilename('fullpath'));
tapasRoot = fullfile(projectRoot, 'Toolboxes', 'tapas');
spmRoot = fullfile(projectRoot, 'Toolboxes', 'spm12');

% Course code. Add tutorial-specific subdirectories where custom model and
% plotting functions live, while keeping the bundled toolboxes separate.
addpath(projectRoot);
addpath(fullfile(projectRoot, 'Utils'));
addpath(fullfile(projectRoot, 'RepresentationalCode'));
addpath(genpath(fullfile(projectRoot, 'HGF_tutorial')));
addpath(fullfile(projectRoot, 'Tutorial-active-inference-Tmaze'));

if isfolder(tapasRoot)
    addpath(genpath(tapasRoot));
end

if isfolder(spmRoot)
    addpath(spmRoot);
end

setup = struct( ...
    'projectRoot', projectRoot, ...
    'tapasAvailable', isfolder(tapasRoot), ...
    'spmAvailable', isfolder(spmRoot));

fprintf('Computational MDD course paths configured.\n');
fprintf('  TAPAS: %s\n', availability(setup.tapasAvailable));
fprintf('  SPM12: %s\n', availability(setup.spmAvailable));
end

function label = availability(isAvailable)
if isAvailable
    label = 'available';
else
    label = 'missing';
end
end
