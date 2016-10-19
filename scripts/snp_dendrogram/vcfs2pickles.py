import vcf
import samples
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
    

#r = vcf.Reader(open('data/amerindian_chr19.vcf'))
def sets(path):
    r = vcf.Reader(open(path))
    
    for v in r:
        if v.is_snp:
            for s in v.samples:
                if s.sample in samples.amerindian:
                    if s.called:
                        all[s.sample].append((v.CHROM, v.POS, v.REF, str(v.ALT)))
                elif s.sample in samples.european or s.sample in samples.asian or s.sample in samples.african:
                    if '1' in s.data.GT:
                        all[s.sample].append((v.CHROM, v.POS, v.REF, str(v.ALT)))


sets('data/root_1kg_chr19.vcf.gz')
#sets('data/amerindian_chr19.vcf')

#sets('data/pruebita.vcf')
#sets('data/pruebota.vcf')

for s in all:
    with open("%s.pickle" % s, 'w') as p:
        v = set(all[s])
        pickle.dump(v, p)
    
