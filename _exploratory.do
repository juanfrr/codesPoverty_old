use ${TreatedData}/cadDomPesRs_idHh.dta, clear

gen dateUpdate = dateUpdateDom
replace dateUpdate = dateUpdatePes if dateUpdateDom == .
gen period = "07/30/09 to 04/01/11" if dateUpdate>date("30Jul2009","DMY") & dateUpdate<date("01Apr2011","DMY")
replace period = "04/01/11 to 06/02/11" if dateUpdate>date("01Apr2011","DMY") & dateUpdate<date("2Jun2011","DMY")
replace period = "06/02/11 to 06/18/12" if dateUpdate>date("2Jun2011","DMY") & dateUpdate<date("18Jun2012","DMY") 
replace period = "06/18/12 to 11/30/12" if dateUpdate>date("18Jun2012","DMY") & dateUpdate<date("30Nov2012","DMY") /*Only one in which below6 matters*/
replace period = "11/30/12 to 02/19/13" if dateUpdate>date("30Nov2012","DMY") & dateUpdate<date("19Feb2013","DMY")
replace period = "02/19/13 to 06/01/14" if dateUpdate>date("19Feb2013","DMY") & dateUpdate<date("1Jun2014","DMY")
replace period = "06/01/14 to 04/18/15" if dateUpdate>date("1Jun2014","DMY") & dateUpdate<date("18Apr2015","DMY")

tab period below15
tab hhSizeDom
tab below6 if hhSizeDom == 3
tab below15 if hhSizeDom == 3
tab teen if hhSizeDom == 3
*Basic and Variable Benefits (always matters)
dateUpdate>date("30Jul2009","DMY") & dateUpdate<date("01Apr2011","DMY")
dateUpdate>date("01Apr2011","DMY") & dateUpdate<date("2Jun2011","DMY")
dateUpdate>date("2Jun2011","DMY") & dateUpdate<date("1Jun2014","DMY")
dateUpdate>date("1Jun2014","DMY") & dateUpdate<date("18Apr2015","DMY")
*Teenager Benefits
dateUpdate>date("30Jul2009","DMY") & dateUpdate<date("1Apr2011","DMY")
dateUpdate>date("1Apr2011","DMY") & dateUpdate<date("1Jun2014","DMY")
dateUpdate>date("1Jun2014","DMY") & dateUpdate<date("18Apr2015","DMY")
*Minimum incomeHhpc
dateUpdate>date("18Jun2012","DMY") & dateUpdate<date("30Nov2012","DMY") /*Only one in which below6 matters*/
dateUpdate>date("30Nov2012","DMY") & dateUpdate<date("19Feb2013","DMY")
dateUpdate>date("19Feb2013","DMY") & dateUpdate<date("1Jun2014","DMY")
dateUpdate>date("1Jun2014","DMY") & dateUpdate<date("18Apr2015","DMY")

*General 
git remote add origin https://github.com/juanfrr/codesPoverty.git
git push -u origin master

/*

unique idHh if mRaisDom == 3
unique idHh if mRaisDom == 3 & mRaisDomPes == 3
unique idHh

foreach name in Young Extraordinary{
	replace date`name' = substr(date`name',1,10) if length(date`name')== 19
	replace date`name' = "" if length(date`name')<10
	replace date`name' = date(date`name',"DMY")
}
tab lYoung
tab lExtra

browse dateYoung if lYoung == 19
browse dateExtra if lExtra == 4
tab dateLast if lLast == 10

destring incomeLas, gen(incomeLasNew) force
browse incomeLas incomeLasNew if incomeLasNew== .
tab mRais if incomeLasNew== .
use ${TreatedData}/raisRs2012.dta, clear
tab mRais


global TreatedData "${root}/TreatedData_nov18"

use ${TreatedData}/cadUnicoDomRs_idHh.dta, clear

histogram incomeDomPc if dateUpdateDom>date("06/01/2014","MDY") ///
& incomeDomPc > 119 & incomeDomPc < 168, width(3.5) start(119.001) ///
 ylabel(0(0.01)0.05) xlabel(154) play(${Codes}/theory)
graph save ${Graphs}/fig_cadDomRs_After, replace
graph export ${Presentation}/fig_cadDomRs_After.pdf, replace

*Rais 
use ${TreatedData}/raisCadCompleteRs_hh.dta, clear


/*
histogram incomeRaisPc if date>date("06/01/2014","MDY") ///
& incomeRaisPc > 119 & incomeRaisPc < 168, width(3.5) start(119.001) ///
ylabel(0(0.01)0.05) xlabel(154) play(${Codes}/theory)
graph save ${Graphs}/fig_raisRs_After, replace
graph export ${Presentation}/fig_raisRs_After.pdf, replace

clear all
set more off
capture log close 
log using "${Logs}/histograms.log", replace

use ${TreatedData}/raisCadCompleteRs_hh.dta, clear

*preserve

replace incomeRaisPc = 0 if incomeRaisPc <=50
forvalues i=100(100)900{
	replace incomeRaisPc = `i' if incomeRaisPc > `i'-50 & incomeRaisPc <= `i'+50
}
replace incomeRaisPc = 1000 if incomeRaisPc > 950
tab incomeRaisPc
collapse incomeBfPc, by(incomeRaisPc)
graph twoway scatter incomeBfPc incomeRaisPc

*restore
use ${TreatedData}/raisCadCompleteRs_hh.dta, clear

replace incomeBfPc = 0 if incomeBfPc <=20
forvalues i=40(40)360{
	replace incomeBfPc = `i' if incomeBfPc > `i'-20 & incomeBfPc <= `i'+20
}
replace incomeBfPc = 400 if incomeBfPc > 380
tab incomeBfPc
collapse incomeRaisPc, by(incomeBfPc)
graph twoway scatter incomeRaisPc incomeBfPc

*Cadunico Domicilio (no need to use Pessoa as there were no missings)
use ${TreatedData}/cadUnicoDomRs_idHh.dta, clear

count if dateUpdateDom<date("06/01/2014","MDY") & incomeDomPc > 52.5 & incomeDomPc < 98
local N: display %19.0f r(N)
histogram incomeDomPc if dateUpdateDom<date("06/01/2014","MDY") ///
& incomeDomPc > 52.5 & incomeDomPc < 99.75, width(3.5) start(52.501)  play(${Codes}/before_first) ///
title("First Threshold (Before)") text(.075 86 "`N' obs.") ylabel(0(0.05)0.1) xlabel(70 (7) 77)
graph save ${Graphs}/cadDomRs_firstBefore, replace 

count if dateUpdateDom<date("06/01/2014","MDY") & incomeDomPc > 119 & incomeDomPc < 168
local N: display %19.0f r(N)
histogram incomeDomPc if dateUpdateDom<date("06/01/2014","MDY") ///
& incomeDomPc > 119 & incomeDomPc < 168, width(3.5) start(119.001) play(${Codes}/before_second) ///
title("Second Threshold (Before)") text(.075 158 "`N' obs.") ylabel(0(0.05)0.1) xlabel(140 (14) 154)
graph save ${Graphs}/cadDomRs_secondBefore, replace

graph combine ${Graphs}/cadDomRs_firstBefore.gph ${Graphs}/cadDomRs_secondBefore.gph, col(2)
graph export ${Presentation}/fig_cadDomRs_Before.pdf, replace

count if dateUpdateDom>date("06/01/2014","MDY") & incomeDomPc > 52.5 & incomeDomPc < 98
local N: display %19.0f r(N)
histogram incomeDomPc if dateUpdateDom>date("07/01/2014","MDY") ///
& incomeDomPc > 52.5 & incomeDomPc < 99.75, width(3.5) start(52.501)  play(${Codes}/after_first) ///
title("First Threshold (After)") text(.075 86 "`N' obs.") ylabel(0(0.05)0.1) xlabel(70 (7) 77)
graph save ${Graphs}/cadDomRs_firstAfter, replace 

count if dateUpdateDom>date("06/01/2014","MDY") & incomeDomPc > 119 & incomeDomPc < 168
local N: display %19.0f r(N)
histogram incomeDomPc if dateUpdateDom>date("06/01/2014","MDY") ///
& incomeDomPc > 119 & incomeDomPc < 168, width(3.5) start(119.001) play(${Codes}/after_second) ///
title("Second Threshold (After)") text(.075 158 "`N' obs.") ylabel(0(0.05)0.1) xlabel(140 (14) 154)
graph save ${Graphs}/cadDomRs_secondAfter, replace

graph combine ${Graphs}/cadDomRs_firstAfter.gph ${Graphs}/cadDomRs_secondAfter.gph, col(2)
graph export ${Presentation}/fig_cadDomRs_After.pdf, replace

*graph combine ${Graphs}/cadDomRs_firstBefore.gph ${Graphs}/cadDomRs_secondBefore.gph ${Graphs}/cadDomRs_firstAfter.gph ${Graphs}/cadDomRs_secondAfter.gph, col(2) 
*graph export "${Text}/fig_CadDomRs.png", replace


use ${TreatedData}/cadUnicoDomRs_idHh.dta, clear
merge 1:1 idHh using ${TreatedData}/cadUnicoPesRs_idHh.dta, keepusing(hhSizePes dateUpdatePes incomePes codmun) update
replace codmun = floor(codmun/10)
rename codmun codmunBf
drop _m
merge 1:m idHh using ${TreatedData}/raisRs_hhMonth.dta


use ${TreatedData}/folhaIncomeCompressRs_hhMonth.dta, clear
keep if dateFolha == dateUpdateFolha
gen monthfolhaMdom = int((dateUpdateFolha-dateUpdateDom)/30)
histogram monthfolhaMdom if monthfolhaMdom < 20
sum monthfolhaMdom, detail
tab monthfolhaMdom, m
gen monthfolhaMpes = int((dateUpdateFolha-dateUpdatePes)/30)
histogram monthfolhaMpes if monthfolhaMpes < 20
sum monthfolhaMpes, detail
tab monthfolhaMpes, m

gen incomefolhaMdom = incomeFolha - incomeDom
sum incomefolhaMdom, detail
gen incomefolhaMpes = incomeFolha - incomePes
sum incomefolhaMpes if incomefolhaMdom !=0, detail

browse idHh income* dateUpdate* if incomefolhaMdom != 0

count if dateUpdateFolha > dateUpdateDom & dateUpdateFolha > dateUpdatePes
count if dateUpdateFolha == dateUpdateDom
count if dateUpdateFolha < dateUpdateDom
gen dfmdd = dateUpdateFolha - dateUpdateDom
sum dfmdd if dateUpdateFolha > dateUpdateDom & dateUpdateFolha > dateUpdatePes, detail
histogram dfmdd if dateUpdateFolha > dateUpdateDom & dateUpdateFolha > dateUpdatePes & dfmdd < 800
tab dfmdd if dateUpdateFolha > dateUpdateDom & dateUpdateFolha > dateUpdatePes & dfmdd < 200
tab dfmdd if dfmdd < 200 & dfmdd > -200


gen dfmdp = dateUpdateFolha - dateUpdatePes
sum dfmdp if dateFolha == dateUpdateFolha, detail
browse if dateFolha == dateUpdateFolha

use ${TreatedData}/raisRs_indMonth.dta, clear
use ${TreatedData}/coordinates.dta, clear
bysort codmun: gen dup = _N
tab dup
sum incomeAvg if month == 12 & year == 2014
sum incomeAvg if month != 12 & year == 2014

forvalues i = 2012/2015{
	use "${TreatedData}/folhaIncome`i'_hhMonth.dta", clear
	rename renda_per_capita incomeFolha
	save "${TreatedData}/folhaIncome`i'_hhMonth.dta", replace
}

use ${TreatedData}/folhaIncomeRs_hhMonth.dta, clear
use ${TreatedData}/folhaIncomeRs.dta, clear
bysort idHh year month: gen dup = _N
tab dup, m
edit if dup > 1
drop if dup > 1 /*35,159 observeations (0.17% of the random sample) are duplicated*/
drop dup
isid idHh year month
sort idHh year month
save ${TreatedData}/folhaIncomeRs_hhMonth.dta, replace

isid idHh year month
count if idHh == .
count if year == .
count if month == .
drop dup
bysort idHh year month: gen dup = _N
tab dup, m

use ${TreatedData}/cadUnicoPesRs_idInd.dta, clear
browse idHh aux hhSize if idHh == 4433 

use ${TreatedData}/cadUnicoPesRs_idInd.dta, clear 
unique idHh
count if aux == hhSize
count if idHh == .
count if aux == .

merge m:1 idHh using ${TreatedData}/cadUnicoPesRs_idInd.dta

forvalues i=2012/2015{
	use "${TreatedData}/folhaBenefit`i'RS_idHh.dta", clear
	tostring vigextra, replace
	save "${TreatedData}/folhaBenefit`i'RS_idHh.dta", replace
}
use "${TreatedData}/folhaBenefit2012RS_idHh.dta", clear
d vigextra
use "${TreatedData}/folhaBenefit2013RS_idHh.dta", clear
d vigextra
use "${TreatedData}/folhaBenefit2014RS_idHh.dta", clear
d vigextra
use "${TreatedData}/folhaBenefit2015RS_idHh.dta", clear
d vigextra
count if vigextra != .


use ${TreatedData}/folhaIncomeRs_hhMonth.dta, clear
rename renda_per_capita incomePcFolha
merge m:1 idHh year month using ${TreatedData}/raisRs_hhMonth.dta
tab _merge if year ==2012 & month<10
tab _merge if year <2015 & (year > 2012 | month>=10)
tab _merge if year == 2015
unique idHh if year <2015 & (year > 2012 | month>=10)
unique idHh if _merge == 1 & (year <2015 & (year > 2012 | month>=10))
unique idHh if _merge == 2 & (year <2015 & (year > 2012 | month>=10))
gen onlyRais = (_merge == 2 & (year <2015 & (year > 2012 | month>=10)))
bysort idHh: egen onlyR = total(onlyR)
sort idHh year month
browse idHh year month _merge if onlyR > 0 
browse idHh year month _merge if onlyRais > 0 & year == 2012 & month == 10
sum year month if _merge == 2 & (year <2015 & (year > 2012 | month>=10))
browse idHh year month _merge if  idHh == 29146
*Looking for households only in rais in the entire period
gen hasFolha = (_merge != 2)
bysort idHh: egen hasF = total(hasFolha)
*Looking for hhs in each _merge
tab mFolhaIncomeRais if year == 2012 & month == 10
tab mFolhaIncomeRais if year == 2014 & month == 5
tab mFolhaIncomeRais if year == 2014 & month == 7
tab mFolhaIncomeRais if year == 2014 & month == 11


foreach var in educHeadEx educHead ageHead genderHead partner educPartnerEx educPartner numMembers numAdults numRooms{
count if `var' == .
}
count if numMembers == . | numRooms == .
tab cod_ano_serie_frequentou_memb if cod_curso_frequentou_pessoa_memb == 7, m

gen head = (relative == 1)
bysort idHh: egen headExist = total(head)
gen partner = (relative == 2)
bysort idHh: egen partnerExist = total(partner)
bysort idHh: egen adultsExist = total(adults)
gen educ = (educLevelHighest != .)
bysort idHh: egen educHh = total(educ)
tab educ if headExist == 0
sum age if educ == 0 & headExist == 0, d
sum age if educ == 1 & headExist == 0, d

count if educLevelHighest == . if headExist == 0
tab headE partnerE

use ${TreatedData}/folhaIncomeRs_hhMonth.dta, clear

histogram renda_per_capita if year == 2012 & month ==10 ///
& renda_per_capita > 119 & renda_per_capita < 168, width(1.75) play(${Codes}/before_second) ///
title("(b) Second Threshold (October 2012)") text(.2 110 "`N' obs.") ylabel(0(0.05)0.15)  

histogram renda_per_capita if year == 2014 & month ==7 ///
& renda_per_capita > 119 & renda_per_capita < 168, width(1.75) start(119.1) play(${Codes}/after_second) ///
title("(d) Second Threshold (July 2014)") text(.2 110 "`N' obs.") ylabel(0(0.05)0.15)



histogram renda_per_capita if year == 2012 & month ==10 & renda_per_capita > 2.5 & renda_per_capita <= 200, width(2.5)

"${TreatedData}/folhaIncome_hhMonth.dta"
use "${TreatedData}/folhaIncome2012_hhMonth.dta", clear
forvalues i = 2013(1)2015{
	append using "${TreatedData}/folhaIncome`i'_hhMonth.dta"
}
set seed 17
sample 5
save ${TreatedData}/folhaIncomeRS_hhMonth.dta, replace

browse rf_folha

rename  date rf_folha
rename dateBirthHead data_nasc_rl
rename dateInitialPayment competinicial 
rename datePayment competfolha  

rename datePregnant vigbvg 
rename dateNursingMother vigbvn 
rename date0to15 vigvar 
rename dateYoung vigbvj 
rename dateExtraordinary vigextra 
rename dateBirth dtnascdep
rename dateLastUpdate dt_validade_beneficio
 vigbvj vigextra dtnascdep dt_validade_beneficio
