# *Data Repository* <br/>Optimising metameric spectra for integrative lighting to modulate the circadian system without affecting visual appearance<br/>
[![Published](https://img.shields.io/badge/Scientific%20Reports-Published-green)](https://www.nature.com/articles/s41598-020-79908-5)
[![DOI](https://img.shields.io/badge/DOI-10.1038%2Fs41598--021--02136--y-blue)](https://doi.org/10.1038/s41598-021-02136-y)
[![CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey)](http://creativecommons.org/licenses/by/4.0/)

This reporsitory provides over 490,000 optimised multi-channel LED metamer spectra presented in the article "Optimising metameric spectra for integrative lighting to modulate the circadian system without affecting visual appearance", authored by Babak Zandi, Oliver Stefani, Alexander Herzog, Luc J. M. Schlangen, Quang Vinh Trinh and Tran Quoc Khanh.

**Correspondence:** zandi@lichttechnik.tu-darmstadt.de<br/>
**Google Scholar Profile:** [Babak Zandi](https://scholar.google.de/citations?user=LSA7SdAAAAAJ&hl=de)<br/>
**Twitter:** [@BkZandi](https://twitter.com/bkzandi)

---

<div align="center">
<a style="font-weight:bold" href="https://www.nature.com/articles/s41598-021-02136-y">[Paper]</a>
<a style="font-weight:bold" href="https://static-content.springer.com/esm/art%3A10.1038%2Fs41598-021-02136-y/MediaObjects/41598_2021_2136_MOESM1_ESM.pdf">[Supplementary materials]</a>
</div> 

---


## Overview

We have used 561 chromaticity coordinates as optimisation targets which were located along the Planckian locus between 2700 K and 7443 K. The targets were selected with Duv's between -0.048 to +0.048 from Planck.

In this repository, we provide the raw spectra data of our optimisation procedure. Additionally, a demo script ```Main.m``` is available that reproduces the figures and the reported values from the paper using the optimised spectra.

The spectral database is divided into three individual files each containing the spectra from the 6-channel, 8-channel and 11-channel luminaire. The use of a certain number of LED channels does not mean that all spectra were generated with a constant channel count. For instance, there may be spectra in the 6-channel data set that were generated with three or four channels. The labeling of the channel count of a luminaire defines the upper limit of available channels for generating the spectra for reaching a target chromaticity point. You need to download the following files before you can start the ```Main.m``` file.

The spectral raw data were stored in the TUdatalib repository: https://tudatalib.ulb.tu-darmstadt.de/handle/tudatalib/3291

Below you can find the direct download links.

**Spectral raw database of the 6-channel LED luminaire:** [Download-Link (130 385 spectra, 405 MB)](https://tudatalib.ulb.tu-darmstadt.de/bitstream/handle/tudatalib/3291/Optim_CH6_L220_Mel_Limit.csv.zip?sequence=1&isAllowed=y)

**Spectral raw database of the 8-channel LED luminaire:** [Download-Link (172 693 spectra, 553 MB)](https://tudatalib.ulb.tu-darmstadt.de/bitstream/handle/tudatalib/3291/Optim_CH8_L220_Mel_Limit.csv.zip?sequence=2&isAllowed=y)

**Spectral raw database of the 11-channel LED luminaire:** [Download-Link (186 990 spectra, 622 MB)](https://tudatalib.ulb.tu-darmstadt.de/bitstream/handle/tudatalib/3291/Optim_CH11_L220_Mel_Limit.csv.zip?sequence=3&isAllowed=y)

Please download these data unzip it and place it into the `A00_Data/` folder. The spectral raw database contains the following values:

**Column 1 -** `IndexNumber_Target`: Continuous number that identifies the index of the optimisation target. A total of 561 optimisation targets were used.

**Column 2 -** `OptimCounter`: The optimisation was performed in a loop to obtain as many spectra for a given chromaticity target as possible. This index defines from which optimisation round the respective optimised spectrum originates. If the same number appears repeatedly, it means that several spectra were found in one optimisation round. The number is not continuous, as it is also possible that no spectra were found in an optimisation round. The counter must be considered in relation to the `IndexNumber_Target`, because with a new optimisation target, the counter started from 0.

**Column 3 -** `CCT_Target`: The CCT of the chromaticity target.

**Column 4 -** `Duv_Target`: The target Duv from Planck in absolut units.

**Column 5 -** `Duv_signed`: Duv from Planck.

**Column 6 -** `Luminance_Target`: The provided spectra (see column XX) were optimised to reach a luminance of 220 cd/m<sup>2</sup> with a tolerance of 2 cd/m<sup>2</sup>. You can scale the spectra to any intensity you need with the provided method in `A01_Methods/ScaleSpectra.m`.

**Column 7 & 8 -** `u1976_Target` and `v1976_Target`: CIEu'v' target coordinates for optimisation.

**Column 9 -** `Luminance_Actual`: The actual luminance calculated from the optimised spectrum.

**Column 10 & 11 -** `u1976_Actual` and `v1976_Actual`: The actual CIEu'v' coordinates calculated from the optimised spectrum.

**Column 12 -** `MelanopicRadiance_Actual`: The actual melanopic radiance W/m<sup>2</sup>sr calculated from the optimised spectrum.

**Column 13 & 14 -** `CIEx2Degree_Actual` and `CIEy2Degree_Actual`: The actual CIExy-2° coordinates calculated from the CIEu'v' coordinates.

**Column 15 -** `LuminanceDifference_TargetTOActucal`: The difference between the specified target luminance and the actual luminance. In the optimisation, the difference was restricted to 2 cd/m<sup>2</sup>.

**Column 16 & 17 -** `u1976_Difference_TargetTOActural` and `v1976_Difference_TargetTOActural`: The difference between the specified target CIEu'v' coordinates and the actual CIEu'v' coordinates.

**Column 18 -** `OptimResult_Number`:  Since several spectra could be found in an optimisation round, this index indicates the number of spectra found in an optimisation round.

**Column 20 -** `CCT_Actual`:  Actual CCT.

**Column 21 -** `CRI_Actual`:  Actual CRI.

**Column 21 -** `Rf_Actual`:  Actual Rf according to the CIE implementation. Not this metric was not used for evaluating the colour fidelity. In the `Main.m` script, the TM30:20 values will be loaded, which were calculated using the Luxpy package from Kevin Smet. See the Main_CalcTM30_20.py for further details. See the `Main_CalcTM30_20.py` for further details.

**Column 39 to 439 -** `x380Nm`, `x381Nm`, `....`, `x780Nm`: The optimised spectrum which is stated in radiance W/m<sup>2</sup>sr nm. Note that these spectra were optimised for the luminance target 220 cd/m<sup>2</sup> and a tolerance of 2 cd/m<sup>2</sup>.

**Column 440 to 442 -** `MelanopicEDI_XXXlx`: The calculated melanopicEDI from the optimised spectra for three different photopic illuminance levels (250 lx, 500 lx, 700lx). To calculate these values, the spectra in columns 39 to 439 were rescaled using the `A01_Methods/ScaleSpectra.m` script.

**Column 443 to 445 -** `MelanopicDER_XXXlx`: The calculated melanopicDER from the optimised spectra for three different photopic illuminance levels (250 lx, 500 lx, 700lx). To calculate these values, the spectra in columns 39 to 439 were rescaled using the `A01_Methods/ScaleSpectra.m` script.

## Misc

The TM30-20 metrics in the files `A00_Data/TM_30_CH6_L220.csv`, `A00_Data/TM_30_CH8_L220.csv` and `A00_Data/TM_30_CH11_L220.csv` were caluclated using the luxpy python library with the `Main_CalcTM30_20.py` script. In the `environment.yml` or `requirements.txt`, our python environment is provided. 

Link to the Luxpy library: https://github.com/ksmet1977/luxpy

Read the following paper for more information about the Luxpy library: Smet, K. A. G. (2019). Tutorial: The LuxPy Python Toolbox for Lighting and Color Science. LEUKOS, DOI: 10.1080/15502724.2018.1518717.

## Citation

Please consider to cite our work if you find this repository or our results useful for your research:

Zandi, B.; Stefani, O.; Herzog, A.; Schlangen, L.; Trinh, QV; Khanh, TQ. Optimising metameric spectra for integrative lighting to modulate the circadian system without affecting visual appearance. *Scientific Reports* **11,** 23188 (2021). https://doi.org/10.1038/s41598-021-02136-y

```bib
@article{Zandi2021d,
author = {Zandi, Babak and Stefani, Oliver and Herzog, Alexander and Schlangen, Luc and Trinh, Quang Vinh and Khanh, Tran Quoc},
doi = {10.1038/s41598-021-02136-y},
issn = {2045-2322},
journal = {Scientific Reports},
number = {1},
pages = {23188},
title = {{Optimising metameric spectra for integrative lighting to modulate the circadian system without affecting visual appearance}},
url = {https://doi.org/10.1038/s41598-021-02136-y},
volume = {11},
year = {2021}}
```