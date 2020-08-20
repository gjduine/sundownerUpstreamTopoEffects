% script to read and plot sea level pressure differences and winds during
% SWEX-I and March 2017 case studies

% this script is for supplemental figures for manuscript discussing 
% influence of terrain modification on Sundowner wind diurnal variability

% Gert-Jan Duine, UCSB
% gertjan.duine@gmail.com; duine@eri.ucsb.edu

clear;clc;tic


% SWEX MSLP
SWEXhm=load('/home/duine/sundowners/swex0/data/obs/Stations_slp_20180423_20180503_PST_lvl0.mat');

SWEXslp=load('/home/duine/sundowners/swex0/data/obs/Stations_slp_20180423_20180503_PST_lvl1.mat');
SWEXslp.stations=SWEXhm.stations_lvl0;
clear('SWEXhm')


% SWEX other obs
SWEXobs=load('/home/duine/sundowners/swex0/data/obs/Stations_SB_20180423_20180503_PST_lvl1.mat');



% March case MSLP
Marchhm=load('/home/duine/sundowners/20170311/data/obs/Stations_slp_20170301_20170331_lvl0.mat');
Marchslp=load('/home/duine/sundowners/20170311/data/obs/Stations_slp_20170301_20170331_lvl1.mat');
Marchslp.stations=Marchhm.stations_lvl0;
clear('Marchhm')

% other obs
Marchobs=load('/home/duine/sundowners/20170311/data/obs/Stations_SB_20170301_20170331_lvl1.mat');



% time of interest
SWEXslp.startComp=datenum(2018,4,27,16,0,0); % PST time
SWEXslp.endComp=datenum(2018,4,29,16,0,0); % PST time

[~,indStSwex]=min(abs(SWEXslp.obs_tnum_PST_lvl1(1,:)-SWEXslp.startComp));
[~,indEndSwex]=min(abs(SWEXslp.obs_tnum_PST_lvl1(1,:)-SWEXslp.endComp));

Marchslp.startComp=datenum(2017,3,10,16,0,0); % PST time
Marchslp.endComp=datenum(2017,3,12,16,0,0); % PST time
[~,indStMarch]=min(abs(Marchslp.obs_tnum_PST_lvl1(1,:)-Marchslp.startComp));
[~,indEndMarch]=min(abs(Marchslp.obs_tnum_PST_lvl1(1,:)-Marchslp.endComp));

%%
close all
c=jet(length(SWEXslp.stations));

fig=figGD('on');
subplot_tight(2,2,1,[0.05 0.05])
hold on; grid on; box on
p3a=plot(SWEXslp.obs_tnum_PST_lvl1(1,:),(squeeze(SWEXslp.obs_slp_lvl1(2,:))-squeeze(SWEXslp.obs_slp_lvl1(1,:)))/100,...
    'color','r','LineWidth',2); % sba - bfl: -4.9 hPa
p3b=plot(SWEXslp.obs_tnum_PST_lvl1(1,:),(squeeze(SWEXslp.obs_slp_lvl1(2,:))-squeeze(SWEXslp.obs_slp_lvl1(3,:)))/100,...
    'color','b','LineWidth',2); % sba - sma: -5.2 hPa

% set legend here to avoid conflict with child axis.
leg=legend([p3a p3b],{'KSBA-KBFL','KSBA-KSMA'});
set(leg,'Location','NorthWest')
set(gca,'XLim',[SWEXslp.startComp SWEXslp.endComp])
datetick('x','dd/HH','keeplimits')
ax1=gca;
grid on
xlims=get(ax1,'XLim');  set(ax1,'YLim',[-7 1])
ylabel('\Delta mslp [hPa]')
% xlabel('Time [HH/MM]')
title('Western regime')



subplot_tight(2,2,2,[0.05 0.05])
hold on; grid on; box on
p3a=plot(Marchslp.obs_tnum_PST_lvl1(1,:),(squeeze(Marchslp.obs_slp_lvl1(2,:))-squeeze(Marchslp.obs_slp_lvl1(1,:)))/100,...
    'color','r','LineWidth',2); % sba - bfl: -6.1 hPa
p3b=plot(Marchslp.obs_tnum_PST_lvl1(1,:),(squeeze(Marchslp.obs_slp_lvl1(2,:))-squeeze(Marchslp.obs_slp_lvl1(3,:)))/100,...
    'color','b','LineWidth',2); % sba - sma:  -4.2 hPa

% set legend here to avoid conflict with child axis.
leg=legend([p3a p3b],{'KSBA-KBFL','KSBA-KSMA'});
set(leg,'Location','NorthWest')
set(gca,'XLim',[Marchslp.startComp Marchslp.endComp])
datetick('x','dd/HH','keeplimits')
ax1=gca;
grid on
xlims=get(ax1,'XLim');  set(ax1,'YLim',[-7 1])
ylabel('\Delta mslp [hPa]')
% xlabel('Time [HH/MM]')
title('Eastern regime')




% wind plot for SWEX
subplot_tight(2,2,3,[0.05 0.05])
hold on; grid on; box on

p2a=plot(SWEXobs.obs_tnum_PST_lvl1(23,:),SWEXobs.obs_wspd_lvl1(23,:),...
    'color','r','LineWidth',2); % SBVC1 is station 23: 9.8 m/s
p2b=plot(SWEXobs.obs_tnum_PST_lvl1(23,:),SWEXobs.obs_wspd_gust_lvl1(23,:),...
    'color','r','LineWidth',2,'LineStyle','--'); % SBVC1 is station 23: 15.6 m/s

p3a=plot(SWEXobs.obs_tnum_PST_lvl1(21,:),SWEXobs.obs_wspd_lvl1(21,:),...
    'color','b','LineWidth',2); % RHWC1 is stations 21: 20.1 m/s
p3b=plot(SWEXobs.obs_tnum_PST_lvl1(21,:),SWEXobs.obs_wspd_gust_lvl1(21,:),...
    'color','b','LineWidth',2,'LineStyle','--'); % RHWC1 is stations 21: 25.9 m/s

% set legend here to avoid conflict with child axis.
leg=legend([p2a p3a],{SWEXobs.stations{23},SWEXobs.stations{21}});
set(leg,'Location','NorthEast')
set(gca,'XLim',[SWEXslp.startComp SWEXslp.endComp])
datetick('x','dd/HH','keeplimits')
ax1=gca;
grid on
xlims=get(ax1,'XLim');  set(ax1,'YLim',[0 26])
ylabel('Wind speed [m s^{-1}]')
xlabel('Time in April 2018 [dd/HH PST]')

% % wind direction plots



% wind plot for MARCH 2017
subplot_tight(2,2,4,[0.05 0.05])
hold on; grid on; box on

p2a=plot(Marchobs.obs_tnum_PST_lvl1(21,:),Marchobs.obs_wspd_lvl1(21,:),...
    'color','r','LineWidth',2); % sba - bfl: SBVC1 is station 21: 10.3 m/s
p2b=plot(Marchobs.obs_tnum_PST_lvl1(21,:),Marchobs.obs_wspd_gust_lvl1(21,:),...
    'color','r','LineWidth',2,'LineStyle','--'); % sba - bfl: SBVC1 is station 21: 17.9 m/s

p3a=plot(Marchobs.obs_tnum_PST_lvl1(19,:),Marchobs.obs_wspd_lvl1(19,:),...
    'color','b','LineWidth',2); % sba - sma RHWC1 is station 19: 14.8 m/s
p3b=plot(Marchobs.obs_tnum_PST_lvl1(19,:),Marchobs.obs_wspd_gust_lvl1(19,:),...
    'color','b','LineWidth',2,'LineStyle','--'); % sba - sma RHWC1 is station 19: 19.7 m/s

% set legend here to avoid conflict with child axis.
leg=legend([p2a p3a],{Marchobs.stations{21},Marchobs.stations{19}});
set(leg,'Location','NorthWest')
grid on
ax1=gca;
set(ax1,'XLim',[Marchslp.startComp Marchslp.endComp]); set(ax1,'YLim',[0 26])
datetick('x','dd/HH','keeplimits')
ylabel('Wind speed [m s^{-1}]')
xlabel('Time in March 2017 [dd/HH PST]')

export_fig(strcat('FigS02'),'-pdf')



toc