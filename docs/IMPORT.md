# Complete the inverted-pendulum project import

The GitHub branch currently has the MATLAB source, documentation and import tooling. The remaining Simulink models, reports, figures and media are inside the prepared **71-file** ZIP archive.

**The simplest method is now a single file upload on GitHub.** A workflow already committed at `.github/workflows/import-archive.yml` handles unpacking and committing the missing assets.

## Option A: One ZIP upload (recommended)

1. Download `inverted-pendulum-control-git-ready.zip` from the ChatGPT conversation.
2. Open the [repository](https://github.com/Arian-Abdollahi/inverted-pendulum-control).
3. Select the branch **`import/inverted-pendulum-source`**, not `main`.
4. Click **Add file → Upload files**.
5. Upload the **ZIP itself**, named exactly `inverted-pendulum-control-git-ready.zip`, into the **repository root**. Do not extract it or place it in a subfolder.
6. Commit to the **current branch**.
7. Open the [GitHub Actions page](https://github.com/Arian-Abdollahi/inverted-pendulum-control/actions) and check the **Import project archive** workflow. It extracts only missing files, preserves existing project code, verifies the seven Simulink `.slx` files and required PDFs, updates the docs, deletes the temporary ZIP, and pushes to the import branch.
8. Review [PR #1](https://github.com/Arian-Abdollahi/inverted-pendulum-control/pull/1). **Do not merge** until the workflow has succeeded and you have reviewed the new files.

GitHub's browser file limit is ordinarily 25 MiB per file; this prepared ZIP is roughly 21 MB, so it is below that limit.

## Option B: Local Git upload (fallback)

If uploading through the GitHub web interface or GitHub Actions is unavailable, download `finish_inverted_pendulum_import.py` from ChatGPT (also tracked here as `scripts/finish_import.py`). With Git and Python installed and GitHub authentication configured locally, preview and upload:

```bash
python finish_inverted_pendulum_import.py inverted-pendulum-control-git-ready.zip
python finish_inverted_pendulum_import.py inverted-pendulum-control-git-ready.zip --push
```

The script checks out only the import branch, preserves existing files, verifies the project files, and commits the missing assets. It does not touch `main`.

## Licensing and validation

Third-party animation and legacy code/media are present in the archive. Their rights have not all been verified, so keep the repository private until publication permissions are checked.

Archive checks confirm file structure and integrity, **not** scientific or control-system correctness. MATLAB/Simulink runs have not been repeated.
