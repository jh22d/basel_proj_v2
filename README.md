# basel_proj_v2
*new sample data selected*

### Design

Period: 2011-2018

Sample: All G-SIBs and D-SIBs in Canada and the US

y: roe

fe: 

- Did estimator: TP

- Macro: GDP, CPI, stock_idx, RIR (real interest rate)
  
- Bankwise: Roe, T1cr, stock_price, mkt_cap, leverage ratio, adj_EBIT (Earnings before interest and tax)

- Control for invariant: absorb(group tq_var): group: based on the Tier 1 capital -- more than !!! (e.g. euro 3 million) considered as group 1 banks

Clustered standard error: vce(cluster country)

##### Description
- p.9 - p.12 in bis.org/bcbs/pibl/d544.pdf)

### EDA & Viz
- evolution of all avg t1c
- weighted tic (p.13 in bis.org/bcbs/pibl/d544.pdf)




Samples:

**US**

G-SIBs
1.	JPMORGAN CHASE & CO: jpm
2.	Citigroup: c
3.	Bank of America: bac
4.	Goldman Sachs: gs
5.	Morgan Stanley: ms
6.	Wells Frago: wfc
7.	BNY Mellon: bk
8.	State Street: stt
   
D-SIBs
1.	U.S. Bancorp:usb
2.	Truist Financial:tfc
3.	SunTrust Banks
4.	Regions Financial: rf
6.	Fifth Third Bank:fitb
7.	Capital One Financial: cof
8.	American Express: axp
9.	Ally Financial: ally
10.	Zions: zion
11.	Mufg americans holdings:mufg
12.	Santander Holdings USA: sov
13.	RBS Citizens Financial Group: cfg
14.	Northern Trust: ntrs
15.	M&T Bank: mtb
16.	Huntington Bancshares: hban
17.	Discover Financial Services: dfs
18.	Comerica: cma
19.	BMO Financial Corp.


**CA**

G-SIBs
1.	RBC
2.	TD
3.	BMO
4.	BNS

D-SIBs
1.	CIBC: cm
2.	National Bank of Canada


