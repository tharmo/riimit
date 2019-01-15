verbi <- read.csv(file="verbs.csv", header=TRUE, sep=",")
colnames(verbi)<-c('sana','x','tot','tta','lta','acc','lla','lle','aux','ine','sta','na','gen','han','ssa','oin','nom','a','ksi')
vnam<-c('tot','tta','lta','acc','lla','lle','aux','ine','sta','na','gen','han','ssa','oin','nom','a','ksi')

fit <- princomp(verbi, cor=TRUE)
install.packages("psych")
library(psych)
install.packages("factoextra")
library(factoextra)
install.packages("weights")
library(weights)
library(dplyr)
cor(verbi[17:22])
cor(dat[,c(2, 10:15)][,1]

verbi[paste("x",vnam,sep="")] <- (100*(verbi[vnam]/verbi$tot))



                                  cor(verbi[,c('tta','lta','acc','lla','lle','aux','ssa','sta','na','gen','han','ssa','oin','nom','a','ksi')][,1])    
muodot <- subset(verbi, select = c('tta','lta','acc','lla','lle','aux','ssa','sta','na','gen','han','ssa','oin','nom','a','ksi'))        
cors<-cor(muodot)
fit <- princomp(cors, cor=TRUE)
pc <- principal(cors,rotate="varimax",scores=TRUE)
res.pca <- prcomp(muodot, scale = TRUE)
factor.scores(pc)
km<- kmeans(verbi[, 21:35], 3, nstart = 20)
verbi$kmem <- as.factor(km$cluster)
str(km)
c1<-subset(data, kmem == "1" )
verbi$kmem
