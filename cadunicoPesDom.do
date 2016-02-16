clear all
set more off
capture log close 
log using "${Logs}/cadunicoPesDom.log", replace

/*Goal: Verify whether hhSizeDom == hhSizePes and if incomeDomPc == incomePes/hhSize
Conclusions: */

			 
			 
****Analysis at the individual level
use ${TreatedData}/cadDomPesRs_idInd.dta, clear

***Checking dates
count if dateUpdateDom == datePesMax
count if dateUpdateDom == dateUpdatePes
count if dateUpdateDom == dateUpdatePes & dateUpdateDom != datePesMax
count if dateUpdateDom != dateUpdatePes & dateUpdateDom == datePesMax
count

***Checking Income (individual level)

*Proportion of consistent income 
count if abs(incomeDomMPes) < 1 
loc incomeConsistent = r(N)
count if incomeDomMPes < .
loc totalIncome = r(N)
display `incomeConsistent'/`totalIncome'

*** Remaining problems:

**1) min(incomeLast, incomeYear) when either is missing
*Remember that min(#,.)=#

*Proportion of right incomes when min(#>0,.) or min(.,#>0)
count if abs(incomeDomMPes) < 1 & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .))
loc incomeConsistent = r(N)
count if incomeDomMPes < . & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .))
loc totalIncome = r(N)
display `incomeConsistent'/`totalIncome'

*Proportion of right incomes when min(#>0,.) ie when incomeYear == .
count if abs(incomeDomMPes) < 1 & (incomeYear == . & incomeLast > 0 & incomeLast < .)
loc incomeConsistent = r(N)
count if incomeDomMPes < . & (incomeYear == . & incomeLast > 0 & incomeLast < .)
loc totalIncome = r(N)
display `incomeConsistent'/`totalIncome'

*Proportion of right incomes when min(.,#>0) ie when incomeLast == .
count if abs(incomeDomMPes) < 1 & (incomeLast == . & incomeYear > 0 & incomeYear < .) 
loc incomeConsistent = r(N)
count if incomeDomMPes < . & (incomeLast == . & incomeYear > 0 & incomeYear < .)
loc totalIncome = r(N)
display `incomeConsistent'/`totalIncome'

*Proportion of right incomes when min(#,#) or min(.,.) or min(0,x) or min(x,0)
count if abs(incomeDomMPes) < 1 & ((incomeLast != . & incomeYear != .) | (incomeYear == . & incomeLast == .) | incomeYear == 0 | incomeLast == 0)
loc incomeConsistent = r(N)
count if incomeDomMPes < . & ((incomeLast != . & incomeYear != .) | (incomeYear == . & incomeLast == .) | incomeYear == 0 | incomeLast == 0)
loc totalIncome = r(N)
display `incomeConsistent'/`totalIncome'

***Getting examples

**For MDS meeting

sort idHh dateUpdatePes
preserve

gen cond = (abs(incomeDomMPes) > 1  & abs(incomeDomMPes) < .  & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .)) & dateUpdatePes >= date("01-01-2015", "MDY"))
bysort idHh: egen hhcond = total(cond)
keep if hhcond == 1
export excel using "${Tables}/forMDS/min.xls", sheet("zero_complete") firstrow(variables) replace

keep idHh idInd dateUpdatePes dateUpdateDom hhSizePes income*
export excel using "${Tables}/forMDS/min.xls", sheet("zero") firstrow(variables)

restore
preserve

gen cond = (abs(incomeDomMPes) < 1 & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .)) & dateUpdatePes >= date("01-01-2015", "MDY"))
bysort idHh: egen hhcond = total(cond)
keep if hhcond == 1
export excel using "${Tables}/forMDS/min.xls", sheet("number_complete") firstrow(variables)

keep idHh idInd dateUpdatePes dateUpdateDom hhSizePes income* 
export excel using "${Tables}/forMDS/min.xls", sheet("number") firstrow(variables)

restore
preserve

summdate dateUpdateDom if abs(incomeDomMPes) < 1  & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .))
summdate dateUpdateDom if abs(incomeDomMPes) > 1  & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .))

summdate dateUpdateDom if abs(incomeDomMPes) < 1 & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .))
summdate dateUpdatePes if abs(incomeDomMPes) < 1 & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .))

**For BH meeting

*Pampulha Inconsistencies
gen cond = (cd_ibge == 3106200 & codUnity == 25 & dateUpdateDom != dateUpdatePes)
bysort idHh: egen hhcond = total(cond)
keep if hhcond == 1
export excel using "${Tables}/forBH/inconsistencies.xls", sheet("pampulha_date_complete") firstrow(variables) replace

keep idHh idInd date* 
export excel using "${Tables}/forBH/inconsistencies.xls", sheet("pampulha_date") firstrow(variables)

restore
preserve

*Venda Nova Inconsistencies
gen cond = (cd_ibge == 3106200 & codUnity == 26 & dateUpdateDom != dateUpdatePes)
bysort idHh: egen hhcond = total(cond)
keep if hhcond == 1
export excel using "${Tables}/forBH/inconsistencies.xls", sheet("vendanova_date_complete") firstrow(variables)

keep idHh date* 
export excel using "${Tables}/forBH/inconsistencies.xls", sheet("vendanova_date") firstrow(variables)

restore
preserve

gen cond = (cd_ibge == 3106200 & codUnity == 26 & abs(incomeDomMPes) > 1 & mPesDom == 3)
bysort idHh: egen hhcond = total(cond)
keep if hhcond == 1
export excel using "${Tables}/forBH/inconsistencies.xls", sheet("vendanova_income_complete") firstrow(variables)

keep idHh idInd dateUpdatePes dateUpdateDom hhSizePes income* 
export excel using "${Tables}/forBH/inconsistencies.xls", sheet("vendanova_income") firstrow(variables)

restore
preserve

*BH inconsistencies with merge
gen cond = (cd_ibge == 3106200 & mPesDom < 3)
bysort idHh: egen hhcond = total(cond)
keep if hhcond == 1
export excel using "${Tables}/forBH/inconsistencies.xls", sheet("bh_merge_complete") firstrow(variables)

keep idHh idInd dateUpdatePes dateUpdateDom hhSizePes income* 
export excel using "${Tables}/forBH/inconsistencies.xls", sheet("bh_merge") firstrow(variables)

**** Checking income (hh level)

use ${TreatedData}/cadDomPesRs_idHh.dta, clear

count if incomeDomPc == .
count if incomePesPc == .
count if incomeDomPc ==. & incomePesPc == .
count
count if incomeDomPc !=. & incomePesPc != .

sum incomeDomMPes, d
sum incomeDomMPes if abs(incomeDomMPes)>1, d
sum incomeDomMPes if abs(incomeDomMPes)>1 & per == "06/01/14 to 04/18/15", d

count if abs(incomeDomMPes) < 1
loc incomeConsistent = r(N)
count if incomeDomMPes < .
loc totalIncome = r(N)
display `incomeConsistent'/`totalIncome'

count if abs(incomeDomMPes) < 1 & dateUpdateDom == dateUpdatePes
loc incomeConsistentDateCons = r(N)
count if incomeDomMPes < . & dateUpdateDom == dateUpdatePes
loc totalIncomeDateCons = r(N)
display `incomeConsistentDateCons'/`totalIncomeDateCons'

count if per == "07/30/09 to 04/01/11" & abs(incomeDomMPes) < 1 
loc incomeConsistent1 = r(N)
count if per == "07/30/09 to 04/01/11" & abs(incomeDomMPes) == 0
count if per == "07/30/09 to 04/01/11" & abs(incomeDomMPes)< .
loc totalIncome1 = r(N)
display `incomeConsistent1'/`totalIncome1'

count if per == "04/01/11 to 06/02/11" & abs(incomeDomMPes) < 1
loc incomeConsistent2 = r(N)
count if per == "04/01/11 to 06/02/11" & abs(incomeDomMPes) == 0
count if per == "04/01/11 to 06/02/11" & abs(incomeDomMPes)< .
loc totalIncome2 = r(N)
display `incomeConsistent2'/`totalIncome2'

count if per == "06/02/11 to 06/18/12" & abs(incomeDomMPes) < 1
loc incomeConsistent3 = r(N)
count if per == "06/02/11 to 06/18/12" & abs(incomeDomMPes) == 0
count if per == "06/02/11 to 06/18/12" & abs(incomeDomMPes)< .
loc totalIncome3 = r(N)
display `incomeConsistent3'/`totalIncome3'

count if per == "06/18/12 to 11/30/12" & abs(incomeDomMPes) < 1
loc incomeConsistent4 = r(N)
count if per == "06/18/12 to 11/30/12" & abs(incomeDomMPes) == 0
count if per == "06/18/12 to 11/30/12" & abs(incomeDomMPes)< .
loc totalIncome4 = r(N)
display `incomeConsistent4'/`totalIncome4'

count if per == "11/30/12 to 02/19/13" & abs(incomeDomMPes) < 1
loc incomeConsistent5 = r(N)
count if per == "11/30/12 to 02/19/13" & abs(incomeDomMPes) == 0
count if per == "11/30/12 to 02/19/13" & abs(incomeDomMPes)< .
loc totalIncome5 = r(N)
display `incomeConsistent5'/`totalIncome5'

count if per == "02/19/13 to 06/01/14" & abs(incomeDomMPes) < 1
loc incomeConsistent6 = r(N)
count if per == "02/19/13 to 06/01/14" & abs(incomeDomMPes) == 0
count if per == "02/19/13 to 06/01/14" & abs(incomeDomMPes)< .
loc totalIncome6 = r(N)
display `incomeConsistent6'/`totalIncome6'

count if per == "06/01/14 to 04/18/15" & abs(incomeDomMPes) < 1
loc incomeConsistent7 = r(N)
count if per == "06/01/14 to 04/18/15" & abs(incomeDomMPes) == 0
count if per == "06/01/14 to 04/18/15" & abs(incomeDomMPes)< .
loc totalIncome7 = r(N)
display `incomeConsistent7'/`totalIncome7'

count if incomeDomMPes == 50
count if incomeDomMPes > 49 & incomeDomMPes <51

capture log close 
