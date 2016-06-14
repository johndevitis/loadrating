%% example1 - section_readwrite
%
% demonstrate section input/output capabilities
%
% example1 shows how to programmatically set up the working environment and 
% name spaces of the project as well as read/write properties using the 
% section class. section is subclassed by filio, thus, it inherets all of 
% the functionality contained in the file @fileio/fileio.m

% jdv 05252016


%% generate project paths and add to current namespace

% define the root path of the project (this will be where you cloned the
% project to using git
pname = 'C:\Users\John\Documents\MATLAB\repos\loadrating'; 

% generate paths to folders/subfolders and add to namespace
addpath(genpath(pname));


%% fileio class

% create instance of the section class
s = section();

% you can view the methods (think of these as functions) of the fileio
% class by executing the following. view the results in the command window
methods(s)

% you can also view help documentation of these methods like any other
% matlab function. the only difference is with classes, you use the dot
% notation
help s.read_xls


%% read from xls file

% define file name
fname = 'sectionprops.xlsx'; 

% define tab name
tab = 'example1'; 

% read file
s.read_xls(fname,tab);

% display contents of section
% note: 
%  1. the read_xls() method automatically matched the varaibles defined in 
%     the first column of the xls file and assigned the value to the section
%     property
%  2. the auto-generated dependent properties
disp(s)


%% write to xls file

% define new path and filename. note that tab name is optional
newpath = 'C:\Users\John\Desktop';
newname1 = 'sectionprops_new.xlsx';

% use the write_xls method to write section properties to new file
s.write_xls(fullfile(newpath,newname));


%% generalized fileio
% you can also use the read/write functions for generalized fileio. for
% example, we can write a comma and tab deliminated file using the write
% method

% the default deliminator is a comma
newname2 = 'sectionprops_comma.csv';
s.write(fullfile(newpath,newname2))

% the write method also takes an optional deliminator input. from the help,
% this can be either 't', 'tab', or the literal '\t'
newname3 = 'sectionprops_tab.txt';
s.write(fullfile(newpath,newname3),'tab');

% view written files
edit(fullfile(newpath,newname2));
edit(fullfile(newpath,newname3));





