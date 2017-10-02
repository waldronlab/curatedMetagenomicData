FROM umigs/chiron-humann2

WORKDIR /opt

RUN apt-get update
RUN apt-get install -y wget

RUN wget --output-document sratoolkit.tar.gz http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz
RUN tar -xvzf *.tar.gz

COPY curatedMetagenomicData_pipeline.sh /root/
RUN rm /dbs/humann2/uniref/*
RUN rm /dbs/humann2/chocophlan/*
RUN chmod +x /root/curatedMetagenomicData_pipeline.sh
COPY run_markers2.py /root/
WORKDIR /root

ENV PATH "$PATH:/opt/sratoolkit.2.8.2-1-ubuntu64/bin"
