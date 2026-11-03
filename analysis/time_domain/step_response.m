s=tf('s');
G=4.545.*s/(s+5.6197)/(s+0.14)/(s-5.56);
figure
plot(step(G));
hold on;
xlim([0, 100]);
stepinfo(G)
