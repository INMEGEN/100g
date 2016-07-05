
#SIF_TO_MATRIX
#Converts SIF-like structures to adjacency matrix -like structures

sif_to_matrix<-function(sif, row_column, column_column, interaction_column) {
 #sif = sif-like object with two columns of nodes and a column of interactions 
 #row_column, column_column and interaction_column are column NUMBER to identify the purpose of each column. Important because some SIF-likes are node-node-interaction, whereas others are node-interaction-node)
 
  #identify unique nodes
  A <- names(table(sif[,row_column]))
  B <- names(table(sif[,column_column]))
  #list to contain A and B as rownames and colnames of matrix
  list_dimnames<-list(A, B)
  #generate empty matrix AxB ... this function will generate a square matrix only if A and B are equal. Otherwise a non-symmetrical matrix is obtained.
  matriz<-matrix(nrow = length(A), ncol = length(B), dimnames = list_dimnames)
  #fill matrix "matriz" with interaction values
  for (fella in rownames(matriz)) { # goes by rows ...
    #print(fella)
    for (fellow in colnames(matriz)) { # then goes by each column 
      #matrix_nombres[fella, fellow] <- ## valor de X$V2 que resulta de la combinación fella, fellow
      if (fella == fellow) {matriz[fella, fellow]<-1} # Because they are identical
      else {
        q<- sif[sif[,row_column] == fella & sif[,column_column] == fellow, interaction_column] # q becomes interaction value
        if (length(q) == 0) {matriz[fella, fellow] <- 0 } # if this particular interaction is not found, mark as zero
        else { matriz[fella, fellow] <-q } # matrix value for that interaction is q 
      }
      
    }
  }
return(matriz)
}