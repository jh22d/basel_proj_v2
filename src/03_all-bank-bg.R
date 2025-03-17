# output:
# df: all_bank
source("src/00_variables.R")
source("src/01_all-bank-wise.R")
macro<-read_csv("data/processed/macro.csv")

# create a df to match bank, country and scale
all_bank_bg <- data.frame(
  bank = c(US_GSIB_banks, US_DSIB_banks, CA_GSIB_banks, CA_DSIB_banks),
  country = c(rep("United States", length(c(US_GSIB_banks, US_DSIB_banks))),
              rep("Canada", length(c(CA_GSIB_banks, CA_DSIB_banks)))),
  GSIB = c(rep(1, length(US_GSIB_banks)),
          rep(0, length(US_DSIB_banks)),
          rep(1, length(CA_GSIB_banks)),
          rep(0, length(CA_DSIB_banks)))
)
# write.csv(all_bank_bg,"data/processed/all_bank_bg.csv")

