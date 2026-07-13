% --- Your existing FHSZ plot (EPSG:3310) ---
shp = "\FHSZ_SRA_LRA_Combined_7655045730008688696\FHSZ_SRA_LRA_Combined.shp";%Data not available anymore; was earlier in https://data.cnra.ca.gov/dataset/fire-hazard-severity-zones-in-sra-effective-april-1-2024-with-lra-recommended-2007-2011
S = shaperead(shp);
c_mod     = [1.00 1.00 0.00];
c_high    = [1.00 0.65 0.00];
c_vhigh   = [0.55 0.00 0.00];
spec = makesymbolspec('Polygon', ...
    {'FHSZ',  1, 'FaceColor', c_mod,     'EdgeColor','none'}, ...
    {'FHSZ',  2, 'FaceColor', c_high,    'EdgeColor','none'}, ...
    {'FHSZ',  3, 'FaceColor', c_vhigh,   'EdgeColor','none'});
figure; mapshow(S, 'SymbolSpec', spec); hold on; axis equal tight;
% --- Legend (as you had) ---
h1 = patch(NaN,NaN,c_mod,    'EdgeColor','none');
h2 = patch(NaN,NaN,c_high,   'EdgeColor','none');
h3 = patch(NaN,NaN,c_vhigh,  'EdgeColor','none');
legend([h1 h2 h3], {'Moderate','High','Very High'}, 'Location','bestoutside');
% --- Read 4326 shapefiles (lat/lon) ---
shapefileCA ="Data\California_Shapefile_EPSG4326\California_shapefile.shp";
shapefileSN = "Data\Merged_SierraNevada_shapefile\Merged_SierraNevada.shp";
CA = shaperead(shapefileCA);
SN = shaperead(shapefileSN);

% --- Define the projection (EPSG:3310) and project lat/lon -> meters ---
p3310 = projcrs(3310);  % requires Mapping Toolbox (R2020b+)

CA_3310 = CA;
for k = 1:numel(CA)
    [Xproj, Yproj] = projfwd(p3310, CA(k).Y, CA(k).X);  % projfwd(lat, lon)
    CA_3310(k).X = Xproj;
    CA_3310(k).Y = Yproj;
end

SN_3310 = SN;
for k = 1:numel(SN)
    [Xproj, Yproj] = projfwd(p3310, SN(k).Y, SN(k).X);
    SN_3310(k).X = Xproj;
    SN_3310(k).Y = Yproj;
end

% --- Overlay outlines on top of FHSZ ---
mapshow(CA_3310, 'FaceColor','none', 'EdgeColor','k', 'LineWidth',1.5);
mapshow(SN_3310, 'FaceColor','none', 'EdgeColor','b', 'LineWidth',2, 'LineStyle','--');
% Remove x and y axis labels
xlabel('')
ylabel('')

% Turn off axes completely
axis off
