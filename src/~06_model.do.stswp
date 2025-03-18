* import dataset
import delimited "/Users/jinghan/Desktop/basel_proj/data/processed/df_for_stata.csv", case(preserve) stringcols(8 10 12 17) numericcols(1 2 3 4 5 6 7 9 11 13 14 15 16 18 19 20) clear 

gen tq_var = quarterly(yr_qtr, "YQ")  
format tq_var %tq  

** FE **
// ssc install ftools
// ssc install reghdfe
// reghdfe roe TP t1cr stock_price mkt_cap leverage_ratio rir gdp cpi, absorb(Group tq_var) vce(cluster country)

// 完美pvalue，但是少参数
// DID t1cr mkt_cap不sig
reghdfe roe TP t1cr mkt_cap rir gdp cpi, absorb(Group tq_var) vce(cluster country)

// // t1cr, rir, _cons不sig
// reghdfe roe TP t1cr leverage_ratio rir gdp cpi, absorb(Group tq_var) vce(cluster country)
//
// // DID不sig
// reghdfe roe TP t1cr leverage_ratio mkt_cap rir gdp cpi, absorb(Group tq_var) vce(cluster country)

// graph dif-in-dif result
preserve
collapse roe, by(T tq_var)

qui graph twoway (connected roe tq_var if T==1, lcol(dknavy) mcol(dknvy) msym(Oh))/*
*/(connected roe tq_var if T==0, lpat(dash) lcol(red) mcol(red) msym(Sh)) /*
*/,xline(4, lcolor(cranberry) lpat(vdash)) yline(0, lcolor(black) lpat(vdash))/*
*/ytitle("roe")/*
*/legend(order(1 "Treated Group (Canadian Banks)" 2 "Control Group (Others)")) title("Effects of increased Tier 1 Capital Ratio") /*
*/xtitle("Time") /*
*/graphregion(fcolor(white)  ifcolor(white) color(white) icolor(white)) ylabel() 
// graph export ../outputs/graphs/rm_banks.pdf, replace
// restore



**Diff in diff**
margins, at(TP=(0 1))
marginsplot, xdimension(TP) recast(line) plotopts(msymbol(circle))
// graph export ../outputs/graphs/did1.pdf, replace



// inclass method: graph dif-in-dif result
// reg roe T##i.tq_var T, cluster(bank)
reg roe T##i.tq_var, cluster(bank)

forvalues i=205(1)235{
qui gen b`i'=_b[1.T#`i'.tq_var]
qui gen se`i'=_se[1.T#`i'.tq_var]
}

preserve
collapse b205-se235
qui gen id=1
order id
reshape long b se, i(id) j(tq_var)
drop id

qui gen ub = b+1.96*se
qui gen lb = b-1.96*se

qui graph twoway (connected b tq_var, lcol(dknavy) mcol(dknavy) msym(Oh))(rcap ub lb tq_var, lcol(emidblue) lpat(dash) mcol(emidblue))/*
*/,xline(4, lcolor(cranberry) lpat(vdash)) yline(0, lcolor(black) lpat(vdash))/*
*/legend(off) title("Effects of Reform on Health Outcome") /*
*/ytitle("Health Outcome") xtitle("Year")  /*
*/graphregion(fcolor(white)  ifcolor(white) color(white) icolor(white)) ylabel() 
// graph export ../outputs/graphs/did2.pdf, replace



reg roe i.tq_var##i.Group GDP CPI stock_inx, vce(robust)
margins time#Group
marginsplot

