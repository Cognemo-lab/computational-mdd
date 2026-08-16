# Computational Modeling of Major Depressive Disorder

MATLAB tutorials for a course on computational approaches to cognition and
major depressive disorder (MDD). The repository is designed so that students
can run each tutorial as a self-contained, annotated script while sharing a
single set of model toolboxes and plotting utilities.

## Requirements

- MATLAB R2018b or newer
- A MATLAB license (University of Toronto students can use the institutional
  license)
- Approximately 250 MB of disk space

The required snapshots of TAPAS and SPM12 are included in `Toolboxes/`, so no
additional download is needed.

## Getting started

Clone the repository and open its root folder in MATLAB:

```bash
git clone git@github.com:Cognemo-lab/computational-mdd.git
cd computational-mdd
```

Then run this once at the beginning of each MATLAB session:

```matlab
setup = cognemo_setup_paths();
```

The returned `setup` structure reports which bundled toolboxes were found. To
check an installation without running a full tutorial, run:

```matlab
run(fullfile('tests', 'smoke_test.m'))
```

## Tutorials

| Topic | Entry point | Main ideas |
| --- | --- | --- |
| Models of perception | `HGF_tutorial/ModelsofPerception_tutorial_load_task.m` | Hierarchical beliefs, volatility, ideal-observer simulation, model inversion |
| Reinforcement learning | `HGF_tutorial/RL_tutorial_load_task.m` | HGF and Rescorla-Wagner learning, parameter recovery, belief trajectories |
| Generating a volatile task | `HGF_tutorial/vnet_tutorial_generate_task.m` | Experimental design, simulation, inversion, precision-weighted prediction errors |
| Simulating learners | `HGF_tutorial/vnet_generate_learners.m` | Parameter manipulations and prototypical patient simulations |
| Active inference in a T-maze | `Tutorial-active-inference-Tmaze/Tutorial_active_inference (1).m` | Epistemic value, policy precision, and learning priors |

Open an entry-point script in the MATLAB Editor and run it section by section
(`Ctrl+Enter` on Windows/Linux or `Command+Enter` on macOS). Read the comments
and answer any prompts before moving to the next section.

## Repository layout

```text
computational-mdd/
├── HGF_tutorial/                  HGF and reinforcement-learning tutorials
├── Tutorial-active-inference-Tmaze/  Active-inference tutorial
├── RepresentationalCode/          Shared plotting code
├── Utils/                         Shared simulation and design helpers
├── Toolboxes/                     Versioned third-party dependencies
├── docs/                          Authoring guidance and tutorial template
├── tests/                         Fast installation checks
└── cognemo_setup_paths.m          MATLAB path setup
```

## For instructors and contributors

See [CONTRIBUTING.md](CONTRIBUTING.md) for the repository workflow and
[docs/adding-a-tutorial.md](docs/adding-a-tutorial.md) for the tutorial format.
Keep student-facing entry points readable and put reusable logic in a local
`utils/` folder or the repository-level `Utils/` directory.

## Troubleshooting

- **A function is undefined:** return to the repository root and rerun
  `cognemo_setup_paths`.
- **MATLAB reports a name conflict:** run `restoredefaultpath`, then rerun
  `cognemo_setup_paths`. The setup function deliberately adds only the SPM12
  root, not all of its subdirectories.
- **The repository is incomplete:** verify that `Toolboxes/tapas` and
  `Toolboxes/spm12` exist.

## License and citation

Course authors should add a license before public release. Third-party code in
`Toolboxes/` retains its original authorship and licensing terms. If you use
the teaching materials in academic work, cite the repository URL and the
specific toolbox or model papers used by the tutorial.
