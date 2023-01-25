library(config)
config <- config::get(file="config.yml")

base.dir <- config$base.dir
dir.create(save.dir <- file.path(base.dir, "intermediate-files"))
dir.create(geo.dir <- file.path(base.dir, "geo"))

## library(devtools)
## install_github("perishky/eval.save")
library(eval.save)

## install_github("perishky/meffil")
library(meffil) ## used by load-chip-signal.r
library(minfi) ## used by tost.r

eval.save.dir(save.dir)

source("remove-pcs.r")
## out: remove.pcs()

source("geo.r")
## out: geo.samples(), get.characteristic(), get.sentrix()

source("tost.r")
## out: tost.normalize()

source("load-sample-info.r")
## in: geo.samples(), get.characteristic(), get.sentrix()
## out: samples

source("load-chip-signal.r")
## in: samples
## out: signal

## Note: removed data/GSM2337437_9979553017_R05C01
## because idat files could not be read in

beta <- eval.save({
    tost.normalize(signal) ## 10 minutes
}, "tost-normalized")


system.time(beta.adj <- remove.pcs(beta, pcs=10,most.variable=10000))
## 5-10 minutes

stopifnot(all(colnames(beta) %in% samples$gsm))
samples <- samples[match(colnames(beta), samples$gsm),]

write.csv(samples, file=file.path(base.dir, "samples.csv"))
save(signal, file=file.path(base.dir, "signal.rda"))
save(beta, file=file.path(base.dir, "beta.rda"))
save(beta.adj, file=file.path(base.dir, "beta-adj.rda"))
