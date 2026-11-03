M = .5;
m = 0.2;
b = 0.1;
I = 0.006;
g = 9.8;
l = 0.3;

p = I*(M+m)+M*m*l^2; %denominator for the A and B matrices

A = [0      1              0           0;
     0 -(I+m*l^2)*b/p  (m^2*g*l^2)/p   0;
     0      0              0           1;
     0 -(m*l*b)/p       m*g*l*(M+m)/p  0];
B = [     0;
     (I+m*l^2)/p;
          0;
        m*l/p];
C = [0 0 1 0];
D = [0];
pos = 1;
Ts=0.8;
z= (-log(pos/100)/sqrt(pi^2));
wn=4/(z*Ts);
[num,den]=ord2(wn,z);
r=roots(den);
poles=[r(1) r(2) -60 -60];
k=acker(A,B,poles);

Anew=A-B*k;
Bnew=B;
Cnew=C;
Dnew=D;
Tss=ss(Anew,Bnew,Cnew,Dnew);
T=tf(Tss);
step(T);
