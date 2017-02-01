wg.args <- commandArgs(trailingOnly = TRUE)

set.seed(666)

wg.rm_data <- read.table(wg.args[1], header=F, sep="\t", stringsAsFactors=F)

wg.rm_data <- wg.rm_data[sample(nrow(wg.rm_data),wg.args[2]),]

#wg.rm_data ##DEBUGGIN

write.table(wg.rm_data, file = wg.args[3], quote = F, sep = "\t", row.names = F, col.names = F)
