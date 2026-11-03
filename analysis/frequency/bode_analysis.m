s=tf('s');
g=4.545*s/(s+5.6197)/(s+0.14)/(s-5.56);
controlSystemDesigner('bode',g);
