# loadrating
This project uses Matlab class definitions to provide an object oriented approach to load rating analysis. The goal is to build an extensible framework that can be used now as well as built upon as additional use-cases are encountered.


## Where to start
This project can be downloaded manually (if you do not plan on editing) or by using [Git](https://git-scm.com). Downloading and incorporating the Git client into your workflow is best as you will be able to save and track any changes you make (i.e. bug fixes, new features) which can then be merged back into this repository relatively easily, so please use it :)

Once you have the windows client installed, grab the code (using info in the next section) and check out the examples described in below  


### Using Git Bash
To use Git, download from the link above and install. Open the Git Bash terminal and navigate to the project's root directory (i.e. C:\Users\John\Projects) and type:

```
git clone https://github.com/johndevitis/loadrating
```

This will automatically create a folder named `loadrating` in the current directory and download the contents of the remote repository to your local machine. From here, you have an up to date snapshot of the entire project and can begin using/exploring.

If you are new to Git, these links are a good place to start:

* [the manual](https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control)
* [the cheatsheet](https://services.github.com/kit/downloads/github-git-cheat-sheet.pdf)
* [a few commands I find myself using a lot](https://github.com/johndevitis/useful_things)

## Examples

Project files are expected to be on the Matlab search path. You can either add all folders/subfolders manually or run the `init.m` script in the project root.

The following is an overview of the examples located in `loadrating/examples/`


### LRFR Positive Flexure Capacity

Create an instance of composite section class:
```
c = comp();
```

Read inputs from file using dot notation:
```
c.read_csv('sectionprops_pos.csv');
```

Get single line girder [SLG] demands:
```
d = c.getSLGdemands();
```

Create instance of LRFR class and get positive flexure resistance:
```
r = lrfr();
r.getPosFlex(c,d);
```

### LRFR Negative Flexure and Shear

Load data:
```
c = comp();
c.read_csv('sectionprops_neg.csv');
```

Get negative flexure and shear resistance:
```
r = lrfr();
r.region = 'neg'; % change from positive default
r.getShear()
r.getNegFlex()
```


### LFR Positive Flexure

LFR positive flexure is similar to LRFR but also requires flange info from the corresponding section at the negative moment region. This is handled by passing an additional section class to the lfr rating class with that info:
```
cPos = comp();  % positive section
cNeg = comp();  % negative section
r = lfr();      % lfr object

cPos.read_csv('sectionprops_pos.csv');
cNeg.read_csv('sectionprops_pos.csv');

% get demands using positive section
d = cPos.getSLGdemands();

% positive flexure resistance
r.getPosFlex(cPos,cNeg,d)
```

### LFR Negative Flexure

Using the negative section from LFR Positive Flexure example above:
```
r = lfr();          % create new instance
r.region = 'neg';   % currently optional for lfr
r.getShear(cNeg)    % shear
r.getNegFlex(cNeg)  % flexure
```
