
## obtain raw methylation levels for GSE50660 (idats are not available)
signal.gse50660 <- eval.save({
    filename <- "ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE50nnn/GSE50660/suppl/GSE50660_matrix_signal.txt.gz"
    download.file(filename, file.path(geo.dir, basename(filename)))
    signal <- read.table(file.path(geo.dir, basename(filename)),
                         header=T,sep="\t",quote="",comment.char="")    
    a <- grep("Signal_A",colnames(signal))
    b <- grep("Signal_B",colnames(signal))

    rownames(signal) <- as.character(signal$ID_REF)
    signal <- list(M=signal[,b], U=signal[,a])
    colnames(signal$M) <- colnames(signal$U) <- colnames(meth)
    signal
}, "gse50660-raw")

samples.gse50660 <- geo.samples("GSE50660")
colnames(signal.gse50660$M) <- colnames(signal.gse50660$U) <- samples.gse50660$geo_accession

download.idats <- function(gse,dir) {
    urlname <- geo.raw.url(gse)
    filename <- file.path(dir, basename(urlname))
    if (!file.exists(filename)) {
        download.file(urlname, filename)
        system(paste("cd", dir, "; tar xvf", basename(filename)))
    }
}
download.idats("GSE85210",geo.dir)
download.idats("GSE87648",geo.dir)
download.idats("GSE42861",geo.dir)

## removed data/GSM2337437_9979553017_R05C01
## because idat files could not be read in

library(meffil)
options(mc.cores=12)
samplesheet <- meffil.create.samplesheet(geo.dir)
samplesheet$sentrix <- with(samplesheet, paste(Slide, "_",
                                               "R", sentrix_row,
                                               "C", sentrix_col, sep=""))

qc.objects <- eval.save(meffil.qc(samplesheet, verbose=T), "qc-objects")

qc.summary <- meffil.qc.summary(qc.objects, verbose=T)

meffil.qc.report(qc.summary,
                 output.file=file.path(base.dir, "qc"),
                 author="Matthew Suderman",
                 study="Training smoking predictors")

##qc.objects <- meffil.remove.samples(qc.objects, qc.summary$bad.samples)
names(qc.objects) <- sapply(qc.objects, function(obj) obj$sample.name)

signal <- eval.save(meffil.load.raw.data(qc.objects, just.beta=F), "raw-data")
colnames(signal$M) <- colnames(signal$U) <- names(qc.objects)

sites <- intersect(rownames(signal$M), rownames(signal.gse50660$M))
signal$M <- cbind(signal$M[sites,], signal.gse50660$M[sites,])
signal$U <- cbind(signal$U[sites,], signal.gse50660$U[sites,])
