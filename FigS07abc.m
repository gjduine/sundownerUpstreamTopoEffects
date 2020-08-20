% script to plot Figure supplementary plot hovmoller diagram

clear;clc; tic

load('/home/duine/sundowners/sensSRM/201703/data/model/WRF_sensSRM_hovmueller_20170301_20170331.mat')
runNames={'a','b','c'};
runs={'SRM100','SRM075','SRM010'};
runs2={'control','25% red.','90% red.'};


% prepare X and Y for Z
lonsHovMul=repmat(squeeze(WRF.SRM100.XLONG(lonsRange,115)),[1 length(squeeze(WRF.tnumWRF_PST(:)))]);
timesHovMul=repmat(squeeze(WRF.tnumWRF_PST(:)),[1 length(lonsRange)])';



%% a summary of the differences
cRangeV10=[-20:1:20];
cRangePBLD=[0:100:2000];
cRangePBLH=[0:100:3500];
cRangePBLHftMSL=[0:300:10000];
cRangeHFX=[-250:10:250];
cRangeSWDOWN=[0:50:1000];

mToFt=3.28084;




%% V10 slopes.

close
fig=figGD('off');
for r=1:length(runs)
    runX=strcat(runs{r});
    
    sp1=subplot_tight(1,2,1,[0.07 0.05]);
    hold on; box on
    ax1=gca; clear('gca')
    set(ax1,'Clim',[cRangeV10(1) cRangeV10(end)]);
    cmap1=colormap(ax1,flipud(bluewhitered));
    [c1,m1]=contourf(lonsHovMul,timesHovMul,WRF.(runX).V10HovMulSlp,[cRangeV10],'edgecolor','none');
    hold on; box on
     % plot properties
    ylabel('Time [days in March 2017]');
    xLab=xlabel('Longitude [^\circ]');
    datetick('y','dd','keeplimits')
    title(strcat('(',runNames{r},')',{' '},runs2{r},{' - '},' V-component on leeslope [m/s]'))
    cb=colorbar;
    set(ax1,'Layer','top') % to let the box re-appear
    clear('cmap1')
    

set(findall(gcf, '-property', 'FontSize'), 'FontSize', 16)
export_fig(strcat('FigS07',runNames{r}),'-png')

end



toc