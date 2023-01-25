
samples <- eval.save({list(
    "GSE50660" = {
        samples <- geo.samples("GSE50660")
        samples <- with(samples, {
            data.frame(sentrix=NA,
                       gsm=geo_accession,
                       gse="GSE50660",
                       smoking=get.characteristic(characteristics_ch1,"smoking"),
                       age=get.characteristic(characteristics_ch1,"age","numeric"),
                       sex=get.characteristic(characteristics_ch1,"gender"),
                       stringsAsFactors=F)
        })
        samples$smoking <- recode(samples$smoking,
                                  c("0"="never",
                                    "1"="former",
                                    "2"="current"))
        samples
    },
    "GSE42861" = {
        samples <- geo.samples("GSE42861")
        samples <- with(samples, {
            data.frame(sentrix=get.sentrix(supplementary_file),
                       gsm=geo_accession,
                       gse="GSE42861",
                       sex=get.characteristic(characteristics_ch1, "gender"),
                       age=get.characteristic(characteristics_ch1, "age", "numeric"),
                       smoking=get.characteristic(characteristics_ch1, "smoking status"),
                       arthritis=get.characteristic(characteristics_ch1, "disease state"),
                       stringsAsFactors=F)
        })
        samples$smoking <- recode(samples$smoking,
                                  c("current"="current",
                                    "ex"="former",
                                    "never"="never",
                                    "occasional"="current"))
        samples
    },
    "GSE85210" = {
        samples <- geo.samples("GSE85210")
        samples <- with(samples, {
            data.frame(sentrix=get.sentrix(supplementary_file),
                       gsm=geo_accession,                   
                       gse="GSE85210",
                       smoking=get.characteristic(characteristics_ch1, "subject status"),
                       sex=NA,
                       stringsAsFactors=F)
        })
        samples$smoking <- recode(samples$smoking,
                                  c("smoker"="current",
                                    "non-smoker"="never"))
        samples
    },
    "GSE87648" = {
        samples <- geo.samples("GSE87648")
        samples <- with(samples, {
            data.frame(sentrix=get.sentrix(supplementary_file),
                       gsm=geo_accession,                   
                       gse="GSE87648",
                       smoking=get.characteristic(characteristics_ch1, "smoking status"),
                       sex=get.characteristic(characteristics_ch1, "Sex"),
                       age=get.characteristic(characteristics_ch1, "age", "numeric"),
                       stringsAsFactors=F)
        })
        samples$smoking <- recode(samples$smoking,
                                  c("Current"="current",
                                    "Ex"="former",
                                    "Never"="never"))
        samples
    })
}, "geo-samples")


samples <- do.call(rbind, lapply(samples, function(x)
                                 x[,c("sentrix","gsm","gse","smoking","sex")]))
samples$sex <- tolower(substring(samples$sex, 1, 1))
samples$exposed <- samples$smoking != "never"

rownames(samples) <- samples$gsm
