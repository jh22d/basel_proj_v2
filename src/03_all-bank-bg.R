# output:
# df: all_bank
source("src/00_variables.R")
source("src/01_import-bank-wise-data.R")
macro<-read_csv("data/processed/macro.csv")

# create a df to match bank, country and scale
all_bank_bg <- data.frame(
  bank = c(US_GSIB_banks, US_DSIB_banks, CA_GSIB_banks, CA_DSIB_banks),
  country = c(rep("United States", length(c(US_GSIB_banks, US_DSIB_banks))),
              rep("Canada", length(c(CA_GSIB_banks, CA_DSIB_banks)))),
  SIB = c(rep("G", length(US_GSIB_banks)),
          rep("D", length(US_DSIB_banks)),
          rep("G", length(CA_GSIB_banks)),
          rep("D", length(CA_DSIB_banks)))
)

# write.csv(all_bank_bg,"data/processed/all_bank_bg.csv")

