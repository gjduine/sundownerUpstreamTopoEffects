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

cmapsea=[1 1 1];
% HGT_d01(HGT_d01<1)=20;
% HGT_d01(LU_INDEX_d01==17)=-100;
% demcmap(HGT_d01,100,cmapsea);

for g=1
geoX=strcat('geo',num2str(g));

close
fig=figGD('on'); % somehow on small screen the 'on' works better.
for d=4
    doX=strcat('d0',num2str(d));
    
    cmapsea=[1 1 1]; % turn sea white
%     WRF.(geoX).(doX).HGT(WRF.(geoX).(doX).HGT<25)=25; % replace 1 m to 20 m. 
    WRF.(geoX).(doX).HGT(WRF.(geoX).(doX).LU==17)=0;

    sp=subplot_tight(1,1,1,[0.15 0.33]);
%     colormap(flipud(pink))
    clevs=[1 200 400 800 1200 1600 2000];%2400]; % change this later
    demcmap(WRF.(geoX).(doX).HGT,100,cmapsea,[]);%,'deltaz',clevs);
%     demcmap('inc',WRF.(geoX).(doX).HGT,200,cmapsea,[]); % [] represents cmapland here

%     p1=pcolor(squeeze(WRF.(geoX).(doX).Lons),squeeze(WRF.(geoX).(doX).Lats),squeeze(WRF.(geoX).(doX).HGT));
    p1=contourf(squeeze(WRF.(geoX).(doX).Lons),squeeze(WRF.(geoX).(doX).Lats),squeeze(WRF.(geoX).(doX).HGT),...
        clevs);%,'color',[0.5 0.5 0.5]);
    shading interp
    cb = colorbar;
    set(cb,'TickDir','out','Ticks',clevs,'TickLabels',{'0','200','400','800','1200','1600','2000'})
    ylabel(cb,'Elevation above sea level (m)')%,'tickdir','outside')
    
    
    
    bordersGD('continental us','k','LineWidth',3)
    line([-120.5 -119.3],[34.65 34.65],'color','k','LineWidth',1,'color','k') % square for fig. 1b
    line([-120.5 -119.3],[34.3 34.3],'color','k','LineWidth',1,'color','k')
    line([-120.5 -120.5],[34.3 34.65],'color','k','LineWidth',1,'color','k')
    line([-119.3 -119.3],[34.3 34.65],'color','k','LineWidth',1,'color','k')
    
    % cross section line fig. 8ish
%     line([-119.8517 -119.8517],[34.3 34.8],'color','r','LineWidth',2) % KSBA
    line([-120.075 -120.075],[34.3 34.8],'color','r','LineWidth',2) % RHWC1
    line([-119.649 -119.649],[34.3 34.8],'color','r','LineWidth',2) % MTIC1
    
    
    
    
    box on
    set(gca,'CLim',[0 2.0223e+03],'Layer','top')
    set(gca,'XLim',[-120.7 -118.8],'YLim',[33.8 35.5],...
        'XTick',[-120.5 -120.0 -119.5 -119],...
        'YTick',[34.0 34.5 35.0 35.5])
    for st=[1:4,6]
        p1(st)=plot(lons_obs(st),lats_obs(st),'LineStyle','none','Marker','o','color','w','LineWidth',1,...
            'MarkerFaceColor','w','MarkerSize',5);
    end
%     xlabel('Longitude [deg W]')
    ylabel('Latitude [^\circN]')
    ti=title('(a) Study area');
    % set(gca,'XTick',[],'YTick',[])

    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)

%     % SYM arrows:
%     x1=[0.370 0.370];   y1=[0.33 0.435];annotation('arrow',x1,y1,'LineWidth',2)
%     x2=[0.570 0.570];   y2=[0.33 0.425];annotation('arrow',x2,y2,'LineWidth',2)

    
    % western regime arrow
    x1=[-120.65 -120.6 -120.5 -120.4 -120.3 -120.2 -120.1]; 
    y1=[34.85 34.84 34.82 34.79 34.75 34.7 34.63];
    p_west=plot(x1,y1,'color','w','LineWidth',2); % arrow line
    p_wArr_X=[-120.17 -120.1 -120.1]; 
    p_wArr_Y=[34.63 34.63 34.68];
    p_westArrow=plot(p_wArr_X,p_wArr_Y,'color','w','LineWidth',2); % arrow head
    textArrowWest1=text(-120.55,34.79,'Western','FontSize',14,'rotation',-20,'FontWeight','bold','color','w');
    textArrowWest2=text(-120.54,34.74,'regime','FontSize',14,'rotation',-20,'FontWeight','bold','color','w');
    
    % eastern regime arrow
    x2=[-119.35 -119.41 -119.46 -119.50 -119.53 -119.55 -119.56 -119.568 -119.573 -119.577 -119.580]; 
    y2=[35.25 35.2 35.15 35.1 35.05 35.0 34.95 34.90 34.85 34.8 34.75];
    p_east=plot(x2,y2,'color','w','LineWidth',2); % arrow line
    p_eArr_X=[-119.63 -119.58 -119.53];
    p_eArr_Y=[34.8 34.75 34.8];
    p_eastArrow=plot(p_eArr_X,p_eArr_Y,'color','w','LineWidth',2); % arrow head
    textArrowEast1=text(-119.5,35.0,'Eastern','FontSize',14,'rotation',20,'FontWeight','bold','color','w');
    textArrowEast2=text(-119.48,34.95,'regime','FontSize',14,'rotation',20,'FontWeight','bold','color','w');
    
    % some important annotations
%     SYM=text(-120.2,34.2,'Santa Ynez Mountains','FontSize',21);
%     SYMAb=text(-119.5,34.12,'(SYM)','FontSize',21);
    SRM=text(-119.88,34.68,'San Rafael Mts','FontSize',15,'FontWeight','bold','color','k');
%     SRMAb=text(-119.2,34.63,'(SRM)','FontSize',15);
    SYV=text(-120.1,34.6,'Santa Ynez Valley','FontSize',12,'rotation',-10,'FontWeight','bold','color','w');
    SJV=text(-119.5,35.45,'San Joaquin Valley','FontSize',10,'rotation',-40,'color','w');
    SM=text(-119.97,34.97,'Sierra Madre','FontSize',10,'rotation',-30);
    SE=text(-119.25,34.7,'San Emigdio','FontSize',10,'rotation',0);
    TT=text(-119.2,34.5,'Topa topa','FontSize',10,'rotation',0);
    PO=text(-120.6,33.85,'Pacific Ocean','FontSize',12);
    
    KSMX=text(-120.55,34.97,'Santa Maria airport','FontSize',10,'color','w');
    KSMX2=text(-120.5,34.935,'(KSMX - ASOS)','FontSize',10,'color','w');
    KBFL=text(-119.22,35.4,'Bakersfield airport','FontSize',10,'color','w');
    KBFL2=text(-119.15,35.365,'(KBFL - ASOS)','FontSize',10,'color','w');
    MTIC1=text(-119.64,34.44,'Montecito (RAWS)','FontSize',10,'color','w');
    RHWC1=text(-120.4,34.54,'Refugio (RAWS)','FontSize',10,'color','w');
    KSBA=text(-120.05,34.385,'Santa Barbara','FontSize',10);%,'rotation',20);
    KSBA2=text(-120.045,34.35,'airport (KSBA - ASOS)','FontSize',10);
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
set(cb,'Position',[0.6751 0.3099 0.0111 0.4003])
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
%     colormap(flipud(pink))
    demcmap(WRF.(geoX).(doX).HGT,100,cmapsea,[]); % [] represents cmapland
%     p1=pcolor(squeeze(WRF.(geoX).(doX).Lons),squeeze(WRF.(geoX).(doX).Lats),squeeze(WRF.(geoX).(doX).HGT));
    p1=contourf(squeeze(WRF.(geoX).(doX).Lons),squeeze(WRF.(geoX).(doX).Lats),squeeze(WRF.(geoX).(doX).HGT),...
        clevs);
    shading interp
    if g==1
        cb = colorbar;
        ylabel(cb,'Elevation above sea level (m)')
        set(gca,'Position',[0.1500 0.5750 0.2750 0.2750])
    elseif g==5
        cb = colorbar;
        ylabel(cb,'Elevation above sea level (m)')
        set(cb,'TickDir','out','Ticks',clevs,'TickLabels',{'0','200','400','800','1200','1600','2000'})
        set(cb,'Position',[0.4318 0.5754 0.0111 0.2747])
        
    end
    
    bordersGD('continental us','k','LineWidth',2)
    box on
    
    set(gca,'CLim',[0 2.0223e+03],'Layer','top')
    set(gca,'XLim',[-120.7 -118.8],'YLim',[34.2 35.1])
    text(-120.66,34.28,titleStr(g),'FontSize',16,...
        'BackGroundColor','w','EdgeColor','k');
    
   
    if (g==2)
        ylabel('Latitude [^\circN]')
%         xlabel('Longitude [^\circW]')
        set(gca,'XtickLabel',{''})

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