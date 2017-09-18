## Usage

```
#docker run -v /PATH_TO_WHERE_YOU_WANT_OUTPUT:/RUN_PATH_IN_CONTAINER -ti teamcgc/curatedmetagenomics SAMPLENAME SRA_ACCESSION /RUN_PATH_IN_CONTAINER
# a runnable example
OUTPUT_PATH=/tmp/abc docker run -e OUTPUT_PATH=$OUTPUT_PATH -v /tmp:$OUTPUT_PATH -ti teamcgc/curatedmetagenomicdata /bin/bash /root/curatedMetagenomicData_pipeline.sh TEST_SAMPLE ERR262957
```

### on google genomics api

```
RUN=ERR262957 SAMPLE=TEST_SAMPLE dsub \
--project isb-cgc-04-0020 \
--zones "us-*" \
--logging gs://isb-cgc-04-0020-cromwell-workflows/logs-for-metagenomics \
--env SAMPLE=${SAMPLE} \
--env RUN=${RUN} \
--output-recursive OUTPUT_PATH=gs://isb-cgc-04-0020-cromwell-workflows/out-for-metagenomics/${SAMPLE}/ \
--image teamcgc/curatedmetagenomicdata --command '/bin/bash /root/curatedMetagenomicData_pipeline.sh ${SAMPLE} ${RUN} ' \
--min-cores 8 --min-ram 16
```

## Build

```sh
docker build --tag teamcgc/curatedmetagenomicdata .
```
