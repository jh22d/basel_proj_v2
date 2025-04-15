// This file is created on Msr 24, 2025, after the meeting with TA 
. import delimited "/Users/jinghan/Desktop/basel_proj/data/processed/df_for_stata.csv", case(preserve) stringcols(6 8 12) numericcols(1 2 3 4 5 7 9 10 11 13 14 15 16 17 18 19) clear 

gen tq_var = quarterly(yr_qtr, "YQ")  
format tq_var %tq  


// // model1: 
// reghdfe roe TP T P, absorb(Group) vce(cluster bank)
// eststo did_plain
// Model 2: 
reghdfe roe TP  T P, absorb(yr_qtr bank) vce(cluster bank)
eststo plain
reghdfe roe TP  T P leverage_ratio adj_ebitda mkt_cap_B stock_price t1c_B gdp cpi rir, absorb(yr_qtr bank) vce(cluster bank)
eststo full
// Combine results into one table
esttab  plain full, ///
    b(%9.3f) se(%9.3f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    label ///
    title("Comparison of Regression Models") ///
 	mtitles("Plain" "Full") ///
    addnotes("Standard errors clustered at the bank level." "*** p<0.01, ** p<0.05, * p<0.10")

	

----------------------------------------------------
                            Plain            Full   
----------------------------------------------------
TP                         -3.033***       -2.516***  

T                           0.000           0.000   

P                           0.000           0.000   

Leverage Retio                              0.613** 

Adjusted EBITDA (B)                         0.727***

Market Capitalization (B)                   0.006   

Stock Price                                -0.027    

Tier 1 Capital (B)                         -0.017   

GDP                                         0.000   

CPI                                         2.220** 

RIR                                        -0.113   

Constant                   11.195***     -238.003**   
----------------------------------------------------
Observations                  979             542   
----------------------------------------------------
Standard errors clustered at the bank level.
`*** p<0.01, ** p<0.05, * p<0.10



// Comparison of Regression Models
// ----------------------------------------------------
//                             Plain            Full   
// ----------------------------------------------------
// TP                         -3.033***       -2.516***
//                           (0.873)         (0.665)   
//
// T                           0.000           0.000   
//                               (.)             (.)   
//
// P                           0.000           0.000   
//                               (.)             (.)   
//
// leverage_ratio                              0.613** 
//                                           (0.260)   
//
// adj_ebitda_B                                0.727***
//                                           (0.091)   
//
// mkt_cap_B                                   0.006   
//                                           (0.009)   
//
// stock_price                                -0.027   
//                                           (0.026)   
//
// t1c_B                                      -0.017   
//                                           (0.026)   
//
// gdp                                         0.000   
//                                           (0.001)   
//
// cpi                                         2.220** 
//                                           (0.887)   
//
// rir                                        -0.113   
//                                           (0.232)   
//
// Constant                   11.195***     -238.003** 
//                           (0.107)       (105.892)   
// ----------------------------------------------------
// Observations                  979             542   
// ----------------------------------------------------
// Standard errors clustered at the bank level.
// *** p<0.01, ** p<0.05, * p<0.10



