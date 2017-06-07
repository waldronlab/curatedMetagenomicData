You must install 'R', 'Bioconductor', and *curatedMetagenomicData* using the instructions from main README.md at www.github.com/waldronlab/curatedMetagenomicData. 
Additionally, you must install the 'docopt' package from within 'R':
```
BiocInstaller::biocLite("docopt")
```

Then:

1. Download the *curatedMetagenomicData* [shell script](https://raw.githubusercontent.com/waldronlab/curatedMetagenomicData/master/inst/commandline/curatedMetagenomicData){:target="_blank"}.

2. Make sure the shell script has executable permissions (i.e., `chmod a+x curatedMetagenomicData`)

3. Making sure the R executable at the top of the script is correct (by default `/usr/bin/Rscript`). Check where `Rscript` is installed by `which Rscript`.

4. Placing the *curatedMetagenomicData* file somewhere in your `PATH`, or invoke it using `./curatedMetagenomicData`. Use `./curatedMetagenomicData -h` to see its help.
