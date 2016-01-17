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

/*
*Samples for bunching estimates
use ${TreatedData}/cadDomPesRs_idHh.dta, clear
bysort incomeDomPc period dependents teen: gen c = _N
bysort incomeDomPc period dependents teen: gen aux = _n
keep if c == aux & incomeDomPc <1000
keep incomeDomPc c period dependents teen
sort incomeDomPc
gen aux = 100*(income[_n+1]-income)
replace aux = 1 if aux == .
expand aux, gen(dup)
sort income dup
replace c = 0 if dup == 1
gen ybar = _n/100-0.01
keep c ybar
gen r1 = (mod(ybar,1) == 0)
gen r5 = (mod(ybar,5) == 0)
gen r10 = (mod(ybar,10) == 0)
gen r25 = (mod(ybar,25) == 0)
gen r50 = (mod(ybar,50) == 0)
gen r100 = (mod(ybar,100) == 0)
save ${TreatedData}/cadUnicoDomRs_07302009_bin.dta, replace


capture log close 
