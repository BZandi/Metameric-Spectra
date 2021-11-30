function ContrastTable = Calculate_ContrastRF(RF_Threshold, InpuData)

% Calculate the difference between min and max
Datensatz_Original_CRI = InpuData(InpuData.Rf_Actual > RF_Threshold, :);
[G, TargetGroups] = findgroups(categorical(Datensatz_Original_CRI.IndexNumber_Target));
Tabelle_Differenzen = table(splitapply(@(x) x(1), Datensatz_Original_CRI.IndexNumber_Target, G),... % OK
    splitapply(@(x) x(1), Datensatz_Original_CRI.u1976_Target , G),... % OK
    splitapply(@(x) x(1), Datensatz_Original_CRI.v1976_Target , G),... % OK
    splitapply(@(x) min(x), Datensatz_Original_CRI.CS250lx_Actual, G),... % OK
    splitapply(@(x) max(x), Datensatz_Original_CRI.CS250lx_Actual, G),... % OK
    splitapply(@(x) abs(max(x) - min(x)), Datensatz_Original_CRI.CS250lx_Actual, G),... % OK
    splitapply(@(x) abs(max(x) - min(x)), Datensatz_Original_CRI.MelanopicRadiance_Actual, G),... % OK
    splitapply(@(x) ((100*max(x))/min(x))-100, Datensatz_Original_CRI.MelanopicRadiance_Actual, G),... % OK
    splitapply(@(x) min(x), Datensatz_Original_CRI.MelanopicEDI_250lx, G),... % OK
    splitapply(@(x) max(x), Datensatz_Original_CRI.MelanopicEDI_250lx, G),... % OK
    splitapply(@(x) abs(max(x) - min(x)), Datensatz_Original_CRI.MelanopicEDI_250lx, G),... % OK
    splitapply(@(x) x(1), Datensatz_Original_CRI.CCT_Target, G),... % OK
    splitapply(@(x) min(x), Datensatz_Original_CRI.MelanopicDER_250lx, G),...
    splitapply(@(x) max(x), Datensatz_Original_CRI.MelanopicDER_250lx, G),...
    splitapply(@(x) abs(max(x) - min(x)), Datensatz_Original_CRI.MelanopicDER_250lx, G),...
    splitapply(@(x) x(1), Datensatz_Original_CRI.DUV_signed, G),...
    'VariableNames', {'IndexNumber_Target' 'u1976_Actual' 'v1976_Actual'...
    'CS250lx_Actual_MIN' 'CS250lx_Actual_MAX' 'CS250lx_Actual_Diff', 'MelanopicRadiance_Diff', 'MelanopicRadiance_DiffREL',...
    'Mel_EDI250lx_Actual_MIN' 'Mel_EDI250lx_Actual_MAX' 'Mel_EDI250lx_Actual_Diff' 'CCT_Target'...
    'Mel_DER250lx_Actual_MIN' 'Mel_DER250lx_Actual_MAX' 'Mel_DER250lx_Actual_Diff' 'DUV_signed'});

% Calculate the CIExy chromaticity coordinates from CIEu'v'
u = Tabelle_Differenzen.u1976_Actual;
v = Tabelle_Differenzen.v1976_Actual;
Tabelle_Differenzen.x = (9.*u)./(6.*u- 16.*v + 12);
Tabelle_Differenzen.y = (4.*v)./(6.*u- 16.*v + 12);

ContrastTable = Tabelle_Differenzen;

end