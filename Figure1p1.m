%Study area: Sierra Nevada
shapefileCA="Data\California_Shapefile_EPSG4326\California_shapefile.shp";
shapefileSN="Data\DataMerged_SierraNevada_shapefile\Merged_SierraNevada.shp";
figure;
t = tiledlayout(1, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
ax1 = nexttile;
geoshow(shapefileCA, 'FaceColor', 'none', 'LineWidth', 1.5); % no face color, only boundaries
DEM=geotiffread("Data\DEM_SierraNevada.tif");
DEM=flipud(DEM);
DEM=single(DEM);
DEM(DEM==32767)=NaN;
%Lat and Lon (DEM)
[Z, R] = geotiffread("Data\DEM_SierraNevada.tif");
% Extract world limits and resolution from the spatial referencing object
latitudeLimits = R.LatitudeLimits;   % [minLat, maxLat]
longitudeLimits = R.LongitudeLimits; % [minLon, maxLon]
latResolution = R.CellExtentInLatitude;
lonResolution = R.CellExtentInLongitude;
% Generate 1-D arrays of latitude and longitude
latitude = (latitudeLimits(1) + latResolution/2):latResolution:(latitudeLimits(2) - latResolution/2);
longitude = (longitudeLimits(1) + lonResolution/2):lonResolution:(longitudeLimits(2) - lonResolution/2);
yDEM=latitude;xDEM=longitude;
[XDEM,YDEM]=meshgrid(xDEM,yDEM);
mymap=pcolor(xDEM,yDEM,DEM);mymap.EdgeAlpha=0;   %Removes the grids
hold on;
geoshow(shapefileSN, 'FaceColor', 'none', 'LineWidth', 1.5); 
axis equal;
box on;
set(gca,'linew',2);   % thickens the axis
hold on;
geoshow(shapefileCA, 'FaceColor', 'none', 'LineWidth', 1.5); % no face color, only boundaries
% Coordinates
x = [-122.3836, -120.6530, -121.5577, -120.1452, -121.4944, ...
     -119.5383, -118.3952, -119.7871, -117.6718, -118.4490];
y = [40.5754, 40.4163, 39.5133, 39.1677, 38.5781, ...
     37.8651, 37.3614, 36.7378, 35.6205, 35.1322];

% Plot hollow round scatter points
hold on;
scatter(x, y, 80, 'o', 'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', 'none', 'LineWidth', 2); 
hold on;
% Add labels (1 to 10) next to each point
for i = 1:length(x)
    text(x(i) + 0.05, y(i), num2str(i), 'FontSize', 14,'FontWeight','bold', 'Color', 'k');
end
ylim([34.8 42.2]); 
xlim([-123 -116]);
% Define tick positions
xticks([-123 -122 -121 -120 -119 -118 -117 -116]);
yticks([35 36 37 38 39 40 41 42]);
% Define tick labels with degree symbols
xticklabels({'123° W','122° W','121° W','120° W','119° W','118° W','117° W','116° W'});
yticklabels({'35° N','36° N','37° N','38° N','39° N','40° N','41° N','42° N'});
% Format tick labels
set(gca, 'FontName', 'Helvetica', 'FontWeight', 'bold', 'FontSize', 16);
% Define DEM-style colormap with more emphasis on white at the top
dem_cmap = [ ...
    0.0 0.4 0.0   % dark green (lowlands)
    0.0 0.8 0.0   % light green
    0.8 0.8 0.0   % yellow
    0.6 0.3 0.0   % brown
    0.8 0.6 0.6   % light brown transitioning
    1.0 1.0 1.0]; % pure white (high peaks)
% Interpolate smoothly to 256 colors
dem_cmap = interp1(linspace(0,1,size(dem_cmap,1)), dem_cmap, linspace(0,1,256));
% Apply colormap
colormap(dem_cmap);
% Fix the elevation range
caxis([33 4412]);
% Add colorbar at the top ("northoutside")
hcb = colorbar('northoutside');
% Set custom ticks
set(hcb, 'Ticks', 0:500:4500);   % 0, 500, 1000, … 4500
% Format tick labels
set(hcb, 'FontName','Helvetica', 'FontWeight','bold', 'FontSize',16);
% Define tick values in metres and convert to feet
ticks_m = 0:1000:5000;              % ticks in metres
ticks_ft = ticks_m * 3.28084;       % convert to feet
% Apply ticks and labels
set(hcb, 'Ticks', ticks_m, ...
         'TickLabels', arrayfun(@(x) sprintf('%d', round(x)), ticks_ft, 'UniformOutput', false), ...
         'FontName','Helvetica', 'FontWeight','bold', 'FontSize',16);
% Make tick marks thicker
hcb.TickLength = 0.02;      % relative to colorbar length
hcb.LineWidth = 2;          % thickness of ticks/box
% Rotate tick labels 45 degrees
set(hcb, 'TickLabelInterpreter','none');  % avoid LaTeX rotation conflicts