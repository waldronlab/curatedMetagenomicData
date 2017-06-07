The scripts in this directory allow the user to reproduce the entire process of downloading raw reads, process them with the  MetaPhlAn2 and HUMAnN2 pipelines, generate the final normalized profiles, and arrange them in folders exactly as done for the package.

A single sample is downloaded and processed as follows:

```$ bash curatedMetagenomicData_pipeline.sh sample_name "SRRxxyxyxx;SRRyyxxyyx"```

where `sample_name` is the name to be given to the sample, and SRRxxyxyxx etc are the relative NCBI accession numbers which are all available in the `combined_metadata` dataset provided in the package:

```
> library(curatedMetadata)
> data(combined_metadata)
```

See within `curatedMetagenomicData_pipeline.sh` for requirements and settings.

See within `curatedMetagenomicData_pipeline_allsamples.sh` for downloading and processing all the samples included in the package (be aware this would take ages to be run on a single CPU).
