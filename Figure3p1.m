LC=double(geotiffread("Data\reclassifiedLC_SierraNevada.tif"));
LC(LC==0)=NaN;
LC=flipud(LC);
%Forest (All conifer forest and all hardwood forests)
LC(LC==11)=100;
LC(LC==14)=100;
LC(LC==20)=100;
LC(LC==24)=100;
LC(LC==27)=100;
LC(LC==29)=100;
LC(LC==35)=100;
LC(LC==42)=100;
LC(LC==45)=100;
LC(LC==44)=100;
LC(LC==51)=100;
LC(LC==48)=100;
LC(LC==58)=100;
LC(LC==5)=100;
LC(LC==36)=100;
LC(LC==37)=100;
%Woodland (All conifer woodland and all hardwood woodland)
LC(LC==26)=200;
LC(LC==40)=200;
LC(LC==9)=200;
LC(LC==8)=200;
LC(LC==10)=200;
LC(LC==77)=200;
LC(LC==56)=200;
LC(LC==55)=200;
%Shrub (Desert woodland and Shrub except "Alpine-dwarf shrub"
LC(LC==15)=300;
LC(LC==25)=300;
LC(LC==41)=300;
LC(LC==7)=300;
LC(LC==12)=300;
LC(LC==13)=300;
LC(LC==30)=300;
LC(LC==32)=300;
LC(LC==34)=300;
LC(LC==50)=300;
%Meadow (wet meadow)
LC(LC==59)=400;
LC(LC==22)=400;
LC(LC==1)=400;
LC(LC==22)=400;
%Others 
LC(LC<100)=500;
LC(LC<100)=NaN;
LC(LC==100)=1;%Forest
LC(LC==200)=2;%Woodland
LC(LC==300)=3;%Shrub
LC(LC==400)=4;%Meadow
LC(LC==500)=5;%Others
[Z, R] = geotiffread("Data\reclassifiedLC_SierraNevada.tif");
% Extract world limits and resolution from the spatial referencing object
latitudeLimits = R.LatitudeLimits;   % [minLat, maxLat]
longitudeLimits = R.LongitudeLimits; % [minLon, maxLon]
latResolution = R.CellExtentInLatitude;
lonResolution = R.CellExtentInLongitude;
% Generate 1-D arrays of latitude and longitude
latitude = (latitudeLimits(1) + latResolution/2):latResolution:(latitudeLimits(2) - latResolution/2);
longitude = (longitudeLimits(1) + lonResolution/2):lonResolution:(longitudeLimits(2) - lonResolution/2);
y=latitude;x=longitude;
[XLC,YLC]=meshgrid(x,y);
figure;
t=tiledlayout(1,1,'TileSpacing','none','Padding','none');
ax1=nexttile;
mymap=pcolor(x,y,LC);
mymap.EdgeAlpha=0;             %Removes the grids
caxis([1 5]);
box on;
set(gca,'linew',1.5);   % thickens the axis
axis equal;           %important for maps so that there is no stretch
xlim([min(x) max(x)]); 
ylim([min(y) max(y)]); 
set(gca,'TickLabelInterpreter','none'); set(gca,'fontweight','bold','fontsize',12);
grid on;
set(gca,'fontweight','bold','fontsize',12);
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
colors1 = [0.2235294117647059 0.4117647058823529 0.20392156862745098;0.11764705882352941 0.2 0.9215686274509803;0.8705882352941177 0 0;0.12941176470588237 0.9568627450980393 1;0.65 0.65 0.65];
colormap(ax1,colors1);
cb1=colorbar(ax1);
cb1.Ticks=[];
%Save as GeoTiff image
R = georefcells([min(latitude) max(latitude)], [min(longitude) max(longitude)], size(LC(:,:,1)));  % For 2D and 3D
% Step 3: Write the GeoTIFF file (as before, this can be for single or multi-band)
filename = 'LC_SierraNevada.tif';
geotiffwrite(filename, LC, R, 'CoordRefSysCode', 'EPSG:4326');
set(gca,'linew',1.5);   % thickens the axis
set(gca,'linew',2);   % thickens the axis
ax = gca; % Get current axes
ax.XColor = 'k'; % Set X-axis color to black
ax.YColor = 'k'; % Set Y-axis color to black