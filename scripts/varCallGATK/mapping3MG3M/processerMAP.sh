
bsub -q high -e proc%J.err -o proc%J.out -n 16 "cd /home/inmegen/r.garcia/gh/100g_rgalindor/scripts/varCallGATK/scripts/; ./mapeador4.sh /scratch/inmegen/100g/SM-3MG3M_wg_alignment"

