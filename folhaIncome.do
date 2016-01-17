clear all
set more off
capture log close 
log using "${Logs}/folhaIncome.log", replace 

use ${TreatedData}/folhaIncomeRs.dta, clear

drop if rf_folha == ""
gen dateFolha = date(rf_folha,"MY")
rename renda_per_capita incomeFolhaPc

bysort idHh dateFolha: gen dup = _N
tab dup, m
drop if dup > 1 /*38,236 observeations (0.19% of the random sample) are duplicated*/
drop dup
format date* %tdCCYY.NN.DD

isid idHh dateFolha
sort idHh dateFolha
save ${TreatedData}/folhaIncomeRs_hhMonth.dta, replace

bysort idHh: gen ordering = _n
bysort idHh: gen change = (incomeFolha != incomeFolha[_n-1])
keep if ordering == 1 | change == 1
drop ordering change
isid idHh dateFolha
sort idHh dateFolha

save ${TreatedData}/folhaIncomeCompressRs_hhMonth.dta, replace

capture log close 
