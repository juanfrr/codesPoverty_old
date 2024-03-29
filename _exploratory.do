use ${TreatedData}/cadUnicoPesCompleteRs_raw.dta, clear

gen aux = length(dta_atual_memb)
drop aux
gen dta_atual_memb_s =substr(dta_atual_memb,1,7)
gen dateUpdatePes = date(dta_atual_memb_s, "YM")
label var dateUpdatePes "Update Date for the Individual"
count if dateUpdatePes >= date("Jan2013", "MY")

use ${TreatedData}/folhaBenefit2015RS_idHh.dta, clear
codebook id if rf_folha == "03/2015"
codebook id if rf_folha == "03/2015" & vlrtotal > 0 & vlrtotal <.

/*Checking spikes at RAIS
use ${TreatedData}/raisRs_060114_0_bin.dta, clear
browse if ybar <=182 & ybar >= 180
*dep = 0 is at 181.75

use ${TreatedData}/raisRs_060114_1_bin.dta, clear
browse if ybar <=200 & ybar >= 150 & r1 == 1
browse if ybar <=184 & ybar >= 182
*dep = 1 is at 182.44

use ${TreatedData}/raisRs_060114_2_bin.dta, clear
browse if ybar <=200 & ybar >= 150 & r1 == 1
browse if ybar <=189 & ybar >= 187
*dep = 2 is at 187.87 and 187.33

/*Checking if there is an individual in two hhs
use ${TreatedData}/cadUnicoCompleteRs.dta, clear
bysort idInd: gen dup = _N 
tab dup
unique idHh if dup == 2
browse idHh idInd dta_atua dup cpf if dup > 1
*Verifying individuals from same hh that updated in different dates
use ${TreatedData}/cadUnicoPesRs_idInd.dta, clear

bysort idHh dateUpdatePes: gen nIndDate = _N
bysort idHh : gen nInd = _N
count if nInd == nIndDate
count if nInd != nIndDate

/*Checking incomeRais == 0
use ${TreatedData}/raisCadRs_idHh.dta, clear
keep if date >= date("1Jun2014","DMY") & below15 == 0 & teens == 0
count 
count if incomeRaisPc == .
count if incomeRais == .

bysort incomeRaisPc: gen c = _N
bysort incomeRaisPc: gen aux = _n
keep if c == aux & incomeRaisPc <1000
keep incomeRaisPc c
sort incomeRaisPc
gen aux = 100*(income[_n+1]-income)
replace aux = 1 if aux == .
expand aux, gen(dup)
sort income dup
replace c = 0 if dup == 1
gen ybar = _n/100-0.01
keep c ybar
sort ybar


use ${TreatedData}/raisRs_060114_0_bin.dta, clear
browse
tab c if ybar < 1000
tab 
/*Checking obs with non integer incomeDomPc
*Conclusion: Until the beginning of 2011 the non-round numbers were more frequent.


use ${TreatedData}/cadUnicoDomRs_idHh.dta, clear
count
count if mod(incomeDomPc, 1) != 0
count if incomeDomPc == .
browse if mod(incomeDomPc, 1) != 0
summdate dateUpdate
summdate dateUpdate if mod(incomeDomPc, 1) != 0

count if mod(incomeDomPc, 1) != 0
count
count if mod(incomeDomPc, 1) != 0 & dateUpdate>=date("01Jan2009","DMY") & dateUpdate<date("01Jan2010","DMY")
count if dateUpdate>=date("01Jan2009","DMY") & dateUpdate<date("01Jan2010","DMY")
count if mod(incomeDomPc, 1) != 0 & dateUpdate>=date("01Jan2010","DMY") & dateUpdate<date("01Jan2011","DMY")
count if dateUpdate>=date("01Jan2010","DMY") & dateUpdate<date("01Jan2011","DMY")
count if mod(incomeDomPc, 1) != 0 & dateUpdate>=date("01Jan2011","DMY") & dateUpdate<date("01Jan2012","DMY")
count if dateUpdate>=date("01Jan2011","DMY") & dateUpdate<date("01Jan2012","DMY")

count if mod(incomeDomPc, 1) != 0 & dateUpdate>=date("01Jan2011","DMY") & dateUpdate<date("01Mar2011","DMY")
count if dateUpdate>=date("01Jan2011","DMY") & dateUpdate<date("01Mar2011","DMY")
count if mod(incomeDomPc, 1) != 0 & dateUpdate>=date("01Mar2011","DMY") & dateUpdate<date("01May2011","DMY")
count if dateUpdate>=date("01Mar2011","DMY") & dateUpdate<date("01May2011","DMY")

count if mod(incomeDomPc, 1) != 0 & dateUpdate>=date("01Jan2012","DMY") & dateUpdate<date("01Jan2013","DMY")
count if dateUpdate>=date("01Jan2012","DMY") & dateUpdate<date("01Jan2013","DMY")
count if mod(incomeDomPc, 1) != 0 & dateUpdate>=date("01Jan2013","DMY") & dateUpdate<date("01Jan2014","DMY")
count if dateUpdate>=date("01Jan2013","DMY") & dateUpdate<date("01Jan2014","DMY")
count if mod(incomeDomPc, 1) != 0 & dateUpdate>=date("01Jan2014","DMY") & dateUpdate<date("01Jan2015","DMY")
count if dateUpdate>=date("01Jan2014","DMY") & dateUpdate<date("01Jan2015","DMY")
count if mod(incomeDomPc, 1) != 0 & dateUpdate>=date("01Jan2015","DMY") & dateUpdate<date("01Jan2016","DMY")
count if dateUpdate>=date("01Jan2015","DMY") & dateUpdate<date("01Jan2016","DMY")

/*Check incomeDom and incomePes
use ${TreatedData}/cadDomPesRs_idHh.dta, clear
d income*
count
count if incomeDomPc !=. & incomePesPc != .
gen incomeDomMPes = incomeDomPc -incomePesPc
sum incomeDomMPes, d
histogram incomeDomMPes if incomeDomMPes>-100 & incomeDomMPes < 100
count if incomeDomMPes == 0
count if incomeDomMPes == 50
count if abs(incomeDomMPes) < 1
count if abs(incomeDomMPes) < 10
count if abs(incomeDomMPes) < 50
count if abs(incomeDomMPes) < 51
count if abs(incomeDomMPes) < 100
summdate dateUpdate if abs(incomeDomMPes) < 1
summdate dateUpdate if abs(incomeDomMPes) >= 1 & abs(incomeDomMPes)< .

count if abs(incomeDomMPes) < 1
count if abs(incomeDomMPes) >= 1 & abs(incomeDomMPes)< .
*In general income is coherent for 41.1% of the households
count if per == "02/19/13 to 06/01/14" & abs(incomeDomMPes) < 1
count if per == "02/19/13 to 06/01/14" & abs(incomeDomMPes) >= 1 & abs(incomeDomMPes)< .
*In the second to last period income is coherent for 42.6% of the households
count if per == "06/01/14 to 04/18/15" & abs(incomeDomMPes) < 1
count if per == "06/01/14 to 04/18/15" & abs(incomeDomMPes) >= 1 & abs(incomeDomMPes)< .
*In the last period income is coherent for 42% of the households

tab hhSize if incomeDomMPes == 50
count if hhSizeDom == . & incomeDomMPes == 50

          1 |      5,413       13.18       13.18
          2 |     14,716       35.82       48.99
          3 |      9,544       23.23       72.23
          4 |      7,604       18.51       90.73

tab hhSize 

browse if incomeDomMPes == 50
*Check 



/*use ${TreatedData}/cadUnicoDomRs_021913_0_bin.dta, clear
browse if r1 == 1
use ${TreatedData}/cadUnicoDomRs_021913_2_bin.dta, clear
browse if div3p5 >0 | r1 == 1
gen div3 = 3*(mod(ybar,3)==0)
gen Ybar3 = sum(div3)-1.5
bysort Ybar3: gen ordering = _n
keep if r25 == 0 & r25_3 == 0 & r10 == 0
bysort Ybar3: egen c3 = total(c)
browse ybar div3 Ybar3 c c3 ordering if r1 == 1 
twoway (connected c3 Ybar3 if ybar<200 & ordering == 1, msize(small)) , ///
ytitle(Number of Applicants, size(small) margin(small)) xtitle(Reported Income (Reais), size(small)) ///
title(2 dep. - before, size(med) margin(medium)) plotregion(color(white)) graphregion(color(white)) ///
legend(off) xlabel( , labsize(small)) ylabel(, labsize(small)) xline(70, lcolor(red)) ///
xline(77, lpattern(dash)) xline(140, lcolor(red)) xline(154, lpattern(dash))

use ${TreatedData}/cadUnicoDomRs_idHh.dta, clear
d income*
count
count if mod(income, 1) != 0
count if mod(income, 5) != 0
count if income == .
codebook income if mod(income, 1) != 0 & income <200

/*use ${TreatedData}/cadFolRs_idIndMon.dta, clear
keep if _merge == 3
sort idHh dateFolha datePayment
browse idHh idInd dateFolha datePayment ben* if benDifHh >= 1 & benDifHh < .

use ${TreatedData}/FolhaBenefitsRs_idIndMonth.dta, clear
tab benDifInd
tab benDifHh, m
sort idHh dateFolha datePayment
browse idHh idInd dateFolha datePayment ben* 
/*erase ${TreatedData}/cadFolBenRs_idHhMon.dta
use ${TreatedData}/FolhaBenefitsRs_idIndMonth.dta, clear

/*use ${TreatedData}/cadDomPesRs_idHh.dta, clear

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
