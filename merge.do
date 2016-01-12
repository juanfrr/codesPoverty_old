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
replace period = "04/01/11 to 06/02/11" if dateUpdate>date("01Apr2011","DMY") & dateUpdate<date("2Jun2011","DMY")
replace period = "06/02/11 to 06/18/12" if dateUpdate>date("2Jun2011","DMY") & dateUpdate<date("18Jun2012","DMY")
replace period = "06/18/12 to 11/30/12" if dateUpdate>date("18Jun2012","DMY") & dateUpdate<date("30Nov2012","DMY") /*Only one in which below6 matters*/
replace period = "11/30/12 to 02/19/13" if dateUpdate>date("30Nov2012","DMY") & dateUpdate<date("19Feb2013","DMY")
replace period = "02/19/13 to 06/01/14" if dateUpdate>date("19Feb2013","DMY") & dateUpdate<date("1Jun2014","DMY")
replace period = "06/01/14 to 04/18/15" if dateUpdate>date("1Jun2014","DMY") & dateUpdate<date("18Apr2015","DMY")
gen dependents = below15
replace dependents = 5 if below15 > = 5
tostring dependents, replace
replace depedents = "5+" if dependents == "5"
gen teen = teens
replace teen = 2 if teens >= 2
tostring teen, replace
replace teen = "2+" if teen == "2"
save ${TreatedData}/cadDomPesRs_idHh.dta, replace

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



