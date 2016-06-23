from itertools import combinations
import pickle
import argparse

parser = argparse.ArgumentParser(description='create condor jobs for jaccard index computation of pairs of sets of variation in samples')
parser.add_argument("varsets", type=argparse.FileType('r'))
args = parser.parse_args()

varsets = pickle.load( args.varsets )

samples = varsets.keys()

plantilla = """
executable     = jinx.py
arguments      = {pickle} {s1} {s2}
output         = jinx_{s1}_{s2}.out
error          = jinx_{s1}_{s2}.err
log            = jinx_{s1}_{s2}.log                                                    
requirements = Machine == "notron.inmegen.gob.mx"
queue 

"""

with open('pair_intersect_%s.condor' % args.varsets.name, 'w') as script:
    for pair in combinations(samples, 2):
        script.write(plantilla.format(pickle=args.varsets.name,
                                      s1=pair[0],
                                      s2=pair[1]))
