% script to plot figure s8 manuscript on influence of terrain
% modification on Sundowner wind diurnal variability

% Gert-Jan Duine, UCSB
% gertjan.duine@gmail.com; duine@eri.ucsb.edu

clear;clc;tic

% some constants
rd=287.05;
cp=1004;
rdcp=rd/cp; 
crit_rib=0.25;
clear('rd','cp')


% swex datafile
load('/home/sbarc/duine/sundowners/swex0/data/model/swex-0_vertProfs_sensSRM_moreLocs_stc.mat');
WRFSwex=WRF;    clear('WRF')


% march 2017 datafile
load('/home/sbarc/duine/sundowners/20170311/data/model/20170311_vertProfs_sensSRM_moreLocs_stc.mat')
WRFMarch=WRF;   clear('WRF')

sims={'1way','SRM010','SRM010_stc1',...
    'SRM010_stc2','SRM010_stc3','SRM010_stc4'};
simsStr=sims;
legStr={'control','90% red.','90% red. stc1-stc4'};
%     '90% red. stc2','90% red. stc3','90% red. stc4'};

%% plotting from here
%%%% some plotting constants. We plot stuff.

WRFSwex.dateSt=datenum(2018,4,27,18,0,0);%tnumPST(indSt));
WRFSwex.dateEnd=datenum(2018,4,29,8,0,0);%tnumPST(indEnd));
WRFSwex.indSt=find(WRFSwex.s1way.tnumPST==WRFSwex.dateSt);
WRFSwex.indEnd=find(WRFSwex.s1way.tnumPST==WRFSwex.dateEnd);

WRFMarch.dateSt=datenum(2017,3,10,18,0,0);%tnumPST(indSt));
WRFMarch.dateEnd=datenum(2017,3,12,8,0,0);%tnumPST(indEnd));
WRFMarch.indSt=find(WRFMarch.s1way.tnumPST==WRFMarch.dateSt);
WRFMarch.indEnd=find(WRFMarch.s1way.tnumPST==WRFMarch.dateEnd);

% cmap=[0 0 0; 0 0 1; 0 1 0; 1 0 1; 0.64 0.16 0.16]; % color scheme
% cmap=[0 0 0; 0.64 0.16 0.16; 1 0 0;
%     1 0 0; 1 0 0; 1 0 0]; % color scheme based on red
cmap=[0 0 0; 0 0 1; 0 0.8 1;
    0 0.8 1; 0 0.8 1; 0 0.8 1]; % color scheme based on blue
cmap=[0 0 0; 0 0.5 0; 0.2 0.8 0.2;
    0.2 0.8 0.2;0.2 0.8 0.2;0.2 0.8 0.2]; % color scheme based on blue

LineWidths=[2 2 1 1 1 1];

close
figGD('off')
%%%%%% western regime refugio %%%%%%%
sp1=subplot_tight(2,3,1,[0.1 0.05]); % plot 1
hold on; grid on; box on
st=8; % refugio station
for s=1:length(sims)
    simX=strcat('s',sims{s}); % wind speed
    p3c(s)=plot(WRFSwex.(simX).tnumPST(WRFSwex.indSt:WRFSwex.indEnd),...
        WRFSwex.(simX).wspd10_st(st,WRFSwex.indSt:WRFSwex.indEnd),...
        'color',cmap(s,:),'LineWidth',LineWidths(s),'LineStyle','-'); % only plot total rainfall
end
leg=legend([p3c(1:3)],legStr{1:3});
set(leg,'Location','SouthWest')
xlabel('Time PST in April 2018 [dd/HH]')
ylabel('Wind speed [m s^{-1}]')
datetick('x','dd/HH','keeplimits')
set(gca,'YLim',[0 20])
ax1a=gca;
ylims=get(ax1a,'YLim');
set(ax1a,'YColor','k','XLim',[WRFSwex.dateSt WRFSwex.dateEnd],...
    'XTick',[WRFSwex.dateSt:datenum(0,0,0,6,0,0):WRFSwex.dateEnd],...
    'YLim',[0 ylims(2)],'YTick',[0 ylims(2)*0.25 ylims(2)*0.5 ylims(2)*0.75 ylims(2)])
datetick('x','dd/HH','keeplimits')

ax1a=gca;
ax1b = axes('Position',get(ax1a,'Position'),'XAxisLocation', 'top',...
    'YAxisLocation','right','Color','none','XColor','k','YColor','k');
hold on
for s=1:length(sims)
    simX=strcat('s',sims{s}); % wind direction
    p3d=plot(WRFSwex.(simX).tnumPST(WRFSwex.indSt:WRFSwex.indEnd),...
        WRFSwex.(simX).wdir10_st(st,WRFSwex.indSt:WRFSwex.indEnd),...
        'color',cmap(s,:),'LineWidth',LineWidths(s),'LineStyle','none',...
        'Marker','x','Parent',ax1b); % only plot total rainfall
end
datetick('x','dd/HH','keeplimits')
set(ax1b,'XLim',[WRFSwex.dateSt WRFSwex.dateEnd],'XTickLabel',{''},'YLim',[0 360],...
    'YTick',[0 90 180 270 360],'YTickLabel',{'N','E','S','W','N'})
% ylabel('Wind direction')
set(ax1b,'XTickLabel',{''})
ti1=title(strcat('(a) Western regime - Refugio'));

% 
% %%%%%% western regime center lee slope %%%%%%%
% sp2=subplot_tight(2,3,2,[0.1 0.05]);
% hold on; grid on; box on
% st=2;
% for s=1:length(sims)
%     simX=strcat('s',sims{s});
%     p3c(s)=plot(WRFSwex.(simX).tnumPST(WRFSwex.indSt:WRFSwex.indEnd),...
%         WRFSwex.(simX).wspd10_st(st,WRFSwex.indSt:WRFSwex.indEnd),...
%         'color',cmap(s,:),'LineWidth',LineWidths(s),'LineStyle','-'); % only plot total rainfall
% end
% xlabel('Time PST in April 2018 [dd/HH]')
% datetick('x','dd/HH','keeplimits')
% set(gca,'YLim',[0 20])
% ax1a=gca;
% ylims=get(ax1a,'YLim');
% set(ax1a,'YColor','k','XLim',[WRFSwex.dateSt WRFSwex.dateEnd],...
%     'XTick',[WRFSwex.dateSt:datenum(0,0,0,6,0,0):WRFSwex.dateEnd],...
%     'YLim',[0 ylims(2)],'YTick',[0 ylims(2)*0.25 ylims(2)*0.5 ylims(2)*0.75 ylims(2)])
% datetick('x','dd/HH','keeplimits')
% 
% ax2a=gca;
% ax2b = axes('Position',get(ax2a,'Position'),'XAxisLocation', 'top',...
%     'YAxisLocation','right','Color','none','XColor','k','YColor','k');
% hold on
% for s=1:length(sims)
%     simX=strcat('s',sims{s});
%     p3d=plot(WRFSwex.(simX).tnumPST(WRFSwex.indSt:WRFSwex.indEnd),...
%         WRFSwex.(simX).wdir10_st(st,WRFSwex.indSt:WRFSwex.indEnd),...
%         'color',cmap(s,:),'LineWidth',LineWidths(s),'LineStyle','none',...
%         'Marker','x','Parent',ax2b); % only plot total rainfall
% end
% datetick('x','dd/HH','keeplimits')
% set(ax2b,'XLim',[WRFSwex.dateSt WRFSwex.dateEnd],'XTickLabel',{''},'YLim',[0 360],...
%     'YTick',[0 90 180 270 360],'YTickLabel',{'N','E','S','W','N'})
% set(ax2b,'XTickLabel',{''})
% ti2=title(strcat('(b) Western regime - center lee slope'));



%%%%%%%%%%%%%%%%%%%% plot western regime at montecito %%%%%%%%%%%%%%%
sp3=subplot_tight(2,3,3,[0.1 0.05]);
hold on; grid on; box on
st=5; % montecito nr.
for s=1:length(sims)
    simX=strcat('s',sims{s});
    p3c=plot(WRFSwex.(simX).tnumPST(WRFSwex.indSt:WRFSwex.indEnd),...
        WRFSwex.(simX).wspd10_st(st,WRFSwex.indSt:WRFSwex.indEnd),...
        'color',cmap(s,:),'LineWidth',LineWidths(s),'LineStyle','-'); % only plot total rainfall
end
xlabel('Time PST in April 2018 [dd/HH]')
datetick('x','dd/HH','keeplimits')
set(gca,'YLim',[0 20])
ax3a=gca;
ylims=get(ax3a,'YLim');
set(ax3a,'YColor','k','XLim',[WRFSwex.dateSt WRFSwex.dateEnd],...
    'XTick',[WRFSwex.dateSt:datenum(0,0,0,6,0,0):WRFSwex.dateEnd],...
    'YLim',[0 ylims(2)],'YTick',[0 ylims(2)*0.25 ylims(2)*0.5 ylims(2)*0.75 ylims(2)])
datetick('x','dd/HH','keeplimits')


ax3a=gca;
ax3b = axes('Position',get(ax3a,'Position'),'XAxisLocation', 'top',...
    'YAxisLocation','right','Color','none','XColor','k','YColor','k');
hold on
for s=1:length(sims)
    simX=strcat('s',sims{s});
    p3d=plot(WRFSwex.(simX).tnumPST(WRFSwex.indSt:WRFSwex.indEnd),...
        WRFSwex.(simX).wdir10_st(st,WRFSwex.indSt:WRFSwex.indEnd),...
        'color',cmap(s,:),'LineWidth',LineWidths(s),'LineStyle','none',...
        'Marker','x','Parent',ax3b); % only plot total rainfall
end
datetick('x','dd/HH','keeplimits')
set(ax3b,'XLim',[WRFSwex.dateSt WRFSwex.dateEnd],'XTickLabel',{''},'YLim',[0 360],...
    'YTick',[0 90 180 270 360],'YTickLabel',{'N','E','S','W','N'})
ylabel('Wind direction')
ti3=title(strcat('(b) Western regime - Montecito'));



%%%%%%%%%%%% eastern regime refugio %%%%%%%%%%
sp4=subplot_tight(2,3,4,[0.1 0.05]);
hold on; grid on; box on
st=8;
for s=1:length(sims)
    simX=strcat('s',sims{s});
    p3c(s)=plot(WRFMarch.(simX).tnumPST(:),WRFMarch.(simX).wspd10_st(st,:),...
        'color',cmap(s,:),'LineWidth',LineWidths(s),'LineStyle','-'); % only plot total rainfall
end
xlabel('Time PST in March 2017 [dd/HH]')
ylabel('Wind speed [m s^{-1}]')
datetick('x','dd/HH','keeplimits')
set(gca,'YLim',[0 20])
ax4a=gca;
ylims=get(ax4a,'YLim');
set(ax4a,'YColor','k','XLim',[WRFMarch.dateSt WRFMarch.dateEnd],...
    'XTick',[WRFMarch.dateSt:datenum(0,0,0,6,0,0):WRFMarch.dateEnd],...
    'YLim',[0 ylims(2)],'YTick',[0 ylims(2)*0.25 ylims(2)*0.5 ylims(2)*0.75 ylims(2)])
datetick('x','dd/HH','keeplimits')


ax4a=gca;
ax4b = axes('Position',get(ax4a,'Position'),'XAxisLocation', 'top',...
    'YAxisLocation','right','Color','none','XColor','k','YColor','k');
hold on
for s=1:length(sims)
    simX=strcat('s',sims{s});
    p3d=plot(WRFMarch.(simX).tnumPST(:),WRFMarch.(simX).wdir10_st(st,:),...
        'color',cmap(s,:),'LineWidth',LineWidths(s),'LineStyle','none',...
        'Marker','x','Parent',ax4b); % only plot total rainfall
end
datetick('x','dd/HH','keeplimits')
set(ax4b,'XLim',[WRFMarch.dateSt WRFMarch.dateEnd],'XTickLabel',{''},'YLim',[0 360],...
    'YTick',[0 90 180 270 360],'YTickLabel',{'N','E','S','W','N'})
% ylabel('Wind direction')
set(ax4b,'XTickLabel',{''})
ti4=title(strcat('(b) Eastern regime - Refugio'));


% 
% %%%%%%%%%%%% eastern regime center lee slope %%%%%%%%%%
% sp5=subplot_tight(2,3,5,[0.1 0.05]);
% hold on; grid on; box on
% st=2;
% for s=1:length(sims)
%     simX=strcat('s',sims{s});
%     p3c(s)=plot(WRFMarch.(simX).tnumPST(:),WRFMarch.(simX).wspd10_st(st,:),...
%         'color',cmap(s,:),'LineWidth',LineWidths(s),'LineStyle','-'); % only plot total rainfall
% end
% xlabel('Time PST in March 2017 [dd/HH]')
% datetick('x','dd/HH','keeplimits')
% set(gca,'YLim',[0 20])
% ax5a=gca;
% ylims=get(ax5a,'YLim');
% set(ax5a,'YColor','k','XLim',[WRFMarch.dateSt WRFMarch.dateEnd],...
%     'XTick',[WRFMarch.dateSt:datenum(0,0,0,6,0,0):WRFMarch.dateEnd],...
%     'YLim',[0 ylims(2)],'YTick',[0 ylims(2)*0.25 ylims(2)*0.5 ylims(2)*0.75 ylims(2)])
% datetick('x','dd/HH','keeplimits')
% 
% 
% ax5a=gca;
% ax5b = axes('Position',get(ax5a,'Position'),'XAxisLocation', 'top',...
%     'YAxisLocation','right','Color','none','XColor','k','YColor','k');
% hold on
% for s=1:length(sims)
%     simX=strcat('s',sims{s});
%     p3d=plot(WRFMarch.(simX).tnumPST(:),WRFMarch.(simX).wdir10_st(st,:),...
%         'color',cmap(s,:),'LineWidth',LineWidths(s),'LineStyle','none',...
%         'Marker','x','Parent',ax5b); % only plot total rainfall
% end
% datetick('x','dd/HH','keeplimits')
% set(ax5b,'XLim',[WRFMarch.dateSt WRFMarch.dateEnd],'XTickLabel',{''},'YLim',[0 360],...
%     'YTick',[0 90 180 270 360],'YTickLabel',{'N','E','S','W','N'})
% set(ax5b,'XTickLabel',{''})
% ti5=title(strcat('(e) Eastern regime - center lee slope'));


%%%%%%%%%%%%%%%%%%%% plot eastern regime at montecito %%%%%%%%%%%%%%%
sp6=subplot_tight(2,3,6,[0.1 0.05]);
hold on; grid on; box on
st=5; % montecito nr.
for s=1:length(sims)
    simX=strcat('s',sims{s});
    p3c=plot(WRFMarch.(simX).tnumPST(:),WRFMarch.(simX).wspd10_st(st,:),...
        'color',cmap(s,:),'LineWidth',LineWidths(s),'LineStyle','-'); % only plot total rainfall
end
xlabel('Time PST in March 2017 [dd/HH]')
datetick('x','dd/HH','keeplimits')
set(gca,'YLim',[0 20])
ax6a=gca;
ylims=get(ax6a,'YLim');
set(ax6a,'YColor','k','XLim',[WRFMarch.dateSt WRFMarch.dateEnd],...
    'XTick',[WRFMarch.dateSt:datenum(0,0,0,6,0,0):WRFMarch.dateEnd],...
    'YLim',[0 ylims(2)],'YTick',[0 ylims(2)*0.25 ylims(2)*0.5 ylims(2)*0.75 ylims(2)])
datetick('x','dd/HH','keeplimits')


ax6a=gca;
ax6b = axes('Position',get(ax6a,'Position'),'XAxisLocation', 'top',...
    'YAxisLocation','right','Color','none','XColor','k','YColor','k');
hold on
for s=1:length(sims)
    simX=strcat('s',sims{s});
    p3d=plot(WRFMarch.(simX).tnumPST(:),WRFMarch.(simX).wdir10_st(st,:),...
        'color',cmap(s,:),'LineWidth',LineWidths(s),'LineStyle','none',...
        'Marker','x','Parent',ax6b); % only plot total rainfall
end
datetick('x','dd/HH','keeplimits')
set(ax6b,'XLim',[WRFMarch.dateSt WRFMarch.dateEnd],'XTickLabel',{''},'YLim',[0 360],...
    'YTick',[0 90 180 270 360],'YTickLabel',{'N','E','S','W','N'})
ylabel('Wind direction')
ti6=title(strcat('(d) Eastern regime - Montecito'));


% reset some figure properties
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 18)
set(ti1,'FontSize',16)
% set(ti2,'FontSize',16)
set(ti3,'FontSize',16)
set(ti4,'FontSize',16)
% set(ti5,'FontSize',16)
set(ti6,'FontSize',16)
set(leg,'FontSize',16)


set(sp1,'Position',[0.0500 0.5600 0.2667 0.3500])
set(ax1b,'Position',[0.0500 0.5600 0.2667 0.3500])
% set(sp2,'Position',[0.3567 0.5600 0.2667 0.3500])
% set(ax2b,'Position',[0.3567 0.5600 0.2667 0.3500])
set(sp3,'Position',[0.3567 0.5600 0.2667 0.3500])
set(ax3b,'Position',[0.3567 0.5600 0.2667 0.3500])

set(sp4,'Position',[0.0500 0.1000 0.2667 0.3500])
set(ax4b,'Position',[0.0500 0.1000 0.2667 0.3500])
% set(sp5,'Position',[0.3567 0.1000 0.2667 0.3500])
% set(ax5b,'Position',[0.3567 0.1000 0.2667 0.3500])
set(sp6,'Position',[0.3567 0.1000 0.2667 0.3500])
set(ax6b,'Position',[0.3567 0.1000 0.2667 0.3500])

export_fig(strcat('FigS03'),'-pdf');







toc