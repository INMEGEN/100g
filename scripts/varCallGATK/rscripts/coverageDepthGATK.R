

input_cov<-commandArgs(trailingOnly=T)[1]
output_img<-commandArgs(trailingOnly=T)[2]

reporte<-read.table(input_cov,header=TRUE)

suma<-0
for ( i in 1:length(reporte[,2])){
suma<-suma+(reporte[i,1]*reporte[i,2])
}
prom<-suma/sum(reporte[,2])
cove<-(1-(reporte[1,2]/sum(reporte[,2])))*100

prom<-sprintf("%.2f",prom)
cove<-sprintf("%.2f",cove)

png(output_img)
plot(reporte$Coverage,log(reporte$Count),ylab="cantidad de bases (log 10)",xlab="profundidad",main=paste("cobertura:",cove,"profundidad promedio:",prom))
points(reporte$Coverage,log(reporte$Filtered),pch=20)
dev.off()

df<-data.frame(basename(getwd()),cove,prom)
write.table(df, file="../coverage.txt", append=TRUE,sep="\t",quote=FALSE,row.names=FALSE,col.names=FALSE)




