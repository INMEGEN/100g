
require(ggplot2)
require(reshape)
require(gridExtra)

setwd("/Users/hachepunto/mnt/notron/mnt/d/hachepunto/qualimap/qualimap/depthFiles")

temp = list.files(pattern="*.tsv")

list2env(
  lapply(setNames(temp, make.names(gsub("*.tsv$", "", temp))), header = FALSE, skip = 1,
         read.delim), envir = .GlobalEnv)


all_deapths <- cbind(SM.3MG3O[-420,], SM.3MG45[-420, 2], SM.3MG46[-420, 2], SM.3MG48[-420, 2], SM.3MG4B[-420, 2], SM.3MG4K[-420, 2], SM.3MG4M[-420, 2], SM.3MG4N[-420, 2], SM.3MG4P[-420, 2], SM.3MG4V[-420, 2])
names <- c("base_pair", "SM.3MG3O", "SM.3MG45", "SM.3MG46", "SM.3MG48", "SM.3MG4B", "SM.3MG4K", "SM.3MG4M", "SM.3MG4N", "SM.3MG4P", "SM.3MG4V")

head(all_deapths)

colnames(all_deapths) <- names
rownames(all_deapths) <- all_deapths[,1]

dfm <- melt(all_deapths,  id.vars = 'base_pair', variable.name = 'sample')
colnames(dfm) <- c("base_pair", "sample", "coverage")
table(dfm[,2])
length(dfm[,2])

coef(lm(coverage ~ base_pair, data = dfm))
#  (Intercept)    base_pair 
# 2.962194e+01 1.834631e-09 

g <- ggplot(dfm, aes(x = base_pair, y = coverage, colour = sample)) + 
	geom_line() +
	geom_abline(intercept = 2.962194e+01, slope = 1.834631e-09, color = "red")


ggsave("depth.pdf", plot = g)
