#########################################################################
#
#	Algorithm for supervised learning model selection 
#	Created: 14/05/2011
#	Author: Alexandre Balon-Perin
#
#########################################################################

#########################################################################
#
#						PREPARATION
#
#########################################################################
rm(list=ls())
#setwd('/Users/Alex/Desktop/Statistical Foundation of ML/Projet/')
#par(mfrow=c(1,2),ask=TRUE)
#par(ask=TRUE)
load("training.Rdata")

n<-100
N<-5000
R<-3000

#########################################################################
#
#						FEATURE SELECTION (PCA)
#
#########################################################################
feature<-function(){
	print('Feature selection')

	#Mean and standard deviation for training
	#----------------------------------------
	means<-apply(X.tr,2,mean)
	sds<-apply(X.tr,2,sd)

	#Centering of the data for mean 0 and variance 1
	#-----------------------------------------------
	X.tild.tr<-array(0,c(N,n))
	for(i in 1:N){
		X.tild.tr[i,]<-(as.numeric(X.tr[i,])-means)/sds
	}

	#Mean and standard deviation for test
	#------------------------------------
#means<-apply(X.ts,2,mean)
#	sds<-apply(X.ts,2,sd)
	
	#Centering of the data for mean 0 and variance 1
	#-----------------------------------------------
	X.tild.ts<-array(0,c(R,n))
	for(i in 1:R){
		X.tild.ts[i,]<-(as.numeric(X.ts[i,])-means)/sds
	}

	#Singular Value Decomposition on training data
	#----------------------------------------------
	s<-svd(X.tild.tr)
	D<-diag(s$d)
	X.tild <- s$u %*% D %*% t(s$v)
	print("dim s$v")
	print(dim(s$v))
	print("dim s$u")
	print(dim(s$u))
	Z1 <- X.tild %*% s$v
	Z2 <- s$u %*% D
	print(Z2)
	#Eigen values to determine the number of useful variables
	#--------------------------------------------------------
	eigen_values<-s$d
	plot(1:length(s$d),s$d,main="Variance of eigenvectors",xlab="Eigenvectors",ylab="Variance")
	abline(h=60,col="red")
	eig_val_sum<-sum(eigen_values)
	for(j in 1:length(eigen_values)){
		if(eigen_values[j] <= 60)
			break
	}
	h<-j

	#Singular Value Decomposition on test data
	#-----------------------------------------
	
	Z3 <- X.tild.ts %*% s$v
	Z4 <- s$u %*% D

	#Create the new dataset
	#----------------------
	dataSet<-array(0,c(N,h))
	testSet<-array(0,c(R,h))
	for(k in 1:h){
			dataSet[,k] <- Z1[,k]
			testSet[,k] <- Z3[,k]
	}
		
	write.table(dataSet,file="dataSet.txt")
	write.table(testSet,file="testSet.txt")
	
}

#########################################################################
#
#						MODEL SELECTION	
#
#########################################################################
model<-function(){
	print('Model Selection')

	library(lazy)
	library(randomForest)
	library(tree)
	library(e1071)
	dataSet <- read.table("dataSet.txt")
	X.tr<-dataSet

	Remp_lazy<-NULL
	Remp_randForest<-NULL
	Remp_lm<-NULL
	Remp_tree<-NULL
	Remp_svm<-NULL

	MSE_lazy<-NULL
	MSE_randForest<-NULL
	MSE_lm<-NULL
	MSE_tree<-NULL
	MSE_svm<-NULL

	NMSE_randForest<-NULL
	NMSE_lm<-NULL
	NMSE_lazy<-NULL
	NMSE_svm<-NULL
	NMSE_tree<-NULL

	model_lazy <- lazy(Y.tr~.,X.tr)
	model_randForest <- randomForest(Y.tr~.,X.tr)
	model_lm <- lm(Y.tr~.,X.tr)	
	model_tree <- tree(Y.tr~.,X.tr)	
	model_svm <- svm(Y.tr~.,X.tr)	

	# Compute the prediction for the training set for all the algorithms
	# ==================================================================
	Y.hat.tr_lazy<- predict(model_lazy,X.tr)$h
	Y.hat.tr_randForest<- predict(model_randForest,X.tr)
	Y.hat.tr_lm<- predict(model_lm,X.tr)
	Y.hat.tr_tree<- predict(model_tree,X.tr)
	Y.hat.tr_svm<- predict(model_svm,X.tr)
		
	# Compute the empirical errors
	# ============================
	Remp_lazy = c(Remp_lazy,1-mean(as.numeric(round(Y.hat.tr_lazy)==Y.tr)))
	Remp_randForest = c(Remp_randForest,1-mean(as.numeric(round(Y.hat.tr_randForest)==Y.tr)))
	Remp_lm = c(Remp_lm,1-mean(as.numeric(round(Y.hat.tr_lm)==Y.tr)))
	Remp_tree = c(Remp_tree,1-mean(as.numeric(round(Y.hat.tr_tree)==Y.tr)))
	Remp_svm = c(Remp_svm,1-mean(as.numeric(round(Y.hat.tr_svm)==Y.tr)))

	#Compute the size of the cross validation
	# =======================================
	index=sample(1:dim(X.tr)[1])
	size.CV<-floor(dim(X.tr)[1]/10)

	#Start 10-fold Cross validation
	# =============================
	for (i in 1:10) {
		#take 500 observations for test and 4500 for training
		# ===================================================
		i.ts<-(((i-1)*size.CV+1):(i*size.CV))	
		i.tr<-setdiff(index,i.ts)

		X.tr.tr<-X.tr[i.tr,]
		Y.tr.tr<-Y.tr[i.tr]	
		X.tr.ts<-X.tr[i.ts,]	
		Y.tr.ts<-Y.tr[i.ts]	
		
		# Get the model for the algorithms 
		# ==============================================
		model_lazy<- lazy(Y.tr.tr~.,X.tr.tr)
		model_randForest <- randomForest(Y.tr.tr~.,X.tr.tr)
		model_lm <- lm(Y.tr.tr~.,X.tr.tr)	
		model_tree <- tree(Y.tr.tr~.,X.tr.tr)	
		model_svm <- svm(Y.tr.tr~.,X.tr.tr)	
		
		# Compute the prediction and errors for lazy 
		# ==============================================
		Y.hat.ts_lazy<- predict(model_lazy,X.tr.ts)$h
		MSE_lazy <- c(MSE_lazy ,sum((Y.hat.ts_lazy-Y.tr.ts)^2)/size.CV)
		NMSE_lazy <- c(NMSE_lazy ,sum((Y.hat.ts_lazy-Y.tr.ts)^2)/sum((Y.tr.ts-mean(Y.tr.ts))^2))
		
		# Compute the prediction and errors for random forest 
		# ===================================================
		Y.hat.ts_randForest<- predict(model_randForest,X.tr.ts)
		MSE_randForest <- c(MSE_randForest,sum((Y.hat.ts_randForest-Y.tr.ts)^2)/size.CV)
		NMSE_randForest <- c(NMSE_randForest,sum((Y.hat.ts_randForest-Y.tr.ts)^2)/sum((Y.tr.ts-mean(Y.tr.ts))^2))
		
		# Compute the prediction and errors for linear model 
		# ==================================================
		Y.hat.ts_lm<- predict(model_lm,X.tr.ts)
		MSE_lm <- c(MSE_lm,sum((Y.hat.ts_lm-Y.tr.ts)^2)/size.CV)
		NMSE_lm <- c(NMSE_lm,sum((Y.hat.ts_lm-Y.tr.ts)^2)/sum((Y.tr.ts-mean(Y.tr.ts))^2))
		
		# Compute the prediction and errors for decision tree 
		# ==================================================
		Y.hat.ts_tree<- predict(model_tree,X.tr.ts)
		MSE_tree <- c(MSE_tree,sum((Y.hat.ts_tree-Y.tr.ts)^2)/size.CV)
		NMSE_tree <- c(NMSE_tree,sum((Y.hat.ts_tree-Y.tr.ts)^2)/sum((Y.tr.ts-mean(Y.tr.ts))^2))

		# Compute the prediction and errors for support vector machines 
		# =============================================================
		Y.hat.ts_svm<- predict(model_svm,X.tr.ts)
		MSE_svm <- c(MSE_svm,sum((Y.hat.ts_svm-Y.tr.ts)^2)/size.CV)
		NMSE_svm <- c(NMSE_svm,sum((Y.hat.ts_svm-Y.tr.ts)^2)/sum((Y.tr.ts-mean(Y.tr.ts))^2))
		
	}

	MSE_lazy.mean<-mean(MSE_lazy)
	MSE_randForest.mean<-mean(MSE_randForest)
	MSE_lm.mean<-mean(MSE_lm)
	MSE_tree.mean<-mean(MSE_tree)
	MSE_svm.mean<-mean(MSE_svm)

	NMSE_lazy.mean<-mean(NMSE_lazy)
	NMSE_randForest.mean<-mean(NMSE_randForest)
	NMSE_lm.mean<-mean(NMSE_lm)
	NMSE_tree.mean<-mean(NMSE_tree)
	NMSE_svm.mean<-mean(NMSE_svm)

	print(paste("Algorithm Lazy Learning for local regression: ", " Empirical error=", round(Remp_lazy,digits=4)," MSE=",round(MSE_lazy.mean,digits=4)," NMSE=",round(NMSE_lazy.mean,digits=4)))  
	print(paste("Algorithm Random Forest: ", " Empirical error=", round(Remp_randForest,digits=4)," MSE=",round(MSE_randForest.mean,digits=4)," NMSE=",round(NMSE_randForest.mean,digits=4)))  
	print(paste("Algorithm Linear Models: ", " Empirical error=", round(Remp_lm,digits=4)," MSE=",round(MSE_lm.mean,digits=4)," NMSE=",round(NMSE_lm.mean,digits=4)))    
	print(paste("Algorithm Decision Tree: ", " Empirical error=", round(Remp_tree,digits=4)," MSE=",round(MSE_tree.mean,digits=4)," NMSE=",round(NMSE_tree.mean,digits=4)))    
	print(paste("Algorithm Support Vector Machines: ", " Empirical error=", round(Remp_svm,digits=4)," MSE=",round(MSE_svm.mean,digits=4)," NMSE=",round(NMSE_svm.mean,digits=4)))    
}

#########################################################################
#
#						CONFIDENCE INTERVAL	
#
#########################################################################
confidence<-function(){
	print('Confidence Interval')
	library(lazy)
	trainingSet <- read.table("dataSet.txt")
	testSet <- read.table("testSet.txt")
	X.tr<-trainingSet
	X.ts<-testSet

	nb.digits<-4
	R<-3000


	model_lazy <- lazy(Y.tr~.,X.tr)
	Y.hat.ts_lazy <- predict(model_lazy,X.ts)$h

	# Compute the confidence interval for beta1 for lazy
	# ==================================================
	sigma<- sd(Y.hat.ts_lazy)
	alpha<-0.05
	z.alpha<-qnorm(alpha/2, lower=FALSE)
	conf.int.max<-Y.hat.ts_lazy+z.alpha*sigma/sqrt(R)
	conf.int.min<-Y.hat.ts_lazy-z.alpha*sigma/sqrt(R)
	prediction<-as.vector(round(Y.hat.ts_lazy,digits= nb.digits))
	conf.int.min<-round(conf.int.min,digits= nb.digits)
	conf.int.max<-round(conf.int.max,digits= nb.digits)
	d<-data.frame(pred=prediction, min=conf.int.min , max=conf.int.max)

	write.table(d,file="Ytest.txt",row.names = FALSE,col.names = TRUE,sep="		",eol="\r")

}
#########################################################################
#
#						COMBINATION OF MODELS 	
#
##########################################################################
combine<-function(){
	print('Combination of models')
	trainingSet <- read.table("dataSet.txt")
	testSet <- read.table("testSet.txt")
	X.tr<-trainingSet
	X.ts<-testSet
	Y.hat.ts.vec<-NULL
	R<-3000
	nb.digits<-4

	#Compute the size of the cross validation
	# =======================================
	index=sample(1:dim(X.ts)[1])
	size.CV<-floor(dim(X.ts)[1]/10)

	#Start 10-fold Cross validation
	# =============================
	for (i in 1:10) {
	#take 300 observations for test and 2700 for training
	# ===================================================
		i.ts<-(((i-1)*size.CV+1):(i*size.CV))	
		i.tr<-setdiff(index,i.ts)
		
		X.tr.tr<-X.tr[i.tr,]
		Y.tr.tr<-Y.tr[i.tr]	
		X.tr.ts<-X.ts[i.ts,]	
		
	# Get the model for the algorithms 
	# ================================
		rand<-abs((rnorm(1)*10)%%10)
		if(rand>=5){
			model<- lazy(Y.tr.tr~.,X.tr.tr)
			Y.hat.ts<- predict(model,X.tr.ts)$h
			print("lazy")
		}
		else{	
			model <- randomForest(Y.tr.tr~.,X.tr.tr)
			Y.hat.ts<- predict(model,X.tr.ts)
			print("forest")
		}
		Y.hat.ts.vec <- c(Y.hat.ts.vec,Y.hat.ts)
	}

	# Compute the confidence interval for beta1 for combination
	# =========================================================
	sigma<- sd(Y.hat.ts.vec)
	alpha<-0.05
	z.alpha<-qnorm(alpha/2, lower=FALSE)
	conf.int.max<-Y.hat.ts.vec+z.alpha*sigma/sqrt(R)
	conf.int.min<-Y.hat.ts.vec-z.alpha*sigma/sqrt(R)
	prediction<-as.vector(round(Y.hat.ts.vec,digits= nb.digits))
	conf.int.min<-round(conf.int.min,digits= nb.digits)
	conf.int.max<-round(conf.int.max,digits= nb.digits)
	d<-data.frame(pred=prediction, min=conf.int.min , max=conf.int.max)

	write.table(d,file="Ytest2.txt",row.names = FALSE,col.names = TRUE,sep="		",eol="\r")  
	
}

#########################################################################
#
#								MAIN 	
# 
##########################################################################
op <- options(digits.secs=2)
time1 <-Sys.time()
options(op)

#feature()
print('===========================================================================================================')
model()
print('===========================================================================================================')
confidence()
print('===========================================================================================================')
#combine()
print('===========================================================================================================')

time2 <-Sys.time()
computation.time<-time2-time1

print(paste("The computation time is : ", round(computation.time))) 