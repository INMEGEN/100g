import fileinput
import pickle

variants = set()
for line in fileinput.input():
    (chrom, start, ref, alt) = line.split()
    variants.add((chrom, start, ref, alt))

pickle.dump( variants, open( fileinput.filename() + "_set.pickle", "w" ))
