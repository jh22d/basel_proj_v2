// This file is created on Mar 24, 2025 after the office hour

* import dataset
. import delimited "/Users/jinghan/Desktop/basel_proj/data/processed/df_for_stata.csv", case(preserve) stringcols(8 10 13 20) numericcols(1 2 3 4 5 6 7 9 11 12 14 15 16 17 18 19 21 22 23) clear 

gen tq_var = quarterly(yr_qtr, "YQ")  
format tq_var %tq  


// model1: 
reghdfe roe t1cr stock_price mkt_cap leverage_ratio adj_ebitda  t1c_B GSIB rir gdp cpi, absorb(Group) vce(cluster bank)
eststo full
// Model 2:
reghdfe roe t1cr stock_price mkt_cap leverage_ratio adj_ebitda  log_t1c_B GSIB rir log_gdp cpi, absorb(Group) vce(cluster bank)
eststo full_std_adj
// Combine results into one table
esttab full full_std_adj, ///
    b(%9.3f) se(%9.3f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    label ///
    title("Comparison of Regression Models") ///
	mtitles("treatment w/o t1cr" "w/o t1cr" "w/ t1cr") ///
    addnotes("Standard errors clustered at the country level." "*** p<0.01, ** p<0.05, * p<0.10")
	
// Comparison of Regression Models
// ----------------------------------------------------
//                               (1)             (2)   
//                      treatment ~r        w/o t1cr   
// ----------------------------------------------------
// t1cr                        0.835**         0.767*  
//                           (0.347)         (0.378)   
//
// stock_price                 0.023           0.039** 
//                           (0.016)         (0.017)   
//
// mkt_cap                     0.000**         0.000*  
//                           (0.000)         (0.000)   
//
// leverage_ratio              0.925**         0.793** 
//                           (0.414)         (0.288)   
//
// adj_ebitda                  0.000*          0.000   
//                           (0.000)         (0.000)   
//
// t1c_B                      -0.101***                
//                           (0.032)                   
//
// GSIB                       -3.023          -3.370   
//                           (2.184)         (2.279)   
//
// rir                         0.430           0.325   
//                           (0.251)         (0.304)   
//
// gdp                        -0.001***                
//                           (0.000)                   
//
// cpi                         0.156           0.191   
//                           (0.158)         (0.209)   
//
// log_t1c_B                                  -5.064   
//                                           (3.379)   
//
// log_gdp                                   -43.233***
//                                           (8.964)   
//
// Constant                   13.956         456.496***
//                          (15.776)        (94.598)   
// ----------------------------------------------------
// Observations                  542             542   
// ----------------------------------------------------
// Standard errors in parentheses
// Standard errors clustered at the country level.
// *** p<0.01, ** p<0.05, * p<0.10
