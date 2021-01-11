% script to plot supplemental figure 7 manuscript on influence of terrain
% modification on Sundowner wind diurnal variability

% Gert-Jan Duine, UCSB
% gertjan.duine@gmail.com; duine@eri.ucsb.edu

clear;clc;tic


% first load the dataset. These are basically subsets of the WRF output
% WRF=load(strcat('/home/sbarc/wrf/wrf401/sundowners/swex-0/WRF_cxSects_sensSRM.mat'));

WRF=load('/home/sbarc/duine/sundowners/sensSRM/201703/data/model/WRF_sensSRM_cxSects_20170301_20170331.mat');

runs={'SRM100','SRM075','SRM010'};
runX=runs;


runsTitle={'(a) control','(b) 25% red.','(c) 90% red.',...
            '(d) control','(e) 25% red.','(f) 90% red.'};

% THIS IS SELF-IMPLEMENTED, SO CHECK IT.
stations_cx={'Refugio', 'KSBA', 'Montecito'};


%%

% plot limits 
plotLimsX=[34.3 34.8];
plotLimsHgt=[0 5000];

regX=1;

regime={'western','eastern'};
daysRegime=[11];
% daysRegime=[22,23,25,26,27;     % western
%             6,8,11,28,29];      % eastern
% daysEast=[6,8,11,28,29];

% plot all days
days=daysRegime(regX,:);
% 
yr=2017;mo=3;

tnums=datenum(yr,mo,days,14,0,0);
% tnumEast=datenum(yr,mo,daysEast,12,0,0);

% plotting can start.
for i=1:length(days)
    [~,tid(i)]=min(abs(tnums(i)-WRF.SRM100.tnumPST));
	times=[tid(i) tid(i)+6];
for cx=[3]%:7
close
fig=figGD('off');
c=1; % this is a counter

for t=times
    [cx,t]
for r=1:length(runs)
    runX=runs{r}
%     WRF.(runX).tnumPST=WRF.(runX).tnumPDT-datenum(0,0,0,1,0,0);
ax3(c)=subplot_tight(2,3,c,[0.05 0.05]);
box on; hold on



line(WRF.(runX).lats(cx,:),WRF.(runX).HGT(cx,:),'LineWidth',2,'color','k') % terrain elevation
hold on
h3=contourf(repmat(WRF.(runX).lats(cx,:),size(WRF.(runX).z(cx,:,:,t),3),1)',...
    squeeze(WRF.(runX).z(cx,:,:,t))+WRF.(runX).HGT(cx,:)',...
    squeeze(WRF.(runX).V(cx,:,:,t)),[-30:1:30],'edgecolor','none');
bwr=flipud(bluewhitered(30));
colormap(ax3(c),bwr);
caxis([-15 15])
set(gca,'CLim',[-15 15])
hold on

% theta v contour
[c2,m2]=contour(repmat(WRF.(runX).lats(cx,:),size(WRF.(runX).z(cx,:,:,t),3),1)',...
    squeeze(WRF.(runX).z(cx,:,:,t))+WRF.(runX).HGT(cx,:)',...
    squeeze(WRF.(runX).thetaV(cx,:,:,t)),[280:2:320],'k','LineStyle','-','LineWidth',2,'ShowText','on');
clabel(c2,m2,'FontSize',14)


% PBL height
l1=line(WRF.(runX).lats(cx,:),WRF.(runX).HGT(cx,:)+WRF.(runX).PBLH(cx,:,t),...
    'LineStyle','-','LineWidth',3,'color',' g');

% need to set it a second time.
bwr=flipud(bluewhitered(30));
colormap(ax3(c),bwr);
caxis([-15 15])
if c==6
    cbar=colorbar;
    set(cbar,'YLim',[-15 15])
    ylabel(cbar,'V-component [m s^{-1}]')
end


Ti(c)=title(strcat(runsTitle{c},{' '},stations_cx{cx},{' - '},...
    datestr(WRF.(runX).tnumPST(t),'yyyymmdd/HH:MM')));
Ti(c).Position=[34.5800 5.0329e+03 0];

set(gca,'XLim',plotLimsX,'YLim',plotLimsHgt,'TickDir','out')

if (c==1) || (c==2) || (c==3)
    set(gca,'XTickLabels',{''})
end

if c==5
    xLab=xlabel('Latitude [N]');
end

if (c==4) || (c==5)
    set(gca,'XTickLabels',{'34.3','34.4','34.5','34.6','34.7',''})
end

if (c==1) || (c==4)
    ylabel('Elevation [km]')
    set(gca,'YTick',[0 1000 2000 3000 4000 5000],...
        'YTickLabels',{'0','1','2','3','4','5'})
else
    set(gca,'YTickLabels',{''})
end
if c==1
    leg=legend([l1],{'PBLH'});
    set(leg,'Location','NorthWest','FontSize',12)
end

box on
c=c+1; % subplot count +1
end
end

% reposition subpanels
ax3(1).Position=[0.0500 0.5250 0.2667 0.4250];
ax3(2).Position=[0.3267 0.5250 0.2667 0.4250];
ax3(3).Position=[0.6033 0.5250 0.2667 0.4250];
ax3(4).Position=[0.0500 0.0700 0.2667 0.4250];
ax3(5).Position=[0.3267 0.0700 0.2667 0.4250];
ax3(6).Position=[0.6033 0.0700 0.2667 0.4250];
cbar.Position=[0.8849 0.3200 0.0112 0.4255];
xLab.Position=[34.5500 -318.6667 -1.0000];


set(findall(gcf, '-property', 'FontSize'), 'FontSize', 18)


figName=strcat('FigS07');
export_fig(figName,'-pdf')

close

end

end
toc
