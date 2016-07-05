
library(corrplot)
library(gplots)
library(gtools)
library(ggdendro)
library(RColorBrewer)
library(stats)

source("heatmap.2a.R")
source("A2Rplot.R")

library("Matrix")
source("jaccard.R")
source("sif_to_matrix_function.R")


jindex_sif <- read.table("jacaressif.txt", sep = "\t", header = TRUE, )


boxplot(jindex_sif[,3])

lg <- jindex_sif
lg[,3] <- jindex_sif[,3] * 100000

summary(lg)

matrix <- sif_to_matrix(jindex_sif, row_column=1, column_column=2, interaction_column=3)
matrixS <- matrix[sort(rownames(matrix)),sort(colnames(matrix))]
length(rownames(matrixS))




sample_names <- read.table("sample_names.tsv", header = TRUE)
sn <- sample_names[,2]
names(sn)<-sample_names[,1]
sn <- sn[sort(names(sn))]
sn <- sn[-c(47,91)] # bad sample

names(sn)
rownames(matrixS) <- sn
colnames(matrixS) <- sn


MA <- matrixS
rownames(MA) <- sn
colnames(MA) <- sn

write.table(M, file = "M.tsv", quote = FALSE, sep = "\t", )

# snp_int <- read.table("snp_intersections_matrix.txt", sep="\t", header = TRUE, row.names=1,colClasses = "character")
# snp_int <- data.matrix(snp_int)
# labels <- row.names(snp_int)

M <- matrixS
labels <- row.names(matrixS)
labelsA <- as.character(sn)
labelsB <- as.character(sn)
labelsA[1]<- c(" ")
labelsB[93]<- c(" ")

# summary(jindex_sif[,3])
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#  0.4754  0.5419  0.5509  0.5476  0.5566  0.7411 

quantile(seq(0.4754,0.5419, length=250), probs = seq(0, 1, 0.5))
quantile(seq(0.5419, 0.5566, length = 3500), probs = seq(0, 1, 0.15))
quantile(seq(0.5566, 0.7411, length=250), probs = seq(0, 1, 0.5))

0.541900, 0.544105, 0.546310, 0.548515, 0.550720, 0.552925, 0.555130,


#quantile(jindex_sif[,3], probs = seq(0, 1, 0.1249))
# 0.4754440, 0.5326322, 0.5419321, 0.5474486, 0.5508673, 0.5536036, 0.5566329, 0.5604464, 0.7034893


colours <- colorRampPalette(c('#f7f4f9','#e7e1ef','#d4b9da','#c994c7','#df65b0','#e7298a','#ce1256','#91003f'))(n = length(table(jindex_sif[,3]))-1)
col_breaks = c(seq(0.47540, 0.54190, length=200),
    seq(0.541900, 0.544105, length=200),
    seq(0.544105, 0.546310, length=200),
    seq(0.546310, 0.548515, length=200),
    seq(0.548515, 0.550720, length=200),
    seq(0.550720, 0.552925, length=200),
    seq(0.552925, 0.555130, length=200),
    seq(0.5566, 0.74110, length=200))



colfunc <- colorRampPalette(c("blue", "red"))

# Trianglular heatmap 
M[lower.tri(M,diag = TRUE)] <- NA
M <- t(M)

pdf("triangulo1.pdf",width=200,height=200)
heatmap.2a(M[-1,-93],
  #cellnote = M,  # same data set for cell labels
  #notecol="black",      # change font color of cell labels to black
  density.info="none",  # turns off density plot inside color legend
  trace="none",         # turns off trace lines inside the heat map
  margins =c(26,25),     # widens margins around plot
  col=colfunc(length(table(jindex_sif[,3]))),       # use on color palette defined earlier 
  #breaks=col_breaks,    # enable color transition at specified limits
  dendrogram="row",     # only draw a row dendrogram
  Colv="NA",            # turn off column clustering
  cexCol =4,    # Tamaño de letra de las columnas
  cexRow =4,    # Tamaño de letra de los renglones
  key=FALSE,    
  Rowv=FALSE,
  offsetRow = 23,
  offsetCol = 1,
  sepcolor=jindex_sif[,3],
  labRow = labelsA,
  labCol = labelsB,
  )
dev.off()

# classic heatmap
pdf("heatmap1.pdf",width=200,height=200)
heatmap.2(matrixS,
	density.info="density",  # turns off density plot inside color legend
	trace="none",         # turns off trace lines inside the heat map
	col=colfunc(length(table(jindex_sif[,3]))),       # use on color palette defined earlier 
#	breaks=col_breaks,    # enable color transition at specified limits
	cexCol =6,    # Tamaño de letra de las columnas
	cexRow =6,    # Tamaño de letra de los renglones
	margins =c(26,25),     # widens margins around plot
	)
dev.off()

# classic dendrogram
Md <- dist(matrixS, method= "minkowski",  upper = TRUE, p=2)
Mc <- hclust(Md, method = "complete")
pdf("dendrograma1.pdf",width=10,height=10)
ggdendrogram(Mc, rotate = TRUE, size = 4, theme_dendro = FALSE, color = "black")
dev.off()

# colored dendrogram
pdf("color_dendrograma1.pdf",width=20,height=8)
hc = hclust(dist(matrixS))
op = par(bg = "gray15")
A2Rplot(Mc, 
	k = 6, 
	boxes = FALSE, 
	col.up = "gray50", 
	col.down = c("#d73027", "#fc8d59", "#fee090", "#e0f3f8", "#91bfdb", "#4575b4")
	)
dev.off()

# Trianglular heatmap ordered
Mx <- matrixS[Mc$order,Mc$order]
Mx[lower.tri(Mx,diag = TRUE)] <- NA
Mx <- t(Mx)
pdf("ordered_triangulo1.pdf",width=200,height=200)
heatmap.2a(Mx,
  #cellnote = M,  # same data set for cell labels
  #notecol="black",      # change font color of cell labels to black
  density.info="density",  # turns off density plot inside color legend
  trace="none",         # turns off trace lines inside the heat map
  margins =c(26,25),     # widens margins around plot
  col=colfunc(length(table(jindex_sif[,3]))),       # use on color palette defined earlier 
  #breaks=col_breaks,    # enable color transition at specified limits
  dendrogram="none",     # only draw a row dendrogram
  Colv="NA",            # turn off column clustering
  cexCol =4,    # Tamaño de letra de las columnas
  cexRow =4,    # Tamaño de letra de los renglones
  key=TRUE,    
  Rowv=FALSE,
  offsetRow = 23,
  offsetCol = 1,
  labRow = labelsA,
  labCol = labelsB,
  )
dev.off()

