%% capacity_ex1()
%
% LRFR Resistance for steel composite section 
% 
% jdv 06/22/2016

%% get lrfr capacity - positive region - flexure 

% create instance of composite section class
% note: comp class is a subclass of the section class
c = comp();

% read inputs from file
c.read_csv('sectionprops_pos.csv');

% get single line girder [SLG] demands w/ section method
%  note: because comp class is a subclass of section class, it inherets its
%  methods
d = c.getSLGdemands();

% create instance of lrfr rating structure
r = lrfr()

% positive flexure resistance
r.getPosFlex(c,d)


%% get lrfr capacity - negative region - flexure and shear

% load data
c = comp();
c.read_csv('sectionprops_neg.csv');

% rating
r = lrfr();
r.region = 'neg'; % change from 'pos' default
r.getShear(c) % shear
r.getNegFlex(c) % negative flexure 