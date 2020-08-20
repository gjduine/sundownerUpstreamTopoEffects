% script to plot figures 1a and 2a-d of manuscript on influence of terrain
% modification on Sundowner wind diurnal variability

% Gert-Jan Duine, UCSB, April 2019
% gertjan.duine@gmail.com; duine@eri.ucsb.edu
% 
close all
clear;clc;tic

folder{1}='/home/sbarc/wrf/wrf401/WPS-4.0.1-duine/geo_em/orig/';
folder{2}='/home/sbarc/wrf/wrf401/WPS-4.0.1-duine/geo_em/SRM075/';
folder{3}='/home/sbarc/wrf/wrf401/WPS-4.0.1-duine/geo_em/SRM050/';
folder{4}='/home/sbarc/wrf/wrf401/WPS-4.0.1-duine/geo_em/SRM030/';
folder{5}='/home/sbarc/wrf/wrf401/WPS-4.0.1-duine/geo_em/SRM010/';

runs={'orig','SRM075','SRM050','SRM030','SRM010'}; % the runs we want to plot
titleStr={'default','(a) 25% reduction SRM','(b) 50% reduction SRM','(c) 70% reduction SRM','(d) 90% reduction SRM'}; % plot subtitlies


% Import surface and other data data

for g=1:5
    geoX=strcat('geo',num2str(g));
    runpath(1,:) = strcat(folder{g},'/geo_em.d01.nc');
    runpath(2,:) = strcat(folder{g},'/geo_em.d02.nc');
    runpath(3,:) = strcat(folder{g},'/geo_em.d03.nc');
    runpath(4,:) = strcat(folder{g},'/geo_em.d04.nc');
    
    for d = 4
        doX=strcat('d0',num2str(d));
        WRF.(geoX).(doX).Lons = double(ncread(runpath(d,:),'XLONG_M'));
        WRF.(geoX).(doX).Lats = double(ncread(runpath(d,:),'XLAT_M'));
        WRF.(geoX).(doX).HGT = double(ncread(runpath(d,:),'HGT_M'));
        WRF.(geoX).(doX).LU = double(ncread(runpath(d,:),'LU_INDEX'));
        
        % some constants of the domains
        WRF.(geoX).(doX).DX=ncreadatt(runpath(d,:),'/','DX')/1000;
        WRF.(geoX).(doX).DY=ncreadatt(runpath(d,:),'/','DY')/1000;
        WRF.(geoX).(doX).i_parentStart=ncreadatt(runpath(d,:),'/','i_parent_start');
        WRF.(geoX).(doX).j_parentStart=ncreadatt(runpath(d,:),'/','j_parent_start');
        WRF.(geoX).(doX).i_parentEnd=ncreadatt(runpath(d,:),'/','i_parent_end');
        WRF.(geoX).(doX).j_parentEnd=ncreadatt(runpath(d,:),'/','j_parent_end');
        WRF.(geoX).(doX).e_we=ncreadatt(runpath(d,:),'/','WEST-EAST_GRID_DIMENSION');
        WRF.(geoX).(doX).e_sn=ncreadatt(runpath(d,:),'/','SOUTH-NORTH_GRID_DIMENSION');
        
    end
    clear('d')
    clear('runpath','g')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotting stuff
% station locations of importance to the plots
stations_obs={'KBFL'   ,'KSMX'   ,'KSBA'   ,'RHWC1' ,'SBVC1','MTIC1' };
lons_obs=[    -119.0567;-120.4521;-119.8517;-120.075;-119.706;-119.649];
lats_obs=[      35.4336;  34.8941;  34.4261;  34.517;  34.456;  34.461];

% NOTE THAT HERE KSBA LONGITUDE IS THE WIND PROFILER LOCATION (more or less)



%% start plotting figure 1a
for g=1
geoX=strcat('geo',num2str(g));

close
fig=figGD('on'); % somehow on small screen the 'on' works better.
for d=4
    doX=strcat('d0',num2str(d));
    
    cmapsea=[1 1 1];
    sp=subplot_tight(1,1,1,[0.15 0.33]);
    colormap(flipud(pink))
    p1=pcolor(squeeze(WRF.(geoX).(doX).Lons),squeeze(WRF.(geoX).(doX).Lats),squeeze(WRF.(geoX).(doX).HGT));
    shading interp
    cb = colorbar;
    ylabel(cb,'Elevation above sea level (m)')
    bordersGD('continental us','k','LineWidth',2)
    line([-120.3 -119.2],[34.65 34.65],'color','k','LineWidth',1,'color','k') % square for fig. 1b
    line([-120.3 -119.2],[34.3 34.3],'color','k','LineWidth',1,'color','k')
    line([-120.3 -120.3],[34.3 34.65],'color','k','LineWidth',1,'color','k')
    line([-119.2 -119.2],[34.3 34.65],'color','k','LineWidth',1,'color','k')
    
    % cross section line fig. 8ish
%     line([-119.8517 -119.8517],[34.3 34.8],'color','r','LineWidth',2) % KSBA
    line([-120.075 -120.075],[34.3 34.8],'color','r','LineWidth',2) % RHWC1
    line([-119.649 -119.649],[34.3 34.8],'color','r','LineWidth',2) % MTIC1
    
    
    box on
    set(gca,'CLim',[0 2.0223e+03],'Layer','top')
    set(gca,'XLim',[-120.7 -118.8],'YLim',[33.8 35.5],...
        'XTick',[-120.5 -120.0 -119.5 -119],...
        'YTick',[34.0 34.5 35.0 35.5])
    x1=[0.410 0.410];   y1=[0.33 0.435];annotation('arrow',x1,y1)
    x2=[0.552 0.552];   y2=[0.33 0.425];annotation('arrow',x2,y2)
    for st=[1:4,6]
        p1(st)=plot(lons_obs(st),lats_obs(st),'LineStyle','none','Marker','o','color','k','LineWidth',1,...
            'MarkerFaceColor','k','MarkerSize',5);
    end
%     xlabel('Longitude [deg W]')
    ylabel('Latitude [^\circN]')
    ti=title('(a) Study area');
    % set(gca,'XTick',[],'YTick',[])

    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)

    % western regime arrow
    x1=[-120.65 -120.6 -120.5 -120.4 -120.3 -120.2 -120.1]; 
    y1=[34.85 34.84 34.82 34.79 34.75 34.7 34.63];
    p_west=plot(x1,y1,'color','k','LineWidth',2); % arrow line
    p_wArr_X=[-120.17 -120.1 -120.1]; 
    p_wArr_Y=[34.63 34.63 34.68];
    p_westArrow=plot(p_wArr_X,p_wArr_Y,'color','k','LineWidth',2); % arrow head
    textArrowWest1=text(-120.55,34.79,'Western','FontSize',14,'rotation',-20);
    textArrowWest2=text(-120.54,34.74,'regime','FontSize',14,'rotation',-20);
    
    % eastern regime arrow
    x2=[-119.35 -119.41 -119.46 -119.50 -119.53 -119.55 -119.56 -119.568 -119.573 -119.577 -119.580]; 
    y2=[35.25 35.2 35.15 35.1 35.05 35.0 34.95 34.90 34.85 34.8 34.75];
    p_east=plot(x2,y2,'color','k','LineWidth',2); % arrow line
    p_eArr_X=[-119.63 -119.58 -119.53];
    p_eArr_Y=[34.8 34.75 34.8];
    p_eastArrow=plot(p_eArr_X,p_eArr_Y,'color','k','LineWidth',2); % arrow head
    textArrowEast1=text(-119.5,35.0,'Eastern','FontSize',14,'rotation',20);
    textArrowEast2=text(-119.48,34.95,'regime','FontSize',14,'rotation',20);
    
    % some important annotations
    SYM=text(-120.2,34.2,'Santa Ynez Mountains','FontSize',21);
    SYMAb=text(-119.5,34.12,'(SYM)','FontSize',21);
    SRM=text(-119.7,34.7,'San Rafael Mts','FontSize',20);
    SRMAb=text(-119.2,34.63,'(SRM)','FontSize',20);
    SYV=text(-120.1,34.6,'Santa Ynez Valley (SYV)','FontSize',12,'rotation',-10);
    SJV=text(-119.5,35.45,'San Joaquin Valley','FontSize',10,'rotation',-40);
    CV=text(-119.9,35.0,'Cuyama Valley','FontSize',10,'rotation',-20);
    CP=text(-119.9,35.25,'Carrizo Plains','FontSize',10,'rotation',-40);
    
    KSMX=text(-120.55,34.97,'Santa Maria airport','FontSize',10);
    KSMX2=text(-120.5,34.935,'(KSMX)','FontSize',10);
    KBFL=text(-119.22,35.4,'Bakersfield airport','FontSize',10);
    KBFL2=text(-119.1,35.365,'(KBFL)','FontSize',10);
    MTIC1=text(-119.63,34.45,'Montecito','FontSize',10);
    RHWC1=text(-120.24,34.54,'Refugio','FontSize',10);
    KSBA=text(-120.05,34.385,'Santa Barbara','FontSize',10);%,'rotation',20);
    KSBA2=text(-120.045,34.35,'airport (KSBA)','FontSize',10);
%     textA=text(-120.7,35.55,'(a)','FontSize',18,'FontWeight','bold');
    set(ti,'FontSize',18)
end

% inset map
sp2=subplot_tight(4,4,1,[0.05 0.13]);
bordersGD('continental us','k','LineWidth',2)
box on
xlim([-124.5 -113.8])
ylim([32.2 42.2])
set(gca,'XTickLabel',{''},'YTickLabel',{''})
% red box
lred=line([-120.7 -120.7],[33.8 35.5],'LineWidth',2,'color','r');
lred=line([-118.8 -118.8],[33.8 35.5],'LineWidth',2,'color','r');
lred=line([-120.7 -118.8],[33.8 33.8],'LineWidth',2,'color','r');
lred=line([-120.7 -118.8],[35.5 35.5],'LineWidth',2,'color','r');

set(sp2,'Position',[0.2900 0.6925 0.0875 0.1875]) % half inside the box
%set(sp2,'Position',[0.3325 0.6600 0.0875 0.1875]) % inside the box

export_fig(strcat('Fig01a'),'-pdf')
end




%% Figure 2a-d to show terrein modificatoin

d=4;
doX=strcat('d0',num2str(d));
runsFile={'','a','b','c','d'}; % for subtitle panels
for g=2:5
    geoX=strcat('geo',num2str(g));
    
    close
    fig=figGD('off');
    sp=subplot_tight(2,2,1,[0.15 0.15]);
    colormap(flipud(pink))
    
    p1=pcolor(squeeze(WRF.(geoX).(doX).Lons),squeeze(WRF.(geoX).(doX).Lats),squeeze(WRF.(geoX).(doX).HGT));
    shading interp
    if g==1
        cb = colorbar;
        ylabel(cb,'Elevation above sea level (m)')
        set(gca,'Position',[0.1500 0.5750 0.2750 0.2750])
    elseif g==5
        cb = colorbar;
        ylabel(cb,'Elevation above sea level (m)')
        
    end
    
    bordersGD('continental us','k','LineWidth',2)
    box on
    %     grid on
    
    set(gca,'CLim',[0 2.0223e+03],'Layer','top')
    set(gca,'XLim',[-120.7 -118.8],'YLim',[34.2 35.1])
    text(-120.66,34.28,titleStr(g),'FontSize',16,...
        'BackGroundColor','w','EdgeColor','k');
    
    % caxis([0 1600])
    
    if (g==2)
        ylabel('Latitude [^\circN]')
        set(gca,'XTickLabel',{''})
    elseif (g==3)
        set(gca,'XtickLabel',{''})
        set(gca,'YtickLabel',{''})
    elseif (g==4) % has to be separate
        xlabel('Longitude [^\circW]')
        ylabel('Latitude [^\circN]')
    elseif (g==5)
        xlabel('Longitude [^\circW]')
        set(gca,'YtickLabel',{''})
    end
    
    % set(gca,'XTick',[],'YTick',[])
    set(gca,'Position',[0.1500 0.5750 0.2750 0.2750])
    
    % set(findall(gcf, '-property', 'FontSize'), 'FontSize', 18)
    
    export_fig(strcat('Fig02',runsFile{g}),'-pdf')
    
end






toc