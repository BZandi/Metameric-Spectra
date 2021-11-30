%% Graphics preferences and setting the path

set(groot, 'DefaultLineLineWidth', 2);
set(groot, 'DefaultAxesLineWidth', 1);
set(groot, 'DefaultAxesFontName', 'Lato');
set(groot, 'DefaultAxesFontSize', 8);
set(groot, 'DefaultAxesFontWeight', 'normal');
set(groot, 'DefaultAxesXMinorTick', 'on');
set(groot, 'DefaultAxesXGrid', 'on');
set(groot, 'DefaultAxesYGrid', 'on');
set(groot, 'DefaultAxesGridLineStyle', ':');
set(groot, 'DefaultAxesUnits', 'normalized');
set(groot, 'DefaultAxesOuterPosition',[0, 0, 1, 1]);
set(groot, 'DefaultFigureUnits', 'inches');
set(groot, 'DefaultFigurePaperPositionMode', 'manual');
set(groot, 'DefaultFigurePosition', [0.1, 11, 8.5, 4.5]);
set(groot, 'DefaultFigurePaperUnits', 'inches');
set(groot, 'DefaultFigurePaperPosition', [0.1, 11, 8.5, 4.5]);

addpath("A01_Methods/");
addpath("A00_Data/");

%% Load optimised spectral data

% This reporsitory provides over 490,000 optimised multi-channel
% LED metamer spectra presented in the article
% "Optimising metameric spectra for integrative lighting to modulate
% the circadian system without affecting visual appearance",
% authored by Babak Zandi, Oliver Stefani,
% Alexander Herzog, Luc J. M. Schlangen, Quang Vinh Trinh and Tran Quoc Khanh.
% DOI: https://doi.org/10.1038/s41598-021-02136-y
% GitHub: https://github.com/BZandi/Metameric-Spectra

% Please download the data and drag them into the folder A00_Data/
% Download-Link 1: https://tudatalib.ulb.tu-darmstadt.de/bitstream/handle/tudatalib/3291/Optim_CH6_L220_Mel_Limit.csv.zip?sequence=1&isAllowed=y
% Download-Link 2: https://tudatalib.ulb.tu-darmstadt.de/bitstream/handle/tudatalib/3291/Optim_CH8_L220_Mel_Limit.csv.zip?sequence=2&isAllowed=y
% Download-Link 3: https://tudatalib.ulb.tu-darmstadt.de/bitstream/handle/tudatalib/3291/Optim_CH11_L220_Mel_Limit.csv.zip?sequence=3&isAllowed=y
Optim_CH6_L220 = readtable("A00_Data/Optim_CH6_L220_Mel_Limit.csv");
Optim_CH8_L220 = readtable("A00_Data/Optim_CH8_L220_Mel_Limit.csv");
Optim_CH11_L220 = readtable("A00_Data/Optim_CH11_L220_Mel_Limit.csv");

% The TM30-20 metrics were caluclated using the luxpy python library with the Main_CalcTM30_20.py script
% Luxpy library: https://github.com/ksmet1977/luxpy
% Citation of the luxpy:
% Smet, K. A. G. (2019).
% Tutorial: The LuxPy Python Toolbox for Lighting and Color Science.
% LEUKOS, 1–23. DOI: 10.1080/15502724.2018.1518717
TM3020_CH6_L220 = readtable("A00_Data/TM_30_CH6_L220.csv");
TM3020_CH8_L220 = readtable("A00_Data/TM_30_CH8_L220.csv");
TM3020_CH11_L220 = readtable("A00_Data/TM_30_CH11_L220.csv");

% Combining the two datasets and replace the Rf_Actual coloumn
Optim_CH6_L220 = [Optim_CH6_L220, TM3020_CH6_L220];
Optim_CH6_L220.Rf_Actual = Optim_CH6_L220.Rf_TM30(:);

Optim_CH8_L220 = [Optim_CH8_L220, TM3020_CH8_L220];
Optim_CH8_L220.Rf_Actual = Optim_CH8_L220.Rf_TM30(:);

Optim_CH11_L220 = [Optim_CH11_L220, TM3020_CH11_L220];
Optim_CH11_L220.Rf_Actual = Optim_CH11_L220.Rf_TM30(:);

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220

%% Plot the optimisation targets
close all;
% Load the optimisation targets. Data are from the publication:
% Truong, W., Zandi, B., Trinh, V. Q., and Khanh, T. Q. (2020).
% Circadian metric – Computation of circadian stimulus using illuminance,
% correlated colour temperature and colour rendering index.
% Build. Environ. 184, 107146. doi:10.1016/j.buildenv.2020.107146.
Optimierungs_Ziele = readtable('A00_Data/Optimisation_Targets.csv');

% Convert from CIEuv-1960 to CIExy-2°
% Reference: https://en.wikipedia.org/wiki/CIELUV
% % Formula for converting CIEu'v'-1960 to CIExy-2°
% CIEx1931 = (3.*u)./(2.*u- 8.*v + 4)
% CIEy1931 = (2.*v)./(2.*u- 8.*v + 4);

% % Formula for converting CIEu'v'-1967 to CIExy-2°
% CIEx1931 = (9.*u)./(6.*u- 16.*v + 12);
% CIEy1931 = (4.*v)./(6.*u- 16.*v + 12);
u = Optimierungs_Ziele.CIEu1960_Target;
v = Optimierungs_Ziele.CIEv1960_Target;
Optimierungs_Ziele.CIEx1931_Target = (3.*u)./(2.*u- 8.*v + 4);
Optimierungs_Ziele.CIEy1931_Target = (2.*v)./(2.*u- 8.*v + 4);

% Plotting the optimisation targets
h1 = figure; plot_CCTLocus(true, true, [], []); hold on;
set(gcf, 'Position', [0.1, 11, 5, 4]);
% Plot negative Duv
DataNegativDuv = Optimierungs_Ziele(Optimierungs_Ziele.Duv_signed < 0, :);
Ziele_1 = scatter(DataNegativDuv.CIEx1931_Target, DataNegativDuv.CIEy1931_Target, 15,...
    'MarkerEdgeColor', 'none', 'MarkerFaceColor', '#2c7fb8');
% Plot positive Duv
DataNegativDuv = Optimierungs_Ziele(Optimierungs_Ziele.Duv_signed >= 0, :);
Ziele_2 = scatter(DataNegativDuv.CIEx1931_Target, DataNegativDuv.CIEy1931_Target, 15,...
    'MarkerEdgeColor', 'none', 'MarkerFaceColor', 'red');
alpha(Ziele_1,.4); alpha(Ziele_2,.4); hold off;
xlim([0.2, 0.6]); ylim([0.24, 0.62]);

fig = gcf;
FontName = 'Charter';
FontSize = 10;
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',FontSize)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', FontSize)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.75)
set(gcf, 'Position', [0.1, 11, 15.8, 12]); % [PositionDesk, PositionDesk, Width, Height]

% Exportparameter - Width: 6, Height: auto, Font: 7, FontName: Charter, Line: 0.5
% In Illustrator: FontSize CCT: 5 pt, FontSize Normal: 7 pt, CCT Linien: 0.25 pt

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220

%% Figure 1A): Plotting the the found optimisation targets for each channel configuration

% CUSTOM VALUE: If you need to export the plot change this value to true
Boolean_Export = true;
% -----------------------------------------------------------------------

close all;
figure; t = tiledlayout(1,3, 'Padding', "tight", "TileSpacing", "compact");
set(gcf, 'Position', [0.1, 11, 14, 4]);
GridLabel = 'on';
MarkerSize = 4;
ScatterSze = 0.25;

ax(1) = nexttile(1);
Titlestr = {'6-channel'};
CurrentTable = Optim_CH6_L220;
CurrentTable.IndexNumber_Target = categorical(CurrentTable.IndexNumber_Target);
CurrentTable = groupfilter(CurrentTable,'IndexNumber_Target',@(x) x == x(1));
u = CurrentTable.u1976_Target;
v = CurrentTable.v1976_Target;
CurrentTable.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CurrentTable.y_Target = (4.*v)./(6.*u- 16.*v + 12);

plot_CCTLocus(false, true, [], []); hold on;
Targets = scatter(CurrentTable.x_Target, CurrentTable.y_Target, MarkerSize,...
    'MarkerEdgeColor', 'none', 'MarkerFaceColor', '#2c7fb8', 'LineWidth', ScatterSze);
alpha(Targets,.4)
xlim([0.2, 0.6]); ylim([0.24, 0.62]); hold off;
title(Titlestr);

ax(2) = nexttile(2);
Titlestr = {'8-channel'};
CurrentTable = Optim_CH8_L220;
CurrentTable.IndexNumber_Target = categorical(CurrentTable.IndexNumber_Target);
CurrentTable = groupfilter(CurrentTable,'IndexNumber_Target',@(x) x == x(1));
u = CurrentTable.u1976_Target;
v = CurrentTable.v1976_Target;
CurrentTable.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CurrentTable.y_Target = (4.*v)./(6.*u- 16.*v + 12);

plot_CCTLocus(false, true, [], []); hold on;
Targets = scatter(CurrentTable.x_Target, CurrentTable.y_Target, MarkerSize,...
    'MarkerEdgeColor', 'none', 'MarkerFaceColor', '#2c7fb8', 'LineWidth', ScatterSze);
alpha(Targets,.4)
xlim([0.2, 0.6]); ylim([0.24, 0.62]); hold off;
title(Titlestr);

ax(3) = nexttile(3);
Titlestr = {'11-channel'};
CurrentTable = Optim_CH11_L220;
CurrentTable.IndexNumber_Target = categorical(CurrentTable.IndexNumber_Target);
CurrentTable = groupfilter(CurrentTable,'IndexNumber_Target',@(x) x == x(1));
u = CurrentTable.u1976_Target;
v = CurrentTable.v1976_Target;
CurrentTable.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CurrentTable.y_Target = (4.*v)./(6.*u- 16.*v + 12);

plot_CCTLocus(false, true, [], []); hold on;
Targets = scatter(CurrentTable.x_Target, CurrentTable.y_Target, MarkerSize,...
    'MarkerEdgeColor', 'none', 'MarkerFaceColor', '#2c7fb8', 'LineWidth', ScatterSze);
alpha(Targets,.4)
xlim([0.2, 0.6]); ylim([0.24, 0.62]); hold off;
title(Titlestr);

YLim = [0.25, 0.5]; YLimTick = [0.25:0.05:0.5];
XLim = [0.25, 0.5]; XLimTick = [0.25:0.05:0.5];
xlabel(t, 'x', 'FontSize', 8, 'FontName', 'Charter');
ylabel(t, 'y', 'FontSize', 8, 'FontName', 'Charter');
set(ax(1), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(1), GridLabel);
set(ax(2), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(2), GridLabel);
set(ax(3), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(3), GridLabel);

fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.5)
set(gcf, 'Position', [0.1, 11, 15.8, 4]); % [PositionDesk, PositionDesk, Width, Height]

if Boolean_Export == true
    disp("Figure 1A exported !")
    % Note: Before the plot was exported, the figure was expanded to fill the axes
    % exportgraphics(gcf, 'A02_Exported_Figures/Figure1A.pdf','ContentType','vector')
end

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220

%% Fugure 1B): Example Plot for one chromaticity coordinate target

% CUSTOM VALUE: If you need to export the plot change this value to true
Boolean_Export = true;
% -----------------------------------------------------------------------

close all;
% 1) Plotting 5552 K chromaticity targets in CIExy colour space -----------------------------------
figure; t = tiledlayout(1,1, 'Padding', "tight", "TileSpacing", "compact");
set(gcf, 'Position', [0.1, 11, 4, 4]);
GridLabel = 'on';
MarkerSize = 4;
ScatterSze = 0.25;
Titlestr = 'Optimisation Targets';

ax(1) = nexttile(1);
CurrentTable = Optim_CH11_L220(Optim_CH11_L220.CCT_Target == 5552,:);
CurrentTable.IndexNumber_Target = categorical(CurrentTable.IndexNumber_Target);
CurrentTable = groupfilter(CurrentTable,'IndexNumber_Target',@(x) x == x(1));
u = CurrentTable.u1976_Target;
v = CurrentTable.v1976_Target;
CurrentTable.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CurrentTable.y_Target = (4.*v)./(6.*u- 16.*v + 12);

plot_CCTLocus(false, true, [], []); hold on;
Targets = scatter(CurrentTable.x_Target, CurrentTable.y_Target, MarkerSize,...
    'MarkerEdgeColor', 'none', 'MarkerFaceColor', '#2c7fb8', 'LineWidth', ScatterSze);
xlim([0.2, 0.6]); ylim([0.24, 0.62]); hold off;
title(Titlestr);

YLim = [0.25, 0.5]; YLimTick = [0.25:0.05:0.5];
XLim = [0.25, 0.4]; XLimTick = [0.25:0.05:0.4];
xlabel(t, 'x', 'FontSize', 8, 'FontName', 'Charter');
ylabel(t, 'y', 'FontSize', 8, 'FontName', 'Charter');
set(ax(1), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(1), GridLabel);

fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.5)
set(gcf, 'Position', [0.1, 11, 3, 5]); % [PositionDesk, PositionDesk, Width, Height]

if Boolean_Export == true
    exportgraphics(gcf, 'A02_Exported_Figures/Figure1B_Part_1.pdf','ContentType','vector')
end

% 2) Plotting 5552 K chromaticity targets in CIExy colour space -----------------------------------
figure; t = tiledlayout(2,1, 'Padding', "tight", "TileSpacing", "compact");
set(gcf, 'Position', [0.1, 11, 4, 4]);
GridLabel = 'off';
LineWidthPlot = 0.75;
ScatterSze = 0.25;
CurrentTable = Optim_CH11_L220(Optim_CH11_L220.CCT_Target == 5552 & Optim_CH11_L220.DUV_signed == 0.021,:);

ax(1) = nexttile(1);
Spectra = CurrentTable{:,39:439}';
MaxValue = max(max(Spectra));
plot((380:780)', Spectra/MaxValue, 'LineWidth', LineWidthPlot);

YLim = [0, 1]; YLimTick = [0:0.5:1];
xlabel('Wavelength in nm', 'FontSize', 8, 'FontName', 'Charter');
ylabel('Radiance W/m^2 sr nm.', 'FontSize', 8, 'FontName', 'Charter');
set(ax(1), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(1), GridLabel);

ax(2) = nexttile(2);
scatter(CurrentTable.u1976_Actual, CurrentTable.v1976_Actual, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'k', 'LineWidth', ScatterSze); hold on;
scatter(CurrentTable.u1976_Target(1), CurrentTable.v1976_Target(1), 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'r', 'LineWidth', ScatterSze+0.1);
ang=0:0.01:2*pi;
xp=0.001*cos(ang);
yp=0.001*sin(ang);
plot(CurrentTable.u1976_Target(1)+xp,CurrentTable.v1976_Target(1)+yp,...
    'LineWidth', LineWidthPlot, 'Color', 'r');

XLim = [0.1895, 0.192]; XLimTick = [0.1895:0.001:0.192];
YLim = [0.4965, 0.499]; YLimTick = [0.4965:0.0008:0.499];
xlabel('CIEu-1976', 'FontSize', 8, 'FontName', 'Charter');
ylabel('CIEv-1976', 'FontSize', 8, 'FontName', 'Charter');
%set(ax(2), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off'); grid(ax(1), GridLabel);
set(ax(2), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(2), GridLabel);

fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.5)
set(gcf, 'Position', [0.1, 11, 5, 5]); % [PositionDesk, PositionDesk, Width, Height]

if Boolean_Export == true
    exportgraphics(gcf, 'A02_Exported_Figures/Figure1B_Part_2.pdf','ContentType','vector')
end

% 3) Plotting 5552 K, Duv 0.021 --> melanopic-EDI at 250 photopic lx -----------------------------------
figure; t = tiledlayout(1,1, 'Padding', "tight", "TileSpacing", "compact");
set(gcf, 'Position', [0.1, 11, 4, 4]);
GridLabel = 'off';
LineWidthPlot = 0.75;
ScatterSze = 0.25;
CurrentTable = Optim_CH11_L220(Optim_CH11_L220.CCT_Target == 5552 & Optim_CH11_L220.DUV_signed == 0.021,:);

ax(1) = nexttile(1);
Melanopic_EDI = CurrentTable(CurrentTable.CRI_Actual > 80, :).MelanopicEDI_250lx;
min(Melanopic_EDI)
scatter(repmat(1, size(Melanopic_EDI, 1), 1),...
    Melanopic_EDI, 15,...
    'MarkerEdgeColor','w',...
    'MarkerFaceColor','b',...
    'jitter', 'on', 'jitterAmount', 0.16);

XLim = [0.5, 1.5]; XLimTick = [0 1 1.5];
YLim = [160, 280]; YLimTick = [160:40:280];
ylabel('Melanopic-EDI', 'FontSize', 7, 'FontName', 'Charter');
set(ax(1), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(1), GridLabel);

fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',7)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 7)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.5)
set(gcf, 'Position', [0.1, 11, 0.6, 2]); % [PositionDesk, PositionDesk, Width, Height]

if Boolean_Export == true
    exportgraphics(gcf, 'A02_Exported_Figures/Figure1B_Part_3.pdf','ContentType','vector')
end

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220

%% Figure: 1C): Example Plot for one CCT with several Duv's

% CUSTOM VALUE: If you need to export the plot change this value to true
Boolean_Export = true;
% -----------------------------------------------------------------------

close all;
% 0) Plotting of the optimisatoin targets in CIExy-2° colour space 2901 K
figure; t = tiledlayout(1,1, 'Padding', "tight", "TileSpacing", "compact");
set(gcf, 'Position', [0.1, 11, 4, 4]);
GridLabel = 'on';
MarkerSize = 4;
ScatterSze = 0.25;
Titlestr = 'Optimisation Targets';

ax(1) = nexttile(1);
CurrentTable = Optim_CH11_L220(Optim_CH11_L220.CCT_Target == 2901,:);
CurrentTable.IndexNumber_Target = categorical(CurrentTable.IndexNumber_Target);
CurrentTable = groupfilter(CurrentTable,'IndexNumber_Target',@(x) x == x(1));
u = CurrentTable.u1976_Target;
v = CurrentTable.v1976_Target;
CurrentTable.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CurrentTable.y_Target = (4.*v)./(6.*u- 16.*v + 12);

plot_CCTLocus(false, true, [], []); hold on;
Targets = scatter(CurrentTable.x_Target, CurrentTable.y_Target, MarkerSize,...
    'MarkerEdgeColor', 'none', 'MarkerFaceColor', '#2c7fb8', 'LineWidth', ScatterSze);
xlim([0.2, 0.6]); ylim([0.24, 0.62]); hold off;
title(Titlestr);

YLim = [0.25, 0.5]; YLimTick = [0.25:0.05:0.5];
XLim = [0.35, 0.5]; XLimTick = [0.35:0.05:0.5];
xlabel(t, 'x', 'FontSize', 8, 'FontName', 'Charter');
ylabel(t, 'y', 'FontSize', 8, 'FontName', 'Charter');
set(ax(1), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(1), GridLabel);

fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.5)
set(gcf, 'Position', [0.1, 11, 3, 5]); % [PositionDesk, PositionDesk, Width, Height]

if Boolean_Export == true
    exportgraphics(gcf, 'A02_Exported_Figures/Figure1C_Part_1.pdf','ContentType','vector')
end

% 1) Mel-DER for each Duv at 2901 K in a 2 x1 otting grid
% Note the figure in paper used a CRI condition instead of the TM30-20 metrics
% The following code uses a Rf > = 85, and Rf,h1 > = 85
figure; t = tiledlayout(1,1, 'Padding', "tight", "TileSpacing", "compact");
set(gcf, 'Position', [0.1, 11, 4, 4]);
GridLabel = 'off';
LineWidthPlot = 0.75;
ScatterSze = 0.25;
MarkerSize = 15;
CurrentTable = Optim_CH11_L220(Optim_CH11_L220.CCT_Target == 2901,:);
CurrentTable = Calculate_Contrast([85 85], CurrentTable);
CurrentTable(CurrentTable.Mel_DER250lx_Actual_MIN == min(CurrentTable.Mel_DER250lx_Actual_MIN), :)
ax(1) = nexttile(1);
scatter(CurrentTable.DUV_signed, CurrentTable.Mel_DER250lx_Actual_MIN, MarkerSize,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'k', 'LineWidth', ScatterSze); hold on;
scatter(CurrentTable.DUV_signed, CurrentTable.Mel_DER250lx_Actual_MAX, MarkerSize,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'b', 'LineWidth', ScatterSze);

% Highlight the scatter with the highest melanopic-EDI
High_Mel_DER = CurrentTable(CurrentTable.Mel_DER250lx_Actual_MAX == max(CurrentTable.Mel_DER250lx_Actual_MAX),:);
scatter(High_Mel_DER.DUV_signed, High_Mel_DER.Mel_DER250lx_Actual_MAX, MarkerSize,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'r', 'LineWidth', ScatterSze);

% Highlight the scatter with the highest melanopic-EDI difference
High_Mel_DER_Diff = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff),:);
scatter(High_Mel_DER_Diff.DUV_signed, High_Mel_DER_Diff.Mel_DER250lx_Actual_MAX, MarkerSize,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'g', 'LineWidth', ScatterSze);

ylabel(t, 'Melanopic-DER', 'FontSize', 8, 'FontName', 'Charter');
xlabel(t, 'Duv from Planck', 'FontSize', 8, 'FontName', 'Charter');

YLim = [0.2, 0.8]; YLimTick = [0.2:0.2:0.8];
XLim = [-0.06, 0.04]; XLimTick = [-0.06:0.02:0.04];
set(ax(1), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(1), GridLabel);

fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.5)
set(gcf, 'Position', [0.1, 11, 6, 3]); % [PositionDesk, PositionDesk, Width, Height]

if Boolean_Export == true
    exportgraphics(gcf, 'A02_Exported_Figures/Figure1C_Part_2.pdf','ContentType','vector')
end

% 2) Mel-DER for 2901 K, seperated for min and max in a 2 x 1 otting grid

figure; t = tiledlayout(1,1, 'Padding', "tight", "TileSpacing", "compact");
set(gcf, 'Position', [0.1, 11, 4, 4]);
GridLabel = 'off';
LineWidthPlot = 0.75;
ScatterSze = 0.25;
MarkerSize = 15;
jitterAmount = 0.1;
CurrentTable = Optim_CH11_L220(Optim_CH11_L220.CCT_Target == 2901,:);
CurrentTable = Calculate_Contrast([85 85], CurrentTable);

ax(1) = nexttile(1);
scatter(CurrentTable.CCT_Target, CurrentTable.Mel_DER250lx_Actual_MIN, MarkerSize,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'k', 'LineWidth', ScatterSze, 'jitter', 'on', 'jitterAmount', jitterAmount); hold on;
scatter(CurrentTable.CCT_Target, CurrentTable.Mel_DER250lx_Actual_MAX, MarkerSize,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'b', 'LineWidth', ScatterSze, 'jitter', 'on', 'jitterAmount', jitterAmount);

% Highlight the scatter with the highest melanopic-EDI
High_Mel_DER = CurrentTable(CurrentTable.Mel_DER250lx_Actual_MAX == max(CurrentTable.Mel_DER250lx_Actual_MAX),:);
scatter(High_Mel_DER.CCT_Target, High_Mel_DER.Mel_DER250lx_Actual_MAX, MarkerSize,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'r', 'LineWidth', ScatterSze, 'jitter', 'on', 'jitterAmount', jitterAmount);

% Highlight the scatter with the highest melanopic-EDI difference
High_Mel_DER_Diff = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff),:);
scatter(High_Mel_DER_Diff.CCT_Target, High_Mel_DER_Diff.Mel_DER250lx_Actual_MAX, MarkerSize,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'g', 'LineWidth', ScatterSze, 'jitter', 'on', 'jitterAmount', jitterAmount);

ylabel(t, 'Melanopic-DER', 'FontSize', 8, 'FontName', 'Charter');
xlabel(t, 'Duv from Planck', 'FontSize', 8, 'FontName', 'Charter');

YLim = [0.2, 0.8]; YLimTick = [0.2:0.2:0.8];
XLim = [2900.5, 2901.5]; XLimTick = [2900.5, 2901, 2901.5];
set(ax(1), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(1), GridLabel);

fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.5)
set(gcf, 'Position', [0.1, 11, 3, 3.15]); % [PositionDesk, PositionDesk, Width, Height]

if Boolean_Export == true
    exportgraphics(gcf, 'A02_Exported_Figures/Figure1C_Part_3.pdf','ContentType','vector')
end

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220

%% Figure 2A): Plotting the metameric tuning limits map using Delta melanopic-DER (250 photopic lux)
% As color quality criterion metric, we applied the TM30-20 definition of the Rf
% Thre thresholds were choosen according to the TM30-20 Annex E.4 "Recommended Color rendition.."
% Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
% Priority level 2 of Rf: Rf,h1 >= 90, Rf >=90

% CUSTOM VALUE: If you need to export the plot change this value to true
Boolean_Export = true;
% -----------------------------------------------------------------------

close all;
figure; t = tiledlayout(2,3, 'Padding', "tight", "TileSpacing", "compact");
set(gcf, 'Position', [0.1, 11, 14, 8]);
GridLabel = 'on';
MarkerSize = 5;
FontSize = 12;

% 6-Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85 -------------------------------
ax(1) = nexttile(1);
Titlestr = {'6-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'];
CurrentTable = Calculate_Contrast([85, 85], Optim_CH6_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_DER250lx_Actual_Diff);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
MaxMelValue_Array(1) = MAX_MelContrast.Mel_DER250lx_Actual_Diff;
CH6_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH6_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

u = CH6_CRI80_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH6_CRI80_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH6_CRI80_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH6_CRI80_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH6_CRI80_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH6_CRI80_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH6_CRI80_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH6_CRI80_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH6_CRI80_Spectrum_MAX_Mel_Contrast.x_Target, CH6_CRI80_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[1 1 1],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25);

% 8-Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85 -------------------------------
ax(2) = nexttile(2);
Titlestr = {'8-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'];
CurrentTable = Calculate_Contrast([85, 85], Optim_CH8_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_DER250lx_Actual_Diff);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
MaxMelValue_Array(2) = MAX_MelContrast.Mel_DER250lx_Actual_Diff;
CH8_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH8_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

u = CH8_CRI80_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH8_CRI80_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH8_CRI80_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH8_CRI80_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH8_CRI80_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH8_CRI80_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH8_CRI80_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH8_CRI80_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH8_CRI80_Spectrum_MAX_Mel_Contrast.x_Target, CH8_CRI80_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25); hold off;

% 11-Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85 -------------------------------
ax(3) = nexttile(3);
Titlestr = {'11-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'];
CurrentTable = Calculate_Contrast([85, 85], Optim_CH11_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_DER250lx_Actual_Diff);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
MaxMelValue_Array(3) = MAX_MelContrast.Mel_DER250lx_Actual_Diff;
CH11_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH11_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

u = CH11_CRI80_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH11_CRI80_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH11_CRI80_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH11_CRI80_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH11_CRI80_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH11_CRI80_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH11_CRI80_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH11_CRI80_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH11_CRI80_Spectrum_MAX_Mel_Contrast.x_Target, CH11_CRI80_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25); hold off;

% 6-Channel: Priority level 1 of Rf: Rf >=90 -------------------------------
ax(4) = nexttile(4);
Titlestr = {'6-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'];
CurrentTable = Calculate_Contrast([90, 90], Optim_CH6_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_DER250lx_Actual_Diff);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
MaxMelValue_Array(4) = MAX_MelContrast.Mel_DER250lx_Actual_Diff;
CH6_CRI90_Spectrum_MAX_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH6_CRI90_Spectrum_MIN_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

u = CH6_CRI90_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH6_CRI90_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH6_CRI90_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH6_CRI90_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH6_CRI90_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH6_CRI90_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH6_CRI90_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH6_CRI90_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH6_CRI90_Spectrum_MAX_Mel_Contrast.x_Target, CH6_CRI90_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25); hold off;

% 8-Channel: Priority level 1 of Rf: Rf >=90 -------------------------------
ax(5) = nexttile(5);
Titlestr = {'8-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'];
CurrentTable = Calculate_Contrast([90, 90], Optim_CH8_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_DER250lx_Actual_Diff);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
MaxMelValue_Array(5) = MAX_MelContrast.Mel_DER250lx_Actual_Diff;
CH8_CRI90_Spectrum_MAX_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH8_CRI90_Spectrum_MIN_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

u = CH8_CRI90_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH8_CRI90_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH8_CRI90_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH8_CRI90_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH8_CRI90_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH8_CRI90_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH8_CRI90_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH8_CRI90_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH8_CRI90_Spectrum_MAX_Mel_Contrast.x_Target, CH8_CRI90_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25); hold off;

% 11-Channel: Priority level 1 of Rf: Rf >=90 -------------------------------
ax(6) = nexttile(6);
Titlestr = {'11-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'];
CurrentTable = Calculate_Contrast([90, 90], Optim_CH11_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_DER250lx_Actual_Diff);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
MaxMelValue_Array(6) = MAX_MelContrast.Mel_DER250lx_Actual_Diff;
CH11_CRI90_Spectrum_MAX_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH11_CRI90_Spectrum_MIN_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

u = CH11_CRI90_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH11_CRI90_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH11_CRI90_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH11_CRI90_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH11_CRI90_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH11_CRI90_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH11_CRI90_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH11_CRI90_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH11_CRI90_Spectrum_MAX_Mel_Contrast.x_Target, CH11_CRI90_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25); hold off;

cb = colorbar(ax(end));
set(ax, 'Colormap', parula, 'CLim', [0 0.30])
cb.Ticks = [0:0.05:0.30];
set(ax,'colorscale','log')
%cb.Ruler.Scale = 'log';
cb.Layout.Tile = 'east';

YLim = [0.25, 0.45]; YLimTick = [0.25:0.05:0.45];
XLim = [0.25, 0.45]; XLimTick = [0.25:0.05:0.45];
xlabel(t, 'x', 'FontSize', 8, 'FontName', 'Charter');
ylabel(t, 'y', 'FontSize', 8, 'FontName', 'Charter');
set(ax(1), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(1), GridLabel);
set(ax(2), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(2), GridLabel);
set(ax(3), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(3), GridLabel);
set(ax(4), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(4), GridLabel);
set(ax(5), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(5), GridLabel);
set(ax(6), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(6), GridLabel);

fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.5)
set(gcf, 'Position', [0.1, 11, 15.8, 9]); % [PositionDesk, PositionDesk, Width, Height]

disp(MaxMelValue_Array)
%exportgraphics(gcf, 'A02_Exported_Figures/Figure2A.pdf','ContentType','vector')
%exportgraphics(gcf, 'A02_Exported_Figures/Figure2A_Bar.pdf','ContentType','vector')

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220

%% Figure 2B) Plotting the spectra with the highest Delta melanopic-DER
% As color quality criterion metric, we applied the TM30-20 definition of the Rf
% Thre thresholds were choosen according to the TM30-20 Annex E.4 "Recommended Color rendition.."
% Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
% Priority level 2 of Rf: Rf,h1 >= 90, Rf >=90

% CUSTOM VALUE: If you need to export the plot change this value to true
Boolean_Export = false;
% -----------------------------------------------------------------------

close all;
figure; t = tiledlayout(2,3, 'Padding', "tight", "TileSpacing", "compact");
set(gcf, 'Position', [0.1, 11, 12, 4]);

Color_MaximumDER = '#ec6c1a'; % Orange
Color_MinimumDER = '#0a65a8'; % Blue
GridLabel = 'off';
LineWidthPlot = 0.75;
FontSize = 12;

% 6 Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
ax(1) = nexttile(1);
CurrentTable = Calculate_Contrast([85, 85], Optim_CH6_L220);
MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
CH6_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH6_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH6_CRI80_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH6_CRI80_Spectrum_MIN_Mel_Contrast;
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumDER, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumDER, 'LineWidth', LineWidthPlot);
title('6 Channel LED luminaire');
subtitle({['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'],...
    ['$\gamma_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicDER_250lx, 2)),...
    '$,\ \gamma_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicDER_250lx, 2))]},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;


% 6 Channel: Priority level 2 of Rf: Rf,h1 >= 90, Rf >=90
ax(4) = nexttile(4);
CurrentTable = Calculate_Contrast([90, 90], Optim_CH6_L220);
MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
CH6_CRI90_Spectrum_MAX_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH6_CRI90_Spectrum_MIN_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH6_CRI90_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH6_CRI90_Spectrum_MIN_Mel_Contrast(1, :);
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumDER, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumDER, 'LineWidth', LineWidthPlot);
title('6 Channel LED luminaire');
subtitle({['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'],...
    ['$\gamma_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicDER_250lx, 2)),...
    '$,\ \gamma_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicDER_250lx, 2))]},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;

% 8 Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
ax(2) = nexttile(2);
CurrentTable = Calculate_Contrast([85, 85], Optim_CH8_L220);
MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
CH8_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH8_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH8_CRI80_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH8_CRI80_Spectrum_MIN_Mel_Contrast;
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumDER, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumDER, 'LineWidth', LineWidthPlot);
title('8 Channel LED luminaire');
subtitle({['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'],...
    ['$\gamma_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicDER_250lx, 2)),...
    '$,\ \gamma_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicDER_250lx, 2))]},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;

% 8 Channel: Priority level 2 of Rf: Rf,h1 >= 90, Rf >=90
ax(5) = nexttile(5);
CurrentTable = Calculate_Contrast([90, 90], Optim_CH8_L220);
MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
CH8_CRI90_Spectrum_MAX_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH8_CRI90_Spectrum_MIN_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH8_CRI90_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH8_CRI90_Spectrum_MIN_Mel_Contrast;
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumDER, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumDER, 'LineWidth', LineWidthPlot);
title('8 Channel LED luminaire');
subtitle({['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'],...
    ['$\gamma_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicDER_250lx, 2)),...
    '$,\ \gamma_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicDER_250lx, 2))]},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;

% 11 Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
ax(3) = nexttile(3);
CurrentTable = Calculate_Contrast([85, 85], Optim_CH11_L220);
MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
CH11_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH11_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH11_CRI80_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH11_CRI80_Spectrum_MIN_Mel_Contrast;
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumDER, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumDER, 'LineWidth', LineWidthPlot);
title('11 Channel LED luminaire');
subtitle({['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'],...
    ['$\gamma_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicDER_250lx, 2)),...
    '$,\ \gamma_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicDER_250lx, 2))]},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;

% 11 Channel: Priority level 2 of Rf: Rf,h1 >= 90, Rf >=90
ax(6) = nexttile(6);
CurrentTable = Calculate_Contrast([90, 90], Optim_CH11_L220);
MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
CH11_CRI90_Spectrum_MAX_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH11_CRI90_Spectrum_MIN_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH11_CRI90_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH11_CRI90_Spectrum_MIN_Mel_Contrast;
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumDER, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumDER, 'LineWidth', LineWidthPlot);
title('11 Channel LED luminaire');
subtitle({['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'],...
    ['$\gamma_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicDER_250lx, 2)),...
    '$,\ \gamma_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicDER_250lx, 2))]},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;

% Plot Einstellungen
YLim = [0, 1]; YLimTick = [0:0.5:1];
xlabel(t, 'Wavelength in nm', 'FontSize', 8, 'FontName', 'Charter');
ylabel(t, 'Relative irradiance in a.u.', 'FontSize', 8, 'FontName', 'Charter');
set(ax(1), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(1), GridLabel);
set(ax(2), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(2), GridLabel);
set(ax(3), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(3), GridLabel);
set(ax(4), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(4), GridLabel);
set(ax(5), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(5), GridLabel);
set(ax(6), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(6), GridLabel);

fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.75)
set(gcf, 'Position', [0.1, 11, 15.8, 6]); % [PositionDesk, PositionDesk, Width, Height]

if Boolean_Export == true
    exportgraphics(gcf, 'A02_Exported_Figures/Figure2B_MelDERSpectra.pdf','ContentType','vector')
end

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220

%% Figure 3A) Plotting the Michelson-Contrast in the CIExy-2°colour space
% As color quality criterion metric, we applied the TM30-20 definition of the Rf
% Thre thresholds were choosen according to the TM30-20 Annex E.4 "Recommended Color rendition.."
% Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
% Priority level 2 of Rf: Rf,h1 >= 90, Rf >=90

close all;
figure; t = tiledlayout(2,3, 'Padding', "tight", "TileSpacing", "compact");
set(gcf, 'Position', [0.1, 11, 14, 8]);
GridLabel = 'on';
MarkerSize = 6;
FontSize = 12;

% 6-Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
ax(1) = nexttile(1);
Titlestr = {'6-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'];
CurrentTable = Calculate_Contrast([85, 85], Optim_CH6_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

Comp = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actucal_MichelsonContrast;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == Comp, :);
MaxMelValue_Array(1) = MAX_MelContrast.Mel_EDI250lx_Actucal_MichelsonContrast;
CH6_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH6_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

u = CH6_CRI80_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH6_CRI80_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH6_CRI80_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH6_CRI80_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH6_CRI80_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH6_CRI80_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH6_CRI80_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH6_CRI80_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH6_CRI80_Spectrum_MAX_Mel_Contrast.x_Target, CH6_CRI80_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[1 1 1],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25);


% 8-Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
ax(2) = nexttile(2);
Titlestr = {'8-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'];
CurrentTable = Calculate_Contrast([85, 85], Optim_CH8_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

Comp = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actucal_MichelsonContrast;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == Comp, :);
MaxMelValue_Array(2) = MAX_MelContrast.Mel_EDI250lx_Actucal_MichelsonContrast;
CH8_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH8_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

u = CH8_CRI80_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH8_CRI80_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH8_CRI80_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH8_CRI80_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH8_CRI80_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH8_CRI80_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH8_CRI80_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH8_CRI80_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH8_CRI80_Spectrum_MAX_Mel_Contrast.x_Target, CH8_CRI80_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[1 1 1],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25); hold off;

% 11-Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
ax(3) = nexttile(3);
Titlestr = {'11-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'];
CurrentTable = Calculate_Contrast([85, 85], Optim_CH11_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

Comp = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actucal_MichelsonContrast;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == Comp, :);
MaxMelValue_Array(3) = MAX_MelContrast.Mel_EDI250lx_Actucal_MichelsonContrast;
CH11_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH11_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

u = CH11_CRI80_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH11_CRI80_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH11_CRI80_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH11_CRI80_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH11_CRI80_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH11_CRI80_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH11_CRI80_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH11_CRI80_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH11_CRI80_Spectrum_MAX_Mel_Contrast.x_Target, CH11_CRI80_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[1 1 1],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25); hold off;

% 6-Channel: Priority level 2 of Rf: Rf,h1 >= 90, Rf >=90
ax(4) = nexttile(4);
Titlestr = {'6-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'];
CurrentTable = Calculate_Contrast([90, 90], Optim_CH6_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

Comp = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actucal_MichelsonContrast;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == Comp, :);
MaxMelValue_Array(4) = MAX_MelContrast.Mel_EDI250lx_Actucal_MichelsonContrast;
CH6_CRI90_Spectrum_MAX_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH6_CRI90_Spectrum_MIN_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

u = CH6_CRI90_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH6_CRI90_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH6_CRI90_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH6_CRI90_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH6_CRI90_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH6_CRI90_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH6_CRI90_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH6_CRI90_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH6_CRI90_Spectrum_MAX_Mel_Contrast.x_Target, CH6_CRI90_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[1 1 1],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25); hold off;

% 8-Channel: Priority level 2 of Rf: Rf,h1 >= 90, Rf >=90
ax(5) = nexttile(5);
Titlestr = {'8-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'];
CurrentTable = Calculate_Contrast([90, 90], Optim_CH8_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

Comp = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actucal_MichelsonContrast;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == Comp, :);
MaxMelValue_Array(5) = MAX_MelContrast.Mel_EDI250lx_Actucal_MichelsonContrast;
CH8_CRI90_Spectrum_MAX_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH8_CRI90_Spectrum_MIN_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

u = CH8_CRI90_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH8_CRI90_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH8_CRI90_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH8_CRI90_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH8_CRI90_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH8_CRI90_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH8_CRI90_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH8_CRI90_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH8_CRI90_Spectrum_MAX_Mel_Contrast.x_Target, CH8_CRI90_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[1 1 1],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25); hold off;

% 11-Channel: Priority level 2 of Rf: Rf,h1 >= 90, Rf >=90
ax(6) = nexttile(6);
Titlestr = {'11-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'];
CurrentTable = Calculate_Contrast([90, 90], Optim_CH11_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

Comp = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actucal_MichelsonContrast;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == Comp, :);
MaxMelValue_Array(6) = MAX_MelContrast.Mel_EDI250lx_Actucal_MichelsonContrast;
CH11_CRI90_Spectrum_MAX_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH11_CRI90_Spectrum_MIN_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

u = CH11_CRI90_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH11_CRI90_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH11_CRI90_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH11_CRI90_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH11_CRI90_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH11_CRI90_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH11_CRI90_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH11_CRI90_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH11_CRI90_Spectrum_MAX_Mel_Contrast.x_Target, CH11_CRI90_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[1 1 1],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.3); hold off;

cb = colorbar(ax(end));
set(ax, 'Colormap', parula, 'CLim', [0 0.18])
cb.Ticks = [0:0.045:0.18];
%set(ax,'colorscale','log')
%cb.Ruler.Scale = 'log';
cb.Layout.Tile = 'east';

YLim = [0.25, 0.45]; YLimTick = [0.25:0.05:0.45];
XLim = [0.25, 0.45]; XLimTick = [0.25:0.05:0.45];
xlabel(t, 'x', 'FontSize', 8, 'FontName', 'Charter');
ylabel(t, 'y', 'FontSize', 8, 'FontName', 'Charter');
set(ax(1), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(1), GridLabel);
set(ax(2), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(2), GridLabel);
set(ax(3), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(3), GridLabel);
set(ax(4), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(4), GridLabel);
set(ax(5), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(5), GridLabel);
set(ax(6), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(6), GridLabel);

fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.5)
set(gcf, 'Position', [0.1, 11, 15.8, 9]); % [PositionDesk, PositionDesk, Width, Height]

disp(MaxMelValue_Array)
%exportgraphics(gcf, 'A02_Exported_Figures/Figure3A.pdf','ContentType','vector')
%exportgraphics(gcf, 'A02_Exported_Figures/Figure3A_Bar.pdf','ContentType','vector')

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220

%% Figure 3B) Plotting the spectra with the maximum Michelson-Contrast
% As color quality criterion metric, we applied the TM30-20 definition of the Rf
% Thre thresholds were choosen according to the TM30-20 Annex E.4 "Recommended Color rendition.."
% Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
% Priority level 2 of Rf: Rf,h1 >= 90, Rf >=90

% CUSTOM VALUE: If you need to export the plot change this value to true
Boolean_Export = true;
% -----------------------------------------------------------------------

close all;
figure; t = tiledlayout(2,3, 'Padding', "tight", "TileSpacing", "compact");
set(gcf, 'Position', [0.1, 11, 12, 4]);

Color_MaximumEDI = '#ec6c1a'; % Orange
Color_MinimumEDI = '#0a65a8'; % Blue
GridLabel = 'off';
LineWidthPlot = 0.75;
FontSize = 12;

% 6 Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
ax(1) = nexttile(1);
CurrentTable = Calculate_Contrast([85, 85], Optim_CH6_L220);
Comp_1 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actual_Diff;
Comp_2 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).DUV_signed;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == Comp_1 & CurrentTable.DUV_signed == Comp_2, :);
CH6_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH6_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH6_CRI80_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH6_CRI80_Spectrum_MIN_Mel_Contrast;
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumEDI, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumEDI, 'LineWidth', LineWidthPlot);
title('6 Channel LED luminaire');
subtitle({['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'],...
    ['$\gamma_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicDER_250lx, 2))],...
    ['$\gamma_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicDER_250lx, 2))]},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;


% 6 Channel: Priority level 2 of Rf: Rf,h1 >= 90, Rf >=90
ax(4) = nexttile(4);
CurrentTable = Calculate_Contrast([90, 90], Optim_CH6_L220);
Comp_1 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actual_Diff;
Comp_2 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).DUV_signed;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == Comp_1 & CurrentTable.DUV_signed == Comp_2, :);
CH6_CRI90_Spectrum_MAX_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH6_CRI90_Spectrum_MIN_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH6_CRI90_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH6_CRI90_Spectrum_MIN_Mel_Contrast(1, :);
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumEDI, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumEDI, 'LineWidth', LineWidthPlot);
title('6 Channel LED luminaire');
subtitle({['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'],...
    ['$\gamma_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicDER_250lx, 2))],...
    ['$\gamma_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicDER_250lx, 2))]},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;

% 8 Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
ax(2) = nexttile(2);
CurrentTable = Calculate_Contrast([85, 85], Optim_CH8_L220);
Comp_1 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actual_Diff;
Comp_2 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).DUV_signed;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == Comp_1 & CurrentTable.DUV_signed == Comp_2, :);
CH8_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH8_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH8_CRI80_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH8_CRI80_Spectrum_MIN_Mel_Contrast;
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumEDI, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumEDI, 'LineWidth', LineWidthPlot);
title('8 Channel LED luminaire');
subtitle({['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'],...
    ['$\gamma_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicDER_250lx, 2))],...
    ['$\gamma_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicDER_250lx, 2))]},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;

% 8 Channel:  Priority level 2 of Rf: Rf,h1 >= 90, Rf >=90
ax(5) = nexttile(5);
CurrentTable = Calculate_Contrast([90, 90], Optim_CH8_L220);
Comp_1 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actual_Diff;
Comp_2 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).DUV_signed;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == Comp_1 & CurrentTable.DUV_signed == Comp_2, :);
CH8_CRI90_Spectrum_MAX_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH8_CRI90_Spectrum_MIN_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH8_CRI90_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH8_CRI90_Spectrum_MIN_Mel_Contrast;
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumEDI, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumEDI, 'LineWidth', LineWidthPlot);
title('8 Channel LED luminaire');
subtitle({['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'],...
    ['$\gamma_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicDER_250lx, 2))],...
    ['$\gamma_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicDER_250lx, 2))]},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;

% 11 Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
ax(3) = nexttile(3);
CurrentTable = Calculate_Contrast([85, 85], Optim_CH11_L220);
Comp_1 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actual_Diff;
Comp_2 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).DUV_signed;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == Comp_1 & CurrentTable.DUV_signed == Comp_2, :);
CH11_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH11_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH11_CRI80_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH11_CRI80_Spectrum_MIN_Mel_Contrast;
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumEDI, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumEDI, 'LineWidth', LineWidthPlot);
title('11 Channel LED luminaire');
subtitle({['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'],...
    ['$\gamma_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicDER_250lx, 2))],...
    ['$\gamma_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicDER_250lx, 2))]},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;;

% 11 Channel: Priority level 2 of Rf: Rf,h1 >= 90, Rf >=90
ax(6) = nexttile(6);
CurrentTable = Calculate_Contrast([90, 90], Optim_CH11_L220);
Comp_1 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actual_Diff;
Comp_2 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).DUV_signed;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == Comp_1 & CurrentTable.DUV_signed == Comp_2, :);
CH11_CRI90_Spectrum_MAX_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH11_CRI90_Spectrum_MIN_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH11_CRI90_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH11_CRI90_Spectrum_MIN_Mel_Contrast;
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumEDI, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumEDI, 'LineWidth', LineWidthPlot);
title('11 Channel LED luminaire');
subtitle({['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'],...
    ['$\gamma_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicDER_250lx, 2))],...
    ['$\gamma_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicDER_250lx, 2))]},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;

% Plot Einstellungen
YLim = [0, 1]; YLimTick = [0:0.5:1];
xlabel(t, 'Wavelength in nm', 'FontSize', 8, 'FontName', 'Charter');
ylabel(t, 'Relative irradiance in a.u.', 'FontSize', 8, 'FontName', 'Charter');
set(ax(1), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(1), GridLabel);
set(ax(2), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(2), GridLabel);
set(ax(3), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(3), GridLabel);
set(ax(4), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(4), GridLabel);
set(ax(5), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(5), GridLabel);
set(ax(6), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(6), GridLabel);

fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.75)
set(gcf, 'Position', [0.1, 11, 15.8, 7]); % [PositionDesk, PositionDesk, Width, Height]

if Boolean_Export == true
    exportgraphics(gcf, 'A02_Exported_Figures/Figure3B_MelCMSpectra.pdf','ContentType','vector')
end

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220

%% Figure 4A) Plotting melanopic-DER metamer against CCT (min, max)
% As color quality criterion metric, we applied the TM30-20 definition of the Rf
% Thre thresholds were choosen according to the TM30-20 Annex E.4 "Recommended Color rendition.."
% Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
% Priority level 2 of Rf: Rf,h1 >= 90, Rf >=90

% CUSTOM VALUE: If you need to export the plot change this value to true
Boolean_Export = true;
% -----------------------------------------------------------------------

close all;
figure; t = tiledlayout(2, 3, 'Padding', "tight", "TileSpacing", "loose");
set(gcf, 'Position', [0.1, 11, 10, 4]);
GridLabel = 'on';

ax = [];
MarkerSize = 5;
jitterAmount = 5;
MarkerEdgeAlpha = 0.15;
MarkerFaceAlpha = 0.15;
FontSize = 12;

ax(1) = nexttile(1);
Titlestr = {'6-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'];
CurrentTable = Calculate_Contrast([85, 85], Optim_CH6_L220);
scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_MIN, MarkerSize,...
    'MarkerEdgeColor','k',...
    'MarkerEdgeAlpha',MarkerEdgeAlpha,...
    'MarkerFaceColor','none',...
    'jitter', 'on', 'jitterAmount', jitterAmount); hold on;

scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_MAX, MarkerSize,...
    'MarkerEdgeColor','none',...
    'MarkerFaceColor','r',...
    'MarkerFaceAlpha',MarkerFaceAlpha,...
    'jitter', 'on', 'jitterAmount', jitterAmount);

% Calculate max and min melanopic-DER for each CCT step from all Duvs
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) min(x), CurrentTable.Mel_DER250lx_Actual_MIN, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    'VariableNames', {'CCT' 'MIN' 'MAX'});

plot(TableMaxMin_mDER.CCT, TableMaxMin_mDER.MIN, 'LineWidth', 1, 'Color', 'k', 'LineStyle', '-');
plot(TableMaxMin_mDER.CCT, TableMaxMin_mDER.MAX, 'LineWidth', 1, 'Color', 'r', 'LineStyle', '-'); hold on;

y = [1 1.3 1.3 1];
x = [2500 2500 7500 7500];
PatchObject = patch(x, y, 'k', 'EdgeColor', 'none', 'FaceAlpha', .1);
PatchObject.FaceColor = '#0072BD';

title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');

ax(2) = nexttile(2);
Titlestr = {'8-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'];
CurrentTable = Calculate_Contrast([85, 85], Optim_CH8_L220);
scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_MIN, MarkerSize,...
    'MarkerEdgeColor','k',...
    'MarkerEdgeAlpha',MarkerEdgeAlpha,...
    'MarkerFaceColor','none',...
    'jitter', 'on', 'jitterAmount', jitterAmount); hold on;

scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_MAX, MarkerSize,...
    'MarkerEdgeColor','none',...
    'MarkerFaceColor','r',...
    'MarkerFaceAlpha',MarkerFaceAlpha,...
    'jitter', 'on', 'jitterAmount', jitterAmount);

% Calculate max and min melanopic-DER for each CCT step from all Duvs
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) min(x), CurrentTable.Mel_DER250lx_Actual_MIN, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    'VariableNames', {'CCT' 'MIN' 'MAX'});

plot(TableMaxMin_mDER.CCT, TableMaxMin_mDER.MIN, 'LineWidth', 1, 'Color', 'k', 'LineStyle', '-');
plot(TableMaxMin_mDER.CCT, TableMaxMin_mDER.MAX, 'LineWidth', 1, 'Color', 'r', 'LineStyle', '-'); hold on;

y = [1 1.3 1.3 1];
x = [2500 2500 7500 7500];
PatchObject = patch(x, y, 'k', 'EdgeColor', 'none', 'FaceAlpha', .1);
PatchObject.FaceColor = '#0072BD';

title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');

ax(3) = nexttile(3);
Titlestr = {'11-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'];
CurrentTable = Calculate_Contrast([85, 85], Optim_CH11_L220);
scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_MIN, MarkerSize,...
    'MarkerEdgeColor','k',...
    'MarkerEdgeAlpha',MarkerEdgeAlpha,...
    'MarkerFaceColor','none',...
    'jitter', 'on', 'jitterAmount', jitterAmount); hold on;

scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_MAX, MarkerSize,...
    'MarkerEdgeColor','none',...
    'MarkerFaceColor','r',...
    'MarkerFaceAlpha',MarkerFaceAlpha,...
    'jitter', 'on', 'jitterAmount', jitterAmount);

% Calculate max and min melanopic-DER for each CCT step from all Duvs
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) min(x), CurrentTable.Mel_DER250lx_Actual_MIN, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    'VariableNames', {'CCT' 'MIN' 'MAX'});

plot(TableMaxMin_mDER.CCT, TableMaxMin_mDER.MIN, 'LineWidth', 1, 'Color', 'k', 'LineStyle', '-');
plot(TableMaxMin_mDER.CCT, TableMaxMin_mDER.MAX, 'LineWidth', 1, 'Color', 'r', 'LineStyle', '-'); hold on;

y = [1 1.3 1.3 1];
x = [2500 2500 7500 7500];
PatchObject = patch(x, y, 'k', 'EdgeColor', 'none', 'FaceAlpha', .1);
PatchObject.FaceColor = '#0072BD';

title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');

ax(4) = nexttile(4);
Titlestr = {'6-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'];
CurrentTable = Calculate_Contrast([90, 90], Optim_CH6_L220);
scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_MIN, MarkerSize,...
    'MarkerEdgeColor','k',...
    'MarkerEdgeAlpha',MarkerEdgeAlpha,...
    'MarkerFaceColor','none',...
    'jitter', 'on', 'jitterAmount', jitterAmount); hold on;

scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_MAX, MarkerSize,...
    'MarkerEdgeColor','none',...
    'MarkerFaceColor','r',...
    'MarkerFaceAlpha',MarkerFaceAlpha,...
    'jitter', 'on', 'jitterAmount', jitterAmount);

% Calculate max and min melanopic-DER for each CCT step from all Duvs
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) min(x), CurrentTable.Mel_DER250lx_Actual_MIN, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    'VariableNames', {'CCT' 'MIN' 'MAX'});

plot(TableMaxMin_mDER.CCT, TableMaxMin_mDER.MIN, 'LineWidth', 1, 'Color', 'k', 'LineStyle', '-');
plot(TableMaxMin_mDER.CCT, TableMaxMin_mDER.MAX, 'LineWidth', 1, 'Color', 'r', 'LineStyle', '-'); hold on;

y = [1 1.3 1.3 1];
x = [2500 2500 7500 7500];
PatchObject = patch(x, y, 'k', 'EdgeColor', 'none', 'FaceAlpha', .1);
PatchObject.FaceColor = '#0072BD';

title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');


ax(5) = nexttile(5);
Titlestr = {'8-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'];
CurrentTable = Calculate_Contrast([90, 90], Optim_CH8_L220);
scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_MIN, MarkerSize,...
    'MarkerEdgeColor','k',...
    'MarkerEdgeAlpha',MarkerEdgeAlpha,...
    'MarkerFaceColor','none',...
    'jitter', 'on', 'jitterAmount', jitterAmount); hold on;

scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_MAX, MarkerSize,...
    'MarkerEdgeColor','none',...
    'MarkerFaceColor','r',...
    'MarkerFaceAlpha',MarkerFaceAlpha,...
    'jitter', 'on', 'jitterAmount', jitterAmount);

% Calculate max and min melanopic-DER for each CCT step from all Duvs
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) min(x), CurrentTable.Mel_DER250lx_Actual_MIN, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    'VariableNames', {'CCT' 'MIN' 'MAX'});

plot(TableMaxMin_mDER.CCT, TableMaxMin_mDER.MIN, 'LineWidth', 1, 'Color', 'k', 'LineStyle', '-');
plot(TableMaxMin_mDER.CCT, TableMaxMin_mDER.MAX, 'LineWidth', 1, 'Color', 'r', 'LineStyle', '-'); hold on;

y = [1 1.3 1.3 1];
x = [2500 2500 7500 7500];
PatchObject = patch(x, y, 'k', 'EdgeColor', 'none', 'FaceAlpha', .1);
PatchObject.FaceColor = '#0072BD';

title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');


ax(6) = nexttile(6);
Titlestr = {'11-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'];
CurrentTable = Calculate_Contrast([90, 90], Optim_CH11_L220);
scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_MIN, MarkerSize,...
    'MarkerEdgeColor','k',...
    'MarkerEdgeAlpha',MarkerEdgeAlpha,...
    'MarkerFaceColor','none',...
    'jitter', 'on', 'jitterAmount', jitterAmount); hold on;

scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_MAX, MarkerSize,...
    'MarkerEdgeColor','none',...
    'MarkerFaceColor','r',...
    'MarkerFaceAlpha',MarkerFaceAlpha,...
    'jitter', 'on', 'jitterAmount', jitterAmount);

% Calculate max and min melanopic-DER for each CCT step from all Duvs
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) min(x), CurrentTable.Mel_DER250lx_Actual_MIN, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    'VariableNames', {'CCT' 'MIN' 'MAX'});

plot(TableMaxMin_mDER.CCT, TableMaxMin_mDER.MIN, 'LineWidth', 1, 'Color', 'k', 'LineStyle', '-');
plot(TableMaxMin_mDER.CCT, TableMaxMin_mDER.MAX, 'LineWidth', 1, 'Color', 'r', 'LineStyle', '-'); hold on;

y = [1 1.3 1.3 1];
x = [2500 2500 7500 7500];
PatchObject = patch(x, y, 'k', 'EdgeColor', 'none', 'FaceAlpha', .1);
PatchObject.FaceColor = '#0072BD';

title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');


% Plotting preferences
YLim = [0.3, 1.3]; YLimTick = [0.3:0.2:1.3];
XLim = [2500, 7500]; XLimTick = [2500:1000:7500];
xlabel(t, 'Correlated Colour Temperatur in K', 'FontSize', 8, 'FontName', 'Charter');
ylabel(t, 'melanopic-DER', 'FontSize', 8, 'FontName', 'Charter');
set(ax(1), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','on', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(1), GridLabel);
set(ax(2), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','on', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(2), GridLabel);
set(ax(3), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','on', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(3), GridLabel);
set(ax(4), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','on', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(4), GridLabel);
set(ax(5), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','on', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(5), GridLabel);
set(ax(6), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','on', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(6), GridLabel);

xticklabels(ax(1),{})
xticklabels(ax(2),{})
xticklabels(ax(3),{})

yticklabels(ax(2),{})
yticklabels(ax(3),{})
yticklabels(ax(5),{})
yticklabels(ax(6),{})
t.TileSpacing = 'compact';


fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.5)
set(gcf, 'Position', [0.1, 11, 15.8, 6]); % [PositionDesk, PositionDesk, Width, Height]

if Boolean_Export == true
    exportgraphics(gcf, 'A02_Exported_Figures/Figure4A.pdf','ContentType','vector')
end

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220


%% Figure 4B) Plotting melanopic-DER color-space path of max and max-deviation
% As color quality criterion metric, we applied the TM30-20 definition of the Rf
% Thre thresholds were choosen according to the TM30-20 Annex E.4 "Recommended Color rendition.."
% Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
% Priority level 2 of Rf: Rf,h1 >= 90, Rf >=90

% CUSTOM VALUE: If you need to export the plot change this value to true
Boolean_Export = true;
% -----------------------------------------------------------------------

close all;
figure; t = tiledlayout(2,3, 'Padding', "tight", "TileSpacing", "compact");
set(gcf, 'Position', [0.1, 11, 14, 8]);
GridLabel = 'on';
MarkerSize = 8;
ScatterSze = 0.5;
FontSize = 12;

% 6-Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
ax(1) = nexttile(1);
Titlestr = {'6-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'];
CurrentTable = Calculate_Contrast([85, 85], Optim_CH6_L220);
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_EDI250lx_Actual_Diff, G),...
    splitapply(@(x) min(x), CurrentTable.Mel_DER250lx_Actual_MIN, G),...
    'VariableNames', {'CCT' 'MAX_MelDER' 'MAXDelta_MelEDI', 'MIN_MelDER'});

MAX_MelDERx = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:).x;
MAX_MelDERy = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:).y;

MIN_MelDERx = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MIN,TableMaxMin_mDER.MIN_MelDER),:).x;
MIN_MelDERy = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MIN,TableMaxMin_mDER.MIN_MelDER),:).y;

MAXDelta_MelEDIx = CurrentTable(ismember(CurrentTable.Mel_EDI250lx_Actual_Diff,TableMaxMin_mDER.MAXDelta_MelEDI),:).x;
MAXDelta_MelEDIy = CurrentTable(ismember(CurrentTable.Mel_EDI250lx_Actual_Diff,TableMaxMin_mDER.MAXDelta_MelEDI),:).y;

plot_CCTLocus(false, true, [], []); hold on;
scatter(MAX_MelDERx, MAX_MelDERy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'r', 'LineWidth', ScatterSze);
%scatter(MAX_MelDERx, MAX_MelDERy, MarkerSize, 'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', 'r', 'LineWidth', ScatterSze)
plot(MAX_MelDERx, MAX_MelDERy, 'Color', 'r', 'LineWidth', 0.5)
scatter(MAXDelta_MelEDIx, MAXDelta_MelEDIy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'b', 'LineWidth', ScatterSze);
%scatter(MAXDelta_MelEDIx, MAXDelta_MelEDIy, MarkerSize,'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', 'b', 'LineWidth',ScatterSze)
plot(MAXDelta_MelEDIx, MAXDelta_MelEDIy, 'Color', 'b', 'LineWidth', 0.5)
scatter(MIN_MelDERx, MIN_MelDERy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', '#77AC30', 'LineWidth', ScatterSze);
plot(MIN_MelDERx, MIN_MelDERy, 'Color', '#77AC30', 'LineWidth', 0.5)
xlim([0.25, 0.45]); ylim([0.25, 0.5]); hold off;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');

% 8-Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
ax(2) = nexttile(2);
Titlestr = {'8-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'];
CurrentTable = Calculate_Contrast([85, 85], Optim_CH8_L220);
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_EDI250lx_Actual_Diff, G),...
    splitapply(@(x) min(x), CurrentTable.Mel_DER250lx_Actual_MIN, G),...
    'VariableNames', {'CCT' 'MAX_MelDER' 'MAXDelta_MelEDI', 'MIN_MelDER'});

MAX_MelDERx = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:).x;
MAX_MelDERy = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:).y;

MIN_MelDERx = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MIN,TableMaxMin_mDER.MIN_MelDER),:).x;
MIN_MelDERy = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MIN,TableMaxMin_mDER.MIN_MelDER),:).y;

MAXDelta_MelEDIx = CurrentTable(ismember(CurrentTable.Mel_EDI250lx_Actual_Diff,TableMaxMin_mDER.MAXDelta_MelEDI),:).x;
MAXDelta_MelEDIy = CurrentTable(ismember(CurrentTable.Mel_EDI250lx_Actual_Diff,TableMaxMin_mDER.MAXDelta_MelEDI),:).y;

plot_CCTLocus(false, true, [], []); hold on;
scatter(MAX_MelDERx, MAX_MelDERy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'r', 'LineWidth', ScatterSze);
%scatter(MAX_MelDERx, MAX_MelDERy, MarkerSize, 'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', 'r', 'LineWidth', ScatterSze)
plot(MAX_MelDERx, MAX_MelDERy, 'Color', 'r', 'LineWidth', 0.5)
scatter(MAXDelta_MelEDIx, MAXDelta_MelEDIy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'b', 'LineWidth', ScatterSze);
%scatter(MAXDelta_MelEDIx, MAXDelta_MelEDIy, MarkerSize,'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', 'b', 'LineWidth',ScatterSze)
plot(MAXDelta_MelEDIx, MAXDelta_MelEDIy, 'Color', 'b', 'LineWidth', 0.5)
scatter(MIN_MelDERx, MIN_MelDERy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', '#77AC30', 'LineWidth', ScatterSze);
plot(MIN_MelDERx, MIN_MelDERy, 'Color', '#77AC30', 'LineWidth', 0.5)
xlim([0.25, 0.45]); ylim([0.25, 0.5]); hold off;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');

% 11-Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
ax(3) = nexttile(3);
Titlestr = {'11-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'];
CurrentTable = Calculate_Contrast([85, 85], Optim_CH11_L220);
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_EDI250lx_Actual_Diff, G),...
    splitapply(@(x) min(x), CurrentTable.Mel_DER250lx_Actual_MIN, G),...
    'VariableNames', {'CCT' 'MAX_MelDER' 'MAXDelta_MelEDI', 'MIN_MelDER'});

MAX_MelDERx = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:).x;
MAX_MelDERy = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:).y;

MIN_MelDERx = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MIN,TableMaxMin_mDER.MIN_MelDER),:).x;
MIN_MelDERy = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MIN,TableMaxMin_mDER.MIN_MelDER),:).y;

MAXDelta_MelEDIx = CurrentTable(ismember(CurrentTable.Mel_EDI250lx_Actual_Diff,TableMaxMin_mDER.MAXDelta_MelEDI),:).x;
MAXDelta_MelEDIy = CurrentTable(ismember(CurrentTable.Mel_EDI250lx_Actual_Diff,TableMaxMin_mDER.MAXDelta_MelEDI),:).y;

plot_CCTLocus(false, true, [], []); hold on;
scatter(MAX_MelDERx, MAX_MelDERy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'r', 'LineWidth', ScatterSze);
%scatter(MAX_MelDERx, MAX_MelDERy, MarkerSize, 'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', 'r', 'LineWidth', ScatterSze)
plot(MAX_MelDERx, MAX_MelDERy, 'Color', 'r', 'LineWidth', 0.5)
scatter(MAXDelta_MelEDIx, MAXDelta_MelEDIy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'b', 'LineWidth', ScatterSze);
%scatter(MAXDelta_MelEDIx, MAXDelta_MelEDIy, MarkerSize,'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', 'b', 'LineWidth',ScatterSze)
plot(MAXDelta_MelEDIx, MAXDelta_MelEDIy, 'Color', 'b', 'LineWidth', 0.5)
scatter(MIN_MelDERx, MIN_MelDERy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', '#77AC30', 'LineWidth', ScatterSze);
plot(MIN_MelDERx, MIN_MelDERy, 'Color', '#77AC30', 'LineWidth', 0.5)
xlim([0.25, 0.45]); ylim([0.25, 0.5]); hold off;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');

% 6-Channel: Priority level 3 of Rf: Rf,h1 >= 90, Rf >=90
ax(4) = nexttile(4);
Titlestr = {'6-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'];
CurrentTable = Calculate_Contrast([90, 90], Optim_CH6_L220);
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_EDI250lx_Actual_Diff, G),...
    splitapply(@(x) min(x), CurrentTable.Mel_DER250lx_Actual_MIN, G),...
    'VariableNames', {'CCT' 'MAX_MelDER' 'MAXDelta_MelEDI', 'MIN_MelDER'});

MAX_MelDERx = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:).x;
MAX_MelDERy = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:).y;

MIN_MelDERx = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MIN,TableMaxMin_mDER.MIN_MelDER),:).x;
MIN_MelDERy = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MIN,TableMaxMin_mDER.MIN_MelDER),:).y;

MAXDelta_MelEDIx = CurrentTable(ismember(CurrentTable.Mel_EDI250lx_Actual_Diff,TableMaxMin_mDER.MAXDelta_MelEDI),:).x;
MAXDelta_MelEDIy = CurrentTable(ismember(CurrentTable.Mel_EDI250lx_Actual_Diff,TableMaxMin_mDER.MAXDelta_MelEDI),:).y;

plot_CCTLocus(false, true, [], []); hold on;
scatter(MAX_MelDERx, MAX_MelDERy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'r', 'LineWidth', ScatterSze);
%scatter(MAX_MelDERx, MAX_MelDERy, MarkerSize, 'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', 'r', 'LineWidth', ScatterSze)
plot(MAX_MelDERx, MAX_MelDERy, 'Color', 'r', 'LineWidth', 0.5)
scatter(MAXDelta_MelEDIx, MAXDelta_MelEDIy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'b', 'LineWidth', ScatterSze);
%scatter(MAXDelta_MelEDIx, MAXDelta_MelEDIy, MarkerSize,'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', 'b', 'LineWidth',ScatterSze)
plot(MAXDelta_MelEDIx, MAXDelta_MelEDIy, 'Color', 'b', 'LineWidth', 0.5)
scatter(MIN_MelDERx, MIN_MelDERy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', '#77AC30', 'LineWidth', ScatterSze);
plot(MIN_MelDERx, MIN_MelDERy, 'Color', '#77AC30', 'LineWidth', 0.5)
xlim([0.25, 0.45]); ylim([0.25, 0.5]); hold off;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');

% 8-Channel: Priority level 3 of Rf: Rf,h1 >= 90, Rf >=90
ax(5) = nexttile(5);
Titlestr = {'8-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'];
CurrentTable = Calculate_Contrast([90, 90], Optim_CH8_L220);
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_EDI250lx_Actual_Diff, G),...
    splitapply(@(x) min(x), CurrentTable.Mel_DER250lx_Actual_MIN, G),...
    'VariableNames', {'CCT' 'MAX_MelDER' 'MAXDelta_MelEDI', 'MIN_MelDER'});

MAX_MelDERx = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:).x;
MAX_MelDERy = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:).y;

MIN_MelDERx = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MIN,TableMaxMin_mDER.MIN_MelDER),:).x;
MIN_MelDERy = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MIN,TableMaxMin_mDER.MIN_MelDER),:).y;

MAXDelta_MelEDIx = CurrentTable(ismember(CurrentTable.Mel_EDI250lx_Actual_Diff,TableMaxMin_mDER.MAXDelta_MelEDI),:).x;
MAXDelta_MelEDIy = CurrentTable(ismember(CurrentTable.Mel_EDI250lx_Actual_Diff,TableMaxMin_mDER.MAXDelta_MelEDI),:).y;

plot_CCTLocus(false, true, [], []); hold on;
scatter(MAX_MelDERx, MAX_MelDERy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'r', 'LineWidth', ScatterSze);
%scatter(MAX_MelDERx, MAX_MelDERy, MarkerSize, 'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', 'r', 'LineWidth', ScatterSze)
plot(MAX_MelDERx, MAX_MelDERy, 'Color', 'r', 'LineWidth', 0.5)
scatter(MAXDelta_MelEDIx, MAXDelta_MelEDIy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'b', 'LineWidth', ScatterSze);
%scatter(MAXDelta_MelEDIx, MAXDelta_MelEDIy, MarkerSize,'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', 'b', 'LineWidth',ScatterSze)
plot(MAXDelta_MelEDIx, MAXDelta_MelEDIy, 'Color', 'b', 'LineWidth', 0.5)
scatter(MIN_MelDERx, MIN_MelDERy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', '#77AC30', 'LineWidth', ScatterSze);
plot(MIN_MelDERx, MIN_MelDERy, 'Color', '#77AC30', 'LineWidth', 0.5)
xlim([0.25, 0.45]); ylim([0.25, 0.5]); hold off;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');

% 11-Channel: Priority level 3 of Rf: Rf,h1 >= 90, Rf >=90
ax(6) = nexttile(6);
Titlestr = {'11-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'];
CurrentTable = Calculate_Contrast([90, 90], Optim_CH11_L220);
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_EDI250lx_Actual_Diff, G),...
    splitapply(@(x) min(x), CurrentTable.Mel_DER250lx_Actual_MIN, G),...
    'VariableNames', {'CCT' 'MAX_MelDER' 'MAXDelta_MelEDI', 'MIN_MelDER'});

MAX_MelDERx = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:).x;
MAX_MelDERy = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:).y;

MIN_MelDERx = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MIN,TableMaxMin_mDER.MIN_MelDER),:).x;
MIN_MelDERy = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MIN,TableMaxMin_mDER.MIN_MelDER),:).y;

MAXDelta_MelEDIx = CurrentTable(ismember(CurrentTable.Mel_EDI250lx_Actual_Diff,TableMaxMin_mDER.MAXDelta_MelEDI),:).x;
MAXDelta_MelEDIy = CurrentTable(ismember(CurrentTable.Mel_EDI250lx_Actual_Diff,TableMaxMin_mDER.MAXDelta_MelEDI),:).y;

plot_CCTLocus(false, true, [], []); hold on;
scatter(MAX_MelDERx, MAX_MelDERy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'r', 'LineWidth', ScatterSze);
%scatter(MAX_MelDERx, MAX_MelDERy, MarkerSize, 'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', 'r', 'LineWidth', ScatterSze)
plot(MAX_MelDERx, MAX_MelDERy, 'Color', 'r', 'LineWidth', 0.5)
scatter(MAXDelta_MelEDIx, MAXDelta_MelEDIy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'b', 'LineWidth', ScatterSze);
%scatter(MAXDelta_MelEDIx, MAXDelta_MelEDIy, MarkerSize,'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', 'b', 'LineWidth',ScatterSze)
plot(MAXDelta_MelEDIx, MAXDelta_MelEDIy, 'Color', 'b', 'LineWidth', 0.5)
scatter(MIN_MelDERx, MIN_MelDERy, 15,...
    'MarkerEdgeColor', 'w', 'MarkerFaceColor', '#77AC30', 'LineWidth', ScatterSze);
plot(MIN_MelDERx, MIN_MelDERy, 'Color', '#77AC30', 'LineWidth', 0.5)
xlim([0.25, 0.45]); ylim([0.25, 0.5]); hold off;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');


YLim = [0.25, 0.5]; YLimTick = [0.25:0.05:0.5];
XLim = [0.25, 0.5]; XLimTick = [0.25:0.05:0.5];
xlabel(t, 'x', 'FontSize', 8, 'FontName', 'Charter');
ylabel(t, 'y', 'FontSize', 8, 'FontName', 'Charter');
set(ax(1), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(1), GridLabel);
set(ax(2), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(2), GridLabel);
set(ax(3), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(3), GridLabel);
set(ax(4), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(4), GridLabel);
set(ax(5), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(5), GridLabel);
set(ax(6), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(6), GridLabel);

fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.5)
set(gcf, 'Position', [0.1, 11, 15.8, 9]); % [PositionDesk, PositionDesk, Width, Height]

if Boolean_Export == true
% Do not forget to adjust "expand to fill axes in the preference before saving"
%exportgraphics(gcf, 'A02_Exported_Figures/Figure4B.pdf','ContentType','vector')
end

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220

%% Appendix - Figure S1: Plotting multi-channel LED spectra of used luminaire

Wavelength = (380:780)';
Basisspektren_Channel_11 = readtable('A00_Data/Basisspektren_11_Channel.csv');
Basisspektren_Channel_11.Wavelength = Wavelength;
Basisspektren_Channel_6 = table(Wavelength, Basisspektren_Channel_11.CH_1,...
    Basisspektren_Channel_11.CH_3,...
    Basisspektren_Channel_11.CH_4,...
    Basisspektren_Channel_11.CH_5,...
    Basisspektren_Channel_11.CH_7,...
    Basisspektren_Channel_11.CH_8, 'VariableNames',...
    {'Wavelength' 'CH1' 'CH2' 'CH3' 'CH4' 'CH5' 'CH6'});

Basisspektren_Channel_8 = table(Wavelength, Basisspektren_Channel_11.CH_1,...
    Basisspektren_Channel_11.CH_3,...
    Basisspektren_Channel_11.CH_4,...
    Basisspektren_Channel_11.CH_5,...
    Basisspektren_Channel_11.CH_6,...
    Basisspektren_Channel_11.CH_7,...
    Basisspektren_Channel_11.CH_8,...
    Basisspektren_Channel_11.CH_10,'VariableNames',...
    {'Wavelength' 'CH1' 'CH2' 'CH3' 'CH4' 'CH5' 'CH6' 'CH7' 'CH8'});

% 6 Kanal: Peak-Wavelengths
% Kanal 1: 4655 K
% Kanal 2: 2740 K
% Kanal 3: Peak 475 nm
% Kanal 4: Peak 662 nm
% Kanal 5: Peak 504 nm
% Kanal 6: Peak 521 nm
Peak_CH1 = Basisspektren_Channel_6(Basisspektren_Channel_6.CH1 == max(Basisspektren_Channel_6.CH1),:);
Peak_CH2 = Basisspektren_Channel_6(Basisspektren_Channel_6.CH2 == max(Basisspektren_Channel_6.CH2),:);
Peak_CH3 = Basisspektren_Channel_6(Basisspektren_Channel_6.CH3 == max(Basisspektren_Channel_6.CH3),:);
Peak_CH4 = Basisspektren_Channel_6(Basisspektren_Channel_6.CH4 == max(Basisspektren_Channel_6.CH4),:);
Peak_CH5 = Basisspektren_Channel_6(Basisspektren_Channel_6.CH5 == max(Basisspektren_Channel_6.CH5),:);
Peak_CH6 = Basisspektren_Channel_6(Basisspektren_Channel_6.CH6 == max(Basisspektren_Channel_6.CH6),:);

disp(table(Peak_CH3.Wavelength,...
    Peak_CH4.Wavelength, Peak_CH5.Wavelength, Peak_CH6.Wavelength,...
    'VariableNames', {'Peak CH 3', 'Peak CH 4', 'Peak CH 5', 'Peak CH 6'}));

% 8 Kanal: Peak-Wavelengths(...)
% Kanal 1: 4655 K
% Kanal 2: 2740 K
% Kanal 3: Peak 475 nm
% Kanal 4: Peak 662 nm
% Kanal 5: Peak 504 nm
% Kanal 6: Peak 521 nm
% Kanal 6: Peak 450 nm
% Kanal 6: Peak 638 nm
Peak_CH1 = Basisspektren_Channel_8(Basisspektren_Channel_8.CH1 == max(Basisspektren_Channel_8.CH1),:);
Peak_CH2 = Basisspektren_Channel_8(Basisspektren_Channel_8.CH2 == max(Basisspektren_Channel_8.CH2),:);
Peak_CH3 = Basisspektren_Channel_8(Basisspektren_Channel_8.CH3 == max(Basisspektren_Channel_8.CH3),:);
Peak_CH4 = Basisspektren_Channel_8(Basisspektren_Channel_8.CH4 == max(Basisspektren_Channel_8.CH4),:);
Peak_CH5 = Basisspektren_Channel_8(Basisspektren_Channel_8.CH5 == max(Basisspektren_Channel_8.CH5),:);
Peak_CH6 = Basisspektren_Channel_8(Basisspektren_Channel_8.CH6 == max(Basisspektren_Channel_8.CH6),:);
Peak_CH7 = Basisspektren_Channel_8(Basisspektren_Channel_8.CH7 == max(Basisspektren_Channel_8.CH7),:);
Peak_CH8 = Basisspektren_Channel_8(Basisspektren_Channel_8.CH8 == max(Basisspektren_Channel_8.CH8),:);

disp(table(Peak_CH3.Wavelength,...
    Peak_CH4.Wavelength, Peak_CH5.Wavelength, Peak_CH6.Wavelength,...
    Peak_CH7.Wavelength, Peak_CH8.Wavelength, 'VariableNames', {'Peak CH 3' 'Peak CH 4' 'Peak CH 5' 'Peak CH 6' 'Peak CH 7' 'Peak CH 8'}));


% 11 Kanal: Peak-Wavelengths(...)
% Kanal 1: 4655 K
% Kanal 2: 597 nm
% Kanal 3: 2740 K
% Kanal 4: Peak 457 nm
% Kanal 5: Peak 662 nm
% Kanal 6: Peak 504 nm
% Kanal 7: Peak 521 nm
% Kanal 8: Peak 450 nm
% Kanal 9: Peak 419 nm
% Kanal 10: Peak 638 nm
% Kanal 11: Peak 543 nm (ACHTUNG: Phosphorkonvertiert)
Peak_CH1 = Basisspektren_Channel_11(Basisspektren_Channel_11.CH_1 == max(Basisspektren_Channel_11.CH_1),:);
Peak_CH2 = Basisspektren_Channel_11(Basisspektren_Channel_11.CH_2 == max(Basisspektren_Channel_11.CH_2),:);
Peak_CH3 = Basisspektren_Channel_11(Basisspektren_Channel_11.CH_3 == max(Basisspektren_Channel_11.CH_3),:);
Peak_CH4 = Basisspektren_Channel_11(Basisspektren_Channel_11.CH_4 == max(Basisspektren_Channel_11.CH_4),:);
Peak_CH5 = Basisspektren_Channel_11(Basisspektren_Channel_11.CH_5 == max(Basisspektren_Channel_11.CH_5),:);
Peak_CH6 = Basisspektren_Channel_11(Basisspektren_Channel_11.CH_6 == max(Basisspektren_Channel_11.CH_6),:);
Peak_CH7 = Basisspektren_Channel_11(Basisspektren_Channel_11.CH_7 == max(Basisspektren_Channel_11.CH_7),:);
Peak_CH8 = Basisspektren_Channel_11(Basisspektren_Channel_11.CH_8 == max(Basisspektren_Channel_11.CH_8),:);
Peak_CH9 = Basisspektren_Channel_11(Basisspektren_Channel_11.CH_9 == max(Basisspektren_Channel_11.CH_9),:);
Peak_CH10 = Basisspektren_Channel_11(Basisspektren_Channel_11.CH_10 == max(Basisspektren_Channel_11.CH_10),:);
Peak_CH11 = Basisspektren_Channel_11(Basisspektren_Channel_11.CH_11 == max(Basisspektren_Channel_11.CH_11),:);

disp('Properties 11 Channel luminaire')

disp(table(Peak_CH2.Wavelength,...
    Peak_CH4.Wavelength, Peak_CH5.Wavelength, Peak_CH6.Wavelength,...
    Peak_CH7.Wavelength, Peak_CH8.Wavelength, Peak_CH9.Wavelength, Peak_CH10.Wavelength,...
    'VariableNames', {'Peak CH 2' 'Peak CH 4' 'Peak CH 5' 'Peak CH 6'...
    'Peak CH 7' 'Peak CH 8' 'Peak CH 9' 'Peak CH 10'}));

%% Appendix Figure S2) Plotting DELTA melanopic-DER metamer against CCT

% CUSTOM VALUE: If you need to export the plot change this value to true
Boolean_Export = true;
% -----------------------------------------------------------------------

close all;
figure; t = tiledlayout(2,3, 'Padding', "tight", "TileSpacing", "loose");
set(gcf, 'Position', [0.1, 11, 10, 4]);
GridLabel = 'on';
FontSize = 12;

ax = [];
MarkerSize = 15;
ScatterSze = 1;

ax(1) = nexttile(1);
Titlestr = {'6-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'];
CurrentTable = Calculate_Contrast([85 85], Optim_CH6_L220);
scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_Diff, MarkerSize, 'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'k', 'LineWidth', ScatterSze)
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');

ax(2) = nexttile(2);
Titlestr = {'8-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'];
CurrentTable = Calculate_Contrast([85 85], Optim_CH8_L220);
scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_Diff, MarkerSize, 'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'k', 'LineWidth', ScatterSze)
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');

ax(3) = nexttile(3);
Titlestr = {'11-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 85,\ R_{\mathrm{f, h1}} \geq 85$'];
CurrentTable = Calculate_Contrast([85 85], Optim_CH11_L220);
scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_Diff, MarkerSize, 'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'k', 'LineWidth', ScatterSze)
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');


ax(4) = nexttile(4);
Titlestr = {'6-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'];
CurrentTable = Calculate_Contrast([90 90], Optim_CH6_L220);
scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_Diff, MarkerSize, 'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'k', 'LineWidth', ScatterSze)
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');


ax(5) = nexttile(5);
Titlestr = {'8-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'];
CurrentTable = Calculate_Contrast([90 90], Optim_CH8_L220);
scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_Diff, MarkerSize, 'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'k', 'LineWidth', ScatterSze)
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');

ax(6) = nexttile(6);
Titlestr = {'11-channel LED luminaire'};
SubTitlestr = ['$R_{\mathrm{f}} \geq 90,\ R_{\mathrm{f, h1}} \geq 90$'];
CurrentTable = Calculate_Contrast([90 90], Optim_CH11_L220);
scatter(CurrentTable.CCT_Target,...
    CurrentTable.Mel_DER250lx_Actual_Diff, MarkerSize, 'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'k', 'LineWidth', ScatterSze)
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');

%cb = colorbar(ax(end));
%set(ax, 'Colormap', parula, 'CLim', [0 0.30])
%cb.Ticks = [0:0.05:0.30];
%set(ax,'colorscale','log')
%cb.Ruler.Scale = 'log';
%cb.Layout.Tile = 'east';

YLim = [0 0.30]; YLimTick = [0:0.05:0.30];
XLim = [2500, 7500]; XLimTick = [2500:1000:7500];
xlabel(t, 'Correlated Colour Temperatur in K', 'FontSize', 8, 'FontName', 'Charter');
ylabel(t, '$\Delta \gamma_{mel}^{D65}$', 'interpreter', 'latex', 'FontSize', 8, 'FontName', 'Charter');
set(ax(1), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','on', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(1), GridLabel);
set(ax(2), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','on', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(2), GridLabel);
set(ax(3), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','on', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(3), GridLabel);
set(ax(4), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','on', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(4), GridLabel);
set(ax(5), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','on', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(5), GridLabel);
set(ax(6), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','on', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(6), GridLabel);
%set(ax(1),'yscale','log')
%set(ax(2),'yscale','log')
%set(ax(3),'yscale','log')
%set(ax(4),'yscale','log')
%set(ax(5),'yscale','log')
%set(ax(6),'yscale','log')

fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.5)
set(gcf, 'Position', [0.1, 11, 15.8, 8]); % [PositionDesk, PositionDesk, Width, Height]

if Boolean_Export == true
 exportgraphics(gcf, 'A02_Exported_Figures/Appendix_FigS2.pdf','ContentType','vector')
end

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220

%% Appendix - Table S1) Descriptive values of the maximum reached metamer difference spectra

Table_Summary = table();

% --------------------------------------------------------------------------------------------
% Melanopic-EDI --------------------------------------------------------------------------------------------
% --------------------------------------------------------------------------------------------

% 6-Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
AktuellerDatensatz_Komplett = Optim_CH6_L220;
CurrentTable = Calculate_Contrast([85, 85], AktuellerDatensatz_Komplett);
MAX_Contrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == max(CurrentTable.Mel_EDI250lx_Actual_Diff), :);
Spectrum_MAX_Contrast = AktuellerDatensatz_Komplett(AktuellerDatensatz_Komplett.MelanopicEDI_250lx == MAX_Contrast.Mel_EDI250lx_Actual_MAX, :);
Spectrum_MIN_Contrast = AktuellerDatensatz_Komplett(AktuellerDatensatz_Komplett.MelanopicEDI_250lx == MAX_Contrast.Mel_EDI250lx_Actual_MIN, :);
Aktueller_DatensatzMAX = Spectrum_MAX_Contrast;
Aktueller_DatensatzMIN = Spectrum_MIN_Contrast(1, :);

Table_Summary(1, :) = table({'CH6 Rf >= 85 Mel_max'},...
    Aktueller_DatensatzMAX.CIEx2Degree_Actual, Aktueller_DatensatzMAX.CIEy2Degree_Actual,...
    Aktueller_DatensatzMAX.CCT_Actual,  Aktueller_DatensatzMAX.DUV_signed, Aktueller_DatensatzMAX.CRI_Actual,...
    Aktueller_DatensatzMAX.Rf_Actual, 250, Aktueller_DatensatzMAX.MelanopicEDI_250lx, Aktueller_DatensatzMAX.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'});

Table_Summary(2, :) = table({'CH6 Rf >= 85 Mel_min'},...
    Aktueller_DatensatzMIN.CIEx2Degree_Actual, Aktueller_DatensatzMIN.CIEy2Degree_Actual,...
    Aktueller_DatensatzMIN.CCT_Actual,  Aktueller_DatensatzMIN.DUV_signed, Aktueller_DatensatzMIN.CRI_Actual,...
    Aktueller_DatensatzMIN.Rf_Actual, 250, Aktueller_DatensatzMIN.MelanopicEDI_250lx, Aktueller_DatensatzMIN.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'});

% 8-Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
AktuellerDatensatz_Komplett = Optim_CH8_L220;
CurrentTable = Calculate_Contrast([85, 85], AktuellerDatensatz_Komplett);
MAX_Contrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == max(CurrentTable.Mel_EDI250lx_Actual_Diff), :);
Spectrum_MAX_Contrast = AktuellerDatensatz_Komplett(AktuellerDatensatz_Komplett.MelanopicEDI_250lx == MAX_Contrast.Mel_EDI250lx_Actual_MAX, :);
Spectrum_MIN_Contrast = AktuellerDatensatz_Komplett(AktuellerDatensatz_Komplett.MelanopicEDI_250lx == MAX_Contrast.Mel_EDI250lx_Actual_MIN, :);
Aktueller_DatensatzMAX = Spectrum_MAX_Contrast;
Aktueller_DatensatzMIN = Spectrum_MIN_Contrast;

Table_Summary(3, :) = table({'CH8 Rf >= 85 Mel_max'},...
    Aktueller_DatensatzMAX.CIEx2Degree_Actual, Aktueller_DatensatzMAX.CIEy2Degree_Actual,...
    Aktueller_DatensatzMAX.CCT_Actual,  Aktueller_DatensatzMAX.DUV_signed, Aktueller_DatensatzMAX.CRI_Actual,...
    Aktueller_DatensatzMAX.Rf_Actual, 250, Aktueller_DatensatzMAX.MelanopicEDI_250lx, Aktueller_DatensatzMAX.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'});

Table_Summary(4, :) = table({'CH8 Rf >= 85 Mel_min'},...
    Aktueller_DatensatzMIN.CIEx2Degree_Actual, Aktueller_DatensatzMIN.CIEy2Degree_Actual,...
    Aktueller_DatensatzMIN.CCT_Actual,  Aktueller_DatensatzMIN.DUV_signed, Aktueller_DatensatzMIN.CRI_Actual,...
    Aktueller_DatensatzMIN.Rf_Actual, 250, Aktueller_DatensatzMIN.MelanopicEDI_250lx, Aktueller_DatensatzMIN.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'});

% 11-Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
AktuellerDatensatz_Komplett = Optim_CH11_L220;
CurrentTable = Calculate_Contrast([85, 85], AktuellerDatensatz_Komplett);
MAX_Contrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == max(CurrentTable.Mel_EDI250lx_Actual_Diff), :);
Spectrum_MAX_Contrast = AktuellerDatensatz_Komplett(AktuellerDatensatz_Komplett.MelanopicEDI_250lx == MAX_Contrast.Mel_EDI250lx_Actual_MAX, :);
Spectrum_MIN_Contrast = AktuellerDatensatz_Komplett(AktuellerDatensatz_Komplett.MelanopicEDI_250lx == MAX_Contrast.Mel_EDI250lx_Actual_MIN, :);
Aktueller_DatensatzMAX = Spectrum_MAX_Contrast;
Aktueller_DatensatzMIN = Spectrum_MIN_Contrast;

Table_Summary(5, :) = table({'CH11 Rf >= 85 Mel_max'},...
    Aktueller_DatensatzMAX.CIEx2Degree_Actual, Aktueller_DatensatzMAX.CIEy2Degree_Actual,...
    Aktueller_DatensatzMAX.CCT_Actual,  Aktueller_DatensatzMAX.DUV_signed, Aktueller_DatensatzMAX.CRI_Actual,...
    Aktueller_DatensatzMAX.Rf_Actual, 250, Aktueller_DatensatzMAX.MelanopicEDI_250lx, Aktueller_DatensatzMAX.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'});

Table_Summary(6, :) = table({'CH11 Rf >= 85 Mel_min'},...
    Aktueller_DatensatzMIN.CIEx2Degree_Actual, Aktueller_DatensatzMIN.CIEy2Degree_Actual,...
    Aktueller_DatensatzMIN.CCT_Actual,  Aktueller_DatensatzMIN.DUV_signed, Aktueller_DatensatzMIN.CRI_Actual,...
    Aktueller_DatensatzMIN.Rf_Actual, 250, Aktueller_DatensatzMIN.MelanopicEDI_250lx, Aktueller_DatensatzMIN.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'});

% --------------------------------------------------------------------------------------------

% 6-Channel: Priority level 3 of Rf: Rf,h1 >= 90, Rf >=90
AktuellerDatensatz_Komplett = Optim_CH6_L220;
CurrentTable = Calculate_Contrast([90, 90], AktuellerDatensatz_Komplett);
MAX_Contrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == max(CurrentTable.Mel_EDI250lx_Actual_Diff), :);
Spectrum_MAX_Contrast = AktuellerDatensatz_Komplett(AktuellerDatensatz_Komplett.MelanopicEDI_250lx == MAX_Contrast.Mel_EDI250lx_Actual_MAX, :);
Spectrum_MIN_Contrast = AktuellerDatensatz_Komplett(AktuellerDatensatz_Komplett.MelanopicEDI_250lx == MAX_Contrast.Mel_EDI250lx_Actual_MIN, :);
Aktueller_DatensatzMAX = Spectrum_MAX_Contrast;
Aktueller_DatensatzMIN = Spectrum_MIN_Contrast(1, :);

Table_Summary(7, :) = table({'CH6 Rf >= 90 Mel_max'},...
    Aktueller_DatensatzMAX.CIEx2Degree_Actual, Aktueller_DatensatzMAX.CIEy2Degree_Actual,...
    Aktueller_DatensatzMAX.CCT_Actual,  Aktueller_DatensatzMAX.DUV_signed, Aktueller_DatensatzMAX.CRI_Actual,...
    Aktueller_DatensatzMAX.Rf_Actual, 250, Aktueller_DatensatzMAX.MelanopicEDI_250lx, Aktueller_DatensatzMAX.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'});

Table_Summary(8, :) = table({'CH6 Rf >= 90 Mel_min'},...
    Aktueller_DatensatzMIN.CIEx2Degree_Actual, Aktueller_DatensatzMIN.CIEy2Degree_Actual,...
    Aktueller_DatensatzMIN.CCT_Actual,  Aktueller_DatensatzMIN.DUV_signed, Aktueller_DatensatzMIN.CRI_Actual,...
    Aktueller_DatensatzMIN.Rf_Actual, 250, Aktueller_DatensatzMIN.MelanopicEDI_250lx, Aktueller_DatensatzMIN.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'});

% 8-Channel: Priority level 3 of Rf: Rf,h1 >= 90, Rf >=90
AktuellerDatensatz_Komplett = Optim_CH8_L220;
CurrentTable = Calculate_Contrast([90, 90], AktuellerDatensatz_Komplett);
MAX_Contrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == max(CurrentTable.Mel_EDI250lx_Actual_Diff), :);
Spectrum_MAX_Contrast = AktuellerDatensatz_Komplett(AktuellerDatensatz_Komplett.MelanopicEDI_250lx == MAX_Contrast.Mel_EDI250lx_Actual_MAX, :);
Spectrum_MIN_Contrast = AktuellerDatensatz_Komplett(AktuellerDatensatz_Komplett.MelanopicEDI_250lx == MAX_Contrast.Mel_EDI250lx_Actual_MIN, :);
Aktueller_DatensatzMAX = Spectrum_MAX_Contrast;
Aktueller_DatensatzMIN = Spectrum_MIN_Contrast;

Table_Summary(9, :) = table({'CH8 Rf >= 90 Mel_max'},...
    Aktueller_DatensatzMAX.CIEx2Degree_Actual, Aktueller_DatensatzMAX.CIEy2Degree_Actual,...
    Aktueller_DatensatzMAX.CCT_Actual,  Aktueller_DatensatzMAX.DUV_signed, Aktueller_DatensatzMAX.CRI_Actual,...
    Aktueller_DatensatzMAX.Rf_Actual, 250, Aktueller_DatensatzMAX.MelanopicEDI_250lx, Aktueller_DatensatzMAX.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'});

Table_Summary(10, :) = table({'CH8 Rf >= 90 Mel_min'},...
    Aktueller_DatensatzMIN.CIEx2Degree_Actual, Aktueller_DatensatzMIN.CIEy2Degree_Actual,...
    Aktueller_DatensatzMIN.CCT_Actual,  Aktueller_DatensatzMIN.DUV_signed, Aktueller_DatensatzMIN.CRI_Actual,...
    Aktueller_DatensatzMIN.Rf_Actual, 250, Aktueller_DatensatzMIN.MelanopicEDI_250lx, Aktueller_DatensatzMIN.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'});

% 11-Channel: Priority level 3 of Rf: Rf,h1 >= 90, Rf >=90
AktuellerDatensatz_Komplett = Optim_CH11_L220;
CurrentTable = Calculate_Contrast([90, 90], AktuellerDatensatz_Komplett);
MAX_Contrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == max(CurrentTable.Mel_EDI250lx_Actual_Diff), :);
Spectrum_MAX_Contrast = AktuellerDatensatz_Komplett(AktuellerDatensatz_Komplett.MelanopicEDI_250lx == MAX_Contrast.Mel_EDI250lx_Actual_MAX, :);
Spectrum_MIN_Contrast = AktuellerDatensatz_Komplett(AktuellerDatensatz_Komplett.MelanopicEDI_250lx == MAX_Contrast.Mel_EDI250lx_Actual_MIN, :);
Aktueller_DatensatzMAX = Spectrum_MAX_Contrast;
Aktueller_DatensatzMIN = Spectrum_MIN_Contrast;

Table_Summary(11, :) = table({'CH11 Rf >= 90 Mel_max'},...
    Aktueller_DatensatzMAX.CIEx2Degree_Actual, Aktueller_DatensatzMAX.CIEy2Degree_Actual,...
    Aktueller_DatensatzMAX.CCT_Actual,  Aktueller_DatensatzMAX.DUV_signed, Aktueller_DatensatzMAX.CRI_Actual,...
    Aktueller_DatensatzMAX.Rf_Actual, 250, Aktueller_DatensatzMAX.MelanopicEDI_250lx, Aktueller_DatensatzMAX.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'});

Table_Summary(12, :) = table({'CH11 Rf >= 90 Mel_min'},...
    Aktueller_DatensatzMIN.CIEx2Degree_Actual, Aktueller_DatensatzMIN.CIEy2Degree_Actual,...
    Aktueller_DatensatzMIN.CCT_Actual,  Aktueller_DatensatzMIN.DUV_signed, Aktueller_DatensatzMIN.CRI_Actual,...
    Aktueller_DatensatzMIN.Rf_Actual, 250, Aktueller_DatensatzMIN.MelanopicEDI_250lx, Aktueller_DatensatzMIN.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'});

% Rounding the values
Table_Summary.CRI = round(Table_Summary.CRI);
Table_Summary.Rf = round(Table_Summary.Rf);
Table_Summary.CCT = round(Table_Summary.CCT);
Table_Summary.E_melDER = round(Table_Summary.E_melDER, 2);
Table_Summary.E_melEDI = round(Table_Summary.E_melEDI, 2);
Table_Summary.CIEx = round(Table_Summary.CIEx, 4);
Table_Summary.CIEy = round(Table_Summary.CIEy, 4);

disp(Table_Summary)
writetable(Table_Summary, 'A03_Exported_Data/Table_1.csv')

%% Appendix - Table S2) Spectra and Metrics of the max melanopic-DER path
% As color quality criterion metric, we applied the TM30-20 definition of the Rf
% Thre thresholds were choosen according to the TM30-20 Annex E.4 "Recommended Color rendition.."
% Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
% Priority level 2 of Rf: Rf,h1 >= 90, Rf >=90

Table_Summary = table();
Table_Spectra = table();
Table_Spectra.Wavelength = (380:780)';

% 6-Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
AktuellerDatensatz_Komplett = Optim_CH6_L220;
CurrentTable = Calculate_Contrast([85, 85], Optim_CH6_L220);
CurrentString = {'CH6 Rf > 85 MelDER'};
CurrentStringSpectra = 'CH6_Rf85_MelDER';
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_EDI250lx_Actual_Diff, G),...
    'VariableNames', {'CCT' 'MAX_MelDER' 'MAXDelta_MelEDI'});
% Get the Values
MAX_MelDERValues = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:);
% Get the Spectrum
Data_MelDERValues = AktuellerDatensatz_Komplett(ismember(AktuellerDatensatz_Komplett.MelanopicDER_250lx,MAX_MelDERValues.Mel_DER250lx_Actual_MAX), :);
Table_Summary(1:18,:) = table(repmat(CurrentString,18,1),...
    Data_MelDERValues.CIEx2Degree_Actual, Data_MelDERValues.CIEy2Degree_Actual,...
    Data_MelDERValues.CCT_Actual,  Data_MelDERValues.DUV_signed, Data_MelDERValues.CRI_Actual,...
    Data_MelDERValues.Rf_Actual, repmat(250,18,1), Data_MelDERValues.MelanopicEDI_250lx, Data_MelDERValues.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'});

for index = 1:size(Data_MelDERValues,1)
    Table_Spectra.([CurrentStringSpectra '_' num2str(index)]) = ScaleSpectra(Data_MelDERValues{index, 39:439}', 250);
end

% 8-Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
AktuellerDatensatz_Komplett = Optim_CH8_L220;
CurrentTable = Calculate_Contrast([85, 85], AktuellerDatensatz_Komplett);
CurrentString = {'CH8 Rf > 85 MelDER'};
CurrentStringSpectra = 'CH8_Rf85_MelDER';
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_EDI250lx_Actual_Diff, G),...
    'VariableNames', {'CCT' 'MAX_MelDER' 'MAXDelta_MelEDI'});
% Get the Values
MAX_MelDERValues = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:);
% Get the Spectrum
Data_MelDERValues = AktuellerDatensatz_Komplett(ismember(AktuellerDatensatz_Komplett.MelanopicDER_250lx,MAX_MelDERValues.Mel_DER250lx_Actual_MAX), :);
Table_Summary = [Table_Summary; table(repmat(CurrentString,17,1),...
    Data_MelDERValues.CIEx2Degree_Actual, Data_MelDERValues.CIEy2Degree_Actual,...
    Data_MelDERValues.CCT_Actual,  Data_MelDERValues.DUV_signed, Data_MelDERValues.CRI_Actual,...
    Data_MelDERValues.Rf_Actual, repmat(250,17,1), Data_MelDERValues.MelanopicEDI_250lx, Data_MelDERValues.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'})];

for index = 1:size(Data_MelDERValues,1)
    Table_Spectra.([CurrentStringSpectra '_' num2str(index)]) = ScaleSpectra(Data_MelDERValues{index, 39:439}', 250);
end


% 11-Channel: Priority level 3 of Rf: Rf,h1 >= 85, Rf >=85
AktuellerDatensatz_Komplett = Optim_CH11_L220;
CurrentTable = Calculate_Contrast([85, 85], AktuellerDatensatz_Komplett);
CurrentString = {'CH11 Rf > 85 MelDER'};
CurrentStringSpectra = 'CH11_Rf85_MelDER';
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_EDI250lx_Actual_Diff, G),...
    'VariableNames', {'CCT' 'MAX_MelDER' 'MAXDelta_MelEDI'});
% Get the Values
MAX_MelDERValues = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:);
% Get the Spectrum
Data_MelDERValues = AktuellerDatensatz_Komplett(ismember(AktuellerDatensatz_Komplett.MelanopicDER_250lx,MAX_MelDERValues.Mel_DER250lx_Actual_MAX), :);
Table_Summary = [Table_Summary; table(repmat(CurrentString,17,1),...
    Data_MelDERValues.CIEx2Degree_Actual, Data_MelDERValues.CIEy2Degree_Actual,...
    Data_MelDERValues.CCT_Actual,  Data_MelDERValues.DUV_signed, Data_MelDERValues.CRI_Actual,...
    Data_MelDERValues.Rf_Actual, repmat(250,17,1), Data_MelDERValues.MelanopicEDI_250lx, Data_MelDERValues.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'})];

for index = 1:size(Data_MelDERValues,1)
    Table_Spectra.([CurrentStringSpectra '_' num2str(index)]) = ScaleSpectra(Data_MelDERValues{index, 39:439}', 250);
end

% 6-Channel: Priority level 3 of Rf: Rf,h1 >= 90, Rf >=90
AktuellerDatensatz_Komplett = Optim_CH6_L220;
CurrentTable = Calculate_Contrast([90, 90], Optim_CH6_L220);
CurrentString = {'CH6 Rf > 90 MelDER'};
CurrentStringSpectra = 'CH6_Rf90_MelDER';
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_EDI250lx_Actual_Diff, G),...
    'VariableNames', {'CCT' 'MAX_MelDER' 'MAXDelta_MelEDI'});
% Get the Values
MAX_MelDERValues = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:);
% Get the Spectrum
Data_MelDERValues = AktuellerDatensatz_Komplett(ismember(AktuellerDatensatz_Komplett.MelanopicDER_250lx,MAX_MelDERValues.Mel_DER250lx_Actual_MAX), :);
Table_Summary = [Table_Summary; table(repmat(CurrentString,18,1),...
    Data_MelDERValues.CIEx2Degree_Actual, Data_MelDERValues.CIEy2Degree_Actual,...
    Data_MelDERValues.CCT_Actual,  Data_MelDERValues.DUV_signed, Data_MelDERValues.CRI_Actual,...
    Data_MelDERValues.Rf_Actual, repmat(250,18,1), Data_MelDERValues.MelanopicEDI_250lx, Data_MelDERValues.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'})];

for index = 1:size(Data_MelDERValues,1)
    Table_Spectra.([CurrentStringSpectra '_' num2str(index)]) = ScaleSpectra(Data_MelDERValues{index, 39:439}', 250);
end

% 8-Channel: Priority level 3 of Rf: Rf,h1 >= 90, Rf >=90
AktuellerDatensatz_Komplett = Optim_CH8_L220;
CurrentTable = Calculate_Contrast([90, 90], AktuellerDatensatz_Komplett);
CurrentString = {'CH8 Rf > 90 MelDER'};
CurrentStringSpectra = 'CH8_Rf90_MelDER';
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_EDI250lx_Actual_Diff, G),...
    'VariableNames', {'CCT' 'MAX_MelDER' 'MAXDelta_MelEDI'});
% Get the Values
MAX_MelDERValues = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:);
% Get the Spectrum
Data_MelDERValues = AktuellerDatensatz_Komplett(ismember(AktuellerDatensatz_Komplett.MelanopicDER_250lx,MAX_MelDERValues.Mel_DER250lx_Actual_MAX), :);
Table_Summary = [Table_Summary; table(repmat(CurrentString,17,1),...
    Data_MelDERValues.CIEx2Degree_Actual, Data_MelDERValues.CIEy2Degree_Actual,...
    Data_MelDERValues.CCT_Actual,  Data_MelDERValues.DUV_signed, Data_MelDERValues.CRI_Actual,...
    Data_MelDERValues.Rf_Actual, repmat(250,17,1), Data_MelDERValues.MelanopicEDI_250lx, Data_MelDERValues.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'})];

for index = 1:size(Data_MelDERValues,1)
    Table_Spectra.([CurrentStringSpectra '_' num2str(index)]) = ScaleSpectra(Data_MelDERValues{index, 39:439}', 250);
end


% 11-Channel: Priority level 3 of Rf: Rf,h1 >= 90, Rf >=90
AktuellerDatensatz_Komplett = Optim_CH11_L220;
CurrentTable = Calculate_Contrast([90, 90], AktuellerDatensatz_Komplett);
CurrentString = {'CH11 CRI > 90 MelDER'};
CurrentStringSpectra = 'CH11_CRI90_MelDER';
[G, TargetGroups] = findgroups(categorical(CurrentTable.CCT_Target));
TableMaxMin_mDER = table(splitapply(@(x) x(1), CurrentTable.CCT_Target, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_DER250lx_Actual_MAX, G),...
    splitapply(@(x) max(x), CurrentTable.Mel_EDI250lx_Actual_Diff, G),...
    'VariableNames', {'CCT' 'MAX_MelDER' 'MAXDelta_MelEDI'});
% Get the Values
MAX_MelDERValues = CurrentTable(ismember(CurrentTable.Mel_DER250lx_Actual_MAX,TableMaxMin_mDER.MAX_MelDER),:);
% Get the Spectrum
Data_MelDERValues = AktuellerDatensatz_Komplett(ismember(AktuellerDatensatz_Komplett.MelanopicDER_250lx,MAX_MelDERValues.Mel_DER250lx_Actual_MAX), :);
Table_Summary = [Table_Summary; table(repmat(CurrentString,17,1),...
    Data_MelDERValues.CIEx2Degree_Actual, Data_MelDERValues.CIEy2Degree_Actual,...
    Data_MelDERValues.CCT_Actual,  Data_MelDERValues.DUV_signed, Data_MelDERValues.CRI_Actual,...
    Data_MelDERValues.Rf_Actual, repmat(250,17,1), Data_MelDERValues.MelanopicEDI_250lx, Data_MelDERValues.MelanopicDER_250lx,...
    'VariableNames', {'Condition', 'CIEx', 'CIEy', 'CCT', 'Duv', 'CRI', 'Rf', 'E_v', 'E_melEDI', 'E_melDER'})];

for index = 1:size(Data_MelDERValues,1)
    Table_Spectra.([CurrentStringSpectra '_' num2str(index)]) = ScaleSpectra(Data_MelDERValues{index, 39:439}', 250);
end

% Rounding the values
Table_Summary.CRI = round(Table_Summary.CRI);
Table_Summary.Rf = round(Table_Summary.Rf);
Table_Summary.CCT = round(Table_Summary.CCT);
Table_Summary.E_melDER = round(Table_Summary.E_melDER, 2);
Table_Summary.E_melEDI = round(Table_Summary.E_melEDI, 2);
Table_Summary.CIEx = round(Table_Summary.CIEx, 4);
Table_Summary.CIEy = round(Table_Summary.CIEy, 4);
disp(Table_Summary)
writetable(Table_Summary, 'A03_Exported_Data/Table_2.csv')
writetable(Table_Spectra, 'A03_Exported_Data/Spectra_Table_2.csv')

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220

%% Appendix Figure S3 A) Plotting the metameric tuning limits map using Delta melanopic-DER (250 photopic lux) - WITHOUT CFI CONDITIONS
close all;
figure; t = tiledlayout(1,3, 'Padding', "tight", "TileSpacing", "compact");
set(gcf, 'Position', [0.1, 11, 14, 8]);
GridLabel = 'on';
MarkerSize = 5;
FontSize = 12;

% 6-Channel -------------------------------
ax(1) = nexttile(1);
Titlestr = {'6-channel LED luminaire'};
SubTitlestr = ['No colour fidelity condition'];
CurrentTable = Calculate_Contrast([0, 0], Optim_CH6_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_DER250lx_Actual_Diff);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
MaxMelValue_Array(1) = MAX_MelContrast.Mel_DER250lx_Actual_Diff;
CH6_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH6_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

u = CH6_CRI80_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH6_CRI80_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH6_CRI80_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH6_CRI80_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH6_CRI80_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH6_CRI80_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH6_CRI80_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH6_CRI80_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH6_CRI80_Spectrum_MAX_Mel_Contrast.x_Target, CH6_CRI80_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[1 1 1],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25);


% 8-Channel -------------------------------
ax(2) = nexttile(2);
Titlestr = {'8-channel LED luminaire'};
SubTitlestr = ['No colour fidelity condition'];
CurrentTable = Calculate_Contrast([0, 0], Optim_CH8_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_DER250lx_Actual_Diff);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
MaxMelValue_Array(2) = MAX_MelContrast.Mel_DER250lx_Actual_Diff;
CH8_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH8_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

u = CH8_CRI80_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH8_CRI80_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH8_CRI80_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH8_CRI80_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH8_CRI80_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH8_CRI80_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH8_CRI80_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH8_CRI80_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH8_CRI80_Spectrum_MAX_Mel_Contrast.x_Target, CH8_CRI80_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25); hold off;

% 11-Channel -------------------------------
ax(3) = nexttile(3);
Titlestr = {'11-channel LED luminaire'};
SubTitlestr = ['No colour fidelity condition'];
CurrentTable = Calculate_Contrast([0, 0], Optim_CH11_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_DER250lx_Actual_Diff);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
MaxMelValue_Array(3) = MAX_MelContrast.Mel_DER250lx_Actual_Diff;
CH11_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH11_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

u = CH11_CRI80_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH11_CRI80_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH11_CRI80_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH11_CRI80_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH11_CRI80_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH11_CRI80_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH11_CRI80_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH11_CRI80_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH11_CRI80_Spectrum_MAX_Mel_Contrast.x_Target, CH11_CRI80_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[0 0 0],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25); hold off;

cb = colorbar(ax(end));
set(ax, 'Colormap', parula, 'CLim', [0 1])
cb.Ticks = [0:0.2:1.0];
set(ax,'colorscale','log')
%cb.Ruler.Scale = 'log';
cb.Layout.Tile = 'east';

YLim = [0.25, 0.45]; YLimTick = [0.25:0.05:0.45];
XLim = [0.25, 0.45]; XLimTick = [0.25:0.05:0.45];
xlabel(t, 'x', 'FontSize', 8, 'FontName', 'Charter');
ylabel(t, 'y', 'FontSize', 8, 'FontName', 'Charter');
set(ax(1), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(1), GridLabel);
set(ax(2), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(2), GridLabel);
set(ax(3), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(3), GridLabel);

fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.5)
set(gcf, 'Position', [0.1, 11, 15.8, 5]); % [PositionDesk, PositionDesk, Width, Height]

disp(MaxMelValue_Array)
%exportgraphics(gcf, 'A02_Exported_Figures/Appendix_FigS3A.pdf','ContentType','vector')
%exportgraphics(gcf, 'A02_Exported_Figures/Appendix_FigS3A_Bar.pdf','ContentType','vector')

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220

%% Appendix Figure S3 B) Plotting the spectra with the highest Delta melanopic-DER - WITHOUT CFI CONDITIONS

% CUSTOM VALUE: If you need to export the plot change this value to true
Boolean_Export = true;
% -----------------------------------------------------------------------

close all;
figure; t = tiledlayout(1,3, 'Padding', "tight", "TileSpacing", "compact");
set(gcf, 'Position', [0.1, 11, 12, 4]);

Color_MaximumDER = '#ec6c1a'; % Orange
Color_MinimumDER = '#0a65a8'; % Blue
GridLabel = 'off';
LineWidthPlot = 0.75;
FontSize = 12;

% 6 Channel
ax(1) = nexttile(1);
CurrentTable = Calculate_Contrast([0, 0], Optim_CH6_L220);
MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
CH6_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH6_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH6_CRI80_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH6_CRI80_Spectrum_MIN_Mel_Contrast(1, :);
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumDER, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumDER, 'LineWidth', LineWidthPlot);
title('6 Channel LED luminaire');
subtitle({['$\gamma_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicDER_250lx, 2)),...
    '$,\ \gamma_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicDER_250lx, 2))]},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;

% 8 Channel
ax(2) = nexttile(2);
CurrentTable = Calculate_Contrast([0, 0], Optim_CH8_L220);
MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
CH8_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH8_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH8_CRI80_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH8_CRI80_Spectrum_MIN_Mel_Contrast;
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumDER, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumDER, 'LineWidth', LineWidthPlot);
title('8 Channel LED luminaire');
subtitle({['$\gamma_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicDER_250lx, 2)),...
    '$,\ \gamma_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicDER_250lx, 2))]},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;


% 11 Channel
ax(3) = nexttile(3);
CurrentTable = Calculate_Contrast([0, 0], Optim_CH11_L220);
MAX_MelContrast = CurrentTable(CurrentTable.Mel_DER250lx_Actual_Diff == max(CurrentTable.Mel_DER250lx_Actual_Diff), :);
CH11_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MAX, :);
CH11_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicDER_250lx == MAX_MelContrast.Mel_DER250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH11_CRI80_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH11_CRI80_Spectrum_MIN_Mel_Contrast;
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumDER, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumDER, 'LineWidth', LineWidthPlot);
title('11 Channel LED luminaire');
subtitle({['$\gamma_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicDER_250lx, 2)),...
    '$,\ \gamma_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicDER_250lx, 2))]},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;


% Plot Einstellungen
YLim = [0, 1]; YLimTick = [0:0.5:1];
xlabel(t, 'Wavelength in nm', 'FontSize', 8, 'FontName', 'Charter');
ylabel(t, 'Relative irradiance in a.u.', 'FontSize', 8, 'FontName', 'Charter');
set(ax(1), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(1), GridLabel);
set(ax(2), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(2), GridLabel);
set(ax(3), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(3), GridLabel);

fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.75)
set(gcf, 'Position', [0.1, 11, 15.8, 4]); % [PositionDesk, PositionDesk, Width, Height]

if Boolean_Export == true
 exportgraphics(gcf, 'A02_Exported_Figures/Appendix_FigS3B.pdf','ContentType','vector')
end

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220

%% Appendix Figure S4 A) Plotting the Michelson-Contrast in the CIExy-2° colour space - No CFI conditon

close all;
figure; t = tiledlayout(1,3, 'Padding', "tight", "TileSpacing", "compact");
set(gcf, 'Position', [0.1, 11, 14, 8]);
GridLabel = 'on';
MarkerSize = 6;
FontSize = 12;

% 6-Channel
ax(1) = nexttile(1);
Titlestr = {'6-channel LED luminaire'};
SubTitlestr = ['No colour fidelity condition'];
CurrentTable = Calculate_Contrast([0, 0], Optim_CH6_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

Comp = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actual_Diff;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == Comp, :);
MaxMelValue_Array(1) = MAX_MelContrast.Mel_EDI250lx_Actual_Diff;
CH6_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH6_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

u = CH6_CRI80_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH6_CRI80_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH6_CRI80_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH6_CRI80_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH6_CRI80_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH6_CRI80_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH6_CRI80_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH6_CRI80_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH6_CRI80_Spectrum_MAX_Mel_Contrast.x_Target, CH6_CRI80_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[1 1 1],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25);


% 8-Channel
ax(2) = nexttile(2);
Titlestr = {'8-channel LED luminaire'};
SubTitlestr = ['No colour fidelity condition'];
CurrentTable = Calculate_Contrast([0, 0], Optim_CH8_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

Comp = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actual_Diff;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == Comp, :);
MaxMelValue_Array(2) = MAX_MelContrast.Mel_EDI250lx_Actual_Diff;
CH8_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH8_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

u = CH8_CRI80_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH8_CRI80_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH8_CRI80_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH8_CRI80_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH8_CRI80_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH8_CRI80_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH8_CRI80_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH8_CRI80_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH8_CRI80_Spectrum_MAX_Mel_Contrast.x_Target, CH8_CRI80_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[1 1 1],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25); hold off;

% 11-Channel
ax(3) = nexttile(3);
Titlestr = {'11-channel LED luminaire'};
SubTitlestr = ['No colour fidelity condition'];
CurrentTable = Calculate_Contrast([0, 0], Optim_CH11_L220);
% Preperation for the contour plot
x=linspace(min(CurrentTable.x),max(CurrentTable.x),150);
y=linspace(min(CurrentTable.y),max(CurrentTable.y),150);
[X,Y] = meshgrid(x,y);
F=scatteredInterpolant(CurrentTable.x, CurrentTable.y, CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast);
F.Method = 'linear'; F.ExtrapolationMethod = 'none';
pobject = contourf(X,Y,F(X,Y), 'LineStyle','none'); hold on;
%pobject.FaceColor = 'interp';
%set(pobject, 'EdgeColor', 'none');
plot_CCTLocus(false, true, [], []); hold on;
title(Titlestr);
subtitle(SubTitlestr, 'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter');
xlim([0.25, 0.45]); ylim([0.25, 0.45]);

Comp = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actual_Diff;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == Comp, :);
MaxMelValue_Array(3) = MAX_MelContrast.Mel_EDI250lx_Actual_Diff;
CH11_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH11_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

u = CH11_CRI80_Spectrum_MAX_Mel_Contrast.u1976_Target;
v = CH11_CRI80_Spectrum_MAX_Mel_Contrast.v1976_Target;
CH11_CRI80_Spectrum_MAX_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH11_CRI80_Spectrum_MAX_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);

u = CH11_CRI80_Spectrum_MIN_Mel_Contrast.u1976_Target;
v = CH11_CRI80_Spectrum_MIN_Mel_Contrast.v1976_Target;
CH11_CRI80_Spectrum_MIN_Mel_Contrast.x_Target = (9.*u)./(6.*u- 16.*v + 12);
CH11_CRI80_Spectrum_MIN_Mel_Contrast.y_Target = (4.*v)./(6.*u- 16.*v + 12);
scatter(CH11_CRI80_Spectrum_MAX_Mel_Contrast.x_Target, CH11_CRI80_Spectrum_MAX_Mel_Contrast.y_Target,...
    MarkerSize,...
    'MarkerEdgeColor',[1 1 1],...
    'MarkerFaceColor',[1 0 0],...
    'LineWidth', 0.25); hold off;

cb = colorbar(ax(end));
set(ax, 'Colormap', parula, 'CLim', [0 0.45])
cb.Ticks = [0:0.05:0.45];
%set(ax,'colorscale','log')
%cb.Ruler.Scale = 'log';
cb.Layout.Tile = 'east';

YLim = [0.25, 0.45]; YLimTick = [0.25:0.05:0.45];
XLim = [0.25, 0.45]; XLimTick = [0.25:0.05:0.45];
xlabel(t, 'x', 'FontSize', 8, 'FontName', 'Charter');
ylabel(t, 'y', 'FontSize', 8, 'FontName', 'Charter');
set(ax(1), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(1), GridLabel);
set(ax(2), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(2), GridLabel);
set(ax(3), 'YLim', YLim, 'XLim', XLim, 'XMinorTick','off', 'XTick', XLimTick, 'YTick', YLimTick); grid(ax(3), GridLabel);

fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.5)
set(gcf, 'Position', [0.1, 11, 15.8, 5]); % [PositionDesk, PositionDesk, Width, Height]

disp(MaxMelValue_Array)
%exportgraphics(gcf, 'A02_Exported_Figures/Appendix_FigS4A_MichelsonContrast.pdf','ContentType','vector')
%exportgraphics(gcf, 'A02_Exported_Figures/Appendix_FigS4A_MichelsonContrast_Bar.pdf','ContentType','vector')

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220

%% Appendix Figure S4 B) Plotting the spectra with the maximum Michelson-Contrast - No CFI conditons

% CUSTOM VALUE: If you need to export the plot change this value to true
Boolean_Export = true;
% -----------------------------------------------------------------------

close all;
figure; t = tiledlayout(1,3, 'Padding', "tight", "TileSpacing", "compact");
set(gcf, 'Position', [0.1, 11, 12, 4]);

Color_MaximumCS = '#ec6c1a'; % Orange
Color_MinimumCS = '#0a65a8'; % Blue
GridLabel = 'off';
LineWidthPlot = 0.75;
FontSize = 12;

% 6 Channel - CRI > 80
ax(1) = nexttile(1);
CurrentTable = Calculate_Contrast([0, 0], Optim_CH6_L220);
Comp_1 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actual_Diff;
Comp_2 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).DUV_signed;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == Comp_1 & CurrentTable.DUV_signed == Comp_2, :);
CH6_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH6_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH6_L220(Optim_CH6_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH6_CRI80_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH6_CRI80_Spectrum_MIN_Mel_Contrast(1, :);
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumCS, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumCS, 'LineWidth', LineWidthPlot);
title('6 Channel LED luminaire');
subtitle({['$E_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicEDI_250lx, 2)), ' lx'],...
    ['$E_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicEDI_250lx, 2)), ' lx']},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;

% 8 Channel - CRI > 80
ax(2) = nexttile(2);
CurrentTable = Calculate_Contrast([0, 0], Optim_CH8_L220);
Comp_1 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actual_Diff;
Comp_2 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).DUV_signed;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == Comp_1 & CurrentTable.DUV_signed == Comp_2, :);
CH8_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH8_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH8_L220(Optim_CH8_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH8_CRI80_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH8_CRI80_Spectrum_MIN_Mel_Contrast;
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumCS, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumCS, 'LineWidth', LineWidthPlot);
title('8 Channel LED luminaire');
subtitle({['$E_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicEDI_250lx, 2)), ' lx'],...
    ['$E_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicEDI_250lx, 2)), ' lx']},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;

% 11 Channel - CRI > 80
ax(3) = nexttile(3);
CurrentTable = Calculate_Contrast([0, 0], Optim_CH11_L220);
Comp_1 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).Mel_EDI250lx_Actual_Diff;
Comp_2 = CurrentTable(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast == max(CurrentTable.Mel_EDI250lx_Actucal_MichelsonContrast),:).DUV_signed;
MAX_MelContrast = CurrentTable(CurrentTable.Mel_EDI250lx_Actual_Diff == Comp_1 & CurrentTable.DUV_signed == Comp_2, :);
CH11_CRI80_Spectrum_MAX_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MAX, :);
CH11_CRI80_Spectrum_MIN_Mel_Contrast = Optim_CH11_L220(Optim_CH11_L220.MelanopicEDI_250lx == MAX_MelContrast.Mel_EDI250lx_Actual_MIN, :);

Aktueller_DatensatzMAX = CH11_CRI80_Spectrum_MAX_Mel_Contrast;
Aktueller_DatensatzMIN = CH11_CRI80_Spectrum_MIN_Mel_Contrast;
MaxValue = max([Aktueller_DatensatzMAX{:, 39:439}' ; Aktueller_DatensatzMIN{:, 39:439}']);
plot((380:780)',(Aktueller_DatensatzMAX{:, 39:439}')/MaxValue, 'Color', Color_MaximumCS, 'LineWidth', LineWidthPlot); hold on;
plot((380:780)',(Aktueller_DatensatzMIN{:, 39:439}')/MaxValue, 'Color', Color_MinimumCS, 'LineWidth', LineWidthPlot);
title('11 Channel LED luminaire');
subtitle({['$E_{\mathrm{mel,Min}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMIN.MelanopicEDI_250lx, 2)), ' lx'],...
    ['$E_{\mathrm{mel, Max}}^{D65} =\ $', num2str(round(Aktueller_DatensatzMAX.MelanopicEDI_250lx, 2)), ' lx']},...
    'interpreter', 'latex', 'FontSize', FontSize, 'FontName', 'Charter'); box off;

% Plot Einstellungen
YLim = [0, 1]; YLimTick = [0:0.5:1];
xlabel(t, 'Wavelength in nm', 'FontSize', 8, 'FontName', 'Charter');
ylabel(t, 'Relative irradiance in a.u.', 'FontSize', 8, 'FontName', 'Charter');
set(ax(1), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(1), GridLabel);
set(ax(2), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(2), GridLabel);
set(ax(3), 'YLim', YLim, 'XLim', [380 780], 'XMinorTick','off', 'XTick', 380:100:780, 'YTick', YLimTick); grid(ax(3), GridLabel);


fig = gcf;
FontName = 'Charter';
fig.Units = 'centimeters';
fig.Renderer = 'painters';
fig.PaperPositionMode = 'manual';
set(findall(gcf,'-property','FontSize'),'FontSize',8)
set(findall(gcf,'-property','FontName'),'FontName', FontName)
set(findobj(gcf, 'FontSize', 12), 'FontSize', 8)
% LineWidth Axes
set(findobj(gcf, 'Linewidth', 1), 'Linewidth', 0.75)
set(gcf, 'Position', [0.1, 11, 15.8, 4]); % [PositionDesk, PositionDesk, Width, Height]

if Boolean_Export == true
 exportgraphics(gcf, 'A02_Exported_Figures/Appendix_FigS4B_MichelsonContrast_Spectra.pdf','ContentType','vector')
end

clearvars -except Optim_CH6_L220 Optim_CH8_L220 Optim_CH11_L220

%% Additional - Descriptive values:
% How many optimisation targets were found ?
% Number of optimisation result for each CCT-Target and Duv-Target
format long

% 6 Channel -----------------------------------------------------------------------
[G, TargetGroups] = findgroups(categorical(Optim_CH6_L220.IndexNumber_Target));
CountResults = splitapply(@(x) size(x, 1),Optim_CH6_L220.OptimResult_Number,G);
CH6_L220 = ['Mean spectra count each target ' num2str(mean(CountResults)) ' SD ' num2str(std(CountResults)) ' Total found spectra ' num2str(sum(CountResults))];
CountOptim_CH6_L220 = sum(CountResults);
fprintf('6-Channel Luminance 220 cd/m2: Solutions found for %d of 561 optimisation targets. Mean spectra count for each optimisation target is %.2f SD %.2f - Total: %d \n',...
    size(categories(categorical(Optim_CH6_L220.IndexNumber_Target)),1), mean(CountResults), std(CountResults), CountOptim_CH6_L220);
Table_S2_CH6_220 = table(6, 220, size(categories(categorical(Optim_CH6_L220.IndexNumber_Target)),1), mean(CountResults), std(CountResults), CountOptim_CH6_L220,...
    'VariableNames', {'Illuminance_Configuration', 'Target_Luminance', 'Solutions', 'Mean_metamer_count', 'SD_metamer_count', 'Total_optimised_spectra'});

OptimisationCount_6Channel = table({'CH 6'}, {CH6_L220},...
    'VariableNames', {'Channel', 'Luminance 220 cd/m2'});
% ---------------------------------------------------------------------------------------

% 8 Channel -----------------------------------------------------------------------
[G, TargetGroups] = findgroups(categorical(Optim_CH8_L220.IndexNumber_Target));
CountResults = splitapply(@(x) size(x, 1), Optim_CH8_L220.OptimResult_Number, G);
CH8_L220 = ['Mean spectra count each target ' num2str(mean(CountResults)) ' SD ' num2str(std(CountResults)) ' Total found spectra ' num2str(sum(CountResults))];
CountOptim_CH8_L220 = sum(CountResults);
fprintf('8-Channel luminance 220 cd/m2: Solutions found for %d of 561 optimisation targets. Mean spectra count for each optimisation target is %.2f SD %.2f - Total: %d \n',...
    size(categories(categorical(Optim_CH8_L220.IndexNumber_Target)),1), mean(CountResults), std(CountResults), CountOptim_CH8_L220);
Table_S2_CH8_220 = table(8, 220, size(categories(categorical(Optim_CH8_L220.IndexNumber_Target)),1), mean(CountResults), std(CountResults), CountOptim_CH8_L220,...
    'VariableNames', {'Illuminance_Configuration', 'Target_Luminance', 'Solutions', 'Mean_metamer_count', 'SD_metamer_count', 'Total_optimised_spectra'});

OptimisationCount_6Channel = table({'CH 8'}, {CH8_L220},...
    'VariableNames', {'Channel', 'Luminance 220 cd/m2'});
% ---------------------------------------------------------------------------------------

% 11 Channel -----------------------------------------------------------------------
[G, TargetGroups] = findgroups(categorical(Optim_CH11_L220.IndexNumber_Target));
CountResults = splitapply(@(x) size(x, 1),Optim_CH11_L220.OptimResult_Number,G);
CH11_L220 = ['Mean spectra count each target ' num2str(mean(CountResults)) ' SD ' num2str(std(CountResults)) ' Total found spectra' num2str(sum(CountResults))];
CountOptim_CH11_L220 = sum(CountResults);
fprintf('11-Channel luminance 220 cd/m2: Solutions found for %d of 561 optimisation targets. Mean spectra count for each optimisation target is %.2f SD %.2f - Total: %d \n',...
    size(categories(categorical(Optim_CH11_L220.IndexNumber_Target)),1), mean(CountResults), std(CountResults), CountOptim_CH11_L220);

Table_S2_CH11_220 = table(11, 220, size(categories(categorical(Optim_CH11_L220.IndexNumber_Target)),1), mean(CountResults), std(CountResults), CountOptim_CH11_L220,...
    'VariableNames', {'Illuminance_Configuration', 'Target_Luminance', 'Solutions', 'Mean_metamer_count', 'SD_metamer_count', 'Total_optimised_spectra'});

OptimisationCount_11Channel = table({'CH 11'}, {CH11_L220},...
    'VariableNames', {'Channel', 'Luminance 220 cd/m2'});
% ---------------------------------------------------------------------------------------

% Total count of optimised spectra
TotalCount = CountOptim_CH6_L220 + CountOptim_CH8_L220 + CountOptim_CH11_L220;

fprintf('Number of total optimised spectra across all optimisation targets %d \n', TotalCount);

% For how many chromaticity targets spectra where found in average across all lumiances and channel combinations ?
fprintf('Spectra were found for %.3f SD %.3f chromaticity targets across all luminanes and channel combinations \n',...
    mean([size(categories(categorical(Optim_CH6_L220.IndexNumber_Target)),1),...
    size(categories(categorical(Optim_CH8_L220.IndexNumber_Target)),1),...
    size(categories(categorical(Optim_CH11_L220.IndexNumber_Target)),1)]),...
    std([size(categories(categorical(Optim_CH6_L220.IndexNumber_Target)),1),...
    size(categories(categorical(Optim_CH8_L220.IndexNumber_Target)),1),...
    size(categories(categorical(Optim_CH11_L220.IndexNumber_Target)),1)]))
