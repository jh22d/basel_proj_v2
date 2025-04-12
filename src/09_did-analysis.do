// This file is created on Msr 24, 2025, after the meeting with TA 
. import delimited "/Users/jinghan/Desktop/basel_proj/data/processed/df_for_stata.csv", case(preserve) stringcols(8 10 13) numericcols(1 2 3 4 5 6 7 9 11 12 14 15 16 17 18 19 20 21 22 23) clear 

gen tq_var = quarterly(yr_qtr, "YQ")  
format tq_var %tq  


// // model1: 
// reghdfe roe TP T P, absorb(Group) vce(cluster bank)
// eststo did_plain
// Model 2: 
reghdfe roe TP  T P, absorb(yr_qtr bank) vce(cluster bank)
eststo plain
reghdfe roe TP  T P leverage_ratio adj_ebitda mkt_cap stock_price t1c_B gdp cpi rir, absorb(yr_qtr bank) vce(cluster bank)
eststo full
// Combine results into one table
esttab  plain full, ///
    b(%9.3f) se(%9.3f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    label ///
    title("Comparison of Regression Models") ///
 	mtitles("Plain" "Full") ///
    addnotes("Standard errors clustered at the bank level." "*** p<0.01, ** p<0.05, * p<0.10")

// ----------------------------------------------------
//                             Plain            Full   
// ----------------------------------------------------
// TP                         -3.033***       -2.516*** 
//
// T                           0.000           0.000   
//
// P                           0.000           0.000    
//
// Leverage Ratio                              0.613** 
//
// Adjusted EBITDA                             0.000***  
//
// Market Cap                                  0.000    
//
// Stock Price                                -0.027   
//
// T1C_B                                      -0.017    
//
// GDP                                         0.000     
//
// CPI                                         2.220**  
//
// RIR                                        -0.113    
//
// Constant                   11.195***     -238.003** 
// ----------------------------------------------------
// Observations                  979             542   
// ----------------------------------------------------
// Standard errors clustered at the bank level.
// `*** p<0.01, ** p<0.05, * p<0.10`


