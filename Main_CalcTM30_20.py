# This script calculates the TM30-20 metrics from the spectral data
# in the 'A00_Data' folder
# The following packages are used for this:

# Luxpy library citation:
# Smet, K. A. G. (2019).
# Tutorial: The LuxPy Python Toolbox for Lighting and Color Science.
# LEUKOS, 1–23. DOI: 10.1080/15502724.2018.1518717

# Numpy library citation:
# Harris CR, Millman KJ, van der Walt SJ, Gommers R, Virtanen P, Cournapeau D, et al.
# Array programming with NumPy. Nature. 2020;585:357–62.

# Pandas library citation:
# McKinney, W. (2010).
# Data structures for statistical computing in python.
# In Proceedings of the 9th Python in Science Conference (Vol. 445, pp. 51–56)

import luxpy as lx
import pandas as pd
import numpy as np
import time
import sys
np.set_printoptions(threshold=sys.maxsize)


def importData(PATH):
    Start = time.time()

    Data = pd.read_csv(PATH)

    NumberOfData = Data.shape[0]

    End = time.time()

    print('Load time: {:.3f} Minutes'.format((End-Start)/60))
    print('Loaded {:.3f} Data'.format(NumberOfData))

    return Data, NumberOfData


# Get the data from the dataframe and seprate into bins
def getData(FullSpectraDF, NumberOfData, NumberBins):

    # Create a array for the wavelengths
    Wavelength = np.arange(380, 780+1)
    Wavelength = Wavelength.reshape(1, Wavelength.shape[0])

    # Casting the spectral data to a numpy array
    Spectra_numpy = FullSpectraDF.iloc[0:NumberOfData, 38:439].to_numpy()

    # The data will be splitted into several bins for faster calculations
    SpectraBins = np.array_split(Spectra_numpy, NumberBins)

    # The luxpy library expects that the first line of an array are the wavelength data
    # Therefore each the wavelength array will be added to the first line of each bin
    for i in range(NumberBins):
        SpectraBins[i] = np.concatenate((Wavelength, SpectraBins[i]), axis=0)

    return SpectraBins


def calc_TM30_20(SpectralDataBins, NumberBins):
    # Note: for a full report use the following code snippet: Rf_List.append(tm30_dict['Rf'], report_type='full', save_fig_name='PATH')
    Start = time.time()
    Rf_TM30 = []
    Rg_TM30 = []
    Rcsh1_TM30 = []
    Rfh1_TM30 = []

    # Calculations of the TM30-20 metrics using the luxpy library
    for i in range(NumberBins):
        tm30_dict = lx.cri._tm30_process_spd(spd=SpectralDataBins[i], cri_type='ies-tm30')
        Rf_TM30 = np.append(Rf_TM30, tm30_dict['Rf'])
        Rg_TM30 = np.append(Rg_TM30, tm30_dict['Rg'])
        Rcsh1_TM30 = np.append(Rcsh1_TM30, tm30_dict['Rcshj'][0])
        Rfh1_TM30 = np.append(Rfh1_TM30, tm30_dict['Rfhj'][0])

    # Round values
    Rf_TM30 = np.rint(Rf_TM30)
    Rg_TM30 = np.rint(Rg_TM30)
    Rcsh1_TM30 = np.rint(Rcsh1_TM30*100)
    Rfh1_TM30 = np.rint(Rfh1_TM30)

    # Cast to pandas dataframe
    data_pd = np.hstack((Rf_TM30[:, None],
                         Rg_TM30[:, None],
                         Rcsh1_TM30[:, None],
                         Rfh1_TM30[:, None]))

    CalcDataFrame = pd.DataFrame(data=data_pd, columns=['Rf_TM30', 'Rg_TM30', 'Rcsh1_TM30', 'Rfh1_TM30'])

    End = time.time()

    print('Time of calculation: {:.3f} Minuten'.format((End-Start)/60))

    return CalcDataFrame


def run(DataPath, NumberBins):

    # Import the data
    ImportedData, NumberOfData = importData(PATH=DataPath)

    # Seperate the data intp bins and prepare for luypy
    SpecData = getData(FullSpectraDF=ImportedData,
                       NumberOfData=NumberOfData,
                       NumberBins=NumberBins)

    # Rund the calculation
    Results = calc_TM30_20(SpecData, NumberBins)

    return Results


if __name__ == '__main__':
    Start = time.time()

    # Choose a number, depending which spectral dataset should be used to calculate the metrics
    DataNumber = 3

    if DataNumber == 1:
        DataPath = "A00_Data/Optim_CH6_L220_Mel_Limit.csv"
        ExportPath = 'A00_Data//TM_30_CH6_L220.csv'
    elif DataNumber == 2:
        DataPath = "A00_Data/Optim_CH8_L220_Mel_Limit.csv"
        ExportPath = 'A00_Data/TM_30_CH8_L220.csv'
    elif DataNumber == 3:
        DataPath = "A00_Data/Optim_CH11_L220_Mel_Limit.csv"
        ExportPath = 'A00_Data/TM_30_CH11_L220.csv'

    # As we use vector operations, the data will be splitted into bins for faster calculations
    NumberBins = 80

    # Run the calculation. Note that this step may took a while (approx. 5 minutes)
    Results = run(DataPath=DataPath,
                  NumberBins=NumberBins)

    # The calculation time will be printed
    print('Calculated {:.3f} Data'.format(Results.shape[0]))

    # The results will be exported to the folder 'A00_Data/'
    Results.to_csv(path_or_buf=ExportPath, index=False)

    End = time.time()

    # The total runtime will be printed
    print('Total runtime: {:.3f} Minuten'.format((End-Start)/60))
