clear all
set more off
capture log close 
log using "${Logs}/benefits.log", replace

/*Goal: Verify whether below15 == dependents
Conclusions: Less than 1% of the sample gets pregnant or nursing benefits
			 benefitsYoung are for ages between 15 and 18 
			 benefits0t06 and benefits7to15 are as expected
			 Basic is 0, 70 or 77
			 Extraordinary is non existent
			 Extreme poverty has large support*/

use ${TreatedData}/cadFolRs_idIndMon.dta, clear
sum age if benefit0to6 == 35, d 
sum age if benefit7to15 == 35, d
sum age if benefitYoung == 42, d /*13-18 year old*/

tab benefit0to6 if _m == 3, m
tab benefit7to15 if _m == 3, m
tab benefitBasic if _m == 3, m
tab benefitPregnant if _m == 3, m /*Less than 1% of the sample*/
tab benefitNursin if _m == 3, m /*Less than 1% of the sample*/
tab benefitYoung if _m == 3, m
tab benefitExtrem if _m == 3, m
tab benefitExtrao if _m == 3, m
tab benefitTotalHh if _m == 3, m

*Checking differences in total within household date
bysort idHh dateFolha datePayment: gen benTotDifInd = (benefitTotalHh!=benefitTotalHh[_n-1] & _n>1)
bysort idHh dateFolha datePayment: egen benTotDifHh =total(benTotDifInd)
tab benTotDifInd
tab benTotDifHh

*Proportion of individuals getting benefits0to6 when they should not
count if benefit0to6 == 35 & age > 7 & ageFolha > 7
loc benefitIncons = r(N)
count if benefit0to6 == 35
loc totalBenefit = r(N)
display `benefitIncons'/`totalBenefit'

*Getting examples
preserve

keep if benefit0to6 == 35 & age > 7 & ageFolha > 7 
export excel using "${Tables}/forMDS/benefits.xls", sheet("benefit0to6_complete") firstrow(variables) replace

keep idHh idInd dta_atual_memb dta_nasc_pessoa age* benefit0to6
export excel using "${Tables}/forMDS/benefits.xls", sheet("benefit0to6") firstrow(variables)

restore
capture log close 
