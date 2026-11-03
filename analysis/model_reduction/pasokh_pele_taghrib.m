
s=tf('s');
% tabe asli
g1=4.545*s/(s+5.6197)/(s+0.14)/(s-5.56);
step(g1)
% Bad az Taghrib
g2=4.545/5.6197*s/(s+0.14)/(s-5.56);
hold on 
step(g2)
legend('over damped','critical damped')
