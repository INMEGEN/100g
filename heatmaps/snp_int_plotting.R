
library(corrplot)
library(gplots)
library(gtools)
library(ggdendro)
library(RColorBrewer)
library(stats)
library(Matrix)

source("heatmap.2a.R")
source("A2Rplot.R")



# jindex_sif <- read.table("jacaressif.txt", sep = "\t", header = TRUE, )

jinM <- read.table("jinx_matrix.tsv", sep = "\t", header = FALSE)
jinM <- as.matrix(jinM)
dim(jinM)
sample_names <- read.table("sample_names.tsv", header = FALSE)
sn <- sample_names[,2]
names(sn)<-sample_names[,1]
names(sn)
rownames(jinM) <- sn
colnames(jinM) <- sn

# dist metodos = "euclidean", "maximum", "manhattan", "canberra", "binary" or "minkowski"
# Métodos de agrupamiento = "ward.D", "ward.D2", "single", "complete", "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC).


# classic dendrogram
Md <- dist(jinM, method= "manhattan",  upper = TRUE, p=2)
Mc <- hclust(Md, method = "ward.D")
pdf("dendrograma.pdf",width=10,height=10)
ggdendrogram(Mc, rotate = TRUE, size = 4, theme_dendro = FALSE, color = "black")
dev.off()

# colored dendrogram
pdf("color_dendrograma.pdf",width=20,height=12)
hc = hclust(dist(jinM, method= "manhattan",),method = "ward.D")
op = par(bg = "gray15")
A2Rplot(hc, 
  k = 8, 
  boxes = FALSE, 
  col.up = "gray50", 
  #col.down = c("#d73027", "#fc8d59", "#fee090", "#e0f3f8", "#91bfdb", "#4575b4")
  col.down = c('#e41a1c','#377eb8','#4daf4a','#984ea3','#ff7f00','#ffff33','#a65628','#f781bf')
  )
dev.off()

M <- jinM
labelsA <- as.character(sn)
labelsB <- as.character(sn)
labelsA[1]<- c(" ")
labelsB[93]<- c(" ")


colours <- colorRampPalette(c('#f7fcfd','#e0ecf4','#bfd3e6','#9ebcda','#8c96c6','#8c6bb1','#88419d','#6e016b'))(n = 800-1)
col_breaks = c(seq(0.47540, 0.54190, length=100),
    seq(0.541901, 0.544105, length=100),
    seq(0.544106, 0.546310, length=100),
    seq(0.546311, 0.548515, length=100),
    seq(0.548516, 0.550720, length=100),
    seq(0.550721, 0.552925, length=100),
    seq(0.552926, 0.555130, length=100),
    seq(0.555131, 0.74110, length=100))



colfunc <- colorRampPalette(c("blue", "red"))

# Trianglular heatmap 
M[lower.tri(M,diag = TRUE)] <- NA
M <- t(M)

pdf("triangulo.pdf",width=200,height=200)
heatmap.2a(M,
  #cellnote = M,  # same data set for cell labels
  #notecol="black",      # change font color of cell labels to black
  density.info="none",  # turns off density plot inside color legend
  trace="none",         # turns off trace lines inside the heat map
  margins =c(26,25),     # widens margins around plot
  #col=colfunc(length(table(jindex_sif[,3]))),       # use on color palette defined earlier 
  col=colours,       # use on color palette defined earlier 
  breaks=col_breaks,    # enable color transition at specified limits
  dendrogram="none",     # only draw a row dendrogram
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

# Ordered trianglular heatmap 
Mx <- jinM[Mc$order,Mc$order]
Mx[lower.tri(Mx,diag = TRUE)] <- NA
Mx <- t(Mx)
pdf("ordered_triangulo.pdf",width=200,height=200)
heatmap.2a(Mx,
  #cellnote = M,  # same data set for cell labels
  #notecol="black",      # change font color of cell labels to black
  density.info="density",  # turns off density plot inside color legend
  trace="none",         # turns off trace lines inside the heat map
  margins =c(26,25),     # widens margins around plot
  #col=colfunc(length(table(jindex_sif[,3]))),       # use on color palette defined earlier 
  col=colours,       # use on color palette defined earlier 
  breaks=col_breaks,    # enable color transition at specified limits
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


# classic heatmap
pdf("heatmap.pdf",width=200,height=200)
heatmap.2(as.matrix(jinM),
	density.info="density",  # turns off density plot inside color legend
      key=TRUE,
      trace="none",         # turns off trace lines inside the heat map
	#col=colfunc(length(table(jindex_sif[,3]))),       # use on color palette defined earlier 
      col=colours,       # use on color palette defined earlier 	
      breaks=col_breaks,    # enable color transition at specified limits
	cexCol =6,    # Tamaño de letra de las columnas
	cexRow =6,    # Tamaño de letra de los renglones
	margins =c(26,25),     # widens margins around plot
	)
dev.off()




##### cool dendrogram
library(ape)
# vector of colors
mypal = c('#bd1e24','#e97600','#007256','#7284b7','#964f8e','#0067a7','#172035','#a0333a')
# cutting dendrogram in 6 clusters
clus = cutree(hc, 8)
# plot
# Size reflects miles per gallon
pdf(file="circular_dendrograma.pdf",width=20,height=20)
op = par(bg = "#E8DDCB")
plot(as.phylo(hc), 
      type = "fan", 
      tip.color = mypal[clus], 
      label.offset = 0, 
      col = "blue")
dev.off()


