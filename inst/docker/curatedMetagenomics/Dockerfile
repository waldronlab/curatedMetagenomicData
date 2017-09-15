FROM umigs/chiron-humann2

WORKDIR /opt

# install metaphlan2 in /opt/metaphlan2/biobakery-metaphlan2/
# metaphlan2.py is in that directory

RUN wget 'https://www.dropbox.com/s/ztqr8qgbo727zpn/metaphlan2.zip?dl=0'
RUN unzip metaphlan2.zip
RUN ln -s /opt/metaphlan2/biobakery-metaphlan2/db_v20 /dbs/db_v20

RUN apt-get update
RUN apt-get install -y wget

RUN wget --output-document sratoolkit.tar.gz http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
RUN tar -xvzf *.tar.gz

COPY curatedMetagenomicData_pipeline.sh /root/
COPY run_markers2.py /root/
WORKDIR /root

ENV PATH "$PATH:/opt/sratoolkit.2.8.2-1-ubuntu64/bin"
