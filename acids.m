function acids(pka, varargin)
%ACIDS Plot the dissociation curves of polyprotic acids
%   ACIDS(PKA, C, TXT) plots the log10 concentration vs pH distribution
%   curves for monoprotic up to tetraprotic acids, including water
%   auto-ionization lines.
%
%   INPUT
%     PKA - Row vector of pKa values of the acid (mandatory).
%           Length(PKA) must be between 1 and 4 (mono–tetraprotic).
%
%     C   - Total analytical concentration of the acid [M].
%           Optional, scalar, positive.
%           Default: 0.1 M (100 mM).
%
%     TXT - Acid name, used as plot title (optional).
%           Default: a generic description based on the number of pKa.
%
%   OUTPUT
%     A dissociation plot is displayed, showing:
%       - Acid species line(s)
%       - Amphiprotic species lines (if any)
%       - Basic species line
%       - Water [H+] and [OH-] lines
%       - Black crosses at each pKa value
%
%   EXAMPLE
%     % Phosphoric acid (H3PO4), 100 mM
%     pka = [2.1 7.2 12.6];
%     acids(pka);  % uses default C = 0.1 M
%
%   The plot includes:
%     - Acid line (red)
%     - Amphiprotic line(s) (green, magenta, black depending on order)
%     - Basic line (blue)
%     - H+ and OH- lines (cyan)
%     - Black cross at each pKa
%
%   ------------------------------------------------------------------
%   Author and citation:
%   ------------------------------------------------------------------
%   Created by:  Giuseppe Cardillo
%   E-mail:      giuseppe.cardillo.75@gmail.com
%
%   To cite this file:
%   Cardillo G. (2007). acids.m – Plot the dissociation diagram of a
%   given acid (from monoprotic to tetraprotic).
%
%   GitHub repository:
%   https://github.com/dnafinder/acids
%   ------------------------------------------------------------------

% ------------------------- Input error handling ----------------------
p = inputParser;

% PKA: mandatory, numeric row vector, positive, finite
addRequired(p, 'pka', @(x) validateattributes(x, {'numeric'}, ...
    {'row','real','finite','nonnan','positive'}));

% Default concentration
defaultConcentration = 0.1; % [M] = 100 mM

% C: optional, scalar, positive, real, finite
validationConcentration = @(x) isempty(x) || ...
    (isnumeric(x) && isscalar(x) && isreal(x) && isfinite(x) && x > 0);
addOptional(p, 'c', defaultConcentration, validationConcentration);

% TXT: optional, char or string or empty
validationTxt = @(x) ischar(x) || isstring(x) || isempty(x);
addOptional(p, 'txt', [], validationTxt);

parse(p, pka, varargin{:});

pka = p.Results.pka;
c   = p.Results.c;
txt = p.Results.txt;

% If concentration is left empty, use the default
if isempty(c)
    c = defaultConcentration;
end

% Ensure TXT is char for title
if isstring(txt)
    txt = char(txt);
end

% ------------------------- Pre-computations -------------------------
% Log10 of analytical concentration
lc = log10(c);

% pH range
x = linspace(0, 14, 300);

% Anonymous function: 10^(a-b)
exponential = @(a,b) 10.^(a - b);

% Prepare figure and hold
hold on

% Preallocate handle array:
%   length(pka) species + 2 water lines
H = zeros(1, numel(pka) + 3);

% Plot water auto-ionization lines: [H+] and [OH-]
%   H+  line: log[H+]  = -pH
%   OH- line: log[OH-] = pH - 14
H(end-1:end) = plot([0 14], [-14 0], '-c', ... % [H+]
                    [0 14], [0 -14], '-c', ... % [OH-]
                    'LineWidth', 2);

% ------------------------- Case by number of pKa --------------------
switch numel(pka)
    case 1 % monoprotic acid
        if isempty(txt)
            txt = 'Monoprotic acid';
        end

        f1 = exponential(x, pka);

        % Acid line determination
        ac = lc - log10(1 + f1);

        % Basic line determination
        b  = lc - log10(1 + 1./f1);

        % Plot splines
        H(1:2) = plot(x, ac, '-r', x, b, '-b', 'LineWidth', 2);

        legendtxt = {'Acid Species', 'Basic Species', ...
                     'Water H^+', 'Water OH^-'}; 

    case 2 % diprotic (biprotic) acid
        if isempty(txt)
            txt = 'Diprotic acid';
        end

        f1  = exponential(x, pka(1));
        f2  = exponential(x, pka(2));
        f12 = f1 .* f2;

        % Acid line determination
        ac = lc - log10(1 + f1 + f12);

        % Amphiprotic line determination
        an = lc - log10(1 + 1./f1 + f2);

        % Basic line determination
        b  = lc - log10(1 + 1./f12 + 1./f2);

        % Plot splines
        H(1:3) = plot(x, ac, '-r', x, an, '-g', x, b, '-b', 'LineWidth', 2);

        legendtxt = {'Acid Species', '1^{st} Amphiprotic Species', ...
                     'Basic Species', 'Water H^+', 'Water OH^-'}; 

    case 3 % triprotic acid
        if isempty(txt)
            txt = 'Triprotic acid';
        end

        f1   = exponential(x, pka(1));
        f2   = exponential(x, pka(2));
        f3   = exponential(x, pka(3));
        f12  = f1 .* f2;
        f23  = f2 .* f3;
        f123 = f1 .* f23;

        % Acid line determination
        ac  = lc - log10(1 + f1 + f12 + f123);

        % I amphiprotic line
        an1 = lc - log10(1 + 1./f1 + f2 + f23);

        % II amphiprotic line
        an2 = lc - log10(1 + 1./f12 + 1./f2 + f3);

        % Basic line determination
        b   = lc - log10(1 + 1./f123 + 1./f23 + 1./f3);

        % Plot splines
        H(1:4) = plot(x, ac, '-r', ...
                      x, an1, '-g', ...
                      x, an2, '-m', ...
                      x, b,   '-b', 'LineWidth', 2);

        legendtxt = {'Acid Species', '1^{st} Amphiprotic Species', ...
                     '2^{nd} Amphiprotic Species', 'Basic Species', ...
                     'Water H^+', 'Water OH^-'}; 

    case 4 % tetraprotic acid
        if isempty(txt)
            txt = 'Tetraprotic acid';
        end

        f1    = exponential(x, pka(1));
        f2    = exponential(x, pka(2));
        f3    = exponential(x, pka(3));
        f4    = exponential(x, pka(4));
        f12   = f1 .* f2;
        f23   = f2 .* f3;
        f34   = f3 .* f4;
        f123  = f1 .* f23;
        f234  = f23 .* f4;
        f1234 = f123 .* f4;

        % Acid line determination
        ac  = lc - log10(1 + f1 + f12 + f123 + f1234);

        % I amphiprotic line
        an1 = lc - log10(1 + 1./f1 + f2 + f23 + f234);

        % II amphiprotic line
        an2 = lc - log10(1 + 1./f12 + 1./f2 + f3 + f34);

        % III amphiprotic line
        an3 = lc - log10(1 + 1./f123 + 1./f23 + 1./f3 + f4);

        % Basic line determination
        b   = lc - log10(1 + 1./f1234 + 1./f234 + 1./f34 + 1./f4);

        % Plot splines
        H(1:5) = plot(x, ac,  '-r', ...
                      x, an1, '-g', ...
                      x, an2, '-m', ...
                      x, an3, '-k', ...
                      x, b,   '-b', 'LineWidth', 2);

        legendtxt = {'Acid Species', '1^{st} Amphiprotic Species', ...
                     '2^{nd} Amphiprotic Species', ...
                     '3^{rd} Amphiprotic Species', ...
                     'Basic Species', 'Water H^+', 'Water OH^-'}; 
    otherwise
        error('acids:InvalidNumberOfPka', ...
            'Number of pKa values must be between 1 and 4.');
end

% Mark pKa positions on the diagram (black crosses)
if ~isempty(pka)
    plot(pka, lc * ones(size(pka)), '+k');
end

% ------------------------- Axes and labels --------------------------
hold off
grid on
axis([0 14 -14 max(0, lc + 1)]);
axis square
set(gca, 'XTick', 0:1:14, ...
         'YTick', -14:1:max(0, lc + 1));

title(txt);
xlabel('pH');
ylabel('log_{10} of concentration (M)');

legend(H, legendtxt, 'Location', 'NorthEastOutside');

end
