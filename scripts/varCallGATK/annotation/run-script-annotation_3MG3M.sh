bsub -q medium -n 2 -e anno%J -o anno%J "cd /home/inmegen/r.garcia/gh/100g_FRPV/scripts/varCallGATK/scripts/; ./anotador_amerindios.sh /scratch/inmegen/100g/wg_GATK/perIndividuoGATK/SM-3MG3M hg19"
