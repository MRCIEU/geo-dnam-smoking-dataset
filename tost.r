

tost.normalize <- function(mu) {
    mset <- MethylSet(Meth=as.matrix(mu$M), Unmeth=as.matrix(mu$U),
                      annotation=c(array="IlluminaHumanMethylation450k",
                          annotation="ilmn12.hg19"),
                      preprocessMethod=c(rg.norm="Raw"))
    norm <- preprocessQuantile(mset, verbose=T)
    getBeta(norm)
}

