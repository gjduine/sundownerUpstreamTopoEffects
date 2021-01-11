% script to read and plot data related to figure 3  manuscript on influence of terrain
% modification on Sundowner wind diurnal variability from the month-long runs with SRM100, SRM050
% and SRM010.
% G.J. Duine, UCSB, July 2019.

clear;clc;tic;

% define locations to plot. 

sims={'SRM100','SRM075','SRM050','SRM010'};
simsStr=sims;
load('/home/sbarc/duine/sundowners/sensSRM/201703/data/model/WRF_sensSRM_stations_intp_clst_20170301_20170331.mat');


legStr={'control','25% red.','50% red.','90% red.'};


% have decided on dates for eastern and western before
% these are starting dates. This is for when both MSLP and wind metrics
% exceed 95th percentile in their 30-yr distribution (see figures 4 and 5 
% in supplemental material), then we compute the figure (so there can
% be both days in both calculations). 
yr=2017;    mo=3;
daysWest=[22,23,25,26,27];
daysEast=[6,8,11,28,29];

tnumWest=datenum(yr,mo,daysWest,12,0,0);
tnumEast=datenum(yr,mo,daysEast,12,0,0);


for i=1:length(daysWest)
    [~,idW(i)]=min(abs(tnumWest(i)-WRF.tnumWRF_PST));
end

for i=1:length(daysEast)
    [~,idE(i)]=min(abs(tnumEast(i)-WRF.tnumWRF_PST));
end

% make averages of winds speeds, need to do this in a loop as the
% different simulations are in structures
for s=1:length(sims)
    simX=sims{s};
    for t=1:length(idW)
        WRF.(simX).intp.wspdWest(:,:,t)=WRF.(simX).intp.wspd(:,idW(t):idW(t)+24);
    end
    clear('t')
    
    for t=1:length(idE)
        WRF.(simX).intp.wspdEast(:,:,t)=WRF.(simX).intp.wspd(:,idE(t):idE(t)+24);
    end    
    clear('t')
    
    WRF.(simX).intp.wspdWestAvg(:,:)=mean(WRF.(simX).intp.wspdWest(:,:,:),3);
    WRF.(simX).intp.wspdEastAvg(:,:)=mean(WRF.(simX).intp.wspdEast(:,:,:),3);

    WRF.(simX).intp.wspdWestStd(:,:)=std(WRF.(simX).intp.wspdWest(:,:,:),1,3);
    WRF.(simX).intp.wspdEastStd(:,:)=std(WRF.(simX).intp.wspdEast(:,:,:),1,3);
    
end


%% monthlong meteogram of winds

cmap=[0 0 0; 0 0 1; 0.13 0.54 0.13; 0.64 0.16 0.16]; % color scheme same to figure 6

% refugio: st=8
% montecito: st=5
% KSBA fthl: st=2
opac=0.2;
wh=[1 1 1]; % color edges

close
fig=figGD('off');
% western regimes
st=8; % refugio
sp1=subplot_tight(2,2,1,[0.05 0.05]);
for s=1:length(sims)
    simX=sims{s};
    hold on; box on; grid on;
    l1(s)=plot([0:24],WRF.(simX).intp.wspdWestAvg(st,:),'LineWidth',2,'color',cmap(s,:));
    l1a(s)=jbfill([0:24],WRF.(simX).intp.wspdWestAvg(st,:)-WRF.(simX).intp.wspdWestStd(st,:),...
        WRF.(simX).intp.wspdWestAvg(st,:),cmap(s,:),wh,0,opac);
    l1b(s)=jbfill([0:24],WRF.(simX).intp.wspdWestAvg(st,:)+WRF.(simX).intp.wspdWestStd(st,:),...
        WRF.(simX).intp.wspdWestAvg(st,:),cmap(s,:),wh,0,opac);
end
ylim([0 20]);   xlim([0 24])
set(gca,'XTick',[0:6:24],'XTickLabels',{''},...
    'YTick',[0:5:20])
leg=legend(l1(:),legStr{:},'Location','NorthWest');
title('(a) Western regime - Refugio')
ylabel('Wind speed [m s^{-1}]')

% 
% st=2; % ksba foothills
% sp2=subplot_tight(2,3,2,[0.05 0.05]);
% for s=1:length(sims)
%     simX=sims{s};
%     hold on; box on; grid on;
%     l2(s)=plot([0:24],WRF.(simX).intp.wspdWestAvg(st,:),'LineWidth',2,'color',cmap(s,:));
%     l2a(s)=jbfill([0:24],WRF.(simX).intp.wspdWestAvg(st,:)-WRF.(simX).intp.wspdWestStd(st,:),...
%         WRF.(simX).intp.wspdWestAvg(st,:),cmap(s,:),wh,0,opac);
%     l2b(s)=jbfill([0:24],WRF.(simX).intp.wspdWestAvg(st,:)+WRF.(simX).intp.wspdWestStd(st,:),...
%         WRF.(simX).intp.wspdWestAvg(st,:),cmap(s,:),wh,0,opac);
% end
% ylim([0 20]);   xlim([0 24])
% set(gca,'XTick',[0:6:24],'XTickLabels',{''},...
%     'YTick',[0:5:20],'YTickLabels',{''})
% title('(b) Western regime - center lee slope')


st=5; % montecito
sp2=subplot_tight(2,2,2,[0.05 0.05]);
ax1a=gca;
% ax1b = axes('Position',get(ax1a,'Position'),'XAxisLocation', 'top',...
%     'YAxisLocation','right','Color','none','XColor','k','YColor','k');
for s=1:length(sims)
    simX=sims{s};
    hold on; box on; grid on;
    l3(s)=plot([0:24],WRF.(simX).intp.wspdWestAvg(st,:),'LineWidth',2,'color',cmap(s,:));
    l3a(s)=jbfill([0:24],WRF.(simX).intp.wspdWestAvg(st,:)-WRF.(simX).intp.wspdWestStd(st,:),...
        WRF.(simX).intp.wspdWestAvg(st,:),cmap(s,:),wh,0,opac);
    l3b(s)=jbfill([0:24],WRF.(simX).intp.wspdWestAvg(st,:)+WRF.(simX).intp.wspdWestStd(st,:),...
        WRF.(simX).intp.wspdWestAvg(st,:),cmap(s,:),wh,0,opac);

end
ylim([0 20]);   xlim([0 24])
set(gca,'XTick',[0:6:24],'XTickLabels',{''},...
    'YTick',[0:5:20],'YTickLabels',{''})
title('(b) Western regime - Montecito')
% set(ax1b,'XLim',timeLims,'XTickLabel',{''},'YLim',[0 360],...
%     'YTick',[0 90 180 270 360],'YTickLabel',{'N','E','S','W','N'})



%%%%%%%%%%%%%% eastern regime %%%%%%%%%%%%
st=8; % refugio
sp3=subplot_tight(2,2,3,[0.05 0.05]);
for s=1:length(sims)
    simX=sims{s};
    hold on; box on; grid on;
    l4(s)=plot([0:24],WRF.(simX).intp.wspdEastAvg(st,:),'LineWidth',2,'color',cmap(s,:));
    l4a(s)=jbfill([0:24],WRF.(simX).intp.wspdEastAvg(st,:)-WRF.(simX).intp.wspdEastStd(st,:),...
        WRF.(simX).intp.wspdEastAvg(st,:),cmap(s,:),wh,0,opac);
    l4b(s)=jbfill([0:24],WRF.(simX).intp.wspdEastAvg(st,:)+WRF.(simX).intp.wspdEastStd(st,:),...
        WRF.(simX).intp.wspdEastAvg(st,:),cmap(s,:),wh,0,opac);

end
ylim([0 20]);   xlim([0 24])
set(gca,'XTick',[0:6:24],'XTickLabels',{'12','18','00','06','12'},...
    'YTick',[0:5:20])
leg=legend(l1(:),legStr{:},'Location','NorthWest');
title('(c) Eastern regime - Refugio')
ylabel('Wind speed [m s^{-1}]')
xlabel('Local time [hours]')

% 
% st=2; % ksba foothills
% sp5=subplot_tight(2,3,5,[0.05 0.05]);
% for s=1:length(sims)
%     simX=sims{s};
%     hold on; box on; grid on;
%     l5(s)=plot([0:24],WRF.(simX).intp.wspdEastAvg(st,:),'LineWidth',2,'color',cmap(s,:));
%     l5a(s)=jbfill([0:24],WRF.(simX).intp.wspdEastAvg(st,:)-WRF.(simX).intp.wspdEastStd(st,:),...
%         WRF.(simX).intp.wspdEastAvg(st,:),cmap(s,:),wh,0,opac);
%     l5b(s)=jbfill([0:24],WRF.(simX).intp.wspdEastAvg(st,:)+WRF.(simX).intp.wspdEastStd(st,:),...
%         WRF.(simX).intp.wspdEastAvg(st,:),cmap(s,:),wh,0,opac);
% 
% end
% ylim([0 20]);   xlim([0 24])
% set(gca,'XTick',[0:6:24],'XTickLabels',{'12','18','00','06','12'},...
%     'YTick',[0:5:20],'YTickLabels',{''})
% title('(e) Eastern regime - center lee slope')
% xlabel('Local time [hours]')


st=5; % montecito
sp4=subplot_tight(2,2,4,[0.05 0.05]);
ax1a=gca;
% ax1b = axes('Position',get(ax1a,'Position'),'XAxisLocation', 'top',...
%     'YAxisLocation','right','Color','none','XColor','k','YColor','k');
for s=1:length(sims)
    simX=sims{s};
    hold on; box on; grid on;
    l6(s)=plot([0:24],WRF.(simX).intp.wspdEastAvg(st,:),'LineWidth',2,'color',cmap(s,:));
    l6a(s)=jbfill([0:24],WRF.(simX).intp.wspdEastAvg(st,:)-WRF.(simX).intp.wspdEastStd(st,:),...
        WRF.(simX).intp.wspdEastAvg(st,:),cmap(s,:),wh,0,opac);
    l6b(s)=jbfill([0:24],WRF.(simX).intp.wspdEastAvg(st,:)+WRF.(simX).intp.wspdEastStd(st,:),...
        WRF.(simX).intp.wspdEastAvg(st,:),cmap(s,:),wh,0,opac);

end
ylim([0 20]);   xlim([0 24])
set(gca,'XTick',[0:6:24],'XTickLabels',{'12','18','00','06','12'},...
    'YTick',[0:5:20],'YTickLabels',{''})
title('(d) Eastern regime - Montecito')


xlabel('Local time [hours]')

set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14)

set(sp1,'Position',[0.0500 0.5250 0.2667 0.4250])
set(sp2,'Position',[0.3367 0.5250 0.2667 0.4250])
% set(sp3,'Position',[0.6233 0.5250 0.2667 0.4250])

set(sp3,'Position',[0.0500 0.0600 0.2667 0.4250])
set(sp4,'Position',[0.3367 0.0600 0.2667 0.4250])
% set(sp6,'Position',[0.6233 0.0600 0.2667 0.4250])


export_fig(strcat('Fig03'),'-png')
% export_fig(strcat('Fig03'),'-pdf')


toc