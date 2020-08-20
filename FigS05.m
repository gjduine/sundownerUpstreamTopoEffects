% script to read and plot data from the month-long runs with SRM100, SRM050
% and SRM010.
% G.J. Duine, UCSB, July 2019.

clear;clc;tic;

% define locations to plot. 


sims={'SRM100','SRM075','SRM010'};
simsStr=sims;
load('/home/duine/sundowners/sensSRM/201703/data/model/WRF_sensSRM_stations_intp_clst_20170301_20170331.mat');


stKSBA=1;
stKSMX=15;
stKBFL=16;

%% plot sea level pressure differences
cmap=[0 0 1; 
        0 1 0;
        1 0 0;
        0 0 0.1724];
indHrInt=hour(WRF.tnumWRF_PST); % plus one for indexing. correct in legend later.
indHr=floor((mod(indHrInt,24)+6)/6);

indHrsStr={'00-06','06-12','12-18','18-24'};

st=[8];%1:length(WRF.stations)
close
fig=figGD('off')
sp1=subplot_tight(2,3,1,[0.05 0.05]);
grid on; box on; hold on;
for h=1:length(WRF.tnumWRF_PST)
    p1(h)=plot(WRF.SRM100.intp.U10(st,h),WRF.SRM100.intp.V10(st,h),...
        'Marker','o','MarkerSize',7,'LineStyle','none','color',cmap(indHr(h),:),...
        'LineWidth',1.5);
end
xlim([-11 11]);ylim([-20 5])
%     xlabel('U-component [m s^{-1}]');
ylabel('V-component [m s^{-1}]')
title('(a) Refugio terrain')

sp2=subplot_tight(2,3,2,[0.05 0.05]);
grid on; box on; hold on;
for h=1:length(WRF.tnumWRF_PST)
    p1(h)=plot(WRF.SRM075.intp.U10(st,h),WRF.SRM075.intp.V10(st,h),...
        'Marker','o','MarkerSize',7,'LineStyle','none','color',cmap(indHr(h),:),...
        'LineWidth',1.5);
end
xlim([-11 11]);ylim([-20 5])
%     xlabel('U-component [m s^{-1}]');%ylabel('V-component [m s^{-1}]')
title('(b) Refugio 25% reduced SRM')


sp3=subplot_tight(2,3,3,[0.05 0.05]);
grid on; box on; hold on;
for h=1:length(WRF.tnumWRF_PST)
    p1(h)=plot(WRF.SRM010.intp.U10(st,h),WRF.SRM010.intp.V10(st,h),...
        'Marker','o','MarkerSize',7,'LineStyle','none','color',cmap(indHr(h),:),...
        'LineWidth',1.5);
end
xlim([-11 11]);ylim([-20 5])
%     xlabel('U-component [m s^{-1}]');%ylabel('V-component [m s^{-1}]')
title('(c) Refugio 90% reduced SRM')
leg=legend(p1([9,15,21,27]),indHrsStr{1:4}); % minus 1 for real PST.
%     supTi1=suptitle('Refugio');
%     set(supTi1,'Position',[0.5000 -0.2 0])



st=[5];
sp4=subplot_tight(2,3,4,[0.05 0.05]);
grid on; box on; hold on;
for h=1:length(WRF.tnumWRF_PST)
    p1(h)=plot(WRF.SRM100.intp.U10(st,h),WRF.SRM100.intp.V10(st,h),...
        'Marker','o','MarkerSize',7,'LineStyle','none','color',cmap(indHr(h),:),...
        'LineWidth',1.5);
end
xlim([-11 11]);ylim([-20 5])
xlabel('U-component [m s^{-1}]');ylabel('V-component [m s^{-1}]')
title('(d) Montecito terrain')

sp5=subplot_tight(2,3,5,[0.05 0.05]);
grid on; box on; hold on;
for h=1:length(WRF.tnumWRF_PST)
    p1(h)=plot(WRF.SRM075.intp.U10(st,h),WRF.SRM075.intp.V10(st,h),...
        'Marker','o','MarkerSize',7,'LineStyle','none','color',cmap(indHr(h),:),...
        'LineWidth',1.5);
end
xlim([-11 11]);ylim([-20 5])
xlabel('U-component [m s^{-1}]');%ylabel('V-component [m s^{-1}]')
title('(e) Montecito 25% reduced SRM')


sp6=subplot_tight(2,3,6,[0.05 0.05]);
grid on; box on; hold on;
for h=1:length(WRF.tnumWRF_PST)
    p1(h)=plot(WRF.SRM010.intp.U10(st,h),WRF.SRM010.intp.V10(st,h),...
        'Marker','o','MarkerSize',7,'LineStyle','none','color',cmap(indHr(h),:),...
        'LineWidth',1.5);
end
xlim([-11 11]);ylim([-20 5])
xlabel('U-component [m s^{-1}]');%ylabel('V-component [m s^{-1}]')
title('(f) Montecito 90% reduced SRM')


set(sp1,'Position',[0.0500 0.5300 0.2667 0.4250])
set(sp2,'Position',[0.3367 0.5300 0.2667 0.4250])
set(sp3,'Position',[0.6233 0.5300 0.2667 0.4250])
set(sp4,'Position',[0.0500 0.0600 0.2667 0.4250])
set(sp5,'Position',[0.3367 0.0600 0.2667 0.4250])
set(sp6,'Position',[0.6233 0.0600 0.2667 0.4250])

set(leg,'Position',[0.9081 0.3574 0.0351 0.0572])
text(11.5,4,'Hour [PST]')

set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14)


export_fig(strcat('FigS05'),'-pdf')

toc