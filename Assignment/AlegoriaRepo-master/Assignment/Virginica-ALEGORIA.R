#--------------------------------------------------------------
#                         VIRGINICA
#--------------------------------------------------------------

#1. Data(iris)

data <- data.frame(iris)
data


#2. Subset the iris set into 3 files per-species.

subset3 <- subset(data, Species == 'virginica' )
subset3


#3. Get total mean for each species.

sepalL <- iris$Sepal.Length[101:150]
sepalL

sepalW <- iris$Sepal.Width[101:150]
sepalW 

petalL <- iris$Petal.Length[101:150]
petalL

petalW <- iris$Petal.Width[101:150]
petalW

virginica <- c(sepalL, sepalW, petalL, petalW)
virginica

mean(virginica)


#4. Get the mean of each characteristics of 
#   the species using mean().

mean(sepalL)
mean(sepalW)
mean(petalL)
mean(petalW)

