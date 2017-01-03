# library(readr)
#
# txtFiles <- dir("~/Downloads/52964", ".txt", full.names = T, recursive = T)
#
# # The data table contains the subject and consent group information.
# file1 <- read_tsv(txtFiles[1], skip = 10)
#
# # The data table contains mapping of study subject IDs to sample IDs. Samples
# # are the final preps submitted for sequencing. For example, if one patient
# # (subject ID) gave one sample, and that sample was processed differently to
# # generate 2 sequencing runs, there would be two rows, both using the same
# # subject ID, but having 2 unique sample IDs.
# file2 <- read_tsv(txtFiles[2], skip = 10)
#
# # The data table contains data that were collected from the Concomitant
# # Medications Form (DCM). Variables include medication number and code,
# # indication, if the medication is ongoing, and the duration of the medication.
# file3 <- read_tsv(txtFiles[3], skip = 10)
#
# # The data table contains subject data with sample information for the Global
# # Trace Screen (GTV). Variables include the specimen type (based on 18 specimens
# # from 6 body sites), nucleic extraction method, and sample administrative
# # information. The Global Trace dataset will be updated when additional visits
# # or subjects have been added.
# file4 <- read_tsv(txtFiles[4], skip = 10)
#
# # The data table contains data that were collected from the Suppplemental
# # Questions Form (DSU) upon the completion of HMP study enrollment. Variables
# # include additional health history such as dietary habits, breastfeeding,
# # birthing history, delivery method, and if the subject failed any initial
# # screenings prior to enrollment.
# file5 <- read_tsv(txtFiles[5], skip = 10)
#
# # The Targeted Physical Forms (DTP), Medical History Screening Forms (DHX), and
# # the Visit Documentation Forms (DVD) have been combined into a single data
# # table. The DTP variables include measurements collected for blood pressure,
# # pulse, body weight, height, and BMI. Variables also include physical
# # assessment of areas/systems and the specific details of the abnormalities.
# # Areas/Systems consist of general appearance, HEENT, cardiovascular, pulmonary,
# # abdomen, neurological, musculoskeletal, and extremities. The DHX variables
# # include data that indicate whether the subject noted medical problems in
# # various areas/systems and the indications and specifications of medical
# # problems. Areas/Systems consist of HEENT, cardiovascular, pulmonary, GI,
# # hepatobiliary, renal, neurologic, blood lymphatic, endocrine/metabolic,
# # musculoskeletal, genital/reproductive, dermatologic, allergies, cancer,
# # immunodeficiency, drug or alcohol dependence, and autoimmune disease. Data
# # were also collected for relevant medical or surgical history, medical
# # abnormality with ongoing treatment and presence of acute disease. The DVD
# # variables include education level, insurance status, occupation status,
# # tobacco usage, and visit-specific information. This visit-specific information
# # pertains to subject's oral temperature, pregnancy test results, education
# # level, insurance status, occupation, and if blood and GI specimens were
# # collected. DTP, DHX and DVD data will be collected at each visit though not
# # every variable was collected.
# file6 <- read_tsv(txtFiles[6], skip = 10)
#
# # The Demographics Form (DEM) and the Eligibility Checklist (ENR) have been
# # combined into a single data table. The DEM variables include sociodemographic
# # measurements such as gender, ethnicity, race, and place of birth, while the
# # ENR variables include the enrollment/first sampling time of subjects
# # (n=1 variable) and administrative variables (n=4 variables). Both the Medical
# # History and Targeted Physical exams must be completed prior to the completion
# # of the Exclusion Criteria found in the ENR form. Data derived from the Medical
# # History (DHX) and Targeted Physical (DTP) exams can be found in
# # EMMES_HMP_DTP_DHX_DVD dataset.
# file7 <- read_tsv(txtFiles[7], skip = 10)
#
# samples <- full_join(file2, file4)
#
# something <- full_join(file1, file7)
#
# dfList <- list(file3, file5, file6)
#
# phenotypes <- Reduce(full_join, dfList)
