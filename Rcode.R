library("xlsx")
db <-read.xlsx("invoice.xlsx",1)
db=db[,c(2,4)]
db$INV_DATE=as.Date(db$INV_DATE,"%Y/%m/%d")
k <- aggregate(db$INV_TOTAL, by=list(Category=db$INV_DATE), FUN=sum)
names(k) <- c("Datemonthyear","total")
library(caTools)
training_set = k[1:259,]
test_set = k[260:275,]
vik <- lm(total~.,data=training_set)
y_pred = predict(vik, newdata = test_set)
ggplot()+geom_point(aes(x=training_set$Datemonthyear,y=training_set$total), color='violet') + geom_point(aes(x=test_set$Datemonthyear,y=test_set$total),color='blue') + geom_line(aes(x=training_set$Datemonthyear , y=predict(reg,newdata=training_set)),color='yellow') +
ggtitle('GRAPH') + labs(x="Date") +
labs(y="REVENUE")
summary(vik)
confint.lm(vik)