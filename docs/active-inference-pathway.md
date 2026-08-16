# Active-inference tutorial pathway

The repository contains two complementary MATLAB collections. The
Smith–Friston–Whyte material builds the mathematical and modeling workflow in
stages; the T-maze tutorial provides a compact experiment focused on epistemic
value and policy precision.

Run `cognemo_setup_paths` from the repository root before starting. Open each
script in the MATLAB Editor and run one `%%` section at a time.

## Recommended sequence

| Stage | Script | Focus |
| --- | --- | --- |
| 1 | `Tutorial-active-inference-Smith/Pencil_and_paper_exercise_solutions.m` | Static and dynamic perception calculations |
| 2 | `Tutorial-active-inference-Smith/VFE_calculation_example.m` | Equivalent expressions for variational free energy |
| 3 | `Tutorial-active-inference-Smith/Prediction_error_example.m` | State and outcome prediction errors |
| 4 | `Tutorial-active-inference-Smith/EFE_learning_novelty_term.m` | Parameter exploration and the novelty term |
| 5 | `Tutorial-active-inference-Smith/EFE_Precision_Updating.m` | Expected-free-energy precision updates |
| 6 | `Tutorial-active-inference-Smith/Message_passing_example.m` | Marginal message passing, firing rates, and ERPs |
| 7 | `Tutorial-active-inference-Smith/Simplified_simulation_script.m` | Commented implementation of the simulation routine |
| 8 | `Tutorial-active-inference-Smith/Step_by_Step_AI_Guide.m` | Explore–exploit POMDPs, learning, model fitting, and comparison |
| 9 | `Tutorial-active-inference-Tmaze/Tutorial_active_inference (1).m` | Information gain, behavioral precision, and prior learning |
| 10 | `Tutorial-active-inference-Smith/Step_by_Step_Hierarchical_Model.m` | Deep temporal models and oddball ERPs |

The main Smith–Friston–Whyte guide is long. For a shorter class, stages 2, 5,
7, 8, and 9 form a coherent path from free energy and precision to simulation,
inversion, and experimental manipulation.

## Provenance

`Tutorial-active-inference-Smith/` is a Git submodule of
<https://github.com/rssmith33/Active-Inference-Tutorial-Scripts>, pinned to
commit `106343cb876dba692a0909b5e5a78e5e9a0eb4b9` (9 October 2024). Its source is
kept unmodified. The upstream repository does not currently include a software
license, so do not copy, modify, or redistribute those scripts without the
authors' permission.

The accompanying article is:

Smith, R., Friston, K. J., & Whyte, C. J. (2022). A step-by-step tutorial on
active inference and its application to empirical data. *Journal of
Mathematical Psychology, 107*, 102632.
<https://doi.org/10.1016/j.jmp.2021.102632>
