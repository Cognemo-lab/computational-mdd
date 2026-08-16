# Simple simulations: RL, HGF, and active inference

This tutorial introduces three computational modeling approaches using small,
reproducible tasks. It is intended as an early course practical before model
fitting and formal model comparison.

## Learning objectives

By the end of the tutorial, students should be able to:

1. explain how a Rescorla-Wagner learner updates values with a fixed learning
   rate;
2. describe how a hierarchical Gaussian filter represents beliefs and
   volatility at multiple levels;
3. explain why an active-inference agent may choose an informative cue before
   pursuing reward;
4. distinguish a perceptual model from the response rule that turns beliefs
   into choices; and
5. generate qualitative predictions by changing learning, volatility, and
   policy-precision parameters.

## Requirements and timing

- MATLAB R2018b or newer
- The bundled TAPAS and SPM12 toolboxes
- Approximately 60–90 minutes

From the repository root, run:

```matlab
cognemo_setup_paths;
open('Tutorial-simple-model-simulations/Tutorial_simple_model_simulations.m');
```

Run the script one `%%` section at a time. The active-inference section can
take longer than the RL and HGF sections because it evaluates complete
policies rather than applying a single trial-wise update equation.

Instructors can validate the model cores without opening figures by running:

```matlab
run(fullfile('tests', 'simple_model_simulations_test.m'))
```

## Task designs

The RL and HGF agents observe the same probabilistic reversal task. On every
trial, one of two options is more likely to be rewarded, and the identity of
the better option reverses every 30 trials. Outcomes are provided as full
feedback so both agents receive the same evidence.

The active-inference agent uses a short T-maze task. It can choose a safe arm,
a risky arm, or a cue that reveals whether the risky arm currently has high or
low reward probability. Comparing informative and uninformative cue conditions
isolates information-seeking behavior while holding policy evaluation fixed.

## Files

- `Tutorial_simple_model_simulations.m`: student-facing tutorial
- `utils/generate_binary_reversal_task.m`: reversal-task generator
- `utils/simulate_active_inference_tmaze.m`: compact SPM MDP simulation

## References

- Rescorla, R. A., & Wagner, A. R. (1972). A theory of Pavlovian conditioning.
- Mathys, C. et al. (2011). A Bayesian foundation for individual learning
  under uncertainty. *Frontiers in Human Neuroscience, 5*, 39.
- Smith, R., Friston, K. J., & Whyte, C. J. (2022). A step-by-step tutorial on
  active inference and its application to empirical data. *Journal of
  Mathematical Psychology, 107*, 102632.
