figure(1)
clf
[c,h] = contourf(peaks,50);
xlabel('xlabel')
ylabel('ylabel')
set(h,'linestyle','none')
[ax,nax] = g_despine;
gpng('example')