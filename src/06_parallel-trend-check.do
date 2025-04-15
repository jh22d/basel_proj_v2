// This file is modified on Apr 11, 2025, after the meeting with TA 

. import delimited "/Users/jinghan/Desktop/basel_proj/data/processed/df_for_stata.csv", case(preserve) stringcols(6 8 12) numericcols(1 2 3 4 5 7 9 10 11 13 14 15 16 17 18 19) clear 

// . import delimited "/Users/jinghan/Desktop/basel_proj/data/processed/df_for_stata.csv", case(preserve) stringcols(8 10 13 20) numericcols(1 2 3 4 5 6 7 9 11 12 14 15 16 17 18 19 21 22 23) clear 


gen tq_var = quarterly(yr_qtr, "YQ")  
format tq_var %tq  


// graph roe trend -- pre & post policy change 
preserve
collapse roe, by(T year)
qui graph twoway (connected roe year if T==1, lcol(dknavy) mcol(dknvy) msym(Oh))/*
*/(connected roe year if T==0, lpat(dash) lcol(red) mcol(red) msym(Sh)) /*
*/,xline(2014, lcolor(cranberry) lpat(vdash)) yline(0, lcolor(black) lpat(vdash))/*
*/ytitle("ROE")/*
*/legend(order(1 "Canadian Banks" 2 "US Banks")) title("Effects of increased Tier 1 Capital Ratio Requirement") /*
*/xtitle(" ") /*
*/graphregion(fcolor(white)  ifcolor(white) color(white) icolor(white)) ylabel() 
graph export "../output/graph/parallel_trend_check.pdf", replace
restore



// **Diff in diff given by chatgpt**
// // model 1: DID&Treatment w/o t1cr
// reghdfe roe TP  T P stock_price GSIB  gdp cpi rir, absorb(Group) vce(cluster bank)
// margins, at(T=(0 1) P=(0 1))
// marginsplot, xdimension(P) recast(line) plotopts(msymbol(circle))


**Diff in diff given by Moon**
reg roe T##i.year, cluster(bank)
// reg roe T##b2013i.year, cluster(bank)

forvalues i=2012(1)2018 {
qui gen b`i'=_b[1.T#`i'.year]
qui gen se`i'=_se[1.T#`i'.year]
}

preserve
collapse b2012-se2018
qui gen id=1
order id
reshape long b se, i(id) j(year)
drop id

qui gen ub = b+1.96*se
qui gen lb = b-1.96*se

// qui gen ub = b+1.96*se*10^13
// qui gen lb = b-1.96*se*10^13

qui graph twoway (connected b year, lcol(dknavy) mcol(dknavy) msym(Oh))(rcap ub lb year, lcol(emidblue) lpat(dash) mcol(emidblue))/*
*/,xline(217, lcolor(cranberry) lpat(vdash)) yline(0, lcolor(black) lpat(vdash))/*
*/legend(off) title("Effects of Implementation of Increased Tier 1 Capital Ratio") /*
*/ytitle("T1cr") xtitle("Year") /*
*/graphregion(fcolor(white)  ifcolor(white) color(white) icolor(white)) ylabel() 
// graph export did_ci.pdf, replace
// restore





