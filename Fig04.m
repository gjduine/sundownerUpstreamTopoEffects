% script to plot figure 4 manuscript on influence of terrain
% modification on Sundowner wind diurnal variability

% Gert-Jan Duine, UCSB
% gertjan.duine@gmail.com; duine@eri.ucsb.edu

clear;clc;tic

WRF=load(strcat('/home/sbarc/wrf/wrf401/sundowners/swex-0/WRF_cxSects_sensSMOIS.mat'));

runs={'run_64452560_z0_1way'}%,'run_64452560_z0_SMOIS050','run_64452560_z0_SMOIS200'};
runX=runs;
runsTitle={'(a)','(b)','(c)','(d)','(e)','(f)'};
% THIS IS SELF-IMPLEMENTED, SO CHECK IT.
stations_cx={'KVBG','concepcion', 'Refugio', 'center lee slope', 'Montecito', 'carp', 'gap'};

times=[27,33]; % 12 and 18 PST          %31:35];%25:55];
%%

plotXLims=[34.4 34.62];
plotYLims=[0 2500];

% some plot definitions
obs_stations={'Refugio','center lee slope','Montecito'};
obs_lats=[34.517+0.002;34.486+0.005;34.461+0.007]; % added +.00x for plotting purposes
obs_elev=[414.3;524.6;548.2]; % model terrain elevation
colorLoc=[0 0 1;
            0.15 0.5 0.15
            1 0 0]; % blue, dark green, red

c=1;

close
fig=figGD('off');
for t=times % plotting 12 and 18 PST
    
for cx=[3,4,5]% loop through the 3 different cross sections of interest
% plotting can start.

    [c,cx,t]

for r=1:length(runs)
    runX=runs{r};
    
    ax3(c)=subplot_tight(2,3,c,[0.05 0.05]);
    box on; hold on
    line(WRF.(runX).lats(cx,:),WRF.(runX).HGT(cx,:),'LineWidth',2,'color','k')
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
        squeeze(WRF.(runX).thetaV(cx,:,:,t)),[280:1:320],'k','LineStyle','-','LineWidth',2,'ShowText','on');
    clabel(c2,m2,'FontSize',14)
    
    % PBL height
    l1=line(WRF.(runX).lats(cx,:),WRF.(runX).HGT(cx,:)+WRF.(runX).PBLH(cx,:,t),...
        'LineStyle','-','LineWidth',3,'color',' g');
    
    % marker for location. cx-2 because of separate cx and color definitions
    xlocation=line(obs_lats(cx-2),obs_elev(cx-2),'LineStyle','none','color',colorLoc(cx-2,:),...
        'Marker','^','LineWidth',3,'MarkerSize',10);
    
    % some annotations
    if (c==1)
        t1=text(34.52,180,'SYM');t2=text(34.58,70,'SYV');
        textR=text(34.4,-80,'R`');
        textRR=text(34.61,-80,'R``');
    elseif (c==4)
        textR=text(34.4,-280,'R`');
        textRR=text(34.61,-280,'R``');
    elseif (c==2)
        t1=text(34.50,180,'SYM');t2=text(34.54,90,'SYV');
        textK=text(34.4,-80,'C`');
        textKK=text(34.61,-80,'C``');
    elseif (c==5)
        textK=text(34.4,-280,'C`');
        textKK=text(34.61,-280,'C``');
    elseif (c==3)
        t1=text(34.48,180,'SYM');t2=text(34.54,120,'SYV');
        textM=text(34.4,-80,'M`');
        textMM=text(34.61,-80,'M``');
    elseif (c==6)
        textM=text(34.4,-280,'M`');
        textMM=text(34.61,-280,'M``');
    end
    
    
    % need to set it a second time.
    bwr=flipud(bluewhitered(30));
    colormap(ax3(c),bwr);
    caxis([-15 15])
    if (c==6)
        cbar=colorbar;
        set(cbar,'YLim',[-15 15])
        ylabel(cbar,'V-component [m s^{-1}]')
    end
    
    set(gca,'XLim',plotXLims,'YLim',plotYLims,'TickDir','out')
    
    title(strcat(runsTitle{c},{' '},stations_cx{cx},{' - '},...
        datestr(WRF.(runX).tnumPST(t),'yyyymmdd/HH:MM')))
    
    if (c==1) || (c==4)
        ylabel('Elevation [m]')
    else
        set(gca,'YTickLabels',{''})
    end
    if (c==4) || (c==5) || (c==6)
        xlabel('Latitude [^\circN]')
    end
    
    if c==1
        leg=legend([l1],{'PBLH'});
        set(leg,'Location','NorthEast','FontSize',12)
    end
    
    box on
end
c=c+1;
end


end
set(ax3(1),'XTickLabel',{''});  set(ax3(2),'XTickLabel',{''});  set(ax3(3),'XTickLabel',{''})

% reset subpanels
ax3(1).Position=[0.0500 0.5350 0.2667 0.4250];
ax3(2).Position=[0.3267 0.5350 0.2667 0.4250];
ax3(3).Position=[0.6033 0.5350 0.2667 0.4250];
ax3(4).Position=[0.0500 0.0750 0.2667 0.4250];
ax3(5).Position=[0.3267 0.0750 0.2667 0.4250];
ax3(6).Position=[0.6033 0.0750 0.2667 0.4250];
cbar.Position=[0.8849 0.3000 0.0112 0.4255];

set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)

set(t1,'FontSize',14)
set(t2,'FontSize',14)

figName=strcat('Fig04');
export_fig(figName,'-pdf')


toc


