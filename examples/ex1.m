%%
%
% jdv 05252016

%% read/write from xls/csv file
pname = 'C:\Users\John\Documents\MATLAB\repos\loadrating\data';  %path
fname = 'sectionprops.xlsx';  %file name
tab = 'example1'; % tab name

% read 
s = section();
s.read_xls(fullfile(pname,fname),tab)

% write to new
newname = 'sectionprops_new.xlsx';
s.write(fullfile(pname,newname));







