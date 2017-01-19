---
layout: post
title:  "Accessing Data From the Command Line"
date:   2017-01-17
---
In order to access data from the command line it is necessary to have *R*, *Bioconductor*, and *curatedMetagenomicData* installed (see install). Additionally, it is necessary to install the *docopt* package from within *R*:

```
BiocInstaller::biocLite("docopt")
```

With the above completed, data can be accessed from the command line by:

1. Downloading the curatedMetagenomicData [shell script](https://raw.githubusercontent.com/waldronlab/curatedMetagenomicData/master/inst/commandline/curatedMetagenomicData){:target="_blank"}.

2. Making sure the shell script has executable permissions (i.e., `chmod a+x curatedMetagenomicData`)

3. Making sure the R executable at the top of the script is correct (by default `/usr/bin/Rscript`). Check where `Rscript` is installed by `which Rscript`.

4. Placing the *curatedMetagenomicData* file somewhere on your `PATH`, or invoke it using `./curatedMetagenomicData`. Use `./curatedMetagenomicData -h` to see its help.
