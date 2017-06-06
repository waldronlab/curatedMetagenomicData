The two scripts in this directory perform the complete pipeline of downloading raw reads, HUMAnN2 and MetaPhlAn2 profiling, and normalization. A dataset is downloaded and processed as follows:

```$ bash curatedMetagenomicData_pipeline.sh sample_name "SRRxxyxyxx;SRRyyxxyyx"```

where `sample_name` is the name to be given to the study, and SRRxxyxyxx etc are the relative NCBI accession numbers which are all available in the `combined_metadata` dataset provided in the package:

```
> library(curatedMetadata)
> data(combined_metadata)
```

See within `curatedMetagenomicData_pipeline.sh` for requirements and settings.
