# Adding a tutorial

Create one directory per topic. Use a short, stable name such as
`Tutorial-model-comparison/` and include a `README.md` plus one obvious MATLAB
entry point.

## Recommended contents

```text
Tutorial-model-comparison/
├── README.md                 Goals, prerequisites, timing, and instructions
├── tutorial_model_comparison.m
├── data/                     Small synthetic or openly licensed inputs
└── utils/                    Functions used only by this tutorial
```

Start from `docs/tutorial_template.m`. Replace every `TODO`, then add the
tutorial to the table in the repository README.

## Tutorial checklist

- The first comment block states learning objectives and estimated duration.
- The script runs section by section after `cognemo_setup_paths`.
- Random simulations use a fixed seed such as `rng(1, 'twister')`.
- Inputs are generated in the script or documented in the local README.
- Figures have labels, units where relevant, and interpretable captions.
- Exercises distinguish code changes from conceptual questions.
- A clean run does not depend on files outside the repository.
- The final section summarizes what a student should now be able to explain.
- `tests/smoke_test.m` passes after the new entry point is registered there.

## Suggested pedagogical flow

1. Motivate a concrete behavioral or clinical question.
2. Introduce the model generatively: states, observations, parameters.
3. Simulate data from known parameters.
4. Visualize how a parameter changes predictions.
5. Invert the model and inspect parameter recovery.
6. Compare at least one plausible alternative model.
7. Interpret what the model can and cannot say about MDD.
