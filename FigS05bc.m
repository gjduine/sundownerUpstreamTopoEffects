% script to read and plot data from the month-long runs with SRM100, SRM050
% and SRM010.
% G.J. Duine, UCSB, July 2019.

clear;clc;tic;

% define locations to plot. 

% load data with the percentiles of MSLP differences based on 30-yrs of
% simulations
load('/home/sbarc/students/duine/sundowners/clim/analysis/stats/30years/mslpDiffs_winds/percs_winds_30yrs.mat')

sims={'SRM100','SRM075','SRM010'};
simsStr=sims;
load('/home/sbarc/duine/sundowners/sensSRM/201703/data/model/WRF_sensSRM_stations_intp_clst_20170301_20170331.mat');


legStr={'control','25% red.','90% red.'};


% sundowner PC data
load('/home/sbarc/students/duine/sundowners/clim/data/PCs_sndwn_1987_2017_dy.mat')

[~,indPcSt]=min(abs(tnumPST-WRF.tnumWRF_PST(1)));       % find indices
[~,indPcEnd]=min(abs(tnumPST-WRF.tnumWRF_PST(end)));    % find indices

PC1Thr=PC1(PC1>0);
PC2Thr=PC2(PC2>0);

tnumPST_PC1=tnumPST(PC1>0);
tnumPST_PC2=tnumPST(PC2>0);

[~,indPc1St]=min(abs(tnumPST_PC1-WRF.tnumWRF_PST(1)));       % find indices
[~,indPc1End]=min(abs(tnumPST_PC1-WRF.tnumWRF_PST(end)));    % find indices

[~,indPc2St]=min(abs(tnumPST_PC2-WRF.tnumWRF_PST(1)));       % find indices
[~,indPc2End]=min(abs(tnumPST_PC2-WRF.tnumWRF_PST(end)));    % find indices

fourHrs=datenum(0,0,0,4,0,0);

%% monthlong meteogram of winds

cmap=[0 0 0; 0 0 1; 0.64 0.16 0.16]; % color scheme same to figure 6
timeLims=[WRF.tnumWRF_PST(1) WRF.tnumWRF_PST(end)];
% timeLims=[WRF.tnumWRF_PST(372) WRF.tnumWRF_PST(end)];

% refugio: st=8
% montecito: st=5
% KSBA fthl: st=2


st=8; % refugio
close
fig=figGD('on');
subplot_tight(2,1,1,[0.05 0.05])
for s=1%length(sims)
    simX=sims{s};
    hold on; box on; grid on;
    l1(s)=plot(WRF.tnumWRF_PST,WRF.(simX).intp.wspd(st,:),'LineWidth',2,'color',cmap(s,:));
    
end
xlim(timeLims);ylim([0 15])

% plot percentiles
p1=line([timeLims(1) timeLims(2)],[wspdRHWC1ModelPercs(2) wspdRHWC1ModelPercs(2)],...
    'color','b','LineStyle','--','LineWidth',2);

% leg1=legend(l1(1),legStr{1},'Location','NorthWest');
title(strcat('(b) Refugio'))
ylabel('Wind speed [m s^{-1}]')
datetick('x','dd','keeplimits')
% 
% st=2;
% subplot_tight(3,1,2,[0.05 0.05])
% for s=1:length(sims)
%     simX=sims{s};
%     hold on; box on; grid on;
%     l1(s)=plot(WRF.tnumWRF_PST,WRF.(simX).intp.wspd(st,:),'LineWidth',2,'color',cmap(s,:));
%     
% end
% xlim(timeLims)
% lpc1=line([tnumPST_PC1(indPc1St:indPc1End)-fourHrs tnumPST_PC1(indPc1St:indPc1End)-fourHrs],[0 15],...
%     'LineStyle','--','LineWidth',2,'color','b');
% lpc2=line([tnumPST_PC2(indPc2St:indPc2End)-fourHrs tnumPST_PC2(indPc2St:indPc2End)-fourHrs],[0 15],...
%     'LineStyle',':','LineWidth',2,'color','r');
% leg=legend(l1(:),legStr{:},'Location','NorthWest');
% title(WRF.stations{st})
% ylabel('Wind speed [m s^{-1}]')
% datetick('x','','keeplimits')



st=5; % montecito
subplot_tight(2,1,2,[0.07 0.05])
ax1a=gca;
% ax1b = axes('Position',get(ax1a,'Position'),'XAxisLocation', 'top',...
%     'YAxisLocation','right','Color','none','XColor','k','YColor','k');

for s=1%:length(sims)
    simX=sims{s};
    hold on; box on; grid on;
    l1(s)=plot(WRF.tnumWRF_PST,WRF.(simX).intp.wspd(st,:),...
        'LineWidth',2,'color',cmap(s,:),'Parent',ax1a);
end
p1a=line(NaN, NaN,'color','b','LineStyle','--','LineWidth',2);
p2=line([timeLims(1) timeLims(2)],[wspdMTIC1ModelPercs(2) wspdMTIC1ModelPercs(2)],...
    'color','r','LineStyle','--','LineWidth',2);
title(strcat('(c) Montecito'))
% leg2=legend([p1a p2],{'95th RHWC1','95th MTIC1'},'Location','NorthWest');
ylim([0 15])
set(ax1a,'XLim',timeLims)
% set(ax1b,'XLim',timeLims,'XTickLabel',{''},'YLim',[0 360],...
%     'YTick',[0 90 180 270 360],'YTickLabel',{'N','E','S','W','N'})

xlabel('Time PST [days in March 2017]')
ylabel('Wind speed [m s^{-1}]')
datetick('x','dd','keeplimits')


set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)



export_fig(strcat('FigS05bc'),'-png')
export_fig(strcat('FigS05bc'),'-pdf')

toc