% script to change terrain elevation in nc-file to reduce San Rafael
% Mountains with 90%

% Gert-Jan Duine, UCSB, April 2019
% gertjan.duine@gmail.com
% 
close all
clear
clc
tic

folder=cd;


runpath(1,:) = strcat(folder,'/geo_em.d01toChange.nc');
runpath(2,:) = strcat(folder,'/geo_em.d02toChange.nc');
runpath(3,:) = strcat(folder,'/geo_em.d03toChange.nc');
runpath(4,:) = strcat(folder,'/geo_em.d04toChange.nc');

%% Import surface and other data data

for d = 1:4
    doX=strcat('d0',num2str(d));
    WRF.(doX).Lons = double(ncread(runpath(d,:),'XLONG_M'));
    WRF.(doX).Lats = double(ncread(runpath(d,:),'XLAT_M'));
    WRF.(doX).HGT = double(ncread(runpath(d,:),'HGT_M'));
    WRF.(doX).LU = double(ncread(runpath(d,:),'LU_INDEX'));
    
    % some constants of the domains
    WRF.(doX).DX=ncreadatt(runpath(d,:),'/','DX')/1000;
    WRF.(doX).DY=ncreadatt(runpath(d,:),'/','DY')/1000;
    WRF.(doX).i_parentStart=ncreadatt(runpath(d,:),'/','i_parent_start');
    WRF.(doX).j_parentStart=ncreadatt(runpath(d,:),'/','j_parent_start');
    WRF.(doX).i_parentEnd=ncreadatt(runpath(d,:),'/','i_parent_end');
    WRF.(doX).j_parentEnd=ncreadatt(runpath(d,:),'/','j_parent_end');
    WRF.(doX).e_we=ncreadatt(runpath(d,:),'/','WEST-EAST_GRID_DIMENSION');
    WRF.(doX).e_sn=ncreadatt(runpath(d,:),'/','SOUTH-NORTH_GRID_DIMENSION');
    
end
clear('d')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% definition of boxes for terrain modification %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% box 1: corners of area to change terrain elevation: valley approach
locations_box1={'lower left','lower right','upper left','upper right'};
lons_obs_box1=[-120.64 -120.2 -120.64 -120.2];
lats_obs_box1=[34.57 34.57 34.8 34.8];%35.5027 35.5027];
% extract the closest grid points.
for d=1:4
    doX=strcat('d0',num2str(d));
    for st=1:length(lons_obs_box1)
        sz = size(WRF.(doX).Lons);
        distances = zeros(sz);
        for i = 1:sz(1)
            for j = 1:sz(2)
                % WRF
                curLon = WRF.(doX).Lons(i, j);
                curLat = WRF.(doX).Lats(i, j);
                dist = m_lldistance([lons_obs_box1(st), curLon], [lats_obs_box1(st), curLat]); clear curLon curLat
                distances(i,j) = dist; clear dist
            end
        end
        minDist= min(distances(:));
        [WRF.(doX).lons_gc_box1(st), WRF.(doX).lats_gc_box1(st)] = find(distances == minDist);
        
        clear minDist distances
        %     clear lat1 lon1
    end
    clear sz
end
toc


% box 2: corners of area to change terrain elevation. Gaussian filtering
locations_box2={'lower left','lower right','upper left','upper right'};
lons_obs_box2=[-120.2 -119.84 -120.2 -119.84];
lats_obs_box2=[34.48 34.48 34.8 34.8];%35.5027 35.5027];
% extract the closest grid points.
for d=1:4
    doX=strcat('d0',num2str(d));
    for st=1:length(lons_obs_box2)
        sz = size(WRF.(doX).Lons);
        distances = zeros(sz);
        for i = 1:sz(1)
            for j = 1:sz(2)
                % WRF
                curLon = WRF.(doX).Lons(i, j);
                curLat = WRF.(doX).Lats(i, j);
                dist = m_lldistance([lons_obs_box2(st), curLon], [lats_obs_box2(st), curLat]); clear curLon curLat
                distances(i,j) = dist; clear dist
            end
        end
        minDist= min(distances(:));
        [WRF.(doX).lons_gc_box2(st), WRF.(doX).lats_gc_box2(st)] = find(distances == minDist);
        if (st==1 || st==3)
            WRF.(doX).lons_gc_box2(st)=WRF.(doX).lons_gc_box1(st+1)+1;
        end

        clear minDist distances
        %     clear lat1 lon1
    end
    clear sz
end
toc



% box 3: corners of area to change terrain elevation. Gaussian filtering
locations_box3={'lower left','lower right','upper left','upper right'};
lons_obs_box3=[-119.84 -119.31 -119.84 -119.31];
lats_obs_box3=[34.48 34.48 34.8 34.8];%35.5027 35.5027];
% extract the closest grid points.
for d=1:4
    doX=strcat('d0',num2str(d));
    for st=1:length(lons_obs_box3)
        sz = size(WRF.(doX).Lons);
        distances = zeros(sz);
        for i = 1:sz(1)
            for j = 1:sz(2)
                % WRF
                curLon = WRF.(doX).Lons(i, j);
                curLat = WRF.(doX).Lats(i, j);
                dist = m_lldistance([lons_obs_box3(st), curLon], [lats_obs_box3(st), curLat]); clear curLon curLat
                distances(i,j) = dist; clear dist
            end
        end
        minDist= min(distances(:));
        [WRF.(doX).lons_gc_box3(st), WRF.(doX).lats_gc_box3(st)] = find(distances == minDist);
        
        if (st==1 || st==3)
            WRF.(doX).lons_gc_box3(st)=WRF.(doX).lons_gc_box2(st+1)+1;
        end

        clear minDist distances
        %     clear lat1 lon1
    end
    clear sz
end
toc


% box 4: corners of area to change terrain elevation. Gaussian filtering
locations_box4={'lower left','lower right','upper left','upper right'};
lons_obs_box4=[-119.31 -119.28 -119.31 -119.28];
lats_obs_box4=[34.48 34.48 34.8 34.8];%35.5027 35.5027];
% extract the closest grid points.
for d=1:4
    doX=strcat('d0',num2str(d));
    for st=1:length(lons_obs_box4)
        sz = size(WRF.(doX).Lons);
        distances = zeros(sz);
        for i = 1:sz(1)
            for j = 1:sz(2)
                % WRF
                curLon = WRF.(doX).Lons(i, j);
                curLat = WRF.(doX).Lats(i, j);
                dist = m_lldistance([lons_obs_box4(st), curLon], [lats_obs_box4(st), curLat]); clear curLon curLat
                distances(i,j) = dist; clear dist
            end
        end
        minDist= min(distances(:));
        [WRF.(doX).lons_gc_box4(st), WRF.(doX).lats_gc_box4(st)] = find(distances == minDist);
        
        if (st==1 || st==3)
            WRF.(doX).lons_gc_box4(st)=WRF.(doX).lons_gc_box3(st+1)+1;
        end

        
        clear minDist distances
        %     clear lat1 lon1
    end
    clear sz
end
toc



% box 5: corners of area to change terrain elevation. Gaussian filtering
locations_box5={'lower left','lower right','upper left','upper right'};
lons_obs_box5=[-119.28 -118.3 -119.28 -118.3];
lats_obs_box5=[34.48 34.48 34.8 34.8];%35.5027 35.5027];
% extract the closest grid points.
for d=1:4
    doX=strcat('d0',num2str(d));
    for st=1:length(lons_obs_box5)
        sz = size(WRF.(doX).Lons);
        distances = zeros(sz);
        for i = 1:sz(1)
            for j = 1:sz(2)
                % WRF
                curLon = WRF.(doX).Lons(i, j);
                curLat = WRF.(doX).Lats(i, j);
                dist = m_lldistance([lons_obs_box5(st), curLon], [lats_obs_box5(st), curLat]); clear curLon curLat
                distances(i,j) = dist; clear dist
            end
        end
        minDist= min(distances(:));
        [WRF.(doX).lons_gc_box5(st), WRF.(doX).lats_gc_box5(st)] = find(distances == minDist);
        
        if (st==1 || st==3)
            WRF.(doX).lons_gc_box5(st)=WRF.(doX).lons_gc_box4(st+1)+1;
        end

        
        clear minDist distances
        %     clear lat1 lon1
    end
    clear sz
end
toc



% the northern box 1
locations_boxNo1={'lower left','lower right','upper left','upper right'};
lons_obs_boxNo1=[-121 -118.3 -121 -118.3];%-118.5845
lats_obs_boxNo1=[34.8 34.8 35.52 35.52];%35.5027 35.5027];
% extract the closest grid points.
for d=1:4
    doX=strcat('d0',num2str(d));
    for st=1:length(lons_obs_boxNo1)
        sz = size(WRF.(doX).Lons);
        distances = zeros(sz);
        for i = 1:sz(1)
            for j = 1:sz(2)
                % WRF
                curLon = WRF.(doX).Lons(i, j);
                curLat = WRF.(doX).Lats(i, j);
                dist = m_lldistance([lons_obs_boxNo1(st), curLon], [lats_obs_boxNo1(st), curLat]); clear curLon curLat
                distances(i,j) = dist; clear dist
            end
        end
        minDist= min(distances(:));
        [WRF.(doX).lons_gc_boxNo1(st), WRF.(doX).lats_gc_boxNo1(st)] = find(distances == minDist);
        
        if (st==1 || st==2)
            WRF.(doX).lats_gc_boxNo1(st)=WRF.(doX).lats_gc_box3(st+2)+1;
        end
               
        clear minDist distances
    end
    clear sz
end
toc



% the eastern box north 1
locations_boxNE1={'lower left','lower right','upper left','upper right'};
lons_obs_boxNE1=[-118.3 -117.5 -118.3 -117.5];%-118.5845
lats_obs_boxNE1=[34.8 34.8 35.52 35.52];%35.5027 35.5027];
% extract the closest grid points.
for d=1:4
    doX=strcat('d0',num2str(d));
    for st=1:length(lons_obs_boxNE1)
        sz = size(WRF.(doX).Lons);
        distances = zeros(sz);
        for i = 1:sz(1)
            for j = 1:sz(2)
                % WRF
                curLon = WRF.(doX).Lons(i, j);
                curLat = WRF.(doX).Lats(i, j);
                dist = m_lldistance([lons_obs_boxNE1(st), curLon], [lats_obs_boxNE1(st), curLat]); clear curLon curLat
                distances(i,j) = dist; clear dist
            end
        end
        minDist= min(distances(:));
        [WRF.(doX).lons_gc_boxNE1(st), WRF.(doX).lats_gc_boxNE1(st)] = find(distances == minDist);
        % have to modify the lower corners (st=1,2)
        if (st==1 || st==3)
            WRF.(doX).lons_gc_boxNE1(st)=WRF.(doX).lons_gc_boxNo1(st+1)+1;
        end
        
        clear minDist distances
    end
    clear sz
end
toc

% southeastern corners

% the eastern box south 1
locations_boxSE1={'lower left','lower right','upper left','upper right'};
lons_obs_boxSE1=[-118.3 -117.5 -118.3 -117.5];%-118.5845
lats_obs_boxSE1=[34.48 34.48 34.8 34.8];%35.5027 35.5027];
% extract the closest grid points.
for d=1:4
    doX=strcat('d0',num2str(d));
    for st=1:length(lons_obs_boxSE1)
        sz = size(WRF.(doX).Lons);
        distances = zeros(sz);
        for i = 1:sz(1)
            for j = 1:sz(2)
                % WRF
                curLon = WRF.(doX).Lons(i, j);
                curLat = WRF.(doX).Lats(i, j);
                dist = m_lldistance([lons_obs_boxSE1(st), curLon], [lats_obs_boxSE1(st), curLat]); clear curLon curLat
                distances(i,j) = dist; clear dist
            end
        end
        minDist= min(distances(:));
        [WRF.(doX).lons_gc_boxSE1(st), WRF.(doX).lats_gc_boxSE1(st)] = find(distances == minDist);
        % have to modify the lower corners (st=1,2)
        if (st==1 || st==3)
            WRF.(doX).lons_gc_boxSE1(st)=WRF.(doX).lons_gc_boxNo1(st+1)+1;
        end

        
        clear minDist distances
    end
    clear sz
end
toc









%%
% find the first hilltop from the a defined latitudinal baseline.
% From this hilltop, apply a filter like a gaussian function.
% the gaussian would go from 1 to 0 (northward), from which the lowest
% value would be a set percentage.

% example of gaussian function
% x=[0:0.1:10]
% y=gaussmf(x,[5 0]);y(y<0.1)=0.1;plot(x,y)

% some constants for the terrain elevation changes in the southern boxes
perc=0.1; % to what elevation do we change.
glengthsSo=[NaN NaN NaN NaN NaN;
        NaN NaN NaN NaN NaN;
        1 2 2 2 2;
        5 7 5 5 6];
hgtDef=[NaN NaN NaN NaN NaN;
        NaN NaN NaN NaN NaN;
        NaN NaN 800 10 10;
        NaN NaN NaN 500 400];

    
% some definitions for the northern boxes
glengthsNo=[NaN;NaN;5;15;]; % i represents domain Nr. northeastern gaussian length
glengthsSE=[NaN;NaN;2;NaN;]; % i represents domain Nr. southeastern box gaussian length. for d03=2 as that is better for target area.

% percEast=[0.2; 0.4; 0.65]; % i represent eastward boxes, that progresses up eastward in a 'logarithmic' way.

    
for d=[1:4]
    doX=strcat('d0',num2str(d));
    
    % we only change domains 3 and 4, but for simplicity, we copy also
    % domain 1 and 2 to the new terrain variable called HGTNew
    WRF.(doX).HGTNew=WRF.(doX).HGT; % just copy to prevent overwriting
    

    if (d==3 || d==4)
        % box 1 is gaussian approach correction (from top of ridge)
        for i=[WRF.(doX).lons_gc_box1(1):WRF.(doX).lons_gc_box1(2)] % loop over longitudes
            % WRF.(doX).lons_gc_box2 = 25   189    25   189
            % WRF.(doX).lats_gc_box2 = 116   116   145   145
            %[~,ind]=min(WRF.(doX).HGT(25,116:145)); % example
            
            % if box 1 is gaussian approach
            diffHgt=diff(WRF.(doX).HGT(i,WRF.(doX).lats_gc_box1(1):WRF.(doX).lats_gc_box1(3)));
            ind=find(diffHgt<0,1,'first'); % first negative value of the differene.
            indPlus1(i)=ind+WRF.(doX).lats_gc_box1(1)+1; % plus 1 for the index. This is the ridgetop.
            % apply gaussian function:
            x=1:length(indPlus1(i):WRF.(doX).lats_gc_box1(3));
            y=gaussmf(x,[glengthsSo(d,1) 0]);y(y<perc)=perc;
            WRF.(doX).HGTNew(i,indPlus1(i):WRF.(doX).lats_gc_box1(3))=...
                WRF.(doX).HGT(i,indPlus1(i):WRF.(doX).lats_gc_box1(3)).*y; % 10% is an example
            clear indPlus1
        end
        clear('i')
        
        % box 2 is longer gaussian approach correction (from top of ridge)
        for i=[WRF.(doX).lons_gc_box2(1):WRF.(doX).lons_gc_box2(2)] % loop over longitudes
            diffHgt=diff(WRF.(doX).HGT(i,WRF.(doX).lats_gc_box2(1):WRF.(doX).lats_gc_box2(3)));
            ind=find(diffHgt<0,1,'first'); % first negative value of the differene.
            indPlus2(i)=ind+WRF.(doX).lats_gc_box2(1)+1; % plus 1 for the index. This is the ridgetop.
            % apply gaussian function:
            x=1:length(indPlus2(i):WRF.(doX).lats_gc_box2(3));
            y=gaussmf(x,[glengthsSo(d,2) 0]);y(y<perc)=perc;
            WRF.(doX).HGTNew(i,indPlus2(i):WRF.(doX).lats_gc_box2(3))=...
                WRF.(doX).HGT(i,indPlus2(i):WRF.(doX).lats_gc_box2(3)).*y; % 10% is an example
            clear indPlus2
        end
        clear('i')
        
        % box 3 is shorter gaussian approach correction (from top of ridge)
        for i=[WRF.(doX).lons_gc_box3(1):WRF.(doX).lons_gc_box3(2)] % loop over longitudes
            if d==3 % IS THIS CORRECT ???
                ind=find(WRF.(doX).HGT(i,WRF.(doX).lats_gc_box4(1):WRF.(doX).lats_gc_box4(3))>hgtDef(d,4),1,'first');
                indPlus3(i)=ind+WRF.(doX).lats_gc_box4(1);
            elseif d==4
                diffHgt=diff(WRF.(doX).HGT(i,WRF.(doX).lats_gc_box3(1):WRF.(doX).lats_gc_box3(3)));
                ind=find(diffHgt<0,1,'first'); % first negative value of the differene.
                indPlus3(i)=ind+WRF.(doX).lats_gc_box3(1)+1; % plus 1 for the index. This is the ridgetop.
            end
            % apply gaussian function:
            x=1:length(indPlus3(i):WRF.(doX).lats_gc_box3(3));
            y=gaussmf(x,[glengthsSo(d,3) 0]);y(y<perc)=perc;
            WRF.(doX).HGTNew(i,indPlus3(i):WRF.(doX).lats_gc_box3(3))=...
                WRF.(doX).HGT(i,indPlus3(i):WRF.(doX).lats_gc_box3(3)).*y; % 10% is an example
            clear indPlus3
        end
        clear('i')
        
        
        % box 4. find ridge by threshold of xx m. then apply shorter gaussian approach correction
        for i=[WRF.(doX).lons_gc_box4(1):WRF.(doX).lons_gc_box4(2)] % loop over longitudes
            ind=find(WRF.(doX).HGT(i,WRF.(doX).lats_gc_box4(1):WRF.(doX).lats_gc_box4(3))>hgtDef(d,4),1,'first');
            indPlus4(i)=ind+WRF.(doX).lats_gc_box4(1);
            
            % apply gaussian function:
            x=1:length(indPlus4(i):WRF.(doX).lats_gc_box4(3));
            y=gaussmf(x,[glengthsSo(d,4) 0]);y(y<perc)=perc;
            WRF.(doX).HGTNew(i,indPlus4(i):WRF.(doX).lats_gc_box4(3))=...
                WRF.(doX).HGT(i,indPlus4(i):WRF.(doX).lats_gc_box4(3)).*y; % 10% is an example
            clear indPlus4
        end
        clear('i')
        
        
        % box 5. find ridge by threshold of xx m. then apply shorter gaussian approach correction
        for i=[WRF.(doX).lons_gc_box5(1):WRF.(doX).lons_gc_box5(2)] % loop over longitudes
            
            ind=find(WRF.(doX).HGT(i,WRF.(doX).lats_gc_box5(1):WRF.(doX).lats_gc_box5(3))>hgtDef(d,5),1,'first');
            indPlus5(i)=ind+WRF.(doX).lats_gc_box5(1);
            % apply gaussian function:
            x=1:length(indPlus5(i):WRF.(doX).lats_gc_box5(3));
            y=gaussmf(x,[glengthsSo(d,5) 0]);y(y<perc)=perc;
            WRF.(doX).HGTNew(i,indPlus5(i):WRF.(doX).lats_gc_box5(3))=...
                WRF.(doX).HGT(i,indPlus5(i):WRF.(doX).lats_gc_box5(3)).*y; % 10% is an example
            clear indPlus5
        end
        clear('i')
    
        
        % the northern box 1. West.
        for i=[WRF.(doX).lons_gc_boxNo1(1):WRF.(doX).lons_gc_boxNo1(2)] % loop over longitudes
            x=1:length(WRF.(doX).lats_gc_boxNo1(1):WRF.(doX).lats_gc_boxNo1(3));
            y=gaussmf(x,[glengthsNo(d) x(end)]);y(y<perc)=perc;
            WRF.(doX).HGTNew(i,WRF.(doX).lats_gc_boxNo1(1):WRF.(doX).lats_gc_boxNo1(3))=...
                WRF.(doX).HGT(i,WRF.(doX).lats_gc_boxNo1(1):WRF.(doX).lats_gc_boxNo1(3)).*y; % 10% is an example
            clear('x','y')
        end
        clear('i')
        
        
        % create own filter that goes east west.
        jlength=length(WRF.(doX).lons_gc_boxNE1(1):WRF.(doX).lons_gc_boxNE1(2));
        percEast=logspace(perc.*perc,1,jlength)/10; % have to apply the square for good scaling in the beginning.
        j=1;
        % the Northeastern box 1 
        for i=[WRF.(doX).lons_gc_boxNE1(1):WRF.(doX).lons_gc_boxNE1(2)] % loop over longitudes
            % define a percentage that loops over the ranges.
%             =i; between perc and 1.
            x=1:length(WRF.(doX).lats_gc_boxNE1(1):WRF.(doX).lats_gc_boxNE1(3));
            y=gaussmf(x,[glengthsNo(d) x(end)]);y(y<percEast(j))=percEast(j);
            WRF.(doX).HGTNew(i,WRF.(doX).lats_gc_boxNE1(1):WRF.(doX).lats_gc_boxNE1(3))=...
                WRF.(doX).HGT(i,WRF.(doX).lats_gc_boxNE1(1):WRF.(doX).lats_gc_boxNE1(3)).*y; % 10% is an example
            clear('x','y')
            j=j+1; % j is longitude loop.
        end
        clear('i')
        
        j=1;
        % the Southeastern box 1 
        for i=[WRF.(doX).lons_gc_boxSE1(1):WRF.(doX).lons_gc_boxSE1(2)] % loop over longitudes
            x=1:length(WRF.(doX).lats_gc_boxSE1(1):WRF.(doX).lats_gc_boxSE1(3));
            y=gaussmf(x,[glengthsSE(d) x(1)]);y(y<percEast(j))=percEast(j);
            WRF.(doX).HGTNew(i,WRF.(doX).lats_gc_boxSE1(1):WRF.(doX).lats_gc_boxSE1(3))=...
                WRF.(doX).HGT(i,WRF.(doX).lats_gc_boxSE1(1):WRF.(doX).lats_gc_boxSE1(3)).*y; % 10% is an example
            clear('x','y')
            j=j+1;
        end
        clear('i')
        clear('j','percEast','jlength')
    end
    
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% end of terrain elevation modifications %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% finally, we write the newly acquired values to the desired nc-file\
for d=1:4
    doX=strcat('d0',num2str(d));
    runpath=strcat(folder,'/geo_em.',doX,'.nc');
    ncwrite(runpath,'HGT_M',WRF.(doX).HGTNew)
end





%%%%%%%%%%%%%%%%%%%%%%%%%%
% plotting stuff
% station locations
stations_obs={'RHWC1','ElCap' , 'KSBA', 'SBVC1', 'MTIC1',  'Carp' ,'gap', 'oxn'};
lons_obs=[   -120.075 -119.965 -119.844 -119.706 -119.649 -119.515 -119.3 -119];  
lats_obs=[    34.517    34.458   34.426   34.456  34.461   34.406  34.406 34.406];
% 
% % locations to find in model
% lons_gridcell=zeros(length(lons_obs),1)';
% lats_gridcell=zeros(length(lats_obs),1)';
% % extract the closest grid points.
% for d=1:4
%     doX=strcat('d0',num2str(d));
%     for st=1:length(lons_obs)
%         sz = size(WRF.(doX).Lons);
%         distances = zeros(sz);
%         for i = 1:sz(1)
%             for j = 1:sz(2)
%                 % WRF
%                 curLon = WRF.(doX).Lons(i, j);
%                 curLat = WRF.(doX).Lats(i, j);
%                 dist = m_lldistance([lons_obs(st), curLon], [lats_obs(st), curLat]); clear curLon curLat
%                 distances(i, j) = dist; clear dist
%             end
%         end
%         minDist= min(distances(:));
%         [WRF.(doX).lons_gc_stInt(st), WRF.(doX).lats_gc_stInt(st)] = find(distances == minDist);
%         
%         clear minDist distances
%         %     clear lat1 lon1
%     end
%     clear sz
% 
% end

% just read them here so we don't have to re-run the location seeker loop
WRF.d01.lons_gc_st=[86 87 87 87 88 88 89 90];%WRF.d01.lons_gc_stInt;
WRF.d01.lats_gc_st=[84 83 83 83 83 83 83 83];%WRF.d01.lats_gc_stInt;
WRF.d02.lons_gc_st=[89 91 92 93 94 95 98 101];%WRF.d02.lons_gc_stInt;
WRF.d02.lats_gc_st=[79 78 77 78 78 77 77 77];%WRF.d02.lats_gc_stInt;
WRF.d03.lons_gc_st=[105 109 113 117 119 123 130 140];%WRF.d03.lons_gc_stInt;
WRF.d03.lats_gc_st=[103 100 99 100 101 98 98 98];%WRF.d03.lats_gc_stInt;
WRF.d04.lons_gc_st=[114 125 137 150 156 168 189 218];%WRF.d04.lons_gc_stInt;
WRF.d04.lats_gc_st=[118 111 108 111 112 105 105 105];%WRF.d04.lats_gc_stInt;




% plot an example
res={strcat(num2str(WRF.d01.DX),'x',num2str(WRF.d01.DX),'km');...
    strcat(num2str(WRF.d02.DX),'x',num2str(WRF.d02.DX),'km');...
    strcat(num2str(WRF.d03.DX),'x',num2str(WRF.d03.DX),'km');...
    strcat(num2str(WRF.d04.DX),'x',num2str(WRF.d04.DX),'km')};



fig=figGD('on');
for d=[1:4]
    cmapsea=[1 1 1];

%     if (d==1 || d==2 || d==3 )
%         WRF.(doX).HGT(WRF.(doX).LU==17)=-70;
%     elseif d==4
%         WRF.(doX).HGT(WRF.(doX).HGT<1)=20;
%         WRF.(doX).HGT(WRF.(doX).LU==17)=-70;
%     end
    
    
    subplot_tight(2,2,d,[0.05 0.1])
    
    doX=strcat('d0',num2str(d));
    demcmap(WRF.(doX).HGT,100,cmapsea);
    p1=pcolor(squeeze(WRF.(doX).Lons),squeeze(WRF.(doX).Lats),squeeze(WRF.(doX).HGTNew));
    
    shading flat

    
    if (d==1 || d==2 || d==3 )
        bordersGD('continental us','k','LineWidth',2)
        bordersGD('countries','k','LineWidth',2)
    elseif d==4
        bordersGD('continental us','k','LineWidth',2)
    end
    box off
    
    doX=strcat('d0',num2str(d));
    text(WRF.d04.Lons(2,end-2),WRF.d04.Lats(2,end-2),strcat('d0',num2str(d),'-',res(d,:)),'FontSize',16,...
        'BackGroundColor','w');
    for st=1:length(stations_obs)
        stX=line(WRF.(doX).Lons(WRF.(doX).lons_gc_st(st),WRF.(doX).lats_gc_st(st)),...
            WRF.(doX).Lats(WRF.(doX).lons_gc_st(st),WRF.(doX).lats_gc_st(st)),...
            'LineStyle','none','Marker','x','MarkerSize',10,'LineWidth',2,'color','k');
    end

    
    % set all domains to the innermost domain extent.
    % xlims.d04=get(gca,'xlim');
    % ylims.d04=get(gca,'ylim');
    set(gca,'xlim',[-121.2538 -118.5845])
    set(gca,'ylim',[33.5087   35.5027])
    xlabel('Longitude [deg W]')
    ylabel('Latitude [deg N]')
    
    cb = colorbar;
    ylabel(cb,'Elevation above sea level (m)')
    
    caxis([0 1200])%2.5689e+03]) % from d04.
    % set(gca,'XTick',[],'YTick',[])
    
    % set(findall(gcf, '-property', 'FontSize'), 'FontSize', 18)
    
    
end



export_fig('sbareg_d01-d04_terrain_elev_mod_d04Ext_gaussianApproach','-png')




%% plot cross sections



cmap=hsv(4);

fig=figGD('on');
for st=1:length(stations_obs)
    subplot_tight(2,4,st,[0.05 0.05])
    hold on
    for d=[1:4]
        doX=strcat('d0',num2str(d));
        l3(d)=line(WRF.(doX).Lats(WRF.(doX).lons_gc_st(st),:),...
            WRF.(doX).HGTNew(WRF.(doX).lons_gc_st(st),:),...
            'color',cmap(d,:),'LineWidth',2);
        doXstr{d}=strcat('d0',num2str(d),'-',strcat(num2str(WRF.(doX).DX),'x',num2str(WRF.(doX).DX),'km'));
        
    end
    
%     if st==1
%         leg=legend([l3(:)],doXstr{:});
%     end
    set(gca,'xlim',[34.087   35.5027])
    set(gca,'ylim',[0 2000])
    title(stations_obs{st});
    
    
    ylabel('Elevation [m]')
    if (st==5 || st==6 || st==7 || st==8)
        xlabel('Latitude [deg N]')
    end
end
export_fig('sbareg_d01-d04_terrain_elev_mod_cx_sect_gaussianApproach_withNorth','-png')



% cross section old and new
cmap=hsv(4);

fig=figGD('on');
for st=1:length(stations_obs)
    subplot_tight(2,4,st,[0.05 0.05])
    hold on
    for d=[1:4]
        doX=strcat('d0',num2str(d));
        l3(d)=line(WRF.(doX).Lats(WRF.(doX).lons_gc_st(st),:),...
            WRF.(doX).HGTNew(WRF.(doX).lons_gc_st(st),:),...
            'color',cmap(d,:),'LineWidth',2);
        l3a(d)=line(WRF.(doX).Lats(WRF.(doX).lons_gc_st(st),:),...
            WRF.(doX).HGT(WRF.(doX).lons_gc_st(st),:),...
            'color','k','LineWidth',1);
        doXstr{d}=strcat('d0',num2str(d),'-',strcat(num2str(WRF.(doX).DX),'x',num2str(WRF.(doX).DX),'km'));
        
    end
    
%     if st==1
%         leg=legend([l3(:)],doXstr{:});
%     end
    set(gca,'xlim',[34.087   35.5027])
    set(gca,'ylim',[0 2000])
    title(stations_obs{st});
    
    
    ylabel('Elevation [m]')
    if (st==5 || st==6 || st==7 || st==8)
        xlabel('Latitude [deg N]')
    end
end
export_fig('sbareg_d01-d04_terrain_elev_mod_cx_sect_gaussianApproach_oldNew_withNorth','-png')

%%
% east west cx section
latsd0(1)=85;
latsd0(2)=82;
latsd0(3)=114;
latsd0(4)=151;
% cross section old and new
cmap=hsv(4);

fig=figGD('on');

subplot_tight(1,1,1,[0.25 0.05])
hold on
for d=[1:4]
    doX=strcat('d0',num2str(d));
    l3(d)=line(WRF.(doX).Lons(:,latsd0(d)),...
        WRF.(doX).HGTNew(:,latsd0(d)),...
        'color',cmap(d,:),'LineWidth',2,'Marker','x');
    l3a(d)=line(WRF.(doX).Lons(:,latsd0(d)),...
        WRF.(doX).HGT(:,latsd0(d)),...
        'color','k','LineWidth',1);
    doXstr{d}=strcat('d0',num2str(d),'-',strcat(num2str(WRF.(doX).DX),'x',num2str(WRF.(doX).DX),'km'));
    
    
    
%     if st==1
%         leg=legend([l3(:)],doXstr{:});
%     end
    set(gca,'xlim',[-121 -117])
    set(gca,'ylim',[0 2000])
    title('east-west cx section along');
    
    
    ylabel('Elevation [m]')
    xlabel('Longitude [deg N]')
    
end
export_fig('sbareg_d01-d04_terrain_elev_mod_cx_sect_WE_gaussianApproach_oldNew_withNorth','-png')

%%


fig=figGD('on');
for d=1:4
    cmapsea=[1 1 1];
% 
%     if (d==1 || d==2 || d==3 )
%         WRF.(doX).HGT(WRF.(doX).LU==17)=-70;
%     elseif d==4
%         WRF.(doX).HGT(WRF.(doX).HGT<1)=20;
%         WRF.(doX).HGT(WRF.(doX).LU==17)=-100;
%     end
    
    
    subplot_tight(2,2,d,[0.05 0.1])
    
    doX=strcat('d0',num2str(d));
    demcmap(WRF.(doX).HGT,100,cmapsea);
    p1=pcolor(squeeze(WRF.(doX).Lons),squeeze(WRF.(doX).Lats),squeeze(WRF.(doX).HGTNew));
    
    shading flat
    cb = colorbar;
    ylabel(cb,'Elevation above sea level (m)')
    
    if (d==1 || d==2 || d==3 )
        bordersGD('continental us','k','LineWidth',2)
        bordersGD('countries','k','LineWidth',2)
    elseif d==4
        bordersGD('continental us','k','LineWidth',2)
    end
    box off
    
    if d==1
        for j=1:4
            doX=strcat('d0',num2str(d+1));
            % box ljnes
            line([WRF.(doX).Lons(1,1) WRF.(doX).Lons(1,end)],[WRF.(doX).Lats(1,1) WRF.(doX).Lats(1,end)],'color','k','LineWidth',2)
            line([WRF.(doX).Lons(1,end) WRF.(doX).Lons(end,end)],[WRF.(doX).Lats(1,end) WRF.(doX).Lats(end,end)],'color','k','LineWidth',2)
            line([WRF.(doX).Lons(end,end) WRF.(doX).Lons(end,1)],[WRF.(doX).Lats(end,end) WRF.(doX).Lats(end,1)],'color','k','LineWidth',2)
            line([WRF.(doX).Lons(end,1) WRF.(doX).Lons(1,1)],[WRF.(doX).Lats(end,1) WRF.(doX).Lats(1,1)],'color','k','LineWidth',2)
        end
    elseif d==2
        for j=2
            doX=strcat('d0',num2str(d+1));
            % box ljnes
            line([WRF.(doX).Lons(1,1) WRF.(doX).Lons(1,end)],[WRF.(doX).Lats(1,1) WRF.(doX).Lats(1,end)],'color','k','LineWidth',2)
            line([WRF.(doX).Lons(1,end) WRF.(doX).Lons(end,end)],[WRF.(doX).Lats(1,end) WRF.(doX).Lats(end,end)],'color','k','LineWidth',2)
            line([WRF.(doX).Lons(end,end) WRF.(doX).Lons(end,1)],[WRF.(doX).Lats(end,end) WRF.(doX).Lats(end,1)],'color','k','LineWidth',2)
            line([WRF.(doX).Lons(end,1) WRF.(doX).Lons(1,1)],[WRF.(doX).Lats(end,1) WRF.(doX).Lats(1,1)],'color','k','LineWidth',2)
        end
    elseif d==3
        j=3;
        doX=strcat('d0',num2str(d+1));
        % box ljnes
        line([WRF.(doX).Lons(1,1) WRF.(doX).Lons(1,end)],[WRF.(doX).Lats(1,1) WRF.(doX).Lats(1,end)],'color','k','LineWidth',2)
        line([WRF.(doX).Lons(1,end) WRF.(doX).Lons(end,end)],[WRF.(doX).Lats(1,end) WRF.(doX).Lats(end,end)],'color','k','LineWidth',2)
        line([WRF.(doX).Lons(end,end) WRF.(doX).Lons(end,1)],[WRF.(doX).Lats(end,end) WRF.(doX).Lats(end,1)],'color','k','LineWidth',2)
        line([WRF.(doX).Lons(end,1) WRF.(doX).Lons(1,1)],[WRF.(doX).Lats(end,1) WRF.(doX).Lats(1,1)],'color','k','LineWidth',2)
    end
    
    doX=strcat('d0',num2str(d));
    text(WRF.(doX).Lons(2,end-2),WRF.(doX).Lats(2,end-2),strcat('d0',num2str(d),'-',res(d,:)),'FontSize',16,...
        'BackGroundColor','w');
    
    % caxis([0 1600])
    xlabel('Longitude [deg W]')
    ylabel('Latitude [deg N]')
    % set(gca,'XTick',[],'YTick',[])
    
    % set(findall(gcf, '-property', 'FontSize'), 'FontSize', 18)
    
    
end

export_fig('sbareg_d01-d04_terrain_elev_gaussianApproach_allExt_withNorth','-png')



toc