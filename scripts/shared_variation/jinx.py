#!/usr/bin/env python

import argparse
import pickle

parser = argparse.ArgumentParser(description='print the size of the intersection of two pickled sets')
parser.add_argument("pickle", type=argparse.FileType('r'))
parser.add_argument("s1")
parser.add_argument("s2")
args = parser.parse_args()

varsets = pickle.load( args.pickle )

def jaccard_index(first, *others):
    return float( len( first.intersection(*others))) / float(len(first.union(*others)))

print jaccard_index(varsets[args.s1], varsets[args.s2])
