* import dataset
import delimited "/Users/jinghan/Desktop/basel_proj/data/processed/df_for_stata.csv", case(preserve) stringcols(8 10 12 17) numericcols(1 2 3 4 5 6 7 9 11 13 14 15 16 18 19 20) clear 

gen tq_var = quarterly(yr_qtr, "YQ")  
format tq_var %tq  

** FE pt1**
// Model 1: DID w/o t1cr
reghdfe roe TP  stock_price rir gdp cpi , absorb(Group tq_var) vce(cluster country)
eststo did_fe
// Model 2: DID & t1cr
reghdfe roe TP t1cr t1c_B GSIB mkt_cap rir gdp cpi, absorb(Group tq_var) vce(cluster country)
eststo did_treatment_fe

// Combine results into one table
esttab did_fe did_treatment_fe, ///
    b(%9.3f) se(%9.3f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    label ///
    title("Comparison of Regression Models") ///
    addnotes("Standard errors clustered at the country level." "*** p<0.01, ** p<0.05, * p<0.10")
	
** FE pt2**
// Model 1: DID without t1cr
reghdfe roe TP stock_price GSIB mkt_cap rir gdp cpi, absorb(country tq_var) vce(cluster Group)
eststo m1
// Model 2: DID with t1cr
reghdfe roe TP t1cr mkt_cap rir gdp cpi, absorb(country tq_var) vce(cluster Group)
eststo m2
// Model 3: DID without t1cr, all covariates used
reghdfe roe TP t1cr t1c_B GSIB mkt_cap rir gdp cpi, absorb(country tq_var) vce(cluster Group)
eststo m3
// Combine results into one table
esttab m1 m2 m3,///
    b(%9.3f) se(%9.3f) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    label ///
    title("Comparison of Regression Models") ///
    addnotes("Standard errors clustered at the country level." "*** p<0.01, ** p<0.05, * p<0.10")
	
	
// graph dif-in-dif result
preserve
collapse roe, by(T tq_var)

local xline_value = yq(2014, 1)
qui graph twoway (connected roe tq_var if T==1, lcol(dknavy) mcol(dknvy) msym(Oh))/*
*/(connected roe tq_var if T==0, lpat(dash) lcol(red) mcol(red) msym(Sh)) /*
*/,xline(`xline_value', lcolor(cranberry) lpat(vdash)) yline(0, lcolor(black) lpat(vdash))/*
*/ytitle("roe")/*
*/legend(order(1 "Treatment (Canadian Banks)" 2 "Control (Others)")) title("Effects of increased Tier 1 Capital Ratio Requirement") /*
*/xtitle(" ") /*
*/graphregion(fcolor(white)  ifcolor(white) color(white) icolor(white)) ylabel() 




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

