# Running the MATLAB/Simulink project

The original scripts use MATLAB and Control System Toolbox. Simulink is required for the .slx models distributed in the separate Git-ready ZIP package.

Run from the repository root, one script at a time:

```matlab
run('analysis/modeling/state.m');
eigenvalues
run('analysis/modeling/transfer_function.m');

clearvars;
run('controllers/pid/final_pid.m');

clearvars;
run('controllers/state_feedback/state_feedback.m');
```

Avoid adding every subfolder to the MATLAB path: scripts named `step.m`, `nyquist.m`, and `bode.m` were renamed during organization to avoid shadowing MATLAB functions.

## Known limitations

- `controllers/pid/paydari_bad_pid.m` uses `g1` even though its assignment is commented out. It fails in an otherwise clean workspace unless fixed.
- Different scripts use different controller gains, and archived outputs should not be presented as a unified experiment.
- MATLAB/Simulink simulations were not rerun in this import.
- Full `.slx`, graphical, video, PDF and DOCX assets are in the separately supplied `inverted-pendulum-control-git-ready.zip` until those binary files have been uploaded.
