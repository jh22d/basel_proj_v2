* import dataset
import delimited "/Users/jinghan/Desktop/econ490/term paper/econ490 data prep/data/processed/clean_data_stata.csv", case(preserve) clear
gen tq_var = quarterly(yr_qtr, "YQ")  
format tq_var %tq  
encode bank, gen(bank_id)


* Run the fixed effects DiD model with bank-level fixed effects
xtset bank_id tq_var
reghdfe roe TP t1cr gdp cpi stock_idx, absorb(bank_id tq_var) vce(robust) level(90)
