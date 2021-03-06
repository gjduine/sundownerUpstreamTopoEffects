% script to plot figure 11 and S8 d/h of manuscript on influence of terrain
% modification on Sundowner wind diurnal variability

% Gert-Jan Duine, UCSB, November 2020
% gertjan.duine@gmail.com; duine@eri.ucsb.edu
% 

clear;clc;tic

% some constants
rd=287.05;
cp=1004;
rdcp=rd/cp; 
crit_rib=0.25;
clear('rd','cp')


load(strcat('/home/sbarc/duine/sundowners/sensSRM/201703/data/model/201703_vertProfs_sensSRM_moreLocs_SRMonly.mat'));
runs={'SRM100','SRM010'};
runsStr={'control','90% red.'};

runsTitle={'(d) control -','(h) 90% red. -'};
        
% small correction in the name for the title
WRF.obs_stations{7}='Montecito - upstream SYM';
WRF.obs_stations{10}='Refugio - upstream SYM';
WRF.obs_stations{5}='Montecito - lee slope';
WRF.obs_stations{8}='Refugio - lee slope';


%% plotting from here
%%%% some plotting constants. We plot 48 hours



regime={'western','eastern'};
regimeFileName={'Fig11','FigS08'};

for regX=1:2
caseSt=strcat(regime{regX},{' '},'regime');

% daysRegime=[22,23,25,26,27;     % western
%             6,8,11,28,29];      % eastern
daysRegime=[26;11];
% plot all days
days=daysRegime(regX,:);
% 
yr=2017;mo=3;

tnums=datenum(yr,mo,days,12,0,0);

for d=1:length(days)
    [~,indSt]=min(abs(tnums(d)-WRF.SRM100.tnumPST));
    indSt=indSt-6;
    indEnd=indSt+24;
    
    tnumSixHourly=[WRF.SRM100.tnumPST(indSt):datenum(0,0,0,6,0,0):WRF.SRM100.tnumPST(indEnd)];

    % 2,5,8 --> lee slope locations
    % 4,7,10 --> upstream location
    c=1;
    close
    
    % plot V component and plbh
    fig=figGD('off');
    
for st=[10]%[2,5,8] % loop over locations --> upvalley of KSBA, MTIC and RHWC1
    for r=1:length(runs)
        st
        runX=runs{r}
        
        
        maxAlt=4000; % pick this altitude slightly above max model altitude of interest
        yticks=[0:1000:maxAlt]/1000;
        yticksStr=num2str(yticks');
        indZ=find(WRF.(runX).z(1,:,4)<maxAlt,1,'last'); % find model height index
        tLength=(indEnd-indSt)+1; % needed to normalize time axis
        realAlt=WRF.(runX).z(1,indZ,4); %
        
        sizeTime=repmat(WRF.(runX).tnumPST(indSt:indEnd),[indZ 1]);
        % some modifications for the wind barbs which should be plotted hourly
        tLengthCoarse=(tLength);
        xNormCoarse=tLengthCoarse/24; % normalize time axis to a range of 0 to 2 (because we plot two days)
        timeArrayCoarse=linspace(0,xNormCoarse,tLengthCoarse);
        sizeTimeCoarse=repmat(timeArrayCoarse,[indZ 1]);
        

        
        % more predefitions for the plot, but these are location-dependent
        sizeHeight=repmat((WRF.(runX).z(st,1:indZ,tLength)'+WRF.(runX).hgt_st(st)),[1 tLength]);%/(maxAlt+WRF.(runX).hgt_st(st)),[1 tLength]); % for reference to mean-sea level
%         sizeHeightCoarse=repmat((WRF.(runX).z(st,1:indZ,tLengthCoarse)'+WRF.(runX).hgt_st(st))/(maxAlt+WRF.(runX).hgt_st(st)),[1 tLengthCoarse]); % for reference to mean-sea level
        %     sizeHeight=repmat(WRF.(runX).z(st,1:indZ,tLength)'/maxAlt,[1 tLength]); % for reference to ground level
        
        thetaPlot=squeeze(WRF.(runX).thetaV(st,1:indZ,indSt:indEnd));
        Vplot=squeeze(WRF.(runX).V(st,1:indZ,indSt:indEnd));
        BVplot=squeeze(WRF.(runX).BV(st,1:indZ,indSt:indEnd));
        riPlot=squeeze(WRF.(runX).riProf(st,1:indZ,indSt:indEnd));
        
        pblhPlot=squeeze((WRF.(runX).PBLH_st(st,indSt:indEnd)+WRF.(runX).hgt_st(st)));
%         ribPlot=squeeze((WRF.(runX).PBLH_riB_st(st,indSt:indEnd)+WRF.(runX).hgt_st(st)));
        
        % some constants for contour plotting
        thetaMin=floor(min(min(thetaPlot)));
        thetaMax=ceil(max(max(thetaPlot)));
        VMin=floor(min(min(Vplot)));
        VMax=ceil(max(max(Vplot)));
        
        ax1(c)=subplot_tight(2,2,c,[0.05 0.05]);
        
        clims3=[0 1];
        c1=contourf(sizeTime,sizeHeight,(real(BVplot)*WRF.(runX).zFroude_st(st))./abs(Vplot),...
            [clims3(1):0.5:clims3(2)],'edgecolor','none'); % first fill color
        hold on
        [c1,h]=contour(sizeTime,sizeHeight,(real(BVplot)*WRF.(runX).zFroude_st(st))./abs(Vplot),...
            [clims3(1):0.5:clims3(2)],'k','Linewidth',2,'ShowText','on');

        cmap3=flipud(othercolor('Accent4',30));
        colormap(ax1(c),cmap3);   caxis(clims3);   set(ax1(c),'CLim',clims3)

        
        if c==2
            cb=colorbar;
            set(cb,'YLim',[clims3],'TickDir','out')
            ylabel(cb,'NH/V [-]')
        end
                clabel(c1,h,'FontSize',16)

        
        % pblh
%         line(WRF.(runX).tnumPST(indSt:indEnd)',pblhPlot,'color','k','LineWidth',3)
        line([WRF.(runX).tnumPST(indSt) WRF.(runX).tnumPST(indSt+4)],...
            [WRF.(runX).zFroude_st(st)+WRF.(runX).hgt_st(st) WRF.(runX).zFroude_st(st)+WRF.(runX).hgt_st(st)],...
            'color','k','LineWidth',3,'LineStyle','--')

        
        
        % plot settings for all
        ylim([0 maxAlt])
        set(ax1(c),'box','on')
        title(strcat(runsTitle(c),{' '},WRF.obs_stations{st}))
            
        datetick('x','dd/HH','keeplimits')
        set(ax1(c),'XTick',tnumSixHourly,'YTick',[0:1000:maxAlt],'TickDir','out')
        % exceptions
        if (c==1)
            set(ax1(c),'XTick',tnumSixHourly,'XTickLabels',datestr(tnumSixHourly,'dd/HH'))
            xlabel('Time PST in March 2017 [dd/HH]')
        elseif c==2
            set(ax1(c),'XTick',tnumSixHourly(2:end),'XTickLabels',datestr(tnumSixHourly(2:end),'dd/HH'))
            xlabel('Time PST in March 2017 [dd/HH]')
        end            
        
        if (c==1) || (c==4); set(ax1(c),'YTickLabel',yticksStr)
        else; set(ax1(c),'YTickLabel',{''}); 
        end
        
        
        if (c==1) || (c==4);ylabel('Elevation msl [km]');end
        
%         clabel(c,h,'FontSize',20)
%         set(cb,'Position',[0.8851 0.2999 0.0111 0.4002])
        
        clear('clims')
        c=c+1;
    end
end

% reposition subpanels
ax1(1).Position=[0.0500 0.5250 0.2667 0.4250];
ax1(2).Position=[0.3267 0.5250 0.2667 0.4250];
% ax1(3).Position=[0.6033 0.5250 0.2667 0.4250];
% ax1(4).Position=[0.0500 0.0700 0.2667 0.4250];
% ax1(5).Position=[0.3267 0.0700 0.2667 0.4250];
% ax1(6).Position=[0.6033 0.0700 0.2667 0.4250];
cb.Position=[0.6033 0.5550 0.0112 0.35];

set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)

figName=strcat(regimeFileName{regX},'_gh');
export_fig(figName,'-png')
export_fig(figName,'-pdf')


close






end
end


toc