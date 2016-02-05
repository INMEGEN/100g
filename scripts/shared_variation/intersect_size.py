import argparse
import pickle

parser = argparse.ArgumentParser(description='print the size of the intersection of two pickled sets')
parser.add_argument("samples", nargs=2, type=argparse.FileType('r'))
args = parser.parse_args()


S1 = pickle.load( args.samples[0] )
S2 = pickle.load( args.samples[1] )

print len(set.intersection(S1, S2))
