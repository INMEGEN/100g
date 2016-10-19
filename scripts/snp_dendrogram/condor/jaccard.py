#!/usr/bin/env python

import argparse
import pickle

parser = argparse.ArgumentParser(description='print jaccard index of two pickled sets')
parser.add_argument("samples", nargs=2, type=argparse.FileType('r'))
args = parser.parse_args()

def jaccard_index(first, *others):
    return float( len( first.intersection(*others))) / float(len(first.union(*others)))

S1 = pickle.load( args.samples[0] )
S2 = pickle.load( args.samples[1] )

print args.samples[0].name, args.samples[1].name, jaccard_index(S1, S2)
