% script to read and plot supplemental figure 9

clear;clc;tic

% some constants
rd=287.05;
cp=1004;
rdcp=rd/cp; 
crit_rib=0.25;
clear('rd','cp')


% swex
load('/home/duine/sundowners/swex0/data/model/swex-0_vertProfs_sensSRM_moreLocs_SRMonly.mat');
WRFSwex=WRF;    clear('WRF')


% march 2017
load('/home/duine/sundowners/20170311/data/model/20170311_vertProfs_sensSRM_moreLocs_SRMonly.mat')
WRFMarch=WRF;   clear('WRF')

sims={'1way','SRM075','SRM050',...
    'SRM030','SRM010'};
simsStr=sims;
legStr={'control','25% red.','50% red.','70% red.','90% red.'};


  



cmap=[0 0 0; 0 0 1; 0 1 0; 1 0 1; 0.64 0.16 0.16]; % black

%% start plotting

indSt=21;
indEnd=49;

% refugio station is st 10
% montecito station is 7

close
figGD('off')

s1=subplot_tight(2,4,1,[0.08 0.05]);
hold on; grid on; box on
st=10; % refugio upvalley
for s=1:length(sims)
    simX=strcat('s',sims{s});
    p3c(s)=plot(NaN,NaN,...
        'color',cmap(s,:),'LineWidth',2,'LineStyle','-',...
        'MarkerSize',5);
    p1(s)=line(WRFSwex.(simX).tnumPST(21:49),WRFSwex.(simX).V4000(st,21:49),...
        'color',cmap(s,:),'LineWidth',2);
end
textA=text(WRFSwex.(simX).tnumPST(indSt+2),1,'(a)','FontWeight','bold');
Title1= text(WRFSwex.(simX).tnumPST(indSt+15),3,'Western regime - Refugio upvalley','FontWeight','bold');
textYlab=text(WRFSwex.(simX).tnumPST(indSt)-datenum(0,0,0,6,0,0),-25,...
    'V-component [m s^{-1}]','rotation',90);
leg=legend([p3c(:)],legStr{:});    set(leg,'Location','SouthWest')
ylabel('4000 MSL')
ax1=gca;
set(ax1,'YLim',[-16 2],...
    'XLim',[WRFSwex.(simX).tnumPST(indSt) WRFSwex.(simX).tnumPST(indEnd)],'XTickLabel',{''})
datetick('x','dd/HH','keeplimits')


s2=subplot_tight(2,4,2,[0.08 0.05]);
hold on; grid on; box on
textB=text(WRFSwex.(simX).tnumPST(indSt+2),1,'(b)','FontWeight','bold');
for s=1:length(sims)
    simX=strcat('s',sims{s});
    p3c(s)=plot(NaN,NaN,...
        'color',cmap(s,:),'LineWidth',2,'LineStyle','-',...
        'MarkerSize',5);
    p1(s)=line(WRFSwex.(simX).tnumPST(21:49),WRFSwex.(simX).V1500(st,21:49),...
        'color',cmap(s,:),'LineWidth',2);
end
ylabel('1500 MSL')
ax1=gca;
set(ax1,'YLim',[-16 2],'YTickLabel',{''},...
    'XLim',[WRFSwex.(simX).tnumPST(indSt) WRFSwex.(simX).tnumPST(indEnd)])
datetick('x','dd/HH','keeplimits')


st=7; % monteicto upvalley
s3=subplot_tight(2,4,3,[0.08 0.05]);
hold on; grid on; box on
textC=text(WRFSwex.(simX).tnumPST(indSt+2),1,'(c)','FontWeight','bold');
Title2= text(WRFSwex.(simX).tnumPST(indSt+15),3,'Western regime - Montecito upvalley','FontWeight','bold');
for s=1:length(sims)
    simX=strcat('s',sims{s});
    p3c(s)=plot(NaN,NaN,...
        'color',cmap(s,:),'LineWidth',2,'LineStyle','-',...
        'MarkerSize',5);
    p1(s)=line(WRFSwex.(simX).tnumPST(21:49),WRFSwex.(simX).V4000(st,21:49),...
        'color',cmap(s,:),'LineWidth',2);
end
textXlab1=text(WRFSwex.(simX).tnumPST(1),-18,'Time in April 2018 [dd/HH]'); 
ylabel('4000 MSL')
ax1=gca;
set(ax1,'YLim',[-16 2],'YTickLabel',{''},...
    'XLim',[WRFSwex.(simX).tnumPST(indSt) WRFSwex.(simX).tnumPST(indEnd)])
datetick('x','dd/HH','keeplimits')


s4=subplot_tight(2,4,4,[0.08 0.05]);
hold on; grid on; box on
textD=text(WRFSwex.(simX).tnumPST(indSt+2),1,'(d)','FontWeight','bold');
for s=1:length(sims)
    simX=strcat('s',sims{s});
    p3c(s)=plot(NaN,NaN,...
        'color',cmap(s,:),'LineWidth',2,'LineStyle','-',...
        'MarkerSize',5);
    p1(s)=line(WRFSwex.(simX).tnumPST(21:49),WRFSwex.(simX).V1500(st,21:49),...
        'color',cmap(s,:),'LineWidth',2);
end
ylabel('1500 MSL')
ax1=gca;
set(ax1,'YLim',[-16 2],'YTickLabel',{''},...
    'XLim',[WRFSwex.(simX).tnumPST(indSt) WRFSwex.(simX).tnumPST(indEnd)])
datetick('x','dd/HH','keeplimits')



s5=subplot_tight(2,4,5,[0.08 0.05]);
hold on; grid on; box on
st=10; % refugio upvalley
textE=text(WRFMarch.(simX).tnumPST(indSt+2),1,'(e)','FontWeight','bold');
Title3= text(WRFMarch.(simX).tnumPST(indSt+15),3,' Eastern regime - Refugio upvalley','FontWeight','bold');
for s=1:length(sims)
    simX=strcat('s',sims{s});
    p3c(s)=plot(NaN,NaN,...
        'color',cmap(s,:),'LineWidth',2,'LineStyle','-',...
        'MarkerSize',5);
    p1(s)=line(WRFMarch.(simX).tnumPST(21:49),WRFMarch.(simX).V4000(st,21:49),...
        'color',cmap(s,:),'LineWidth',2);
end
ylabel('4000 MSL')
ax1=gca;
set(ax1,'YLim',[-16 2],...
    'XLim',[WRFMarch.(simX).tnumPST(indSt) WRFMarch.(simX).tnumPST(indEnd)],'XTickLabel',{''})
datetick('x','dd/HH','keeplimits')


s6=subplot_tight(2,4,6,[0.08 0.05]);
hold on; grid on; box on
textF=text(WRFMarch.(simX).tnumPST(indSt+2),1,'(f)','FontWeight','bold');
for s=1:length(sims)
    simX=strcat('s',sims{s});
    p3c(s)=plot(NaN,NaN,...
        'color',cmap(s,:),'LineWidth',2,'LineStyle','-',...
        'MarkerSize',5);
    p1(s)=line(WRFMarch.(simX).tnumPST(21:49),WRFMarch.(simX).V1500(st,21:49),...
        'color',cmap(s,:),'LineWidth',2);
end
ylabel('1500 MSL')
ax1=gca;
set(ax1,'YLim',[-16 2],'YTickLabel',{''},...
    'XLim',[WRFMarch.(simX).tnumPST(indSt) WRFMarch.(simX).tnumPST(indEnd)])
datetick('x','dd/HH','keeplimits')


st=7; % monteicto upvalley
s7=subplot_tight(2,4,7,[0.08 0.05]);
hold on; grid on; box on
textG=text(WRFMarch.(simX).tnumPST(indSt+2),1,'(g)','FontWeight','bold');
Title4= text(WRFMarch.(simX).tnumPST(indSt+15),3,' Eastern regime - Montecito upvalley','FontWeight','bold');
for s=1:length(sims)
    simX=strcat('s',sims{s});
    p3c(s)=plot(NaN,NaN,...
        'color',cmap(s,:),'LineWidth',2,'LineStyle','-',...
        'MarkerSize',5);
    p1(s)=line(WRFMarch.(simX).tnumPST(21:49),WRFMarch.(simX).V4000(st,21:49),...
        'color',cmap(s,:),'LineWidth',2);
end
textXlab2=text(WRFMarch.(simX).tnumPST(1),-18,'Time in March 2017 [dd/HH]');   ylabel('4000 MSL')
ax1=gca;
set(ax1,'YLim',[-16 2],'YTickLabel',{''},...
    'XLim',[WRFMarch.(simX).tnumPST(indSt) WRFMarch.(simX).tnumPST(indEnd)])
datetick('x','dd/HH','keeplimits')


s8=subplot_tight(2,4,8,[0.08 0.05]);
hold on; grid on; box on
texth=text(WRFMarch.(simX).tnumPST(indSt+2),1,'(h)','FontWeight','bold');
for s=1:length(sims)
    simX=strcat('s',sims{s});
    p3c(s)=plot(NaN,NaN,...
        'color',cmap(s,:),'LineWidth',2,'LineStyle','-',...
        'MarkerSize',5);
    p1(s)=line(WRFMarch.(simX).tnumPST(21:49),WRFMarch.(simX).V1500(st,21:49),...
        'color',cmap(s,:),'LineWidth',2);
end
ylabel('1500 MSL')
ax1=gca;
set(ax1,'YLim',[-16 2],'YTickLabel',{''},...
    'XLim',[WRFMarch.(simX).tnumPST(indSt) WRFMarch.(simX).tnumPST(indEnd)])
datetick('x','dd/HH','keeplimits')





set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14)

set(textYlab,'FontSize',18)
set(textXlab1,'FontSize',18)
set(textXlab2,'FontSize',18)

set(Title1,'FontSize',16)
set(Title2,'FontSize',16)
set(Title3,'FontSize',16)
set(Title4,'FontSize',16)


set(s2,'Position',[0.2675 0.5400 0.1875 0.3800])
set(s3,'Position',[0.4850 0.5400 0.1875 0.3800])
set(s4,'Position',[0.7025 0.5400 0.1875 0.3800])

set(s6,'Position',[0.2675 0.0800 0.1875 0.3800])
set(s7,'Position',[0.4850 0.0800 0.1875 0.3800])
set(s8,'Position',[0.7025 0.0800 0.1875 0.3800])


export_fig(strcat('FigS09'),'-png');
export_fig(strcat('FigS09'),'-pdf');





toc