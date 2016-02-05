import matplotlib
matplotlib.use('svg')
import matplotlib.pyplot as plt
import numpy as np

from snp_intersections import *

rows = []
for s1 in samples:
    cols = []
    for s2 in samples:
        cols.append(intersections.get((s1,s2), intersections.get((s2,s1), 2700000)))
    rows.append(cols)

# from pprint import pprint
# pprint(rows)

column_labels = samples
row_labels    = samples
data          = np.array( rows )


fig, ax = plt.subplots()

heatmap = ax.pcolor(data, cmap='BuPu', picker=True)

# Format
fig = plt.gcf()
fig.set_size_inches(16, 13)

# put the major ticks at the middle of each cell
ax.set_xticks(np.arange(data.shape[0])+0.5, minor=False)
ax.set_yticks(np.arange(data.shape[1])+0.5, minor=False)

# want a more natural, table-like display
ax.invert_yaxis()
ax.xaxis.tick_top()

ax.set_xticklabels(row_labels, minor=False, fontsize=8)
ax.set_yticklabels(column_labels, minor=False, fontsize=8)
# plt.show()

plt.xticks(rotation=90)

plt.colorbar(heatmap, orientation="vertical")

plt.savefig('heatmap_snp.svg')
