# Linearized inverted pendulum model

The upright cart-pendulum model uses state vector `[x, x_dot, phi, phi_dot]` and force input `u`.

Parameters from the original `analysis/modeling/state.m`:

| Parameter | Value |
| --- | ---: |
| Cart mass M | 0.5 kg |
| Pendulum mass m | 0.2 kg |
| Cart friction b | 0.1 |
| Pendulum inertia I | 0.006 |
| Gravity g | 9.8 m/s² |
| Pendulum center-of-mass distance l | 0.3 m |

The script computes `p = I*(M+m) + M*m*l^2`, then constructs the state-space matrices `A, B, C, D`, with outputs cart position and pendulum angle. The transfer-function script computes `P_cart` and `P_pend`.

The original Persian report in the complete ZIP package documents the derivation. The upright equilibrium is unstable in open loop.
