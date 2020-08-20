% script to read and plot data from the month-long runs with SRM100, SRM050
% and SRM010.
% G.J. Duine, UCSB, July 2019.

clear;clc;tic;



sims={'SRM100','SRM075','SRM010'};
simsStr=sims;
load('/home/duine/sundowners/sensSRM/201703/data/model/WRF_sensSRM_stations_intp_clst_20170301_20170331.mat');



%% plot sea level pressure differences


close
st=[8];%1:length(WRF.stations)
fig=figGD('on')

spA=subplot_tight(3,2,1,[0.07 0.23]);
grid on; box on; hold on;
edges=[-20:2:6];
h1=histogram(WRF.SRM100.intp.V10(st,:),edges);
title('(a) Refugio control')
set(gca,'XLim',[-21.3 7.3],'YLim',[0 160])
ylabel('Count')

spB=subplot_tight(3,2,3,[0.07 0.23]);
grid on; box on; hold on;
edges=[-20:2:6];
h2=histogram(WRF.SRM075.intp.V10(st,:),edges);
title('(b) Refugio 25% reduced SRM')
set(gca,'XLim',[-21.3 7.3],'YLim',[0 160])
ylabel('Count')


spC=subplot_tight(3,2,5,[0.07 0.23]);
grid on; box on; hold on;
edges=[-20:2:6];
h2=histogram(WRF.SRM010.intp.V10(st,:),edges);
title('(c) Refugio 90% reduced SRM')
set(gca,'XLim',[-21.3 7.3],'YLim',[0 160])
ylabel('Count')
xlabel('V-component [m s^{-1}]')



st=[5];
spD=subplot_tight(3,2,2,[0.07 0.23]);
grid on; box on; hold on;
edges=[-20:2:6];
h1=histogram(WRF.SRM100.intp.V10(st,:),edges);
title('(d) Montecito control')
set(gca,'XLim',[-21.3 7.3],'YLim',[0 250])

spE=subplot_tight(3,2,4,[0.07 0.23]);
grid on; box on; hold on;
edges=[-20:2:6];
h2=histogram(WRF.SRM075.intp.V10(st,:),edges);
title('(e) Montecito 25% reduced SRM')
set(gca,'XLim',[-21.3 7.3],'YLim',[0 250])


spF=subplot_tight(3,2,6,[0.07 0.23]);
grid on; box on; hold on;
edges=[-20:2:6];
h2=histogram(WRF.SRM010.intp.V10(st,:),edges);
title('(f) Montecito 90% reduced SRM')
set(gca,'XLim',[-21.3 7.3],'YLim',[0 250])
xlabel('V-component [m s^{-1}]')


set(spD,'Position',[0.4150 0.6900 0.1550 0.2400])
set(spE,'Position',[0.4150 0.3800 0.1550 0.2400])
set(spF,'Position',[0.4150 0.0700 0.1550 0.2400])

set(findall(gcf, '-property', 'FontSize'), 'FontSize', 12)


export_fig(strcat('FigS06'),'-pdf')

toc