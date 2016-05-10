File: 			 README.txt
Role: 			 Order In Which Scripts Should Be Run
Content type: 	         Text



1.	Generate esets (rda files) for a dataset
        • Run MetaPhlAn2.R or HUMAnN2.R script to produce the esets. (When running the HUMAnN2.R script, make sure that Pheno.Data.txt file is 
        present in the working directory, so that the rda-files could be populated with the pheno-data information.)

2.	Annotate esets
        • Place all the rda-files in a directory. (Don’t call it the working directory)
            ➢	Then run the Annotate_esets.R script while making sure that the Experiment.Data.txt file is being present in the working directory.

3.	Produce Help-Page
        • Place all the (annotated) rda-files in a directory. (Call it the working directory)
            ➢	Then run the Help_esets.R script to produce a help-page for the dataset.

4.	Exception
        • Use the customized scripts: 
            I.	HUMAnN2_WT2D.R, 
            II.	HUMAnN2_Zeller.R and 
            III.HUMAnN2_Neilsen.R 
    ➢	To read WT2D, Zeller and Neilsen datasets respectively.



