function [NewValue, ScaledSpectra] = ScaleSpectra(La, SPD)

load('A00_Data/StandardOb.mat');

Out = sum(SPD'.*standard1931(:,2));

Peak=La./(683*Out);

ScaledSpectra=Peak.*SPD';

NewValue = 683*sum(ScaledSpectra.*standard1931(:,2));

ScaledSpectra = ScaledSpectra';

end