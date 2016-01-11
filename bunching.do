clear all
set more off
capture log close 
log using "${Logs}/bunching.log", replace

use ${TreatedData}/cadUnicoDomRs_idHh.dta, clear

bysort incomeDomPc: gen c = _N
bysort incomeDomPc: gen aux = _n
keep if c == aux & c <1000
drop aux
count 
loc num = r(N)


forvalues i=0(0.01)999.99{
	count if incomeDomPc == `i'
	loc number = r(N)
	gen ci = num
}


gen incomeApprox = round(incomeDomPc,0.1)
replace incomeApprox = round(incomeApprox) if incomeApprox > 200
tab incomeApprox

capture log close
