// This file is created on Msr 24, 2025, after the meeting with TA 
. import delimited "/Users/jinghan/Desktop/basel_proj/data/processed/df_for_stata.csv", case(preserve) stringcols(8 10 13) numericcols(1 2 3 4 5 6 7 9 11 12 14 15 16 17 18 19 20 21 22 23) clear 

gen tq_var = quarterly(yr_qtr, "YQ")  
format tq_var %tq  


// // model1: 
// reghdfe roe TP T P, absorb(Group) vce(cluster bank)
// eststo did_plain
// Model 2: 
reghdfe roe TP  T P  adj_ebitda  gdp cpi rir, absorb(yr_qtr bank) vce(cluster bank)
eststo did_full_new
reghdfe roe TP  T P  stock_price gdp cpi rir, absorb(yr_qtr bank) vce(cluster bank)
eststo did_post_presentation
// Combine results into one table
esttab  did_full_new  did_post_presentation, ///
    b(%9.3f) se(%9.3f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    label ///
    title("Comparison of Regression Models") ///
 	mtitles(" " "") ///
    addnotes("Standard errors clustered at the bank level." "*** p<0.01, ** p<0.05, * p<0.10")

// TP                         -1.486** 
//                           (0.644)   
//
// T                          15.780*  
//                           (8.777)   
//
// P                           0.000   
//                               (.)   
//
// adj_ebitda                  0.000*  
//                           (0.000)   
//
// Group                      -5.345   
//                           (3.159)   
//
// gdp                         0.001   
//                           (0.001)   
//
// cpi                        -0.028   
//                           (0.905)   
//
// rir                         0.106   
//                           (0.175)   
//
// Constant                  -23.034   
//                         (125.671)   
// ------------------------------------
// Observations                  680   
// ------------------------------------
// Standard errors in parentheses
// Standard errors clustered at the country level.
// *** p<0.01, ** p<0.05, * p<0.10
