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

runs={'orig','SRM075','SRM050','SRM030','SRM010'};
titleStr={'default','(a) 25% reduction','(b) 50% reduction','(c) 70% reduction','(d) 90% reduction'};


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
% station locations
stations_obs={'KBFL'   ,'KSMX'   ,'KSBA'   ,'RHWC1' ,'SBVC1','MTIC1'  ,'RHWC1-upv','MTIC1-upv','KSBA-slopes','KSBA-upv'};
lons_obs=[    -119.0567;-120.4521;-119.8436;-120.075;-119.706;-119.649;-120.076   ;-119.649   ;-119.8436    ;-119.8436];
lats_obs=[      35.4336;  34.8941;  34.4261;  34.517;  34.456;  34.461;  34.607   ;  34.527   ;  34.4860    ;  34.5500];




%%

colormap(flipud(pink))

for g=1
geoX=strcat('geo',num2str(g));

close
fig=figGD('on');
for d=4
    doX=strcat('d0',num2str(d));
    
    subplot_tight(1,1,1,[0.25 0.15])
    colormap(flipud(pink))

    p1=pcolor(squeeze(WRF.(geoX).(doX).Lons),squeeze(WRF.(geoX).(doX).Lats),squeeze(WRF.(geoX).(doX).HGT));
    hold on
    p2=contour(squeeze(WRF.(geoX).(doX).Lons),squeeze(WRF.(geoX).(doX).Lats),squeeze(WRF.(geoX).(doX).HGT),...
        [200:200:1600],'color','k','LineWidth',2);

    shading interp
    if g==1
        cb = colorbar;
        ylabel(cb,'Elevation above sea level (m)')
    end

    bordersGD('continental us','k','LineWidth',2)
    box on

    % divider between eastern and western SYM
    l1=line([-119.82 -119.82],[34.325 34.55],'LineWidth',5,'LineStyle','--','color','k');
    textSYMw=text(-120.0,34.35,'Western SYM','color','k','FontWeight','bold');
    x1=[0.420 0.320];   y1=[0.3 0.3];
        annotation('arrow',x1,y1,'LineWidth',3,'HeadWidth',15)
    
    % some annotations
    textSYMe=text(-119.8,34.35,'Eastern SYM','color','k','FontWeight','bold');
    x2=[0.445 0.545];   y2=[0.3 0.3];
        annotation('arrow',x2,y2,'LineWidth',3,'HeadWidth',15)

    set(gca,'CLim',[0 1250],'Layer','top')
    set(gca,'XLim',[-120.3 -119.2],'YLim',[34.3 34.65],...
        'XTick',[-120.2 -120.0 -119.8 -119.6 -119.4 -119.2],...
        'YTick',[34.3 34.4 34.5 34.6])
    text(-120.68,34.25,titleStr(g),'FontSize',16,...
        'BackGroundColor','w','EdgeColor','k');
    
    % cross section line fig. 4/5
    line([-120.075331 -120.075331],[34.4 34.62],'color','m','LineWidth',3)
    textR=text(-120.104,34.395,'R`','color','m','FontWeight','bold');
    textRR=text(-120.106,34.625,'R``','color','m','FontWeight','bold');

    line([-119.8436 -119.8436],[34.4 34.62],'color','m','LineWidth',3)
    textC=text(-119.870,34.395,'C`','color','m','FontWeight','bold');
    textCC=text(-119.864,34.62,'C``','color','m','FontWeight','bold');

    line([-119.649014 -119.649014],[34.4 34.62],'color','m','LineWidth',3)
    textM=text(-119.645,34.4,'M`','color','m','FontWeight','bold');
    textMM=text(-119.645,34.62,'M``','color','m','FontWeight','bold');

    % line along SY valley
    line([-120.3 -119.4],[34.64 34.48],'color','k','LineWidth',3);
    text3=text(-120.26,34.62,'Hovmoller SYV','rotation',-11,'FontWeight','bold');
    textA=text(-120.295,34.62,'A`','color','k','FontWeight','bold');
    textAA=text(-119.41,34.495,'A``','color','k','FontWeight','bold');
    
    % line along south slopes SYM
    line([-120.3   -120.075],[34.48 34.517],'color','k','LineWidth',3);
    line([-120.075 -119.4  ],[34.517 34.43],'color','k','LineWidth',3);
    text4a=text(-120.22,34.48,'Hovmoller','rotation',8,'FontWeight','bold');
    text4b=text(-120.22,34.46,'lee slopes','rotation',8,'FontWeight','bold');
    textB=text(-120.295,34.47,'B`','color','k','FontWeight','bold');
    textBB=text(-119.41,34.415,'B``','color','k','FontWeight','bold');
    
    
    
    % stations
    st=4; % refugio stations
    p1(st)=plot(lons_obs(st),lats_obs(st),'LineStyle','none','Marker','x','color','b','LineWidth',5,...
        'MarkerFaceColor','b','MarkerSize',20);
    text1=text(-120.06,34.51,'Refugio (R)','rotation',-20,'color','b','FontWeight','bold');
    
    st=6; % montecito station
    p2(st)=plot(lons_obs(st),lats_obs(st),'LineStyle','none','Marker','x','color','r','LineWidth',5,...
        'MarkerFaceColor','r','MarkerSize',20);
    text2=text(-119.63,34.45,'Montecito (M)','rotation',-20,'color','r','FontWeight','bold');
    
    cFG=[0.15 0.5 0.15];
    st=9; % KSBA slopes
    p3(st)=plot(lons_obs(st),lats_obs(st),'LineStyle','none','Marker','x','color',cFG,'LineWidth',5,...
        'MarkerFaceColor',cFG,'MarkerSize',20);    
    text3a=text(-119.83,34.475,'center lee','rotation',-20,'color',cFG,'FontWeight','bold');
    text3b=text(-119.81,34.445,'slope (C)','rotation',-20,'color',cFG,'FontWeight','bold');
    
%     st=5;
%     FG=[0.13 0.5 0.13];
%     p3(st)=plot(lons_obs(st),lats_obs(st),'LineStyle','none','Marker','x','color',FG,'LineWidth',5,...
%         'MarkerFaceColor',FG,'MarkerSize',20);
%     text3=text(-119.75,34.435,'SBVC1','rotation',0,'color',FG,'FontWeight','bold');
    
    st=7; % north of SYM for Refugio
    p4(st)=plot(lons_obs(st),lats_obs(st),'LineStyle','none','Marker','x','color','b','LineWidth',5,...
        'MarkerFaceColor','b','MarkerSize',20);
    text4=text(-120.06,34.615,'Refugio upvalley','rotation',10,'color','b','FontWeight','bold');
    
    st=8; % north of SYM for Montecito
    p2(st)=plot(lons_obs(st),lats_obs(st),'LineStyle','none','Marker','x','color','r','LineWidth',5,...
        'MarkerFaceColor','r','MarkerSize',20);
    text2a=text(-119.63,34.54,'Montecito upvalley','rotation',10,'color','r','FontWeight','bold');

%     st=10; % KSBA slpoes
%     p3(st)=plot(lons_obs(st),lats_obs(st),'LineStyle','none','Marker','x','color',cFG,'LineWidth',5,...
%         'MarkerFaceColor','g','MarkerSize',20);    
    
    % caxis([0 1600])
    xlabel('Longitude [^\circW]')
    ylabel('Latitude [^\circN]')
    % set(gca,'XTick',[],'YTick',[])
    % textB=text(-120.28,34.615,'(b)','FontWeight','bold');
    ti=title('(b) Santa Ynez Mountains');
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 18)
    set(text1,'FontSize',22)
    set(text2,'FontSize',22)
    set(ti,'FontSize',24)
end

export_fig(strcat('Fig01b'),'-pdf')

end

toc