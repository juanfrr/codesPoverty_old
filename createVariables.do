clear all
set more off
capture log close 
log using "${Logs}/createVariables.log", replace

*Dataset for rais histograms
use ${TreatedData}/raisCadRs_hh.dta, clear
gen uf = floor(codmun/10000)
gen ufRais = floor(codmunRais/10000)
gen hhSize = hhSizeDom
replace hhSize = hhSizePes if hhSizeDom == . | hhSizeDom == 0
count if hhSizeDom == . & incomeRais !=.
gen incomeRaisPc = incomeRais/hhSize
gen incomePesPc = incomePes/hhSize
gen incomeBfPc = incomeDomPc
replace incomeBfPc = incomePesPc if date != dateUpdateDom
gen evasionPc = incomeRaisPc-incomeBfPc
save ${TreatedData}/raisCadCompleteRs_hh.dta, replace

*Dataset for maps with average evasion
collapse evasionPc, by(codmun)
isid codmun
sort codmun
save ${TreatedData}/evasionPc_mun.dta, replace
 
*Dataset for maps with density of beneficiaries and
use ${TreatedData}/cadDomPesRs_idHh.dta, clear
gen numHh = 1
gen numInd = hhSizeDom
replace numInd = hhSizePes if hhSizeDom == 0 |  hhSizeDom == .
collapse (sum) numHh numInd, by(codmun)
isid codmun
sort codmun
save ${TreatedData}/applicants_mun.dta, replace

capture log close

/*
*Dataset for reported income histograms
use ${TreatedData}/cadDomPesRs_idHh.dta, clear
gen hhSize = hhSizeDom
replace hhSize = hhSizePes if hhSizeDom == . | hhSizeDom == 0
count if hhSize == .
gen incomePesPc = incomePes/hhSize
gen incomeBfPc = incomeDomPc
replace incomeBfPc = incomePesPc if date != dateUpdateDom
save ${TreatedData}/raisCadCompleteRs_hh.dta, replace

*Estimating delta
use ${TreatedData}/folhaIncomeCompressRs_hhMonth.dta, clear
bysort idHh: gen deltaHh = abs(incomeFolha -incomeFolha[_n-1]) if incomeFolha >13.5 & incomeFolha[_n-1] >13.5
count if deltaHh != .
count
sum deltaHh, detail
gen delta = r(p50)
unique idHh
collapse delta, by(idHh)
sort idHh
isid idHh
save ${TreatedData}/delta_hhMonth.dta, replace

*Estimating Instrinsic Occupation
use ${TreatedData}/intrinsicOccupationRs_idHh.dta, clear
merge 1:1 idHh using ${TreatedData}/delta_hhMonth.dta, keepusing(delta)
drop _m
areg incomeAvg educHeadEx educHead ageHead genderHead partner educPartnerEx educPartner hhSizeDom numAdults numRoomsEx numRooms, absorb(cd_ibge) r
areg incomeAvg educHeadEx educHead educHead2 ageHead ageHead2 genderHead partner educPartnerEx educPartner educPartner2 hhSizeDom numAdults numRoomsEx numRooms, absorb(cd_ibge) r
areg incomeAvg i.uf##c.educHeadEx i.uf##c.educHead i.uf##c.ageHead i.uf##c.genderHead i.uf##c.partner i.uf##c.educPartnerEx i.uf##c.educPartner i.uf##c.hhSizeDom i.uf##c.numAdults i.uf##c.numRoomsEx i.uf##c.numRooms, absorb(cd_ibge) 
set matsize 5000
areg incomeAvg i.uf##c.educHeadEx i.uf##c.educHead i.uf##c.educHead2 i.uf##c.ageHead i.uf##c.ageHead2 i.uf##c.genderHead i.uf##c.partner i.uf##c.educPartnerEx i.uf##c.educPartner i.uf##c.educPartner2 i.uf##c.hhSizeDom i.uf##c.numAdults i.uf##c.numRoomsEx i.uf##c.numRooms, absorb(cd_ibge) 
*Saturated Model for age, schooling, number of members, adults and rooms (seems to be the best, but by very little)
replace educHead = 10*educHead
replace educPartner = 10*educPartner
areg incomeAvg educHeadEx i.educHead i.ageHead genderHead partner educPartnerEx i.educPartner i.hhSizeDom i.numAdults i.numRooms, absorb(cd_ibge)
predict yhat
gen d0 = (yhat<=delta*.5)
forvalues i=1/10{
	gen d`i' = (yhat>delta*(`i'-.5) & yhat <=delta*(`i'+.5))
}
isid idHh
sort idHh
save ${TreatedData}/intrinsicOccupationCompleteRs_idHh.dta, replace

*Data set for regressions
***NEED TO GET DATE UPDATE OR ADJUST THE FOR
***NEED TO GET DATE UPDATE OR ADJUST THE FOR
***NEED TO GET DATE UPDATE OR ADJUST THE FOR
***NEED TO GET DATE UPDATE OR ADJUST THE FOR
***NEED TO GET DATE UPDATE OR ADJUST THE FOR
use ${TreatedData}/regressionsRs_AuxIndMonth.dta, clear
gen yearBirth = year(dateBirth)
gen monthBirth = month(dateBirth)

gen age = year-yearBirth 
replace age = age-1 if month < monthBirth
label var age "Age"
gen u = 0
replace u = 1 if age <= 6 & age >= 0
bysort idHh year month: egen below6 = total(u)
replace u = 1 if age <= 15 & age >= 0
bysort idHh year month: egen below15 = total(u)
drop u
gen u = 0
replace u = 1 if age <= 18 & age > 15
bysort idHh year month: egen teens = total(u)
collapse (sum) below6 below15 teens (mean) incomeFolha hhSize, by(idHh year month)

sort idHh 
merge m:1 idHh using ${TreatedData}/intrinsicOccupationCompleteRs_idHh.dta, keepusing(delta d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 d10)
rename _m mIntrinsic

gen wx = incomeFolha
label var wx "Reported per capita Income"

gen wMinusOne = wx-delta
label var wMinusOne "Household income in the lower occupation"

foreach lab in x MinusOne{

	gen rc`lab' = w`lab'
	label var rc`lab' "Reported Consumption of the Household"

	*Basic and Variable Benefits

/*	replace rc`lab' = w`lab' + (68+22*below15)/hhSize if below15 <= 3 & w`lab' <= 70 & dateUpdate>date("30Jul2009","DMY") & dateUpdate<date("01Apr2011","DMY")
	replace rc`lab' = w`lab' + (22*below15)/hhSize if below15 <= 3 & w`lab' > 70 & w`lab' <= 140 & dateUpdate>date("30Jul2009","DMY") & dateUpdate<date("01Apr2011","DMY")
	replace rc`lab' = w`lab' + (68+22*3)/hhSize if below15 > 3 & w`lab' <= 70 & dateUpdate>date("30Jul2009","DMY") & dateUpdate<date("01Apr2011","DMY")
	replace rc`lab' = w`lab' + (22*3)/hhSize if below15 > 3 & w`lab' > 70 & w`lab' <= 140 & dateUpdate>date("30Jul2009","DMY") & dateUpdate<date("01Apr2011","DMY")

	replace rc`lab' = w`lab' + (70+32*below15)/hhSize if below15 <= 3 & w`lab' <= 70 & dateUpdate>date("01Apr2011","DMY") & dateUpdate<date("2Jun2011","DMY")
	replace rc`lab' = w`lab' + (32*below15)/hhSize if below15 <= 3 & w`lab' > 70 & w`lab' <= 140 & dateUpdate>date("01Apr2011","DMY") & dateUpdate<date("2Jun2011","DMY")
	replace rc`lab' = w`lab' + (70+32*3)/hhSize if below15 > 3 & w`lab' <= 70 & dateUpdate>date("01Apr2011","DMY") & dateUpdate<date("2Jun2011","DMY")
	replace rc`lab' = w`lab' + (32*3)/hhSize if below15 > 3 & w`lab' > 70 & w`lab' <= 140 & dateUpdate>date("01Apr2011","DMY") & dateUpdate<date("2Jun2011","DMY")

	replace rc`lab' = w`lab' + (70+32*below15)/hhSize if below15 <= 5 & w`lab' <= 70 & dateUpdate>date("2Jun2011","DMY") & dateUpdate<date("1Jun2014","DMY")
	replace rc`lab' = w`lab' + (32*below15)/hhSize if below15 <= 5 & w`lab' > 70 & w`lab' <= 140 & dateUpdate>date("2Jun2011","DMY") & dateUpdate<date("1Jun2014","DMY")
	replace rc`lab' = w`lab' + (70+32*5)/hhSize if below15 > 5 & w`lab' <= 70 & dateUpdate>date("2Jun2011","DMY") & dateUpdate<date("1Jun2014","DMY")
	replace rc`lab' = w`lab' + (32*5)/hhSize if below15 > 5 & w`lab' > 70 & w`lab' <= 140 & dateUpdate>date("2Jun2011","DMY") & dateUpdate<date("1Jun2014","DMY")
*/
	replace rc`lab' = w`lab' + (77+35*below15)/hhSize if below15 <= 5 & w`lab' <= 77 & dateUpdate>date("1Jun2014","DMY") & dateUpdate<date("18Apr2015","DMY")
	replace rc`lab' = w`lab' + (35*below15)/hhSize if below15 <= 5 & w`lab' > 77 & w`lab' <= 154 & dateUpdate>date("1Jun2014","DMY") & dateUpdate<date("18Apr2015","DMY")
	replace rc`lab' = w`lab' + (77+35*5)/hhSize if below15 > 5 & w`lab' <= 77 & dateUpdate>date("1Jun2014","DMY") & dateUpdate<date("18Apr2015","DMY")
	replace rc`lab' = w`lab' + (35*5)/hhSize if below15 > 5 & w`lab' > 77 & w`lab' <= 154 & dateUpdate>date("1Jun2014","DMY") & dateUpdate<date("18Apr2015","DMY")

	*Teenager Benefits
/*
	replace rc`lab' = rc`lab' + (33*teens)/hhSize if teens <= 2 & w`lab' <= 70 & dateUpdate>date("30Jul2009","DMY") & dateUpdate<date("1Apr2011","DMY")
	replace rc`lab' = rc`lab' + (33*2)/hhSize if teens > 2 & w`lab' > 70 & w`lab' <= 140 & dateUpdate>date("30Jul2009","DMY") & dateUpdate<date("1Apr2011","DMY")

	replace rc`lab' = rc`lab' + (38*teens)/hhSize if teens <= 2 & w`lab' <= 70 & dateUpdate>date("1Apr2011","DMY") & dateUpdate<date("1Jun2014","DMY")
	replace rc`lab' = rc`lab' + (38*2)/hhSize if teens > 2 & w`lab' > 70 & w`lab' <= 140 & dateUpdate>date("1Apr2011","DMY") & dateUpdate<date("1Jun2014","DMY")
*/
	replace rc`lab' = rc`lab' + (42*teens)/hhSize if teens <= 2 & w`lab' <= 77 & dateUpdate>date("1Jun2014","DMY") & dateUpdate<date("18Apr2015","DMY")
	replace rc`lab' = rc`lab' + (42*2)/hhSize if teens > 2 & w`lab' > 77 & w`lab' <= 154 & dateUpdate>date("1Jun2014","DMY") & dateUpdate<date("18Apr2015","DMY")

	*Minimum incomeHhpc

	replace rc`lab' = 70 if rc`lab' <= 70 & below6 >= 1 & dateUpdate>date("18Jun2012","DMY") & dateUpdate<date("30Nov2012","DMY")
	replace rc`lab' = 70 if rc`lab' <= 70 & below15 >= 1 & dateUpdate>date("30Nov2012","DMY") & dateUpdate<date("19Feb2013","DMY")
	replace rc`lab' = 70 if rc`lab' <= 70 & dateUpdate>date("19Feb2013","DMY") & dateUpdate<date("1Jun2014","DMY")
	replace rc`lab' = 77 if rc`lab' <= 77 & dateUpdate>date("1Jun2014","DMY") & dateUpdate<date("18Apr2015","DMY")
}

drop wx 
rename rcx rc

gen lDeltaRc = log(rc-rcMinusOne)
gen lDeltaRc0 = log(rc-77)
replace lDeltaRc0 = log(rc-70) if dateUpdate>date("19Feb2013","DMY") & dateUpdate<date("1Jun2014","DMY")


