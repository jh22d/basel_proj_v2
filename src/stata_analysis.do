* import dataset
import delimited "/Users/jinghan/Desktop/econ490/term paper/econ490 data prep/data/processed/clean_data_stata.csv", case(preserve) clear
gen tq_var = quarterly(yr_qtr, "YQ")  
format tq_var %tq  


** FE **
// ssc install ftools
// ssc install reghdfe
// reghdfe roe t1cr gdp cpi stock_idx, absorb(bank tq_var) vce(cluster bank)

reghdfe roe t1cr gdp cpi stock_idx TP, absorb(bank tq_var) vce(cluster bank)

// graph dif-in-dif result
preserve
collapse roe, by(T tq_var)

qui graph twoway (connected roe tq_var if T==1, lcol(dknavy) mcol(dknvy) msym(Oh))/*
*/(connected roe tq_var if T==0, lpat(dash) lcol(red) mcol(red) msym(Sh)) /*
*/,xline(4, lcolor(cranberry) lpat(vdash)) yline(0, lcolor(black) lpat(vdash))/*
*/ytitle("roe")/*
*/legend(order(1 "Treated Group (Canadian Banks)" 2 "Control Group (Others)")) title("Effects of increased CAR") /*
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

forvalues i=220(1)230{
qui gen b`i'=_b[1.T#`i'.tq_var]
qui gen se`i'=_se[1.T#`i'.tq_var]
}

preserve
collapse b220-se230
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



reg roe i.tq_var##i.group GDP CPI stock_inx, vce(robust)
margins time#group
marginsplot

