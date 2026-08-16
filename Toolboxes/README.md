# Bundled dependencies

This repository vendors fixed toolbox snapshots so that every student runs the
same model implementation without installing Git submodules.

| Directory | Included version | Project |
| --- | --- | --- |
| `spm12/` | SPM12 revision 7771 (13 January 2020) | <https://www.fil.ion.ucl.ac.uk/spm/> |
| `tapas/` | HGF Toolbox v3.0, release `43168dd` | <https://www.translationalneuromodeling.org/tapas/> |

These directories contain third-party software and retain their upstream
copyright and license files. Do not modify them for course-specific behavior;
place adapters in the repository-level `Utils/` directory instead.

When updating a dependency:

1. Record the upstream release or commit here.
2. Run `tests/smoke_test.m` in a clean MATLAB session.
3. Run all tutorials and review numerical and figure changes.
4. Describe any changed results in the pull request.
