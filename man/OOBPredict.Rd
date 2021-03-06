% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/OOBPredict.R
\name{OOBPredict}
\alias{OOBPredict}
\title{Compute out-of-bag predictions}
\usage{
OOBPredict(X, forest, num.cores = 0L, Xtrain = NULL,
  output.scores = FALSE)
}
\arguments{
\item{X}{an n sample by d feature matrix (preferable) or data frame which was used to train the provided forest.}

\item{forest}{a forest trained using the RerF function, with store.oob=TRUE.}

\item{num.cores}{the number of cores to use while training. If num.cores=0 then 1 less than the number of cores reported by the OS are used. (num.cores=0)}

\item{Xtrain}{an n by d numeric matrix (preferable) or data frame. This should be the same data matrix/frame used to train the forest, and is only required if RerF was called with rank.transform = TRUE. (Xtrain=NULL)}

\item{output.scores}{if TRUE then predicted class scores (probabilities) for each observation are returned rather than class labels. (output.scores = FALSE)}
}
\value{
predictions a length n vector of predictions in a format similar to the Y vector used to train the forest
}
\description{
Computes out-of-bag class predictions for a forest trained with store.oob=TRUE.
}
\examples{
library(rerf)
X <- as.matrix(iris[, 1:4])
Y <- iris[[5L]]
forest <- RerF(X, Y, store.oob = TRUE, num.cores = 1L)
predictions <- OOBPredict(X, forest, num.cores = 1L)
oob.error <- mean(predictions != Y)
}
