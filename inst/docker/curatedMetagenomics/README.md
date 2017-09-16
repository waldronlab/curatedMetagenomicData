
## Usage

```
#docker run -v /PATH_TO_WHERE_YOU_WANT_OUTPUT:/RUN_PATH_IN_CONTAINER -ti teamcgc/curatedmetagenomics SAMPLENAME SRA_ACCESSION /RUN_PATH_IN_CONTAINER
# a runnable example
docker run -v /tmp:/tmp -ti teamcgc/curatedmetagenomicdata /bin/bash /root/curatedMetagenomicData_pipeline.sh SAMPLE ERR262957 /tmp
```

## Build

```sh
docker build --tag teamcgc/curatedmetagenomicdata .
```
