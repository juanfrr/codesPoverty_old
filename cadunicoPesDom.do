clear all
set more off
capture log close 
log using "${Logs}/cadunicoPesDom.log", replace

/*Goal: Verify whether hhSizeDom == hhSizePes and if incomeDomPc == incomePes/hhSize
Conclusions: 99% of the households have hhSizeDom greater than hhSizePes-2 and smaller than hhSizePes+5
			 In general income is coherent for 21.4% (29.1%) of the households
			 In the second to last period income is coherent for 21.9%% (29.9%) of the households
			 In the last period income is coherent for 21.8% (29.6%) of the households
			 p25(incomeDomPc-incomePesPc) = -5 and p75(incomeDomPc-incomePesPc) = 83.33
			 41,084 observations or 3.2% (42,720 or 3.3%) have incomeDomPc = incomePesPc +50
			 Values within brackets are allowing for differences of up to 1 real (rounding issues)
			 Errors do not seem to come from particular dates
			 households with error = 50 are more likely to have 2 household members*/

			 
			 
*Analysis at the individual level
use ${TreatedData}/cadDomPesRs_idInd.dta, clear

*keep if mDomPes == 3
gen incomeDomMPes = incomeDomPc -incomePesPc

bysort idHh: egen datePesMax = max(dateUpdatePes)
format date* %tdCCYY.NN.DD

count if dateUpdateDom == datePesMax
count if dateUpdateDom == dateUpdatePes
count if dateUpdateDom == dateUpdatePes & dateUpdateDom != datePesMax
count if dateUpdateDom != dateUpdatePes & dateUpdateDom == datePesMax
count

/*gen uf = floor(codmun/10000)
tab uf 
tab uf if abs(incomeDomMPes) > 1 & mPesDom == 3
tab uf if mPesDom < 3*/

*Pampulha Inconsistencies
edit idHh idInd date* if cd_ibge == 3106200 & codUnity == 25 & dateUpdateDom != dateUpdatePes
edit if cd_ibge == 3106200 & codUnity == 25 & dateUpdateDom != dateUpdatePes

*Venda Nova Inconsistencies
edit idHh date* if cd_ibge == 3106200 & codUnity == 26 & dateUpdateDom != dateUpdatePes
edit if cd_ibge == 3106200 & codUnity == 26 & dateUpdateDom != dateUpdatePes

edit idHh idInd dateUpdatePes dateUpdateDom hhSizePes income* if cd_ibge == 3106200 & codUnity == 26 & abs(incomeDomMPes) > 1 & mPesDom == 3
edit if cd_ibge == 3106200 & codUnity == 26 & abs(incomeDomMPes) > 1 & mPesDom == 3

*BH inconsistencies with merge
edit idHh idInd dateUpdatePes dateUpdateDom hhSizePes income* if cd_ibge == 3106200 & mPesDom < 3
edit if cd_ibge == 3106200 & mPesDom < 3

count if abs(incomeDomMPes) == 1
count if abs(incomeDomMPes) < 1 
loc incomeConsistent = r(N)
count if incomeDomMPes < .
loc totalIncome = r(N)
display `incomeConsistent'/`totalIncome'

*Proportion of right incomes when min(#>0,.) or min(.,#>0)
count if abs(incomeDomMPes) < 1 & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .))
loc incomeConsistent = r(N)
count if abs(incomeDomMPes) > 1 & incomeDomMPes < . & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .))
count if abs(incomeDomMPes) == 1 & incomeDomMPes < . & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .))
count if incomeDomMPes == . & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .))
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

*
keep if m == 3
count if abs(incomeDomMPes) < 1 & (incomeYear == . & incomeLast > 0 & incomeLast < .)
count if abs(incomeDomMPes) > 1 & incomeDomMPes <. & (incomeYear == . & incomeLast > 0 & incomeLast < .)
count if incomeDomMPes == . & (incomeYear == . & incomeLast > 0 & incomeLast < .)
count if incomeDomMPes == . & (incomeLast == . & incomeYear > 0 & incomeYear < .)
browse idHh idInd dateUpdatePes dateUpdateDom hhSizePes income* if abs(incomeDomMPes) < 1 & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .)) 
& dateUpdatePes >= date("01-01-2015", "MDY")
browse idHh idInd dateUpdatePes dateUpdateDom hhSizePes income* if idHh == 5911840

summdate dateUpdateDom if abs(incomeDomMPes) < 1 & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .))
summdate dateUpdatePes if abs(incomeDomMPes) < 1 & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .))

*Proportion of right incomes when min(#,#) or min(.,.) or min(0,x) or min(x,0)
count if abs(incomeDomMPes) < 1 & ((incomeLast != . & incomeYear != .) | (incomeYear == . & incomeLast == .) | incomeYear == 0 | incomeLast == 0)
loc incomeConsistent = r(N)
count if incomeDomMPes < . & ((incomeLast != . & incomeYear != .) | (incomeYear == . & incomeLast == .) | incomeYear == 0 | incomeLast == 0)
loc totalIncome = r(N)
display `incomeConsistent'/`totalIncome'

sort idHh dateUpdatePes
browse idHh idInd dateUpdatePes dateUpdateDom hhSizePes income* if abs(incomeDomMPes) < 1  & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .))
browse idHh idInd dateUpdatePes dateUpdateDom hhSizePes income* if abs(incomeDomMPes) > 1  & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .))

summdate dateUpdateDom if abs(incomeDomMPes) < 1  & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .))
summdate dateUpdateDom if abs(incomeDomMPes) > 1  & ((incomeLast == . & incomeYear > 0 & incomeYear < .) | (incomeYear == . & incomeLast > 0 & incomeLast < .))


*Analysis at the hh level			 
use ${TreatedData}/cadDomPesRs_idHh.dta, clear

count if incomeDomPc == .
count if incomePesPc == .
count if incomeDomPc ==. & incomePesPc == .
count
count if incomeDomPc !=. & incomePesPc != .
gen incomeDomMPes = incomeDomPc -incomePesPc

sum incomeDomMPes, d
sum incomeDomMPes if abs(incomeDomMPes)>1, d
sum incomeDomMPes if abs(incomeDomMPes)>1 & per == "06/01/14 to 04/18/15", d

count if abs(incomeDomMPes) < 1
loc incomeConsistent = r(N)
count if incomeDomMPes == 0
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
