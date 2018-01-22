# sweep

Create a batch of input files from a batch definition file and a template.

The program reads a set of parameters to sweep and the values to use for this
parameter sweep from a spreadsheet file, and reads the template input file
from a text file. It then combines the two, creating a separate input file for
each set of parameter values, ready for a batch run.

Currently highly dependent on what type of filing system is being used,
would be good to generalize. Currently sets up one folder per set of parameter
values.

Based on `sweepLORASR` v0.4.4.0
