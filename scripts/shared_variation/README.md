# Shared variation

These scripts will load each sample's variation into a set.

A Jaccard Index is computed for every pair, they are plotted as a dendrogram and as a heat-map.

Jobs are run in paralel these steps:
 - extraction of a BED file from the original VCF
 - loading of BED files into a Python pickle
 - each pairwise Jaccard Index computation



