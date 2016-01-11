clear all
set more off
capture log close 
log using "${Logs}/merge.log", replace

*Random Sample for Rais histograms
use ${TreatedData}/raisRs_hhMonth.dta, clear
sort idHh
merge m:1 idHh using ${TreatedData}/cadUnicoDomRs_idHh.dta, keepusing(hhSizeDom dateUpdateDom incomeDomPc codmun)
/*No obs just in folhaRais because rais is a subset cadUnicoPes*/ 
rename _m mRaisDom
merge m:1 idHh using ${TreatedData}/cadUnicoPesRs_idHh.dta, keepusing(hhSizePes dateUpdatePes incomePes codmun) update
/*No obs just in cadUnicoPes (apparently a subset of cadUnicoDom, but almost the same)*/
rename _m mRaisDomPes
save ${TreatedData}/raisCadRs_hhMonth.dta, replace
keep if (date == dateUpdateDom | date == dateUpdatePes) & date != . 
unique idHh
bysort idHh: gen dup = _N
tab dup
drop if date == dateUpdatePes & dup == 2
drop dup
count
isid idHh date
sort idHh date
save ${TreatedData}/raisCadRs_hh.dta, replace

*Random Sample for Cadunico Pessoa e Domicilio
use ${TreatedData}/cadUnicoDomRs_idHh.dta, clear
merge 1:1 idHh using ${TreatedData}/cadUnicoPesRs_idHh.dta, keepusing(hhSizePes below6 below15 teens adults dateUpdatePes incomePes codmun) update
save ${TreatedData}/cadDomPesRs_idHh.dta, replace

*Samples for bunching estimates
use ${TreatedData}/cadDomPesRs_idHh.dta, clear
keep if date == & hhSize == & child == & 
bysort incomeDomPc: gen c = _N
bysort incomeDomPc: gen aux = _n
keep if c == aux & incomeDomPc <1000
keep incomeDomPc c
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

save ${TreatedData}/cadUnicoDomRs_bin.dta, replace
capture log close 

*Not using from here on yet..
/*
*For checks across cadunico and folha (incomplete)
use ${TreatedData}/folhaIncomeRs_hhMonth.dta, clear
bysort idHh: gen aux = _n
bysort idHh: gen update = (incomeFolha == incomeFolha[_n-1])
keep if aux == 1 | update == 0
drop aux update
sort idHh dateFolha
bysort idHh: egen dateUpdateFolha = max(dateFolha)
merge m:1 idHh using ${TreatedData}/cadUnicoDomRs_idHh.dta, keepusing(dateUpdateDom incomeDomPc hhSizeDom)
drop _m
merge m:1 idHh using ${TreatedData}/cadUnicoPesRs_idHh.dta, keepusing(dateUpdatePes incomePes hhSizePes)
drop _m
rename dateFolha date
format date %td
merge 1:1 idHh date using ${TreatedData}/raisRs_hhMonth.dta
unique idHh if _m == 3
unique idHh 
/*Note that 316,627 out of the 859,636 of the households (36.8%) are in both datasets*/
drop if _m == 2
drop _m
save ${TreatedData}/folhaIncomeRaisCompressRs_hhMonth.dta, replace
rename incomeFolha incomeAvg
collapse incomeAvg, by(idHh)
sort idHh
merge 1:1 idHh using ${TreatedData}/cadUnicoDomRs_idHh.dta /*21,798 out of 859,636(2.54%) of the Folha obs are not in CadunicoDom*/
/*No obs just in cadUnicoDom because cadUnicoDom is a subset folha*/
gen cadDomEx = (_m>1)
drop _m
merge 1:1 idHh using ${TreatedData}/cadUnicoPesRs_idHh.dta /* 14 out of 2,856,030 (0%) of the Folha with CadUnicoDom obs are not in Cadunico*/
/*No obs just in cadUnicoPes because cadUnicoPes is a subset folha*/
gen cadIndEx = (_m>1)
drop _m
isid idHh
sort idHh
save ${TreatedData}/intrinsicOccupationRs_idHh.dta, replace

*Random Sample for regressions

use ${TreatedData}/folhaIncomeRs_hhMonth.dta, clear
merge m:1 idHh using ${TreatedData}/cadUnicoPesRs_idHh.dta, keepusing(hhSizePes dateUpdatePes)
rename _merge mFolhahhSizePes
expand hhSizePes
bysort idHh year month: gen aux = _n
sort idHh aux 
merge m:1 idHh aux using ${TreatedData}/cadUnicoPesRs_idInd.dta, keepusing(idInd dateBirth)
rename _m mfolhaCadPes
merge m:1 idHh using ${TreatedData}/cadUnicoDomRs_idHh.dta, keepusing(hhSizeDom dateUpdateDom)
rename _m mCadDom
sort idHh year month aux
save ${TreatedData}/regressionsRs.dta, replace
drop if year == .
gen hhSize = hhSizeDom
replace hhSize = hhSizePes if hhSize == . | hhSize == 0
isid idHh year month aux
sort idHh year month aux
save ${TreatedData}/regressionsRs_AuxIndMonth.dta, replace


