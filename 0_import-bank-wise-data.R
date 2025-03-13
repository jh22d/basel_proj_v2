library(readxl)


# US - G-SIBs
files <- list.files(path ="data/raw/US_G-SIBs",
                    pattern = "\\.xlsx$", 
                    full.names = TRUE)
data_list <- lapply(files, read_excel)
names(data_list) <- tools::file_path_sans_ext(basename(files))
list2env(data_list, envir = .GlobalEnv)
# US - D-SIBs
# !!!


# CA - G-SIBs
bmo <- read_excel("data/raw/CA_G-SIBs/bmo.xlsx")
bns <- read_excel("data/raw/CA_G-SIBs/bns.xlsx")
rbc <- read_excel("data/raw/CA_G-SIBs/rbc.xlsx")
td <- read_excel("data/raw/CA_G-SIBs/td.xlsx")
# CA - D-SIBs
nbc <- read_excel("data/raw/CA_D-SIBs/nbc.xlsx")
cm <- read_excel("data/raw/CA_D-SIBs/cm.xlsx")
