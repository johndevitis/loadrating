function s = GetCompositeSectionProperties(s)

% Define Variables
fc = s.fc;
Es = s.Es;
be = s.be;
d = s.d(1);
ts = s.ts;
dh = s.dh;
A = s.A(1);
yBnc = s.yBnc(1);
Ix = s.Ix(1);

% Deck Modulous
s.Ec = 57000*sqrt(fc);

% Modulous Ratio (N)
s.N = Es/s.Ec;

% Transform section to short-term/long-term
% Determine short-term and long-term effective width 
s.beLT = be/(3*s.N);
s.beST = be/s.N;

% Determine short-term and long-term effective area
s.AeLT = ts*s.beLT;
s.AeST = ts*s.beST;
  
% Total Depth of Composite Section
s.D = d+ts+dh;

% Determine distances from centroid of composite short/long-term section to top, bottom
% and deck(bottom of girder is reference axis). 

Alt = s.AeLT;
Ast = s.AeST;

% Short-term 
yBst = (Ast.*(ts/2 + dh + d) + A.*yBnc)./(Ast+A); % formula to find centroid: y = sum(Ai*yi)/sum(Ai)

fprintf('Find location of elastic neutral axis \n')
if yBst > d % Elastic Neutral Axis is in the deck
    fprintf('ENA in deck\n');
    s.yBst = yBst; 
    s.yTst = yBst - d;
    yDst = s.D - yBst; 
elseif yBst < d % Elastic Neutral Axis is in the steel
    s.yBst = yBst; 
    s.yTst = d - yBst;
    yDst = s.D - yBst; 
end
% Long-term
yBlt = (Alt*(ts/2 + dh + d) + A*yBnc)/(Alt+A); % formula to find centroid: y = sum(Ai*yi)/sum(Ai)
if yBlt > d % Elastic Neutral Axis is in the deck
    s.yBlt = yBlt;
    s.yTlt = yBlt - d;
    yDlt = s.D - yBlt; 
elseif yBlt < d % Elastic Neutral Axis is in the steel
    s.yBlt = yBlt;
    s.yTlt = d - yBlt;
    yDlt = s.D - yBlt; 
end

% Caclulate short-term and long term moments of inertia 

% Short-Term 
s.Ist = Ix + A*(yBst-d/2)^2 +...
    Ast*ts^2/12 + Ast*(yDst - ts/2)^2;   
% Long-Term 
s.Ilt=  Ix + A*(yBlt-d/2)^2 +...
    Alt*ts^2/12 + Alt*(yDlt - ts/2)^2;

% Caclulate short-term and long-term elastic section modulii 

% Short-Term 
% Section.SDst = Section.Ist/Section.yDst;
s.STst = s.Ist/s.yTst;
s.SBst = s.Ist/s.yBst;

% Long-Term 
% Section.SDlt = Section.Ilt/Section.yDlt;
s.STlt = s.Ilt/s.yTlt;
s.SBlt = s.Ilt/s.yBlt;


end