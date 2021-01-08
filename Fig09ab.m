% script to read in and plot hysplit trajectory data for figure 9ab
% manuscript on influence of terrain modification on Sundowner wind diurnal 
% variability

% need to run the hysplit code

% Gert-Jan Duine, UCSB
% gertjan.duine@gmail.com; duine@eri.ucsb.edu


clear;clc;tic;

% read-in file
folder='/home/voyager-sbarc/hysplit/sundowners/sensSRM/SRM100/10m_back/';


dateSt=datenum(2017,3,26,22,0,0); % hours in UTC
dateEnd=datenum(2017,3,27,10,0,0);
Out = datevec(dateSt:6/24:dateEnd);
tnumHourly=datenum(Out); clear Out

numLocs=3; % number of trajectory locations in file,  only use two

fname='201703_SRM100_western_tdump_back_'; % file names
for f=1:length(tnumHourly)
    file=strcat(folder,fname,datestr(tnumHourly(f),'yyyymmddHHMM')); % other part of filenames
        
    fid=fopen(file);
    l1=fgetl(fid);  l2=fgetl(fid);  l3=fgetl(fid); % skip some lines
    clear('l1','l2','l3')
    
    % three different locations
    init1{f}=textscan(fid,'%f %f %f %f %f %f %f',1);% 18     4    28    15   34.451 -119.769    10.0
    init2{f}=textscan(fid,'%f %f %f %f %f %f %f',1);% 18     4    28    15   34.451 -119.769    10.0
    init3{f}=textscan(fid,'%f %f %f %f %f %f %f',1);% 18     4    28    15   34.451 -119.769    10.0
    
    l4=fgetl(fid);%clear('l4');
    l5=fgetl(fid);%clear('l5');
    % unk   unk  YY     MM   DD    HH     MM   simtime HHbackwards lat     lon         elev    pres
    % traj# 1    18     4    28    15     0    21      0.0         34.451 -119.769     10.0   1002.6
    data=textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %f %f');
    fclose(fid); clear(file);
    
    % some correction as years are only two digits.
    year=data{3};
    if year(1)>0
        year=year+2000;
    elseif year(1)<=99
        year=year+1900;
    end
    
    for tr=1:numLocs
        ind=find(data{1}==tr);
        
        yearSel=year(ind);
        mo=data{4}(ind);
        day=data{5}(ind);
        hour=data{6}(ind);
        min=data{7}(ind);
        tnumUTC{tr,f}=datenum(yearSel,mo,day,hour,min,0);
        tnumPDT{tr,f}=tnumUTC{tr,f}-datenum(0,0,0,8,0,0);
        
        simtime{tr,f}=data{8}(ind);
        traj_hour{tr,f}=data{9}(ind);
        traj_lat{tr,f}=data{10}(ind);
        traj_lon{tr,f}=data{11}(ind);
        traj_elev{tr,f}=data{12}(ind);
        traj_pressure{tr,f}=data{13}(ind);
        
        clear('ind')
    end
    clear('data')
    clear('yearSel','year','mo','day','hour','min')
end


%% plotting figure 9a

% base files from WRF
folder2='/home/sbarc/wrf/wrf401/WPS-4.0.1-duine/geo_em/orig/';
runpath = strcat(folder2,'/geo_em.d04.nc');
Lons = double(ncread(runpath,'XLONG_M')); WRF.Lons=squeeze(Lons(:,:,1));  clear('Lons')
Lats = double(ncread(runpath,'XLAT_M'));  WRF.Lats=squeeze(Lats(:,:,1));  clear('Lats')
HGT = double(ncread(runpath,'HGT_M'));    WRF.HGT=squeeze(HGT(:,:,1));    clear('HGT')
LU = double(ncread(runpath,'LU_INDEX'));WRF.LU=squeeze(LU(:,:,1));      clear('LU')


% station locations
stations_obs={'KBFL'   ,'KSMX'   ,'KSBA'   };
lons_obs=[    -119.0567;-120.4521;-119.8517];
lats_obs=[      35.4336;  34.8941;  34.4261];

% refugio colors
cmap2=[0 0 1;
        0 1 0;
        1 0 1]; % blue , green, magenta

% montecito color
cmap3=[1 0 0;       % red
        1 0.5 0;    % orange
        0 0   0];   % black

markers={'x','o','p'};

% for eastern regime we use locations 1 and 3 for refugio and montecito

    
    cmapsea=[1 1 1];
    close
    fig=figGD('off');
    sp=subplot_tight(1,1,1,[0.15 0.15]);
    colormap(flipud(pink))

    p1=pcolor(squeeze(WRF.Lons),squeeze(WRF.Lats),squeeze(WRF.HGT));
    bordersGD('continental us','k','LineWidth',2)

    hold on
    shading interp
    tr=1; % refugio
    for f=1:length(tnumHourly)
        if length(traj_lon{tr,f})>=7 % for the trajecotires that are longer than 7 hours
            legline(f)=plot(traj_lon{tr,f}(1:7),traj_lat{tr,f}(1:7),'LineWidth',3,'color',...
                cmap2(f,:),'LineStyle','-','Marker',markers{f},'MarkerSize',10);
        else
            legline(f)=plot(traj_lon{tr,f},traj_lat{tr,f},'LineWidth',3,'color',...
                cmap2(f,:),'LineStyle','-','Marker',markers{f},'MarkerSize',10);%
        end

        legStr2(f)=tnumPDT{tr,f}(1);
    end
    cb = colorbar;
    ylabel(cb,'Elevation above sea level (m)')
    
    %     xlabel('Longitude [deg W]')
    ylabel('Latitude [deg N]')

    box on;    grid on
    line(traj_lon{tr,1}(1),traj_lat{tr,1}(1),'LineStyle','none','Marker','x',...
        'color','b','MarkerSize',30,'LineWidth',5)
    text(-120.25,34.54,'Refugio','rotation',-20,'color','b')

    
    %
    tr=3; % montecito
    for f=1:length(tnumHourly)
        if length(traj_lon{tr,f})>=7 % for the trajecotires that are longer than 8 hours
            legline2(f)=plot(traj_lon{tr,f}(1:7),traj_lat{tr,f}(1:7),'LineWidth',3,'color',...
                cmap3(f,:),'LineStyle','-','Marker',markers{f},'MarkerSize',10);
        else
            legline2(f)=plot(traj_lon{tr,f},traj_lat{tr,f},'LineWidth',3,'color',...
                cmap3(f,:),'LineStyle','-','Marker',markers{f},'MarkerSize',10);%
        end

        legStr4(f)=tnumPDT{tr,f}(1); % string for legend
    end
    
    % airports
    for st=[1:3]
        p1(st)=plot(lons_obs(st),lats_obs(st),'LineStyle','none','Marker','o','color','k','LineWidth',1,...
            'MarkerFaceColor','k','MarkerSize',10);
    end
    KSMX=text(-120.58,34.93,'KSMX','FontSize',10);
    KBFL=text(-119.1,35.125,'KBFL','FontSize',10);
    KSBA=text(-119.97,34.385,'KSBA','FontSize',10);%,'rotation',20);
    annotation('arrow',[0.76 0.775],[0.79 0.84],'color','k','LineWidth',2)

    set(gca,'CLim',[0 2.0223e+03],'XLim',[-121 -118.8],'YLim',[34.2 35.2],...
        'YTick',[34.2 34.4 34.6 34.8 35.0 35.2],'Layer','top','XTickLabels',{''})
    line(traj_lon{tr,1}(1),traj_lat{tr,1}(1),'LineStyle','none','Marker','x',...
        'color','r','MarkerSize',30,'LineWidth',5)
    text(-119.6,34.46,'Montecito','rotation',15,'color','r')
    
    % the legends
    leg1=legend([legline(:)],{datestr(legStr2(:))}); hold on;
    set(leg1,'Location','SouthWest')
    grid off
    title('(a) Western regime')
    
    hold on
    a=axes('position',get(gca,'position'),'visible','off'); % TRICK to get second legend to work :)
    leg2=legend(a,[legline2(:)],{datestr(legStr4(:))}); hold on;
    set(leg2,'Location','SouthEast')
    
%     xlabel('Longitude [deg W]')
    ylabel('Latitude [deg N]')
    grid off

    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 20)
    set(leg1,'FontSize',16);    set(leg2,'FontSize',16)
    set(KSMX,'FontSize',16); set(KSBA,'FontSize',16); set(KBFL,'FontSize',16)

    figName=strcat('Fig09a');
    export_fig(figName,'-pdf')
    
    %% Figure 9b
     
    close
    fig=figGD('off');
    sp2=subplot_tight(1,1,1,[0.15 0.25]);
    hold on;
    for f=1:length(tnumHourly)
        tr=1; % refugio
        p2a(f)=plot(traj_hour{tr,f},traj_pressure{tr,f},'LineWidth',3,...
            'color',cmap2(f,:),'LineStyle','-','Marker',markers{f},'MarkerSize',10);
        legStr2a(f)=tnumPDT{tr,f}(1);
        
        tr=3; % montecito
        p3(f)=plot(traj_hour{tr,f},traj_pressure{tr,f},'LineWidth',3,...
            'color',cmap3(f,:),'LineStyle','-','Marker',markers{f},'MarkerSize',10);
        legStr3(f)=tnumPDT{tr,f}(1);
        
        hold on;
    end
    leg=legend([p2a(:)],{datestr(legStr2a(:))}); 
    set(leg,'Location','East')
   
    
    set(gca,'XLim',[-7 0],'YDir','reverse','XDir','reverse')
    
    ylabel('Pressure [hPa]')
    xlabel('Time before trajectory end [hours]')
    title('(b) Western regime')

    a=axes('position',get(gca,'position'),'visible','off'); % TRICK to get second legend to work :)
    leg2=legend(a,[p3(:)],{datestr(legStr3(:))}); hold on;
    set(leg2,'Position',[0.550 0.4599 0.1540 0.0684])
    set(leg,'Position',[0.550 0.3303 0.1540 0.0684])
   
%     title('Backward trajectories 12h - swex-0 case study 1way')

    set(findall(gcf, '-property', 'FontSize'), 'FontSize', 28)
    set(leg,'FontSize',24)
    set(leg2,'FontSize',24)
    
    figName=strcat('Fig09b');
    export_fig(figName,'-pdf')
    
    
    
%end

toc