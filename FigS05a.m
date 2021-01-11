% script to plot supplemental figure 5a manuscript on influence of terrain
% modification on Sundowner wind diurnal variability

% Gert-Jan Duine, UCSB
% gertjan.duine@gmail.com; duine@eri.ucsb.edu


clear;clc;tic;


% load data with the percentiles of MSLP differences based on 30-yrs of
% simulations
load('/home/sbarc/students/duine/sundowners/clim/analysis/stats/30years/mslpDiffs_winds/percs_MSLPdiffs_30yrs.mat')


% surface data from the thee terrain simulations
sims={'SRM100'};%,'SRM075','SRM010'};
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


% criterion for upper ticks
xTicksTime=[datenum(2017,3,2):datenum(0,0,1):datenum(2017,3,31)];
xTicksStr={'  ','  ','  ','  ','  ',...
              'ER','  ','ER','  ','  ',...
              'ER','  ','  ','  ','  ',...
              '  ','  ','  ','  ','  ',...
              '  ','WR','WR','  ','WR',...
              'WR','WR','ER','ER','  '};

% daysWest=[22,23,25,26,27];    % article days western regime
% daysEast=[6,8,11,28,29];      % article days eastern regime
% daysOneCrit=[1:2,7,9:10,12,15:16,30]; % this is all not selected days that do meet a criterion but not both wspd and mslp
% daysSQ=[3:5,13:14,17:21,24];      % this is all days without criterion to be met


%% monthlong meteogram of winds

% put first half in upper figure, second half in lower figure
timeLims1=[WRF.tnumWRF_PST(1) WRF.tnumWRF_PST(end)];
% timeLims2=[WRF.tnumWRF_PST(372) WRF.tnumWRF_PST(end)];


cmap=[0 0 0; 0 0 1; 0.64 0.16 0.16]; % color scheme same to figure 6


% refugio: st=8
% montecito: st=5
% KSBA fthl: st=2

stKSBA=1;
stKSMX=15;
stKBFL=16;

close
fig=figGD('on');
sp=subplot_tight(2,1,1,[0.05 0.05]);
for s=1:length(sims)
    simX=sims{s};
    hold on; box on; grid on;
    l1a(s)=plot(WRF.tnumWRF_PST,(WRF.(simX).intp.mslp(stKSBA,:)-WRF.(simX).intp.mslp(stKSMX,:)),...
        'LineWidth',2,'color','b');
    l1b(s)=plot(WRF.tnumWRF_PST,(WRF.(simX).intp.mslp(stKSBA,:)-WRF.(simX).intp.mslp(stKBFL,:)),...
        'LineWidth',2,'color','r'); 
end

xlim(timeLims1);
ylims=[-8 6];%get(gca,'YLim');

% pc lines
% lpc1=line([tnumPST_PC1(indPc1St:indPc1End)-fourHrs tnumPST_PC1(indPc1St:indPc1End)-fourHrs],[ylims(1) ylims(2)],...
%     'LineStyle','--','LineWidth',2,'color','b');
% lpc2=line([tnumPST_PC2(indPc2St:indPc2End)-fourHrs tnumPST_PC2(indPc2St:indPc2End)-fourHrs],[ylims(1) ylims(2)],...
%     'LineStyle',':','LineWidth',2,'color','r');

% plot percentiles
p1=line([timeLims1(1) timeLims1(2)],[mslpDiffKSMXModelPercs(3) mslpDiffKSMXModelPercs(3)],...
    'color','b','LineStyle','--','LineWidth',2);
p2=line([timeLims1(1) timeLims1(2)],[mslpDiffKBFLModelPercs(3) mslpDiffKBFLModelPercs(3)],...
    'color','r','LineStyle','--','LineWidth',2);



ylabel('\Delta MSLP [hPa]')
datetick('x','dd','keeplimits')
Ti=title('(a)');

set(sp,'Position',[0.0500 0.4850 0.9000 0.4250])

ax1a=gca;
ax1b = axes('Position',get(ax1a,'Position'),'XAxisLocation', 'top',...
    'YAxisLocation','right','Color','none','XColor','k','YColor','k');
p4=line([timeLims1(1) timeLims1(2)],[mslpDiffKSMXModelPercs(3) mslpDiffKSMXModelPercs(3)],...
    'color','none','LineStyle','-','LineWidth',1,'Parent',ax1b); % a dummy line

for i=1:length(xTicksTime)
    p5=line([xTicksTime(i)-datenum(0,0,0,12,0,0) xTicksTime(i)-datenum(0,0,0,12,0,0)],[7 8],...
        'LineStyle',':','color','k','LineWidth',2);
end

set(ax1b,'XLim',[ax1a.XLim])
set(ax1b,'XTick',xTicksTime,'XTickLabel',xTicksStr,'YTick',[],'YTickLabel',{''})
set(ax1b,'YLim',[-4 8])
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)

% set(Ti,'Position',[7.3677e+05 7.2518 0])

% set(ax1b,'FontSize',12)
% plotting stuff
leg=legend([l1a(1) l1b(1)],{'KSBA - KSMX','KSBA - KBFL'},'Location','NorthWest');
set(leg,'Position',[0.0556 0.7928 0.0991 0.0651])


export_fig(strcat('FigS05a'),'-png')
export_fig(strcat('FigS05a'),'-pdf')

toc