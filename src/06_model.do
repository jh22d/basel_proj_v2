* import dataset
. import delimited "/Users/jinghan/Desktop/basel_proj/data/processed/df_for_stata.csv", case(preserve) stringcols(8 10 12 19) numericcols(1 2 3 4 5 6 7 9 11 13 14 15 16 17 18 20 21 22) clear 

gen tq_var = quarterly(yr_qtr, "YQ")  
format tq_var %tq  


outreg2 using data_description.doc, replace sum(log) title(descriptive statistic)


** FE pt1**
// model0: did w/o other covariates
reghdfe roe TP, absorb(Group tq_var) vce(cluster country)
eststo plain
// model 1: DID&Treatment w/o t1cr
reghdfe roe TP T stock_price rir gdp cpi, absorb(Group tq_var) vce(cluster country)
eststo did_t
// Model 2: DID w/o t1cr
reghdfe roe TP stock_price rir gdp cpi, absorb(Group tq_var) vce(cluster country)
eststo did
// Model 3: DID & t1cr
reghdfe roe TP t1cr t1c_B GSIB mkt_cap rir gdp cpi, absorb(Group tq_var) vce(cluster country)
eststo did_treatment
// Combine results into one table
esttab plain did_t did did_treatment, ///
    b(%9.3f) se(%9.3f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    label ///
    title("Comparison of Regression Models") ///
	mtitles("treatment w/o t1cr" "w/o t1cr" "w/ t1cr") ///
    addnotes("Standard errors clustered at the country level." "*** p<0.01, ** p<0.05, * p<0.10")
	
outreg2 using model_description.doc, replace
	
