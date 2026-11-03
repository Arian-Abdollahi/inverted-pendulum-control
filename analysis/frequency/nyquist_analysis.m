s=tf('s');
g=4.545*s/(s+5.6197)/(s+0.14)/(s-5.56);
nyquist(g)
% From our previous discussion we know that our system has one open-loop 
% pole in the right-half plane ($P$ = 1) and from examination of the
% open-loop Nyquist plot above we can see that there are no encirclements
% of the point -1 ($N$ = 0). Therefore, $Z$ = 0 + 1 = 1 and the closed-loop
% system has 1 pole in the right-half plane indicating 
% that it is indeed unstable
