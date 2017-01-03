You must install *R*, *Bioconductor*, and *curatedMetagenomicData* using the instructions from main README.md at www.github.com/waldronlab/curatedMetagenomicData. 
Additionally, you must install the *docopt* package from within *R*:
```
BiocInstaller::biocLite("docopt")
```

Then:

1. Download the [curatedMetagenomicData shell script](https://github.com/waldronlab/curatedMetagenomicData/blob/master/inst/commandline/curatedMetagenomicData). 

2. Make sure it has executable permissions:
```
chmod a+x curatedMetagenomicData
```

3. Make sure the R executable at the top of the script is correct (by default `/usr/bin/Rscript`). Check where your `Rscript` is installed by `which Rscript`.

4. Place the *curatedMetagenomicData* file somewhere in your PATH, or invoke it using `./curatedMetagenomicData`. Use `./curatedMetagenomicData -h`to see its help.
