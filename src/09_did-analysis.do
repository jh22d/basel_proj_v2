// This file is created on Msr 24, 2025, after the meeting with TA 
. import delimited "/Users/jinghan/Desktop/basel_proj/data/processed/df_for_stata.csv", case(preserve) stringcols(8 10 13 20) numericcols(1 2 3 4 5 6 7 9 11 12 14 15 16 17 18 19 21 22 23) clear 

gen tq_var = quarterly(yr_qtr, "YQ")  
format tq_var %tq  


// // model1: 
// reghdfe roe TP T P, absorb(Group) vce(cluster bank)
// eststo did_plain
// Model 2: 
reghdfe roe TP  T P stock_price GSIB  gdp cpi rir, absorb(Group) vce(cluster bank)
eststo did_full
// Model 3: 
reghdfe roe TP  T P stock_price GSIB  log_gdp , absorb(Group) vce(cluster bank)
eststo did_full_adj_std
// Combine results into one table
esttab did_full did_full_adj_std, ///
    b(%9.3f) se(%9.3f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    label ///
    title("Comparison of Regression Models") ///
	mtitles("full" "lasso+se adj") ///
    addnotes("Standard errors clustered at the country level." "*** p<0.01, ** p<0.05, * p<0.10")


// Comparison of Regression Models
// ----------------------------------------------------
//                               (1)             (2)   
//                              full       lasso+se adj   
// ----------------------------------------------------
// TP                         -1.847*         -1.456*  
//                           (0.932)         (0.856)   
//
// T                           8.515**        12.389***
//                           (4.023)         (4.071)   
//
// P                          -1.351*         -1.422*  
//                           (0.705)         (0.730)   
//
// stock_price                 0.037*          0.037*  
//                           (0.021)         (0.021)   
//
// GSIB                       -2.911**        -2.974** 
//                           (1.258)         (1.233)   
//
// gdp                        -0.000                   
//                           (0.000)                   
//
// cpi                         0.171                   
//                           (0.175)                   
//
// rir                         0.082                   
//                           (0.126)                   
//
// log_gdp                                    14.334   
//                                          (12.844)   
//
// Constant                   -6.353        -146.946   
//                          (14.536)       (140.720)   
// ----------------------------------------------------
// Observations                  910             934   
// ----------------------------------------------------
// Standard errors in parentheses
// Standard errors clustered at the country level.
// *** p<0.01, ** p<0.05, * p<0.10

