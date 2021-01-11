% script to plot supplemental figures 1a/b of manuscript on influence of terrain
% modification on Sundowner wind diurnal variability

% Gert-Jan Duine, UCSB, November 2020
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
titleStr={'control','(a) 25% reduction SRM','(b) 50% reduction SRM','(c) 70% reduction SRM','(b) 90% reduction SRM'}; % plot subtitlies


% Import surface and other data data

for g=1
    geoX=strcat('geo',num2str(g));
    runpath(1,:) = strcat(folder{g},'/geo_em.d01.nc');
    runpath(2,:) = strcat(folder{g},'/geo_em.d02.nc');
    runpath(3,:) = strcat(folder{g},'/geo_em.d03.nc');
    runpath(4,:) = strcat(folder{g},'/geo_em.d04.nc');
    
    for d = 1:4
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

stop

%% start plotting figure 1a

cmapsea=[1 1 1];
% HGT_d01(HGT_d01<1)=20;
% HGT_d01(LU_INDEX_d01==17)=-100;
% demcmap(HGT_d01,100,cmapsea);

for g=1
geoX=strcat('geo',num2str(g));

close
fig=figGD('on'); % somehow on small screen the 'on' works better.
for d=1
    doX=strcat('d0',num2str(d));
    
    cmapsea=[1 1 1]; % turn sea white
    WRF.(geoX).(doX).HGT(WRF.(geoX).(doX).LU==17)=0;

    sp=subplot_tight(1,1,1,[0.18 0.33]);
    clevs=[1 200 400 800 1200 1600 2000];%2400]; % change this later
    demcmap(WRF.(geoX).(doX).HGT,100,cmapsea,[]);%,'deltaz',clevs);

    p1=pcolor(squeeze(WRF.(geoX).(doX).Lons),squeeze(WRF.(geoX).(doX).Lats),squeeze(WRF.(geoX).(doX).HGT));%,'color',[0.5 0.5 0.5]);
    shading interp
    cb = colorbar;
%     set(cb,'TickDir','out','Ticks',clevs,'TickLabels',{'0','200','400','800','1200','1600','2000'})
    ylabel(cb,'Elevation above sea level (m)')%,'tickdir','outside')
    
    
    box on
    bordersGD('continental us','k','LineWidth',3)
    bordersGD('countries','k','LineWidth',3)
    LineWidth=2;
    
    title('(a)')
    % domain 1 extents
    line(WRF.(geoX).d01.Lons(1:end,1),WRF.(geoX).d01.Lats(1:end,1),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d01.Lons(1,1:end),WRF.(geoX).d01.Lats(1,1:end),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d01.Lons(1:end,end),WRF.(geoX).d01.Lats(1:end,end),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d01.Lons(end,1:end),WRF.(geoX).d01.Lats(end,1:end),'color','k','LineWidth',LineWidth)

    
    % domain 2 extents
    line(WRF.(geoX).d02.Lons(1:end,1),WRF.(geoX).d02.Lats(1:end,1),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d02.Lons(1,1:end),WRF.(geoX).d02.Lats(1,1:end),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d02.Lons(1:end,end),WRF.(geoX).d02.Lats(1:end,end),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d02.Lons(end,1:end),WRF.(geoX).d02.Lats(end,1:end),'color','k','LineWidth',LineWidth)

    % domain 3 extents
    line(WRF.(geoX).d03.Lons(1:end,1),WRF.(geoX).d03.Lats(1:end,1),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d03.Lons(1,1:end),WRF.(geoX).d03.Lats(1,1:end),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d03.Lons(1:end,end),WRF.(geoX).d03.Lats(1:end,end),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d03.Lons(end,1:end),WRF.(geoX).d03.Lats(end,1:end),'color','k','LineWidth',LineWidth)
    
    % domain 4 extents
    line(WRF.(geoX).d04.Lons(1:end,1),WRF.(geoX).d04.Lats(1:end,1),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d04.Lons(1,1:end),WRF.(geoX).d04.Lats(1,1:end),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d04.Lons(1:end,end),WRF.(geoX).d04.Lats(1:end,end),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d04.Lons(end,1:end),WRF.(geoX).d04.Lats(end,1:end),'color','k','LineWidth',LineWidth)
    
    
    
    box on
%     set(gca,'CLim',[0 2.0223e+03],'Layer','top')
%     set(gca,'XLim',[-120.7 -118.8],'YLim',[33.8 35.5],...
%         'XTick',[-120.5 -120.0 -119.5 -119],...
%         'YTick',[34.0 34.5 35.0 35.5])
 
    xlabel('Longitude [^\circW]')
    ylabel('Latitude [^\circN]')
    set(gca,'tickdir','out')
    title('(a)')
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)

 
end


% set(cb,'Position',[0.6751 0.3099 0.0111 0.4003])
end


export_fig(strcat('FigS01a'),'-pdf')



%% domain 3


cmapsea=[1 1 1];
% HGT_d01(HGT_d01<1)=20;
% HGT_d01(LU_INDEX_d01==17)=-100;
% demcmap(HGT_d01,100,cmapsea);

for g=1
geoX=strcat('geo',num2str(g));

close
fig=figGD('on'); % somehow on small screen the 'on' works better.
for d=3
    doX=strcat('d0',num2str(d));
    
    cmapsea=[1 1 1]; % turn sea white
    WRF.(geoX).(doX).HGT(WRF.(geoX).(doX).LU==17)=0;

    sp=subplot_tight(1,1,1,[0.18 0.33]);
    clevs=[1 200 400 800 1200 1600 2000];%2400]; % change this later
    demcmap(WRF.(geoX).(doX).HGT,100,cmapsea,[]);%,'deltaz',clevs);

    p1=pcolor(squeeze(WRF.(geoX).(doX).Lons),squeeze(WRF.(geoX).(doX).Lats),squeeze(WRF.(geoX).(doX).HGT));%,'color',[0.5 0.5 0.5]);
    shading interp
    cb = colorbar;
%     set(cb,'TickDir','out','Ticks',clevs,'TickLabels',{'0','200','400','800','1200','1600','2000'})
    ylabel(cb,'Elevation above sea level (m)')%,'tickdir','outside')
    
    
    box on
    bordersGD('continental us','k','LineWidth',3)
    bordersGD('countries','k','LineWidth',3)
    LineWidth=2;
    
    title('(b)')

    

    % domain 3 extents
    line(WRF.(geoX).d03.Lons(1:end,1),WRF.(geoX).d03.Lats(1:end,1),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d03.Lons(1,1:end),WRF.(geoX).d03.Lats(1,1:end),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d03.Lons(1:end,end),WRF.(geoX).d03.Lats(1:end,end),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d03.Lons(end,1:end),WRF.(geoX).d03.Lats(end,1:end),'color','k','LineWidth',LineWidth)
    
    % domain 4 extents
    line(WRF.(geoX).d04.Lons(1:end,1),WRF.(geoX).d04.Lats(1:end,1),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d04.Lons(1,1:end),WRF.(geoX).d04.Lats(1,1:end),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d04.Lons(1:end,end),WRF.(geoX).d04.Lats(1:end,end),'color','k','LineWidth',LineWidth)
    line(WRF.(geoX).d04.Lons(end,1:end),WRF.(geoX).d04.Lats(end,1:end),'color','k','LineWidth',LineWidth)
    
    
    
    box on
%     set(gca,'CLim',[0 2.0223e+03],'Layer','top')
%     set(gca,'XLim',[-120.7 -118.8],'YLim',[33.8 35.5],...
%         'XTick',[-120.5 -120.0 -119.5 -119],...
%         'YTick',[34.0 34.5 35.0 35.5])
 
    xlabel('Longitude [^\circW]')
    ylabel('Latitude [^\circN]')
    set(gca,'tickdir','out')

    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)

 
end


% set(cb,'Position',[0.6751 0.3099 0.0111 0.4003])
end


export_fig(strcat('FigS01b'),'-pdf')





toc