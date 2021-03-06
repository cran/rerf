---
title: "R-RerF: Timed tests"
author: "Jesse Leigh Patsolic"
output: 
  github_document:
    toc: true
    html_preview: true
  html_document:
    code_folding: hide
    keep_md: true
---

<!--
### ### INITIAL COMMENTS HERE ###
###
### Jesse Leigh Patsolic 
### 2018
#
-->


To perform these tests, make sure you're in the correct directory with the
correct version of `R-RerF` installed and run the below code chunk.


```r
require(rmarkdown)
require(knitr)
require(devtools)

opts_chunk$set(cache=FALSE,warning=FALSE,message=FALSE)

rmarkdown::render("test-Times.Rmd", output_format = "html_document")
```


# RerF time tests

Timed tests between different versions of the `RerF` code that live across
various git-branches are performed below.

## Setup library and test data


```r
## sandbox the install location
dev_mode(on = TRUE) 
## install from version 1.1.3 which is the CRAN version as of 20181005.
install_github('neurodata/R-RerF', ref = 'v1.1.3', local = FALSE)
require('rerf')
```



```r
times <- list()
data(mnist)

## Get a random subsample, 100 each of 3's and 5's 
set.seed(317)
threes <- sample(which(mnist$Ytrain %in% 3), 100)
fives  <- sample(which(mnist$Ytrain %in% 5), 100)
numsub <- c(threes, fives)

Ytrain <- mnist$Ytrain[numsub]
Xtrain <- mnist$Xtrain[numsub,]
Ytest <- mnist$Ytest[mnist$Ytest %in% c(3,5)]
Xtest <- mnist$Xtest[mnist$Ytest %in% c(3,5),]

# p is number of dimensions, d is the number of random features to evaluate, iw is image width, ih is image height, patch.min is min width of square patch to sample pixels from, and patch.max is the max width of square patch
p <- ncol(Xtrain)
d <- ceiling(sqrt(p))
iw <- sqrt(p)
ih <- iw
patch.min <- 1L
patch.max <- 5L
```


## Timing v1.1.3


```r
invisible(gc())
startTime <- Sys.time()

forest <- RerF(Xtrain, Ytrain, num.cores = 1L, 
               mat.options = list(p = p, d = d, random.matrix = "image-patch", iw = iw, ih = ih, 
                                  patch.min = patch.min, patch.max = patch.max), 
               seed = 1L, rfPack = FALSE)
stopTime <- Sys.time()

times$cran <- stopTime - startTime
```

## Timing branch staging @3ea880184ed3f593ed0720f4f0556c9f0b9f1375


 

```r
invisible(gc())
startTime <- Sys.time()
forest <- RerF(Xtrain, Ytrain, num.cores = 1L, 
               mat.options = list(p = p, d = d, random.matrix = "image-patch", iw = iw, ih = ih, 
                                  patch.min = patch.min, patch.max = patch.max), seed = 1L)
stopTime <- Sys.time()
times$staging <- stopTime - startTime
```
 
## Timing branch RandMat-split @981db221aa4e6cf269a2e208878151d204413eb9




```r
invisible(gc())
startTime <- Sys.time()
forest <- RerF(Xtrain, Ytrain, num.cores = 1L, FUN = RandMatImagePatch,
             paramList = list(p = p, d = d, iw = iw, ih = ih, 
                              pwMin = patch.min, pwMax = patch.max), 
             seed = 1L)
stopTime <- Sys.time()
times$randMatSplit <- stopTime - startTime

dev_mode(on = FALSE)
```



```r
kable(data.frame(times), format = 'markdown')
```



|cran          |staging       |randMatSplit  |
|:-------------|:-------------|:-------------|
|14.94767 secs |15.02846 secs |15.04736 secs |




# RandMat\* time tests


```r
runs <- list()
require(microbenchmark)
## below is the output of RandMat with mat.options
## from commit 73b896ff053537ee23d82b9debee054171b1c41b
## with set.seed(317) and RcppZiggurat::zsetseed(14)
## for comparison to the new version of RandMat*
#mat.options <- list(p = 5, d = 3, "binary", rho = 0.25, prob = 0.5)
rBinary <- structure(c(3, 2, 3, 2, 1, 2, 2, 3, 1, -1, -1, 1), .Dim = 4:3)

## sandbox the install location
dev_mode(on = TRUE) 

## install from version 1.1.3 which is the CRAN version as of 20181005.
install_github('neurodata/R-RerF', ref = 'v1.1.3', local = FALSE, force = TRUE)
require('rerf')


opt1 <- list(p = 5, d = 3, random.matrix = "binary", rho = 0.25, prob = 0.5)

runs$cran <- microbenchmark(run1 = RandMat(opt1))

## install from branch RandMat-split
detach('package:rerf', unload = TRUE)
install_github('neurodata/R-RerF', ref = 'RandMat-split', local = FALSE, force = TRUE)
require('rerf')

runs$randmat <- microbenchmark(run2 = RandMatBinary(p = 5, d = 3, sparsity = 0.25, prob = 0.5))

dev_mode(on = FALSE)
```



```r
runs
```

```
## $cran
## Unit: microseconds
##  expr    min      lq     mean  median    uq     max neval
##  run1 41.042 45.2365 55.00814 45.9505 47.14 787.393   100
## 
## $randmat
## Unit: microseconds
##  expr    min      lq     mean  median    uq     max neval
##  run2 42.721 45.4845 55.54579 51.8275 55.55 416.578   100
```


