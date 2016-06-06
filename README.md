# Loadrating
Load rating toolbox based in Matlab. This project uses Matlab class definitions to provide an object oriented approach to load rating analysis. The goal is to build an extensible framework that can be used now as well as built upon as additional use-cases are encountered. 


# Setup

## Download
This project can be downloaded manually (if you do not plan on editing) or by using [Git](https://git-scm.com). Downloading the Git client is best as you will be able to keep up to date on any changes (i.e. bug fixes) as well as keep track of any changes you make. Those changes can be merged back into this repository relatively easily, so please use it :) 

## Git 
### Using Git Bash
To use Git, download from the link above and install. Open the Git Bash terminal in the parent directory of where you wish to install (i.e. C:\Users\John\Projects) and type:

```
git clone https://github.com/johndevitis/loadrating
```

This will automatically create a folder named `loadrating` in the parent directory and download the contents of the remote repository to your local machine. From here, you have an up to date snapshot of the entire project and can begin using/exploring.

If you are new to Git, I highly recommend reviewing the [manual](https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control) or [cheatsheet](https://services.github.com/kit/downloads/github-git-cheat-sheet.pdf)


# Examples

## Example1
example1.m shows how to programmatically set up the working environment and name spaces of the project as well as read/write properties using the section class. section is subclassed by filio, thus, it inherets all of the functionality contained in the file @fileio/fileio.m


