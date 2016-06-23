# loadrating
This project uses Matlab class definitions to provide an object oriented approach to load rating analysis. The goal is to build an extensible framework that can be used now as well as built upon as additional use-cases are encountered.


## Where to start
This project can be downloaded manually (if you do not plan on editing) or by using [Git](https://git-scm.com). Downloading and incorporating the Git client into your workflow is best as you will be able to save and track any changes you make (i.e. bug fixes, new features) which can then be merged back into this repository relatively easily, so please use it :)


### Using Git Bash
To use Git, download from the link above and install. Open the Git Bash terminal and navigate to the project's root directory (i.e. C:\Users\John\Projects) and type:

```
git clone https://github.com/johndevitis/loadrating
```

This will automatically create a folder named `loadrating` in the current directory and download the contents of the remote repository to your local machine. From here, you have an up to date snapshot of the entire project and can begin using/exploring.

If you are new to Git, I highly recommend reviewing the [manual](https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control) or [cheatsheet](https://services.github.com/kit/downloads/github-git-cheat-sheet.pdf). I also have a list of a few commands I find myself using a lot [here](https://github.com/johndevitis/useful_things).

## Examples


# to do

* check for non-composite capacity calcs

* lfr
	* ~~add negative section info to getPosFlex~~ added compNeg input to lfr.getPosFlex, so it needs two section classes as inputs now - the section at the positive region as well as negative region
	* ~~fix lateral torsional buckling moment calculation in LFR getNegFlex (completely broken)~~ This should be fixed, just needs to be error screened
  * change Mu -> Mn to be consistent w/ aashto documentation
