% script to plot supplemental figure 4a/b manuscript on influence of terrain
% modification on Sundowner wind diurnal variability

% Gert-Jan Duine, UCSB
% gertjan.duine@gmail.com; duine@eri.ucsb.edu

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

indKSBA=3;
indKSMX=4;
indKBFL=5;

% exclude nan's

mslpDiffKSMXObs=(squeeze(obs_slp_lvl1(indKSBA,:))-squeeze(obs_slp_lvl1(indKSMX,:)))/100;
mslpDiffKBFLObs=(squeeze(obs_slp_lvl1(indKSBA,:))-squeeze(obs_slp_lvl1(indKBFL,:)))/100;


mslpDiffKSMXModel=(squeeze(WRF.intp.MSLP(indKSBA,:))-squeeze(WRF.intp.MSLP(indKSMX,:)))/100;
mslpDiffKBFLModel=(squeeze(WRF.intp.MSLP(indKSBA,:))-squeeze(WRF.intp.MSLP(indKBFL,:)))/100;



percs=[1,2.5,5,50];
percStr=strcat(num2str(100-percs'),'th');

mslpDiffKSMXModelPercs=prctile(mslpDiffKSMXModel,percs,'all');
mslpDiffKBFLModelPercs=prctile(mslpDiffKBFLModel,percs,'all');

mslpDiffKSMXModelStd=nanstd(mslpDiffKSMXModel);
mslpDiffKBFLModelStd=nanstd(mslpDiffKBFLModel);
mslpDiffKSMXModelMean=nanmean(mslpDiffKSMXModel);
mslpDiffKBFLModelMean=nanmean(mslpDiffKBFLModel);



%%
close
fig=figGD('on');



subplot_tight(1,2,1,[0.2 0.05])
hold on; grid on; box on
histogram(mslpDiffKSMXModel,[-6:0.1:6])
% set legend here to avoid conflict with child axis.
title(strcat('(a) KSBA minus KSMX'))
ax1=gca;
grid on
xLab1=xlabel('\Delta mslp [hPa]');
ylabel('Count')
ylims=get(gca,'YLim');
for i=[3,4]%1:length(mslpDiffKSMXModelPercs)
    line([mslpDiffKSMXModelPercs(i) mslpDiffKSMXModelPercs(i)],ylims,...
        'LineStyle','--','color','k','LineWidth',2)
    text(mslpDiffKSMXModelPercs(i),ylims(2)+500,percStr(i,:),'rotation',90)
    text(mslpDiffKSMXModelPercs(i),ylims(1)-1000,...
        num2str(round(mslpDiffKSMXModelPercs(i),2)),'rotation',90)

end
set(gca,'XTick',[-6:2:6],'XTickLabel',{'-6','-4','-2','0','2','4','6'})

text(4.5,ylims(2)-1500,strcat('mean:',num2str(round(mslpDiffKSMXModelMean,2))))
text(4.5,ylims(2)-1800,strcat('\sigma:',num2str(round(mslpDiffKSMXModelStd,2))))



subplot_tight(1,2,2,[0.2 0.05])
hold on; grid on; box on
histogram(mslpDiffKBFLModel,[-10:0.1:10])
% set legend here to avoid conflict with child axis.
title(strcat('(b) KSBA minus KBFL'))
ax1=gca;
grid on
xLab2=xlabel('\Delta mslp [hPa]');
ylabel('Count')
ylims=get(gca,'YLim');
for i=[3,4]%1:length(mslpDiffKBFLModelPercs)
    line([mslpDiffKBFLModelPercs(i) mslpDiffKBFLModelPercs(i)],ylims,...
        'LineStyle','--','color','k','LineWidth',2)
    text(mslpDiffKBFLModelPercs(i),ylims(2)+200,percStr(i,:),'rotation',90)
    text(mslpDiffKBFLModelPercs(i),ylims(1)-400,...
        num2str(round(mslpDiffKBFLModelPercs(i),2)),'rotation',90)

end
set(gca,'XTick',[-10:2:10],'XTickLabel',{'-10','-8','-6','','-2','','2','4','6','8','10'})


text(7.5,ylims(2)-750,strcat('mean:',num2str(round(mslpDiffKBFLModelMean,2))))
text(7.5,ylims(2)-900,strcat('\sigma:',num2str(round(mslpDiffKBFLModelStd,2))))

set(xLab1,'Position',[6.2943e-06 -1200 -1])
set(xLab2,'Position',[1.0490e-05 -500 -1])
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 14)


export_fig('FigS04ab','-png')
export_fig('FigS04ab','-pdf')


% save('percs_MSLPdiffs_30yrs.mat','percs',...
%     'mslpDiffKSMXModelPercs','mslpDiffKSMXModelMean','mslpDiffKSMXModelStd',...
%     'mslpDiffKBFLModelPercs','mslpDiffKBFLModelMean','mslpDiffKBFLModelStd')




toc