% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/UrerfHelperFunctions.R
\name{GrowUnsupervisedForest}
\alias{GrowUnsupervisedForest}
\title{Creates Urerf Tree.}
\usage{
GrowUnsupervisedForest(X, MinParent = 1, trees = 100, MaxDepth = Inf,
  bagging = 0.2, replacement = TRUE, FUN = makeAB, options = list(p
  = ncol(X), d = ceiling(ncol(X)^0.5), sparsity = 1/ncol(X)),
  Progress = TRUE, splitCrit = "twomeans", LinearCombo = TRUE)
}
\arguments{
\item{X}{an Nxd matrix or Data frame of numeric values.}

\item{MinParent}{the minimum splittable node size (MinParent=1).}

\item{trees}{the number of trees to grow in a forest (trees=100).}

\item{MaxDepth}{the maximum depth allowed in a forest (MaxDepth=Inf).}

\item{bagging}{only used experimentally.  Determines the hold out size if replacement=FALSE (bagging=.2).}

\item{replacement}{method used to determine boot strap samples (replacement=TRUE).}

\item{FUN}{the function to create the rotation matrix used to determine mtry features.}

\item{options}{options provided to FUN.}

\item{Progress}{logical that determines whether to show tree creation status (Progress=TRUE).}

\item{splitCrit}{split based on twomeans(splitCrit="twomeans") or BIC test(splitCrit="bicfast")}

\item{LinearCombo}{logical that determines whether to use linear combination of features. (LinearCombo=TRUE).}
}
\value{
tree
}
\description{
Creates Urerf Tree.
}
