% script to compute and plot statistics related to land

clear;clc;tic

filestr='/home/sbarc/students/duine/sundowners/clim/data/model/sbareg_WRF_stations_intp_clst_lvl1_19870701_20170701_v2';
load(filestr)
% clear('startComp','endComp')

[obs_U_lvl1_nan,obs_V_lvl1_nan]=wspdWdirToUV(obs_wspd_lvl1_nan,obs_wdir_lvl1_nan);


% the data is pre-selected in UTC, but we do everything from now in PST for
% clarity in figures, etc.
clear('month','day','hour')
[~,month,day,hour,~,~]=datevec(WRF.tnumWRF_PST);

seasStr={'DJF','MAM','JJA','SON'};
season=floor((mod(month,12)+3)/3);

for s=1:4
    indSeas{s}=find(season==s);
end

for st=1:length(stations)
    stations{st}=strrep(stations{st},'46','b46');
end
%%
indRHWC1=11;
indMTIC1=12;
% indKBFL=5;

% exclude nan's


wspdRHWC1Model=WRF.intp.wspd(indRHWC1,:);
wspdMTIC1Model=WRF.intp.wspd(indMTIC1,:);

percs=[50,95,97.5,99];
percStr=strcat(num2str(percs'),'th');

wspdRHWC1ModelPercs=prctile(wspdRHWC1Model,percs,'all');
wspdMTIC1ModelPercs=prctile(wspdMTIC1Model,percs,'all');

wspdRHWC1ModelStd=nanstd(wspdRHWC1Model);
wspdMTIC1ModelStd=nanstd(wspdMTIC1Model);
wspdRHWC1ModelMean=nanmean(wspdRHWC1Model);
wspdMTIC1ModelMean=nanmean(wspdMTIC1Model);



%%
close
fig=figGD('on');



subplot_tight(1,2,1,[0.2 0.05])
hold on; grid on; box on
histogram(wspdRHWC1Model,[0:0.5:20])
% set legend here to avoid conflict with child axis.
title(strcat('(c) RHWC1'))
ax1=gca;
grid on
xLab1=xlabel('Wind speed [m s^{-1}]');
ylabel('Count')
ylims=get(gca,'YLim');
for i=[1,2]%1:length(mslpDiffKSMXModelPercs)
    line([wspdRHWC1ModelPercs(i) wspdRHWC1ModelPercs(i)],ylims,...
        'LineStyle','--','color','k','LineWidth',2)
    text(wspdRHWC1ModelPercs(i),ylims(2)+1500,percStr(i,:),'rotation',90)
    text(wspdRHWC1ModelPercs(i),ylims(1)-4000,...
        num2str(round(wspdRHWC1ModelPercs(i),2)),'rotation',90)

end
set(gca,'XTick',[0:2:20],'XTickLabel',{'0','2','4','6','8','','12','14','16','18','20'})

text(17.5,ylims(2)-1500,strcat('mean:',num2str(round(wspdRHWC1ModelMean,2))))
text(17.5,ylims(2)-3500,strcat('\sigma:',num2str(round(wspdRHWC1ModelStd,2))))



subplot_tight(1,2,2,[0.2 0.05])
hold on; grid on; box on
histogram(wspdMTIC1Model,[0:0.5:20])
% set legend here to avoid conflict with child axis.
title(strcat('(d) MTIC1'))
ax1=gca;
grid on
xLab2=xlabel('Wind speed [m s^{-1}]');
ylabel('Count')
ylims=get(gca,'YLim');
for i=[1,2]%1:length(mslpDiffKBFLModelPercs)
    line([wspdMTIC1ModelPercs(i) wspdMTIC1ModelPercs(i)],ylims,...
        'LineStyle','--','color','k','LineWidth',2)
    text(wspdMTIC1ModelPercs(i),ylims(2)+1500,percStr(i,:),'rotation',90)
    text(wspdMTIC1ModelPercs(i),ylims(1)-5000,...
        num2str(round(wspdMTIC1ModelPercs(i),2)),'rotation',90)

end
set(gca,'XTick',[0:2:20],'XTickLabel',{'0','','4','6','8','10','','14','16','18','20'})


text(17.5,ylims(2)-1500,strcat('mean:',num2str(round(wspdMTIC1ModelMean,2))))
text(17.5,ylims(2)-3500,strcat('\sigma:',num2str(round(wspdMTIC1ModelStd,2))))

set(xLab1,'Position', [10.0000 -4.0686e+03 -1])
set(xLab2,'Position',[10.0000 -4.9551e+03 -1.0000])
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14)


export_fig('FigS04cd','-png')
export_fig('FigS04cd','-pdf')

% 
% 
% save('percs_winds_30yrs.mat','percs',...
%     'wspdRHWC1ModelPercs','wspdRHWC1ModelMean','wspdRHWC1ModelStd',...
%     'wspdMTIC1ModelPercs','wspdMTIC1ModelMean','wspdMTIC1ModelStd')




toc