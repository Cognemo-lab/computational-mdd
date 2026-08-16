# Contributing

## Repository workflow

1. Create a short-lived branch from the default branch.
2. Keep each change focused on one tutorial or shared utility.
3. Run `tests/smoke_test.m` from the repository root in MATLAB.
4. Run every changed tutorial section from a clean MATLAB session.
5. Open a pull request describing the learning objective, tested MATLAB
   version, and any expected output changes.

Do not commit participant data, credentials, MATLAB preference files, crash
dumps, or generated figures. Small synthetic data needed by a tutorial may be
committed alongside that tutorial with its provenance documented.

## Teaching-code conventions

- Begin each tutorial with its learning objectives, expected duration,
  prerequisites, and outputs.
- Use MATLAB section markers (`%%`) so students can run one conceptual unit at
  a time.
- Set random seeds when simulation results are discussed quantitatively.
- Separate explanatory tutorial code from reusable functions.
- Prefer descriptive variable names and state units or parameter domains in
  comments.
- Include a short exercise and an interpretation question for each major model
  concept.
- Avoid absolute paths; build paths from `mfilename('fullpath')` or the setup
  structure returned by `cognemo_setup_paths`.

See `docs/adding-a-tutorial.md` for a ready-to-copy structure.
