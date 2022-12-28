#An Introduction to Topic Modelling

install.packages('topicmodels')
install.packages('tm')

library(topicmodels)
library(tm)

data('AssociatedPress')

inspect(AssociatedPress[1:5, 1:5])
