% Calculate Section Properties

clear 
clc

filename = 'C:\Users\Nick\Desktop\TestFile.xlsx';
sheet = 1;
column = 'B';
xlStart = 1;

%% DO NOT EDIT BELOW THIS LINE

% Import from Excel
xlEnd = xlStart + 28;
xlRange = [column num2str(xlStart) ':' column num2str(xlEnd)];
[~,~,raw] = xlsread(filename,sheet,xlRange);

% Inputs
s.girderNumber = raw{1};
s.girderDes    = raw{2};
s.nSpans       = raw{3};
s.spanLength   = raw{4};
s.Es           = raw{5};
s.Fy           = raw{6};
s.fc           = raw{7};
s.ts           = raw{8}; 
s.be           = raw{9}; 
s.dh           = raw{10}; 
s.dw           = raw{11};  
s.tw           = raw{12}; 
s.id{1}        = raw{13};
s.st7id(1)     = raw{14};
s.Lb(1)        = raw{15};
s.bf_top(1)    = raw{16}; 
s.tf_top(1)    = raw{17};  
s.bf_bottom(1) = raw{18}; 
s.tf_bottom(1) = raw{19};
s.id{2}        = raw{20};
s.st7id(2)     = raw{21};
s.Lb(2)        = raw{22};
s.bf_top(2)    = raw{23}; 
s.tf_top(2)    = raw{24};  
s.bf_bottom(2) = raw{25}; 
s.tf_bottom(2) = raw{26};
d.wDL          = raw{27};
d.wSDL         = raw{28};
d.wSDW         = raw{29};

% Get non-composite section properties
s = GetNonCompositeSectionProperties(s);

% Get composite section properties (required for positive section only)
s = GetCompositeSectionProperties(s);

% SLG Analysis
d = GetDeadLoadSLGDemands(s,d);

% LRFR Positive
s = CalculatePositiveSectionResistance_LRFR(s,d);

% LRFR Negative
if s.nSpans > 1
    s = CalculateNegativeSectionResistance_LRFR(s);
end

% LFR Positive
s = CalculatePositiveSectionResistance_LFR(s,d);

% LFR Negative
if s.nSpans > 1
    s = CalculateNegativeSectionResistance_LFR(s);
end

% Convert back to cell for filtering and exporting
ss = struct2cell(s);
dd = struct2cell(d);

% Filter 
out = [ss(xlStart:12);...
       ss{13}(1);ss{14}(1);ss{15}(1);ss{16}(1);ss{17}(1);ss{18}(1);ss{19}(1);...
       ss{13}(2);ss{14}(2);ss{15}(2);ss{16}(2);ss{17}(2);ss{18}(2);ss{19}(2);...      
       dd(1:3);...
       ss(20);...
       ss{21}(1);ss{22}(1);ss{23}(1);ss{24}(1);ss{25}(1);ss{26}(1);ss{27}(1);ss{28}(1);ss{29}(1);ss{30}(1);ss{31}(1);...
       ss{21}(2);ss{22}(2);ss{23}(2);ss{24}(2);ss{25}(2);ss{26}(2);ss{27}(2);ss{28}(2);ss{29}(2);ss{30}(2);ss{31}(2);...
       ss(32:57);...
       min(ss{58});...
       ss(59:end)];

% Export to Excel
xlRange = [column num2str(xlStart) ':' column num2str(length(out))];
xlswrite(filename,out,sheet,xlRange);
