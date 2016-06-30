%% LFR Resistance for steel composite section 
%
% note: 
%   for more detailed comments regarding working w/ matlab classes see the
%   capacity_ex_lrfr example
% 
% jdv 06/24/2016

%% get lfr capacity - positive region - flexure 

% create instance of composite section class
% note: comp class is a subclass of the section class
c = comp();

% read positive section props from 
c.read_csv('sectionprops_pos.csv');

% LFR positive flexure resistance requires corresponding negative
% section properties in addition to the positive section properties, so
% we'll load these also
cNeg = comp();
cNeg.read_csv('sectionprops_neg.csv');


% get single line girder [SLG] demands w/ section method
%  note: because comp class is a subclass of section class, it inherets its
%  methods
d = c.getSLGdemands();

% create instance of lfr rating structure
% note that the class definition and folder structure keep the function
% name spaces seperate. so there's no conflicts between functions w/ the
% same name in different class folders such as lfr.getPosFlex() and 
% lrfr.getPosFlex() 
r = lfr(); 

% positive flexure resistance
r.getPosFlex(c,cNeg,d)


%% get lfr capacity - negative region - flexure and shear

% no need to load data, we already have cNeg loaded

% create instance of lfr rating class
r = lfr();
r.region = 'neg'; % change from 'pos' default - note this is only needed in lrfr 
r.getShear(cNeg) % shear
r.getNegFlex(cNeg) % negative flexure 


