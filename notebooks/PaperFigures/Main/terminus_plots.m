%% Set path to Imanalysis
elnDir = '/mnt/sda1/SMLAT/data/real_data/chromosome_dots/EXP-23-CA3057/pool_midway_pos32/fork_outputs';
addpath([elnDir '/matlabcode/']);
addpath([elnDir '/ImAnalysis/']);
ImAnalysis_setup([elnDir '/ImAnalysis/']);

%% Load previously build mcells
mCellsFile = fullfile(elnDir, 'mCells_prob_filtered.mat');
[mCells, mFrames] = Cell.MCell.loadMCells(mCellsFile);

%% Convert particles internal coordinates to nanomenters
dots = getParticleList(mCells);
x = dots.internalCoord(:, 1);
y = dots.internalCoord(:, 2);
z = dots.fluoCoord(:, 3);   
cell_widths = dots.width(:);
cell_lengths = dots.length(:);
y_nm = y .* cell_widths  * 65.0 / 2.0;
x_nm = x .* cell_lengths * 65.0;
x_sigma = dots.err(:, 1);
y_sigma = dots.err(:, 2);
z_sigma = dots.err(:, 3);
prob = dots.prob(:);
pxSize=65;
%% Make forkplots
lengthCutOff = 1;
parentLengthCutOff = 0;
daughterLengthCutOff = 0;
estimateInitArea = 0; 

[shorts, longs, areas, lengths, widths, counts, depths] =  ...
    getDotLocations3D(mCells, 'lengthCutOff', lengthCutOff, ...
    'parentLengthCutoff', parentLengthCutOff, 'daughterLengthCutoff', daughterLengthCutOff, ...
    'orientFlag', 0, 'PixelSize',pxSize/1000);

birthAreas = [];
divisionAreas=[];
initiationAreas=[];

noNaNs = find(~isnan(longs));
displayForkPlot(longs(noNaNs), areas(noNaNs), lengths(noNaNs), counts(noNaNs), ...
    mean(birthAreas), mean(divisionAreas), mean(initiationAreas), 'BinScale', 15, 'HeatMapThreshold',0.95);
xlim([-3 3])
ylim([0.8 2.4])

displayForkPlotShortAxis(shorts(noNaNs), areas(noNaNs), widths(noNaNs), counts(noNaNs), ...
    mean(birthAreas), mean(divisionAreas), mean(initiationAreas), 'BinScale', 80, 'HeatMapThreshold',0.9);
% xlim([-0.5 0.5])
% ylim([1 3])

displayForkPlotDepthAxis(depths(noNaNs), areas(noNaNs), widths(noNaNs), counts(noNaNs), ...
   mean(birthAreas), mean(divisionAreas), mean(initiationAreas), 'BinScale', 80,'HeatMapThreshold',0.9);
% xlim([-0.5 0.5])

%% Plotting distributions of x


%% Plotting distributions of y
figure, hold on
histogram(y_nm)
xlabel('Y [nm]')
ylabel('counts')


%% Plotting distributions of z

figure, hold on
histogram(z)
xlabel('z [nm]')
ylabel('counts')

%% Plotting y-z as a function of probability

figure, hold on
histogram2(y_nm, z, 'DisplayStyle', 'tile');
axis equal;
xlabel('Y [nm]')
ylabel('Z [nm]')
%% Plotting sigmas

figure, hold on
histogram2(z_sigma, z, 'DisplayStyle','tile');
xlabel('Z sigma [nm]');
ylabel('Z [nm]');



figure, hold on
histogram2(y_sigma, y_nm, 'DisplayStyle','tile');
xlabel('y sigma [nm]');
ylabel('y [nm]');

figure, hold on
histogram2(x_sigma, x, 'DisplayStyle','tile');
xlabel('X sigma [nm]');
ylabel('X [nm]');
%% Plotting prob vs x, y, z
figure, hold on
histogram2(prob, z, 'DisplayStyle','tile');
xlabel('probability');
ylabel('Z [nm]');



figure, hold on
histogram2(prob, y_nm, 'DisplayStyle','tile');
xlabel('probability');
ylabel('y [nm]');

figure, hold on
histogram2(prob, x, 'DisplayStyle','tile');
xlabel('probability');
ylabel('X [nm]');

