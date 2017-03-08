wg.args <- commandArgs(trailingOnly = TRUE)

##wg.args <- c(93, "AS") ##DEBUGGIN

set.seed(666)

wg.igsr <- read.table("Input_files/VCFs/1000G_p3/igsr_samples.tsv", header=T, sep="\t", stringsAsFactors=F)

wg.vcf_samples <- read.table("temp/vcf_samples", header = F, sep = "\t", stringsAsFactors = F, comment.char = "")

wg.vcf_samples$col_n <- rownames(wg.vcf_samples)

wg.valid_table <- merge(wg.igsr, wg.vcf_samples, by.x = 'Sample.name', by.y = 'V1')

wg.subsampled_table <- wg.valid_table[ wg.valid_table$Superpopulation.code == wg.args [2], ]

wg.ramdomized_samples <- sample(wg.subsampled_table$col_n, wg.args[1])

wg.random_column_numbers <- paste( sort(as.integer(wg.ramdomized_samples)) ,collapse=",")

write.table(wg.random_column_numbers, file = paste0("temp/col_numbers_",wg.args[2]), quote = F, sep = "\t", row.names = F, col.names = F)
