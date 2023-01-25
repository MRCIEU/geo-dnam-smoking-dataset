library(matrixStats)
library(limma)

remove.pcs <- function(methylation, pcs=10, most.variable=10000) {
    stopifnot(is.matrix(methylation))
    var.idx <- order(rowVars(methylation, na.rm=T), decreasing=T)
    fit <- prcomp(t(methylation[var.idx[1:most.variable],]), scale=T)
    fit <- lmFit(methylation, design=fit$x[,1:pcs])
    methylation.adjusted <- residuals(fit, methylation)
}
