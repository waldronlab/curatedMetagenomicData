The scripts in this directory allow the user to reproduce the entire process of downloading raw reads, process them with the  MetaPhlAn2 and HUMAnN2 pipelines, generate the final normalized profiles, and arrange them in folders exactly as done for the package.

* A single sample can be downloaded and processed as follows:

   ```$ bash curatedMetagenomicData_pipeline.sh sample_name "SRRxxyxyxx;SRRyyxxyyx"``` 

   where `sample_name` is the name to be given to the sample, and SRRxxyxyxx etc are the relative NCBI accession numbers.

   See within `curatedMetagenomicData_pipeline.sh` for requirements and settings.

* `sample_name` and relative NCBI accession numbers for all the samples included in the package are available in the 'combined_metadata' dataset provided in the package:

   ```
   > library(curatedMetagenomicData)
   > data(combined_metadata)
   ```

* All the samples included in the package can be downloaded and processed by running the commands in

   `curatedMetagenomicData_pipeline_allsamples.sh`

   Please be aware that this would take ages to be run on a single CPU.

* Follow the same procedure if you want to process your own dataset.

* When done, your output profile files are properly organized and ready to be [included](https://github.com/waldronlab/curatedMetagenomicData/wiki/The-curatedMetagenomicData-pipelines) in the *curatedMetagenomicData* package.
