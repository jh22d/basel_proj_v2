# outputs: 
# string: US_GSIB_banks, US_DSIB_banks, CA_GSIB_banks, CA_DSIB_banks
# df: all_bank_df

library(readxl)

# US - G-SIBs
US_GSIB_path="data/raw/US_G-SIBs"
US_GSIB_files <- list.files(path = US_GSIB_path, pattern = "\\.xlsx$", full.names = TRUE)
US_GSIB_data_list <- lapply(US_GSIB_files, read_excel)
US_GSIB_banks <- tools::file_path_sans_ext(basename(US_GSIB_files))
names(US_GSIB_data_list) <- US_GSIB_banks
US_GSIB_data_list <- lapply(names(US_GSIB_data_list), function(name) {
  df <- US_GSIB_data_list[[name]]
  df$bank <- name
  colnames(df) <- c("date","roe","t1cr","stock_price","mkt_cap","leverage_ratio","adj_ebitda","bank")
  return(df)
})
names(US_GSIB_data_list) <- US_GSIB_banks

list2env(US_GSIB_data_list, envir = .GlobalEnv)

# US - D-SIBs
US_DSIB_path="data/raw/US_D-SIBs"
US_DSIB_files <- list.files(path = US_DSIB_path, pattern = "\\.xlsx$", full.names = TRUE)
US_DSIB_data_list <- lapply(US_DSIB_files, read_excel)
US_DSIB_banks <- tools::file_path_sans_ext(basename(US_DSIB_files))
names(US_DSIB_data_list) <- US_DSIB_banks
US_DSIB_data_list <- lapply(names(US_DSIB_data_list), function(name) {
  df <- US_DSIB_data_list[[name]]
  df$bank <- name
  colnames(df) <- c("date","roe","t1cr","stock_price","mkt_cap","leverage_ratio","adj_ebitda","bank")
  return(df)
})
names(US_DSIB_data_list) <- US_DSIB_banks
list2env(US_DSIB_data_list, envir = .GlobalEnv)


# CA - G-SIBs
CA_GSIB_path="data/raw/CA_G-SIBs"
CA_GSIB_files <- list.files(path = CA_GSIB_path, pattern = "\\.xlsx$", full.names = TRUE)
CA_GSIB_data_list <- lapply(CA_GSIB_files, read_excel)
CA_GSIB_banks <- tools::file_path_sans_ext(basename(CA_GSIB_files))
names(CA_GSIB_data_list) <- CA_GSIB_banks
CA_GSIB_data_list <- lapply(names(CA_GSIB_data_list), function(name) {
  df <- CA_GSIB_data_list[[name]]
  df$bank <- name
  colnames(df) <- c("date","roe","t1cr","stock_price","mkt_cap","leverage_ratio","adj_ebitda","bank")
return(df)
  })
names(CA_GSIB_data_list) <- CA_GSIB_banks
list2env(CA_GSIB_data_list, envir = .GlobalEnv)
# CA - D-SIBs
CA_DSIB_path="data/raw/CA_D-SIBs"
CA_DSIB_files <- list.files(path = CA_DSIB_path, pattern = "\\.xlsx$", full.names = TRUE)
CA_DSIB_data_list <- lapply(CA_DSIB_files, read_excel)
CA_DSIB_banks <- tools::file_path_sans_ext(basename(CA_DSIB_files))
names(CA_DSIB_data_list) <- CA_DSIB_banks
CA_DSIB_data_list <- lapply(names(CA_DSIB_data_list), function(name) {
  df <- CA_DSIB_data_list[[name]]
  df$bank <- name
  colnames(df) <- c("date","roe","t1cr","stock_price","mkt_cap","leverage_ratio","adj_ebitda","bank")
  return(df)
})
names(CA_DSIB_data_list) <- CA_DSIB_banks
list2env(CA_DSIB_data_list, envir = .GlobalEnv)


all_bank_list <- c(US_GSIB_data_list, US_DSIB_data_list,
       CA_GSIB_data_list, CA_DSIB_data_list)

all_bank_wise <- do.call(rbind, all_bank_list)
# write.csv(all_bank_wise,"data/processed/all_bank_wise.csv")

