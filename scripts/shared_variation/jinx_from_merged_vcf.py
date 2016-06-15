import vcf
import argparse
import pickle

parser = argparse.ArgumentParser(description='calculate jaccard indexes of pairs of samples in VCF')
parser.add_argument("vcf", type=argparse.FileType('r'))
args = parser.parse_args()

vcfr = vcf.Reader(args.vcf)

varsets = {}
for v in vcfr:
    if v.is_snp:
        for s in v.samples:
            if s.called:
                if s.sample in varsets:
                    varsets[s.sample].add((v.CHROM, v.POS, v.REF, str(v.ALT)))
                else:
                    varsets[s.sample]=set([(v.CHROM, v.POS, v.REF, str(v.ALT)),])

#from pprint import pprint
#pprint(varsets)

pickle.dump( varsets, open( args.vcf.name + "_varsets.pickle", "w" ))
