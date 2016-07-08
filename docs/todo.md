# to do

## General 

* need an automated compare function for tests
* need to finish adding test case
* fix read/write for general case (non subclassed objects)
* refactor demands structure into class
* add non-composite test

## Meeting w/ Pedram
* code assumes multiple spans have the same length, need to have array of lengths to allow difference span lengths for multi-span bridges
* section properties assume only one section throughout length of span - sections may vary though which will effect deadload 
	* in the same vane, diaphragm deadload is ignored as well
	* REFERENCE 3-16 of FHWA LRFD Steel Bridge Design Example (pdf page 127) - uses DLmisc = .015 K/ft
* section props (yTcn yBnc) assume top and bottom flange are same thickness - FIX
* S2 calc in section - Iy/bf_bot/2 -> why bottom flange? 



## Rating

* check for non-composite capacity calcs

* lfr

	* ~~add negative section info to getPosFlex~~ added compNeg input to lfr.getPosFlex, so it needs two section classes as inputs now - the section at the positive region as well as negative region
	
	* ~~fix lateral torsional buckling moment calculation in LFR getNegFlex (completely broken)~~ This should be fixed, just needs a case to be error screened with
	
* change Mu -> Mn to be consistent w/ aashto documentation

