% script to read and plot hovmoller diagrams during eastern regime case

% this script is for supplemental figures for manuscript discussing 
% influence of terrain modification on Sundowner wind diurnal variability

% Gert-Jan Duine, UCSB
% gertjan.duine@gmail.com; duine@eri.ucsb.edu

clear;clc; tic


% load data
folder='/home/sbarc/wrf/wrf401/sundowners/20170311/run-64452560-z0-1way/';
inputfile=strcat(folder,'wrfout_20170311_vertProfs_hovmoller_1way.mat');
load(inputfile)

runsLeg='default';
startComp=datenum(2017,3,10,16,0,0); % PST time
endComp=datenum(2017,3,12,16,0,0); % PST time


% time selection on Whovm
[~,iSt]=min(abs(startComp-Whovm.tnumPST)); % so time selection on Whovm is (iwWRStart:2:iwWREnd)
[~,iEnd]=min(abs(endComp-Whovm.tnumPST));


clear('tnumPST')
toc

%% preparation of hovmuller matrices

% need some additional info
load(strcat('/home/sbarc/wrf/wrf401/sundowners/20170311/westEastLocations.mat'));

% prepare X and Y for Z
lonsHovMul=double(repmat(squeeze(Whovm.lons(lonsRange,115)),[1 length(squeeze(Whovm.tnumPST(:)))]));
timesHovMul=double(repmat(squeeze(Whovm.tnumPST(:)),[1 length(lonsRange)])');

%% a summary of the differences
cRangeV10=[-20:1:20];
cRangePBLD=[0:100:1500];
cRangePBLH=[0:100:3000];
cRangeHFX=[-250:10:250];
cRangeSWDOWN=[0:50:1000];


locNames={'Refugio','Montecito','center lee slope'};
locLons=[ -120.075 ;-119.649   ;-119.8517];
    


%% V10 slopes.
close
fig=figGD('off');

j=2;

sp1=subplot_tight(1,2,1,[0.16 0.07]);
hold on; box on
ax1=gca; clear('gca')
set(ax1,'Clim',[cRangeV10(1) cRangeV10(end)]);
cmap1=colormap(ax1,flipud(bluewhitered));
[c1,m1]=contourf(lonsHovMul,timesHovMul,squeeze(Whovm.V10(j,lonsRange,:)),[cRangeV10],'edgecolor','none');
hold on; box on
[c2,h2]=contour(lonsHovMul,timesHovMul,squeeze(Whovm.V10(j,lonsRange,:)),[-15.6 -13.4 -10],...
    'k','LineWidth',2,'ShowText','on');

te=text(-119.45,datenum(2017,3,11,19,0,0),'sunset');
line(lonsHovMul(:,1),[repmat(datenum(2017,3,11,18,3,0),[length(lonsHovMul(:,1)),1])],...
    'LineWidth',2,'LineStyle','--','color','k')
text(-119.45,datenum(2017,3,12,7,11,0),'sunrise')
line(lonsHovMul(:,1),[repmat(datenum(2017,3,12,6,14,0),[length(lonsHovMul(:,1)),1])],...
    'LineWidth',2,'LineStyle','--','color','k')

% plot properties
ylabel('Time in March 2017 [dd/HH PST]');
datetick('y','dd/HH','keeplimits')
set(ax1,'XLim',[-120.3 -119.31],'XTickLabel',{''},'TickDir','Out',...
    'YLim',[startComp endComp],'YTick',[startComp:datenum(0,0,0,6,0,0):endComp],...
    'YTickLabel',datestr([startComp:datenum(0,0,0,6,0,0):endComp],'dd/HH'))

Ti=title(strcat('(b) Eastern regime - V-component halfway leeslope [$m s^{-1}$]'),...
    'interpreter','latex');%,'FontName','Helvetica')
cb=colorbar;
set(ax1,'Layer','top') % to let the box re-appear
clabel(c2,h2,'FontSize',14)
clear('cmap1')
set(Ti,'FontName','Helvetica')

% plot nr. 2
hold on
sp2=subplot_tight(1,2,2,[0.43 0.06]);
hold on; box on
j=2; % slopes are indice 2
line(lonsHovMul,Whovm.hgt_hovm(j,lonsRange),...
    'LineWidth',2,'color','k');
hold on; box on
set(gca,'XLim',[-120.3 -119.31],...
    'YLim',[0 2000],'TickDir','Out')
j=3; % ridgeline is indice 3
line(lonsHovMul,Whovm.hgt_hovm(j,lonsRange),...
    'LineWidth',2,'color',[0.54 0.27 0.07]);

xLab=xlabel('Longitude [^\circW]');
yLab=ylabel('Height [m]');


for tx=1:length(locNames)
    text(locLons(tx)-0.025,1150,{locNames{tx}},'rotation',90)
        %'BackGroundColor','w');
    l1=line([locLons(tx) locLons(tx)],[1000 8000],'color','k','LineWidth',3,'LineStyle','--');
end
text(-119.58,1050,'ridgeline','rotation',20,'color',[0.54 0.27 0.07]);
text(-119.58,400,'slopes','color','k');


textB=text(-120.3,2200,'B`','FontSize',14);
textBB=text(-119.35,2200,'B``','FontSize',14);

set(sp1,'Position',[0.0700 0.2700 0.3643 0.6800])
set(sp2,'Position',[0.0700 0.1000 0.3643 0.1400])
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 18)



export_fig(strcat('FigS03b'),'-pdf')

    
toc
