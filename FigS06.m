% script to read and plot supplemental figure 10

clear;clc;tic

% some constants
rd=287.05;
cp=1004;
rdcp=rd/cp; 
crit_rib=0.25;
clear('rd','cp')


% load data.

load(strcat('/home/sbarc/duine/sundowners/sensSRM/201703/data/model/201703_vertProfs_sensSRM_moreLocs_SRMonly.mat'));
sims={'SRM100','SRM075','SRM050','SRM010'};
legStr={'control','25% red.','50% red.','90% red.'};


% cmap=[0 0 0; 0 0 1; 0.64 0.16 0.16]; % color scheme same to figure 3
cmap=[0 0 0; 0 0 1; 0.13 0.54 0.13; 0.64 0.16 0.16]; % color scheme same to figure 6

%% start plotting


regX=[1,2];

regime={'western','eastern'};
% caseSt=strcat(regime{regX},{' '},'regime');

% daysRegime=[22,23,25,26,27;     % western
%             6,8,11,28,29];      % eastern
daysRegime=[26, 11];      % eastern

days=daysRegime;
% 
yr=2017;mo=3;

tnums=datenum(yr,mo,days,6,0,0);
[~,indStWest]=min(abs(tnums(1)-WRF.SRM100.tnumPST));
[~,indStEast]=min(abs(tnums(2)-WRF.SRM100.tnumPST));



%% plotting from here



% refugio station is st 10
% montecito station is 7

close
figGD('on')

s1=subplot_tight(2,4,1,[0.08 0.05]);
hold on; grid on; box on
st=10; % refugio (upstream SYM)
for s=1:length(sims)
    simX=strcat(sims{s});
    p3c(s)=plot(NaN,NaN,...
        'color',cmap(s,:),'LineWidth',2,'LineStyle','-',...
        'MarkerSize',5);
    p1(s)=line(WRF.(simX).tnumPST(indStWest:indStWest+30),WRF.(simX).V4000(st,indStWest:indStWest+30),...
        'color',cmap(s,:),'LineWidth',2);
end
textA=text(WRF.(simX).tnumPST(indStWest+2),1,'(a)','FontWeight','bold');
Title1= text(WRF.(simX).tnumPST(indStWest+15),3,'Western regime - Refugio (upstream SYM)','FontWeight','bold');
textYlab=text(WRF.(simX).tnumPST(indStWest)-datenum(0,0,0,6,0,0),-30,...
    'V-component [m s^{-1}]','rotation',90);
leg=legend([p3c(:)],legStr{:});    set(leg,'Location','SouthWest')
ylabel('4000 MSL')
ax1=gca;
set(ax1,'YLim',[-20 2],...
    'XLim',[WRF.(simX).tnumPST(indStWest) WRF.(simX).tnumPST(indStWest+30)],'XTickLabel',{''})
datetick('x','dd/HH','keeplimits')




s2=subplot_tight(2,4,2,[0.08 0.05]);
hold on; grid on; box on
textB=text(WRF.(simX).tnumPST(indStWest+2),1,'(b)','FontWeight','bold');
for s=1:length(sims)
    simX=strcat(sims{s});
    p3c(s)=plot(NaN,NaN,...
        'color',cmap(s,:),'LineWidth',2,'LineStyle','-',...
        'MarkerSize',5);
    p1(s)=line(WRF.(simX).tnumPST(indStWest:indStWest+30),WRF.(simX).V1500(st,indStWest:indStWest+30),...
        'color',cmap(s,:),'LineWidth',2);
end
ylabel('1500 MSL')
ax1=gca;
set(ax1,'YLim',[-20 2],'YTickLabel',{''},...
    'XLim',[WRF.(simX).tnumPST(indStWest) WRF.(simX).tnumPST(indStWest+30)])
datetick('x','dd/HH','keeplimits')


st=7; % monteicto (upstream SYM)
s3=subplot_tight(2,4,3,[0.08 0.05]);
hold on; grid on; box on
textC=text(WRF.(simX).tnumPST(indStWest+2),1,'(c)','FontWeight','bold');
Title2= text(WRF.(simX).tnumPST(indStWest+15),3,'Western regime - Montecito (upstream SYM)','FontWeight','bold');
for s=1:length(sims)
    simX=strcat(sims{s});
    p3c(s)=plot(NaN,NaN,...
        'color',cmap(s,:),'LineWidth',2,'LineStyle','-',...
        'MarkerSize',5);
    p1(s)=line(WRF.(simX).tnumPST(indStWest:indStWest+30),WRF.(simX).V4000(st,indStWest:indStWest+30),...
        'color',cmap(s,:),'LineWidth',2);
end
% textXlab1=text(WRF.(simX).tnumPST(indStWest),-18,'Time in April 2018 [dd/HH]'); 
ylabel('4000 MSL')
ax1=gca;
set(ax1,'YLim',[-20 2],'YTickLabel',{''},...
    'XLim',[WRF.(simX).tnumPST(indStWest) WRF.(simX).tnumPST(indStWest+30)])
datetick('x','dd/HH','keeplimits')


s4=subplot_tight(2,4,4,[0.08 0.05]);
hold on; grid on; box on
textD=text(WRF.(simX).tnumPST(indStWest+2),1,'(d)','FontWeight','bold');
for s=1:length(sims)
    simX=strcat(sims{s});
    p3c(s)=plot(NaN,NaN,...
        'color',cmap(s,:),'LineWidth',2,'LineStyle','-',...
        'MarkerSize',5);
    p1(s)=line(WRF.(simX).tnumPST(indStWest:indStWest+30),WRF.(simX).V1500(st,indStWest:indStWest+30),...
        'color',cmap(s,:),'LineWidth',2);
end
ylabel('1500 MSL')
ax1=gca;
set(ax1,'YLim',[-20 2],'YTickLabel',{''},...
    'XLim',[WRF.(simX).tnumPST(indStWest) WRF.(simX).tnumPST(indStWest+30)])
datetick('x','dd/HH','keeplimits')



s5=subplot_tight(2,4,5,[0.08 0.05]);
hold on; grid on; box on
st=10; % refugio (upstream SYM)
textE=text(WRF.(simX).tnumPST(indStEast+2),3,'(e)','FontWeight','bold');
Title3= text(WRF.(simX).tnumPST(indStEast+15),5,' Eastern regime - Refugio (upstream SYM)','FontWeight','bold');
for s=1:length(sims)
    simX=strcat(sims{s});
    p3c(s)=plot(NaN,NaN,...
        'color',cmap(s,:),'LineWidth',2,'LineStyle','-',...
        'MarkerSize',5);
    p1(s)=line(WRF.(simX).tnumPST(indStEast:indStEast+30),WRF.(simX).V4000(st,indStEast:indStEast+30),...
        'color',cmap(s,:),'LineWidth',2);
end
ylabel('4000 MSL')
ax1=gca;
set(ax1,'YLim',[-16 4],...
    'XLim',[WRF.(simX).tnumPST(indStEast) WRF.(simX).tnumPST(indStEast+30)],'XTickLabel',{''})
datetick('x','dd/HH','keeplimits')


s6=subplot_tight(2,4,6,[0.08 0.05]);
hold on; grid on; box on
textF=text(WRF.(simX).tnumPST(indStEast+2),3,'(f)','FontWeight','bold');
for s=1:length(sims)
    simX=strcat(sims{s});
    p3c(s)=plot(NaN,NaN,...
        'color',cmap(s,:),'LineWidth',2,'LineStyle','-',...
        'MarkerSize',5);
    p1(s)=line(WRF.(simX).tnumPST(indStEast:indStEast+30),WRF.(simX).V1500(st,indStEast:indStEast+30),...
        'color',cmap(s,:),'LineWidth',2);
end
ylabel('1500 MSL')
ax1=gca;
set(ax1,'YLim',[-16 4],'YTickLabel',{''},...
    'XLim',[WRF.(simX).tnumPST(indStEast) WRF.(simX).tnumPST(indStEast+30)],'XTickLabel',{''})
datetick('x','dd/HH','keeplimits')


st=7; % monteicto (upstream SYM)
s7=subplot_tight(2,4,7,[0.08 0.05]);
hold on; grid on; box on
textG=text(WRF.(simX).tnumPST(indStEast+2),3,'(g)','FontWeight','bold');
Title4= text(WRF.(simX).tnumPST(indStEast+15),5,' Eastern regime - Montecito (upstream SYM)','FontWeight','bold');
for s=1:length(sims)
    simX=strcat(sims{s});
    p3c(s)=plot(NaN,NaN,...
        'color',cmap(s,:),'LineWidth',2,'LineStyle','-',...
        'MarkerSize',5);
    p1(s)=line(WRF.(simX).tnumPST(indStEast:indStEast+30),WRF.(simX).V4000(st,indStEast:indStEast+30),...
        'color',cmap(s,:),'LineWidth',2);
end
textXlab2=text(WRF.(simX).tnumPST(indStEast-15),-18.5,'Time in March 2017 [dd/HH]');   ylabel('4000 MSL')
ax1=gca;
set(ax1,'YLim',[-16 4],'YTickLabel',{''},...
    'XLim',[WRF.(simX).tnumPST(indStEast) WRF.(simX).tnumPST(indStEast+30)])
datetick('x','dd/HH','keeplimits')


s8=subplot_tight(2,4,8,[0.08 0.05]);
hold on; grid on; box on
texth=text(WRF.(simX).tnumPST(indStEast+2),3,'(h)','FontWeight','bold');
for s=1:length(sims)
    simX=strcat(sims{s});
    p3c(s)=plot(NaN,NaN,...
        'color',cmap(s,:),'LineWidth',2,'LineStyle','-',...
        'MarkerSize',5);
    p1(s)=line(WRF.(simX).tnumPST(indStEast:indStEast+30),WRF.(simX).V1500(st,indStEast:indStEast+30),...
        'color',cmap(s,:),'LineWidth',2);
end
ylabel('1500 MSL')
ax1=gca;
set(ax1,'YLim',[-16 4],'YTickLabel',{''},...
    'XLim',[WRF.(simX).tnumPST(indStEast(1)) WRF.(simX).tnumPST(indStEast+30)])
datetick('x','dd/HH','keeplimits')





set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14)

set(textYlab,'FontSize',18)
% set(textXlab1,'FontSize',18)
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


export_fig(strcat('FigS06'),'-png');
export_fig(strcat('FigS06'),'-pdf');





toc