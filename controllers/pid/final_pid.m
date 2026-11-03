s=tf('s');g=4.545*s/(s+5.6197)/(s+0.14)/(s-5.56);
Kp = 100;
Ki =100;
Kd = 20;
C = pid(Kp,Ki,Kd);
g1 =g*C/(1+g*C);t=0:0.1:20;
impulse(g1,t);axis([0, 2.5, -0.2, 0.2]);
title({'Response of Pendulum Position to an Impulse Disturbance';'under PID Control: Kp = 100, Ki = 100, Kd = 20'})
step(g1);
