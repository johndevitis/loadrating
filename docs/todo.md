# to do

* check for non-composite capacity calcs

* lfr
	* ~~add negative section info to getPosFlex~~ added compNeg input to lfr.getPosFlex, so it needs two section classes as inputs now - the section at the positive region as well as negative region

	* ~~fix lateral torsional buckling moment calculation in LFR getNegFlex (completely broken)~~ This should be fixed, just needs a case to be error screened with
* change Mu -> Mn to be consistent w/ aashto documentation
