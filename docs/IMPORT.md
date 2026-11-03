# Finish importing the original project assets

The 71-file Git-ready archive was prepared from the supplied inverted pendulum project. The GitHub connector has committed the MATLAB source files and documentation to the pull-request branch, but cannot upload binary objects directly from the chat container.

**Do not merge the PR until the remaining files have been uploaded and the integrity workflow passes.**

## Complete the upload

1. Download `inverted-pendulum-control-git-ready.zip` from the ChatGPT conversation.
2. Download `finish_inverted_pendulum_import.py` from the same conversation, or use the copy in `scripts/finish_import.py` on this branch.
3. On your computer, install Git and configure your normal GitHub authentication. Do not paste passwords or personal access tokens into ChatGPT.
4. In a terminal, preview the files to add:

```bash
python finish_inverted_pendulum_import.py /path/to/inverted-pendulum-control-git-ready.zip
```

5. When ready, run:

```bash
python finish_inverted_pendulum_import.py /path/to/inverted-pendulum-control-git-ready.zip --push
```

The script clones **only** `import/inverted-pendulum-source`, skips files that already exist there, adds missing files from the ZIP, validates seven Simulink archives and PDF headers, commits, and pushes to that branch. It does **not** modify `main`.

The `.github/workflows/structure.yml` check is expected to fail until the missing binary files have been committed. After the push, review the changed files, permissions and licenses, and the workflow result before merging [PR #1](https://github.com/Arian-Abdollahi/inverted-pendulum-control/pull/1).

## Provenance and licenses

The package contains original course work plus credited third-party examples, animations, and media. License/author attribution for some material, including a legacy GUI and animations, has not been confirmed. Keep the repository private until public redistribution rights have been checked.

## Validation limits

Archive integrity checks do not demonstrate correctness of the MATLAB/Simulink simulations. MATLAB and Simulink execution has not been rerun.
