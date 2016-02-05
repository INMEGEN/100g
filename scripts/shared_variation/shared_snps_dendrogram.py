from scipy.cluster.hierarchy import dendrogram
from scipy.cluster.hierarchy import linkage
import numpy as np
import matplotlib
matplotlib.use('svg')
import matplotlib.pyplot as plt

from snp_intersections import *


rows = []
for s1 in samples:
    cols = []
    for s2 in samples:
        cols.append(intersections.get((s1,s2), intersections.get((s2,s1), 2700000)))
    rows.append(cols)
  
rows = np.array( rows )


algorythms = [ 'average',
               'complete',
               'ward',
               'centroid',
               'single',
               'weighted',]


for algorythm in algorythms:
        # plot dendrograms
        fig = plt.figure(figsize=(15,15))


        fig.add_subplot()
        linkage_matrix = linkage(rows, algorythm)

        a = dendrogram(linkage_matrix,
                       color_threshold=1,
                       labels=samples,
                       show_leaf_counts=False,
                       leaf_font_size=5,
                       leaf_rotation=0.0,
                       orientation='left',
               )
        plt.savefig('dendrogram_%s.svg' % algorythm)
        plt.close()
