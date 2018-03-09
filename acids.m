function acids(pka,varargin)
%ACIDS Shows the graph of dissociation of a given acids
%Acids can plot from monoprotic to tetraprotic acids
%
% Syntax: acids(pka,c,txt)
%
%     Inputs:
%           pka - Array of the pKa of the acid - mandatory
%           c - Concentration of the acid in M (optional - default 100 mM)
%           txt - Name of the acid (optional)
%     Outputs:
%           - Dissociation plot
%
% Example:
% for the Phosphoric acid 100 mM
% pka=[2.1 7.2 12.6];
%
%   Calling on Matlab the function: 
%      acids(pka)
% it plots 
% acid line (in red)
% I amphiprotic line (in green)
% II amphiprotic line (in magenta)
% basic line (in blue)
% H+ and OH- lines (in cyan)
% black cross in corrispondence of pKa
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2007) Acids: plot the dissociation plot of a given acid. 
% http://www.mathworks.com/matlabcentral/fileexchange/15956

%Input error handling
p = inputParser;
validationpka = @(x) all(isnumeric(x)) && isvector(x) && all(isreal (x)) && all(isfinite(x)) && all((x > 0)) && isrow(x) && length(x)<=4;
addRequired(p,'pka',validationpka);
defaultconcentration=0.1;
validationconcentration = @(x) isempty(x) || (isnumeric(x) && isscalar(x) && isreal (x) && isfinite(x) && (x > 0));
addOptional(p,'c',defaultconcentration,validationconcentration);
validationtxt=@(x) ischar(x) || isempty(x);
addOptional(p,'txt',[],validationtxt);
parse(p,pka,varargin{:});
pka=p.Results.pka; c=p.Results.c; txt=p.Results.txt;
if isempty(c)
    c=defaultconcentration;
end
clear p default* validation*

lc=log10(c); %log of concentration
x=linspace(0,14,300); 
exponential=@(a,b) 10.^(a-b);
hold on
switch numel(pka)
    case 1 %monoprotic acid
        if isempty(txt)
            txt='Monoprotic acid';
        end
        f1=exponential(x,pka);
        % Acid line determination
        ac=lc-log10(1+f1);
        % Basic line determination
        b=lc-log10(1+1./f1);
        % Plot splines and system point
        H(1:2)=plot(x,ac,'-r',x,b,'-b');
        legendtxt={'Acid Species','Basic Species','Water H^+','Water OH^-'};
    case 2 %biprotic acid
        if isempty(txt)
            txt='Biprotic acid';
        end
        f1=exponential(x,pka(1));
        f2=exponential(x,pka(2));
        f12=f1.*f2;
        % Acid line determination
        ac=lc-log10(1+f1+f12);
        % Amphiprotic line determination
        an=lc-log10(1+1./f1+f2); 
        % Basic line determination
        b=lc-log10(1+1./f12+1./f2);
        % Plot splines and system points
		H(1:3)=plot(x,ac,'-r',x,an,'-g',x,b,'-b');
        legendtxt={'Acid Species','1^s^t Amphiprotic Species','Basic Species','Water H^+','Water OH^-'};
    case 3 %triprotic acid
        if isempty(txt)
            txt='Triprotic acid';
        end
        f1=exponential(x,pka(1));
        f2=exponential(x,pka(2));
        f3=exponential(x,pka(3));
        f12=f1.*f2;
        f23=f2.*f3;
        f123=f1.*f23;
        % Acid line determination
        ac=lc-log10(1+f1+f12+f123); 
  	  	% I Amphiprotic line determination
        an1=lc-log10(1+1./f1+f2+f23);
        % II Amphiprotic line determination
        an2=lc-log10(1+1./f12+1./f2+f3);
        % Basic line determination
        b=lc-log10(1+1./f123+1./f23+1./f3); 
        % Plot splines and system points
	    H(1:4)=plot(x,ac,'-r',x,an1,'-g',x,an2,'-m',x,b,'-b');
        legendtxt={'Acid Species','1^s^t Amphiprotic Species','2^n^d Amphiprotic Species','Basic Species','Water H^+','Water OH^-'};
    case 4 %tetraprotic acid
        if isempty(txt)
            txt='Tetraprotic acid';
        end
        f1=exponential(x,pka(1));
        f2=exponential(x,pka(2));
        f3=exponential(x,pka(3));
        f4=exponential(x,pka(4));
        f12=f1.*f2;
        f23=f2.*f3;
        f34=f3.*f4;
        f123=f1.*f23;
        f234=f23.*f4;
        f1234=f123.*f4;
        % Acid line determination
        ac=lc-log10(1+f1+f12+f123+f1234); 
        % I Amphiprotic line determination
        an1=lc-log10(1+1./f1+f2+f23+f234);
        % II Amphiprotic line determination
        an2=lc-log10(1+1./f12+1./f2+f3+f34);
        % III Amphiprotic line determination
        an3=lc-log10(1+1./f123+1./f23+1./f3+f4);
        % Basic line determination
        b=lc-log10(1+1./f1234+1./f234+1./f34+1./f4); 
        % Plot splines and system points
	    H(1:5)=plot(x,ac,'-r',x,an1,'-g',x,an2,'-m',x,an3,'-k',x,b,'-b');
        legendtxt={'Acid Species','1^s^t Amphiprotic Species','2^n^d Amphiprotic Species','3^r^d Amphiprotic Species','Basic Species','Water H^+','Water OH^-'};
end
H(end+1:end+2)=plot([0 14],[-14 0],'-c',[0 14],[0 -14],'-c'); %plot water
if ~isempty(pka)
    plot(pka,lc,'+k')
end
hold off
grid on
axis([0 14 -14 max(0,lc+1)])
axis square
title(txt)
xlabel('pH')
ylabel('Log10 of concentration in Molarity')
legend(H,legendtxt,'Location','NorthEastOutside')
end
