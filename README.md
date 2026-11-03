# Inverted Pendulum Control

Control-system study of an **inverted pendulum on a moving cart**, using MATLAB and Simulink. Based on the team's submitted linear-control course project.

## Source code

This repository now includes the original MATLAB scripts, organized as follows:

| Directory | Purpose |
| --- | --- |
| [analysis/modeling/](analysis/modeling/) | Cart-pendulum state-space and transfer-function models |
| [analysis/model_reduction/](analysis/model_reduction/) | Reduced-order response comparison |
| [analysis/stability/](analysis/stability/) | Root locus |
| [analysis/time_domain/](analysis/time_domain/) | Open-loop step response |
| [analysis/frequency/](analysis/frequency/) | Bode and Nyquist scripts |
| [controllers/pid/](controllers/pid/) | PID experiments |
| [controllers/state_feedback/](controllers/state_feedback/) | State-feedback pole-placement scripts |
| [docs/](docs/) | Setup, model summary, and verification limits |

## Getting started

Requires **MATLAB and Control System Toolbox**. From the repository root:

```matlab
run('analysis/modeling/state.m');
eigenvalues
run('analysis/modeling/transfer_function.m');

clearvars;
run('controllers/pid/final_pid.m');

clearvars;
run('controllers/state_feedback/state_feedback.m');
```

Read [RUNNING.md](docs/RUNNING.md) for caveats. The supplied scripts have not been rerun in MATLAB.

## Project archive and completeness

The user-supplied ZIP contained a nested RAR archive, MATLAB scripts, **7 Simulink models**, plots, saved animations, and a **34-page Persian submitted report**. A separate **17-page university assignment brief** was also supplied.

The **complete 71-file Git-ready package has been prepared outside this repository**. This branch imports the MATLAB text files and documentation only. The `.slx` models, PDF/DOCX reports, figures, third-party examples and large media **are not yet committed to GitHub** and must be imported separately. See [verification and scope](docs/VERIFICATION.md). In particular, do not treat missing images or models as available through links here.

No claim is made that saved controller plots have been regenerated or that closed-loop performance has been independently verified.

## Credits

The submitted report credits **Arian Abdollahi, Matin Masoudi, Armin Hatami and Mohammad Sadegh Rezvani**. Third-party work is separately identified in [CREDITS.md](CREDITS.md); no repository-wide license is implied.
