import vcf

from experiment import samples, paths
from pprint import pprint
import pickle


all={}
for s in samples.amerindian:
    all[s]=[]

for s in samples.european:
    all[s]=[]

for s in samples.asian:
    all[s]=[]    

for s in samples.african:
    all[s]=[]    
    

def sets(path):
    
    r = vcf.Reader(open(path))
    
    for v in r:
        for s in v.samples:
            if s.sample in samples.amerindian:
                if s.called:
                    all[s.sample].append((v.CHROM, v.POS, v.REF, str(v.ALT)))
            elif s.sample in samples.european \
                or s.sample in samples.asian \
                or s.sample in samples.african:
                if '1' in s.data.GT: # aqui esta la bronca@#solo
                    all[s.sample].append((v.CHROM, v.POS, v.REF, str(v.ALT)))


for path in paths.root:
    print path
    sets(path)

for path in paths.amerindian:
    print path
    sets(path)


for s in all:
    with open("%s/%s.pickle" % (paths.outdir, s), 'w') as p:
        v = set(all[s])
        pickle.dump(v, p)
    
