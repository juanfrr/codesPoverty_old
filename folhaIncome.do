use ${TreatedData}/folhaIncomeRs.dta, clear

gen dateFolha = date(rf_folha,"MY")
rename renda_per_capita incomeFolha
sort idHh dateFolha
bysort idHh dateFolha: gen dup = _N
tab dup, m
drop if dup > 1 /*35,159 observeations (0.17% of the random sample) are duplicated*/
drop dup
isid idHh dateFolha
sort idHh dateFolha
save ${TreatedData}/folhaIncomeRs_hhMonth.dta, replace
