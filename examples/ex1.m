%%
%
% jdv 05252016

% read/write from xls file
pname = 'C:\Users\John\Documents\MATLAB\repos\loadrating\data';  %path
fname = 'sectionprops.xlsx';  %file name
tname = 'example1'; % tab name

s = section();
s.read_xls(fullfile(pname,fname),tname);










