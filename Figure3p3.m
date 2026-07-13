%Plotting merged fire and drought Sierra Nevada impacts on tree cover
Fire=double(geotiffread("Data\Fire attributions\ClipSierraNevada_Merged_Fire.tif"));
Drought=double(geotiffread("Data\Drought attributions\ClipSierraNevada_Merged_Drought.tif"));
Fire(Fire<-5000)=NaN;
Drought(Drought<-5000)=NaN;
Fire=flipud(Fire);
Drought=flipud(Drought);
Fire(Fire >= -0.5 & Fire <= 0.5) = 0;
Fire(Fire >= -15 & Fire < -0.5) = -1;
Fire(Fire >= -25 & Fire < -15) = -2;
Fire(Fire < -25) = -3;
Fire(Fire > 0.5 & Fire <= 15) = 1;
Fire(Fire > 15 & Fire <= 25) = 2;
Fire(Fire > 25) = 3;
Drought(Drought >= -0.5 & Drought <= 0.5) = 0;
Drought(Drought >= -15 & Drought < -0.5) = -1;
Drought(Drought >= -25 & Drought < -15) = -2;
Drought(Drought < -25) = -3;
Drought(Drought > 0.5 & Drought <= 15) = 1;
Drought(Drought > 15 & Drought <= 25) = 2;
Drought(Drought > 25) = 3;
[Z, R] = geotiffread("Data\Fire attributions\ClipSierraNevada_Merged_Fire.tif");
% Extract world limits and resolution from the spatial referencing object
latitudeLimits = R.LatitudeLimits;   % [minLat, maxLat]
longitudeLimits = R.LongitudeLimits; % [minLon, maxLon]
latResolution = R.CellExtentInLatitude;
lonResolution = R.CellExtentInLongitude;
% Generate 1-D arrays of latitude and longitude
latitude = (latitudeLimits(1) + latResolution/2):latResolution:(latitudeLimits(2) - latResolution/2);
longitude = (longitudeLimits(1) + lonResolution/2):lonResolution:(longitudeLimits(2) - lonResolution/2);
y=latitude;x=longitude;
[X,Y]=meshgrid(x,y);
figure;
t=tiledlayout(1,3,'TileSpacing','compact','Padding','compact');
ax1=nexttile;
caxis([-3 3]);
mymap=pcolor(x,y,Fire);
mymap.EdgeAlpha=0;             %Removes the grids
box on;
set(gca,'linew',1.5);   % thickens the axis
axis equal;           %important for maps so that there is no stretch
xlim([min(x) max(x)]); 
ylim([min(y) max(y)]); 
set(gca,'TickLabelInterpreter','none'); set(gca,'fontweight','bold','fontsize',16);
grid on;
set(gca,'fontweight','bold','fontsize',16);
% Set y-axis ticks and custom labels
yticks(35:41);
yticklabels(strcat(string(35:41), "°N"));
% Set x-axis ticks and custom labels
xticks(-121:-118); % Specify tick positions for longitudes
xticklabels(strcat(string(abs(-121:-118)), "°W")); % Convert to positive values and append "°W"
shapefile="Data\Merged_SierraNevada_shapefile\Merged_SierraNevada.shp";
hold on;
geoshow(shapefile, 'FaceColor', 'none','LineWidth',2);  %No facecolor
% Enable minor ticks and set ticks outside
ax = gca; % Get the current axes
ax.XAxis.TickDirection = 'out'; % Set ticks to be outside
ax.XMinorTick = 'on'; % Enable minor ticks
ax.YAxis.TickDirection = 'out'; % Set ticks to be outside
ax.YMinorTick = 'on'; % Enable minor ticks
colors1 = [178 24 43;230 139 98;253 219 199;247 247 247;209 229 240;103 169 207;33 102 172]/255;
colormap(ax1,colors1);
cb1=colorbar(ax1);
cb1.Ticks=[];
% Create dummy patches for the legend
hold on;
% Create a patch for each legend entry
p1 = patch(NaN, NaN, [178 24 43] / 255, 'EdgeColor', 'none'); % Eco 5
p2 = patch(NaN, NaN, [230 139 98] / 255, 'EdgeColor', 'none');  % Eco 6
p3 = patch(NaN, NaN, [253 219 199] / 255, 'EdgeColor', 'none');  % Eco 7
p4 = patch(NaN, NaN, [247 247 247] / 255, 'EdgeColor', 'none'); % Eco 8
p5 = patch(NaN, NaN, [209 229 240] / 255, 'EdgeColor', 'none'); % Eco 9
p6 = patch(NaN, NaN, [103 169 207] / 255, 'EdgeColor', 'none'); % Eco 10
p7 = patch(NaN, NaN, [33 102 172] / 255, 'EdgeColor', 'none'); % Eco 11
% Add the legend with the patches and set 2 columns
lgd = legend([p1, p2, p3, p4, p5, p6, p7], 'TCC < -25', '-25 < TCC < -15', '-15 < TCC < -0.5', '-0.5 < TCC < 0.5', '0.5 < TCC < 15', '15 < TCC < 25', 'TCC > 25','Location', 'best');
% Customize the legend
set(lgd, 'FontName', 'Helvetica', 'FontSize', 12);
ax2=nexttile;
caxis([-3 3]);
mymap=pcolor(x,y,Drought);
mymap.EdgeAlpha=0;             %Removes the grids
box on;
set(gca,'linew',1.5);   % thickens the axis
axis equal;           %important for maps so that there is no stretch
xlim([min(x) max(x)]); 
ylim([min(y) max(y)]); 
set(gca,'TickLabelInterpreter','none'); set(gca,'fontweight','bold','fontsize',16);
grid on;
set(gca,'fontweight','bold','fontsize',16);
% Set y-axis ticks and custom labels
yticks(35:41);
yticklabels(strcat(string(35:41), "°N"));
% Set x-axis ticks and custom labels
xticks(-121:-118); % Specify tick positions for longitudes
xticklabels(strcat(string(abs(-121:-118)), "°W")); % Convert to positive values and append "°W"
shapefile="Data\Merged_SierraNevada_shapefile\Merged_SierraNevada.shp";
hold on;
geoshow(shapefile, 'FaceColor', 'none','LineWidth',2);  %No facecolor
% Enable minor ticks and set ticks outside
ax = gca; % Get the current axes
ax.XAxis.TickDirection = 'out'; % Set ticks to be outside
ax.XMinorTick = 'on'; % Enable minor ticks
ax.YAxis.TickDirection = 'out'; % Set ticks to be outside
ax.YMinorTick = 'on'; % Enable minor ticks
colors2 = [178 24 43;230 139 98;253 219 199;247 247 247;209 229 240;103 169 207;33 102 172]/255;
colormap(ax2,colors2);
cb2=colorbar(ax2);
cb2.Ticks=[];
% Create dummy patches for the legend
hold on;
% Create a patch for each legend entry
p1 = patch(NaN, NaN, [178 24 43] / 255, 'EdgeColor', 'none'); % Eco 5
p2 = patch(NaN, NaN, [230 139 98] / 255, 'EdgeColor', 'none');  % Eco 6
p3 = patch(NaN, NaN, [253 219 199] / 255, 'EdgeColor', 'none');  % Eco 7
p4 = patch(NaN, NaN, [247 247 247] / 255, 'EdgeColor', 'none'); % Eco 8
p5 = patch(NaN, NaN, [209 229 240] / 255, 'EdgeColor', 'none'); % Eco 9
p6 = patch(NaN, NaN, [103 169 207] / 255, 'EdgeColor', 'none'); % Eco 10
p7 = patch(NaN, NaN, [33 102 172] / 255, 'EdgeColor', 'none'); % Eco 11
% Add the legend with the patches and set 2 columns
lgd = legend([p1, p2, p3, p4, p5, p6, p7], 'TCC < -25', '-25 < TCC < -15', '-15 < TCC < -0.5', '-0.5 < TCC < 0.5', '0.5 < TCC < 15', '15 < TCC < 25', 'TCC > 25','Location', 'best');
% Customize the legend
set(lgd, 'FontName', 'Helvetica', 'FontSize', 12);
%SSP2-4.5
figure;
t=tiledlayout(1,3,'TileSpacing','compact','Padding','compact');
ax1=nexttile;
ax2=nexttile;
ax3=nexttile;
%North Sierra
North_average=geotiffread("Data\NorthDeltaC_Average.tif");
North_cnm=geotiffread("Data\NorthDeltaC_cnm.tif");
North_gmm=geotiffread("Data\NorthDeltaC_gmm.tif");
North_esm=geotiffread("Data\NorthDeltaC_esm.tif");
%South Sierra
South_average=geotiffread("Data\SouthDeltaC_Average.tif");
South_cnm=geotiffread("Data\SouthDeltaC_cnm.tif");
South_gmm=geotiffread("Data\SouthDeltaC_gmm.tif");
South_esm=geotiffread("Data\SouthDeltaC_esm.tif");
South_average(South_average<-100000)=NaN;
South_cnm(South_cnm<-100000)=NaN;
South_gmm(South_gmm<-100000)=NaN;
South_esm(South_esm<-100000)=NaN;
%Comb
%[ESM GMM CNM Average]
MeanComb=[mean(North_esm,'all','omitnan') mean(South_esm,'all','omitnan');mean(North_gmm,'all','omitnan') mean(South_gmm,'all','omitnan');mean(North_cnm,'all','omitnan') mean(South_cnm,'all','omitnan');mean(North_average,'all','omitnan') mean(South_average,'all','omitnan')];
StdComb=[std(North_esm,0,'all','omitnan') std(South_esm,0,'all','omitnan');std(North_gmm,0,'all','omitnan') std(South_gmm,0,'all','omitnan');std(North_cnm,0,'all','omitnan') std(South_cnm,0,'all','omitnan');std(North_average,0,'all','omitnan') std(South_average,0,'all','omitnan')];
model_series=MeanComb;model_error=StdComb;
b = bar(model_series, 'grouped');
set(b, {'DisplayName'}, {'Northern Sierra Nevada','Southern Sierra Nevada'}');
lgd = legend;
lgd.NumColumns = 2;
hold on;
% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(model_series);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none','CapSize',8,'LineWidth',2);
    end
box on;
set(gca,'linew',2);   % thickens the axis
set(gca,'YMinorTick','on');
set(gca,'TickLabelInterpreter','none');
set(gca,'fontweight','bold','fontsize',16);
xticks([1 2 3 4]);
xticklabels({'ESM','GMM','CNM','Average'});
grid on;
ylabel('\Delta AGL C (kgC m^{-2})','fontweight','bold','fontsize',16);
%SSP5-8.5
figure;
t=tiledlayout(1,3,'TileSpacing','compact','Padding','compact');
ax1=nexttile;
ax2=nexttile;
ax3=nexttile;
%North Sierra
North_average=geotiffread("Data\NorthDeltaC_Average_SSP585.tif");
North_cnm=geotiffread("Data\NorthDeltaC_cnm_SSP585.tif");
North_gmm=geotiffread("Data\NorthDeltaC_gmm_SSP585.tif");
North_esm=geotiffread("Data\NorthDeltaC_esm_SSP585.tif");
%South Sierra
South_average=geotiffread("Data\SouthDeltaC_Average_SSP585.tif");
South_cnm=geotiffread("Data\SouthDeltaC_cnm_SSP585.tif");
South_gmm=geotiffread("Data\SouthDeltaC_gmm_SSP585.tif");
South_esm=geotiffread("Data\SouthDeltaC_esm_SSP585.tif");
South_average(South_average<-100000)=NaN;
South_cnm(South_cnm<-100000)=NaN;
South_gmm(South_gmm<-100000)=NaN;
South_esm(South_esm<-100000)=NaN;
%Comb
%[ESM GMM CNM Average]
MeanComb=[mean(North_esm,'all','omitnan') mean(South_esm,'all','omitnan');mean(North_gmm,'all','omitnan') mean(South_gmm,'all','omitnan');mean(North_cnm,'all','omitnan') mean(South_cnm,'all','omitnan');mean(North_average,'all','omitnan') mean(South_average,'all','omitnan')];
StdComb=[std(North_esm,0,'all','omitnan') std(South_esm,0,'all','omitnan');std(North_gmm,0,'all','omitnan') std(South_gmm,0,'all','omitnan');std(North_cnm,0,'all','omitnan') std(South_cnm,0,'all','omitnan');std(North_average,0,'all','omitnan') std(South_average,0,'all','omitnan')];
model_series=MeanComb;model_error=StdComb;
b = bar(model_series, 'grouped');
set(b, {'DisplayName'}, {'Northern Sierra Nevada','Southern Sierra Nevada'}');
lgd = legend;
lgd.NumColumns = 2;
hold on;
% Find the number of groups and the number of bars in each group
[ngroups, nbars] = size(model_series);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none','CapSize',8,'LineWidth',2);
    end
box on;
set(gca,'linew',2);   % thickens the axis
set(gca,'YMinorTick','on');
set(gca,'TickLabelInterpreter','none');
set(gca,'fontweight','bold','fontsize',16);
xticks([1 2 3 4]);
xticklabels({'ESM','GMM','CNM','Average'});
grid on;
ylabel('\Delta AGL C (kgC m^{-2})','fontweight','bold','fontsize',16);
