🧪 acids.m — MATLAB Polyprotic Acid Dissociation Plotter

acids.m is a MATLAB function that plots the dissociation diagram of an acid from monoprotic up to tetraprotic form.
It shows how the species distribution (acid, amphiprotic, basic forms) changes as a function of pH, together with water auto-ionization lines.

✨ Features

📚 Supports monoprotic, diprotic, triprotic and tetraprotic acids (1 to 4 pKa values)

🧮 Uses analytical expressions for species distribution vs pH

📊 Plots:

Acid species line

Amphiprotic species lines (1st, 2nd, 3rd where applicable)

Basic species line

Water [H⁺] and [OH⁻] lines

pKa positions as black crosses

⚙️ Configurable total analytical concentration (default: 0.1 M)

🏷 Optional title with acid name

📦 Repository

GitHub: https://github.com/dnafinder/acids

🛠 Requirements

MATLAB with support for inputParser and basic plotting

No additional toolboxes required

🚀 Usage

Basic example (phosphoric acid, 100 mM):

pka = [2.1 7.2 12.6]
acids(pka)

This will use the default concentration (0.1 M) and plot:

Acid line (red)

Amphiprotic lines (green, magenta, black depending on protonation stage)

Basic line (blue)

Water lines (cyan)

Black crosses at each pKa value

You can also specify concentration and a title:

pka = [4.76]
acids(pka, 0.05, 'Acetic acid 50 mM')

🧠 Function Summary

acids(pka, c, txt)

Input:
• pka — row vector of pKa values, length from 1 to 4 (mandatory)
• c — scalar, total concentration in mol/L (optional, default: 0.1 M)
• txt — char or string, used as plot title (optional)

Output:
• No returned variables; a dissociation diagram is plotted in the current figure

📚 Citation

If you use this function in teaching, textbooks, or scientific work, please cite:

Cardillo G. (2007). acids.m – Plot the dissociation diagram of a given acid (from monoprotic to tetraprotic).

🔑 License

Please refer to the LICENSE file in this repository for details.

👤 Author

Giuseppe Cardillo
Email: giuseppe.cardillo.75@gmail.com
