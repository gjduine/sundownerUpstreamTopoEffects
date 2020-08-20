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
cRangePBLD=[0:100:2000];
cRangePBLH=[0:100:3000];
cRangeHFX=[-250:10:250];
cRangeSWDOWN=[0:50:1000];


locNames={'Refugio','Montecito','center lee slope'};
locLons=[ -120.075 ;-119.649   ;-119.8517];
    


%% V10 slopes.
close
fig=figGD('off');

j=4;

sp1=subplot_tight(1,2,1,[0.16 0.07]);
hold on; box on
ax1=gca; clear('gca')
set(ax1,'Clim',[cRangePBLD(1) cRangePBLD(end)]);
cmap1=colormap(ax1,jet);
[c1,m1]=contourf(lonsHovMul,timesHovMul,squeeze(Whovm.PBLH(j,lonsRange,:)),[cRangePBLD],'edgecolor','none');
hold on; box on


% plot properties
ylabel('Time in March 2017 [dd/HH PST]');
datetick('y','dd/HH','keeplimits')
set(ax1,'XLim',[-120.3 -119.31],'XTickLabel',{''},'TickDir','Out',...
    'YLim',[startComp endComp],'YTick',[startComp:datenum(0,0,0,6,0,0):endComp],...
    'YTickLabel',datestr([startComp:datenum(0,0,0,6,0,0):endComp],'dd/HH'))

Ti=title(strcat('(b) Eastern regime - PBL top valley [m]'),...
    'interpreter','latex');%,'FontName','Helvetica')
cb=colorbar;
set(ax1,'Layer','top') % to let the box re-appear
clear('cmap1')
set(Ti,'FontName','Helvetica')




% plot nr. 2
hold on
sp2=subplot_tight(1,2,2,[0.43 0.06]);
hold on; box on
j=4; % valley = 4
line(lonsHovMul,Whovm.hgt_hovm(j,lonsRange),...
    'LineWidth',2,'color','k');
hold on; box on
set(gca,'XLim',[-120.2 -119.45],...
    'YLim',[0 2000],'TickDir','Out')
j=3; % ridgeline is indice 
line(lonsHovMul,Whovm.hgt_hovm(j,lonsRange),...
    'LineWidth',2,'color',[0.54 0.27 0.07]);
xLab=xlabel('Longitude [^\circW]');

for tx=1:length(locNames)
    text(locLons(tx)-0.025,1150,{locNames{tx}},'rotation',90)
        %'BackGroundColor','w');
    line([locLons(tx) locLons(tx)],[1000 8000],'color','k','LineWidth',3,'LineStyle','--')
end
annotation('arrow',[0.17 0.17],[0.115 0.17],'LineWidth',2,'color','k')
annotation('arrow',[0.17 0.17],[0.17 0.115],'LineWidth',2,'color','k')
text(-119.985,600,'H_{m}')
text(-119.58,1050,'ridgeline','rotation',20,'color',[0.54 0.27 0.07]);
text(-119.58,400,'valley','color','k');
set(sp1,'Position',[0.0700 0.2700 0.3643 0.6800])
set(sp2,'Position',[0.0700 0.1000 0.3643 0.1400])

textB=text(-120.19,2200,'A`','FontSize',14);
textBB=text(-119.46,2200,'A``','FontSize',14);




set(sp1,'Position',[0.0700 0.2700 0.3643 0.6800])
set(sp2,'Position',[0.0700 0.1000 0.3643 0.1400])
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 18)



export_fig(strcat('FigS04b'),'-pdf')

    
toc
