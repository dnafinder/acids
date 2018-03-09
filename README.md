# acids
ACIDS Shows the graph of dissociation of a given acids.<br/>
Acids can plot from monoprotic to tetraprotic acids

Syntax: acids(pka,c,txt)

    Inputs:
          pka - Array of the pKa of the acid - mandatory
          c - Concentration of the acid in M (optional - default 100 mM)
          txt - Name of the acid (optional)
    Outputs:
          - Dissociation plot

Example:
for the Phosphoric acid 100 mM
pka=[2.1 7.2 12.6];

  Calling on Matlab the function: 
     acids(pka)
it plots 
acid line (in red)
I amphiprotic line (in green)
II amphiprotic line (in magenta)
basic line (in blue)
H+ and OH- lines (in cyan)
black cross in corrispondence of pKa

          Created by Giuseppe Cardillo
          giuseppe.cardillo-edta@poste.it

To cite this file, this would be an appropriate format:
Cardillo G. (2007) Acids: plot the dissociation plot of a given acid. 
http://www.mathworks.com/matlabcentral/fileexchange/15956
