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
rename _merge mcadDomPes
gen hhSize = hhSizeDom
replace hhSize = hhSizePes if hhSize == .
gen incomePesPc = incomePes/hhSize
gen dateUpdate = dateUpdateDom
replace dateUpdate = dateUpdatePes if dateUpdateDom == .
gen period = "07/30/09 to 04/01/11" if dateUpdate>=date("30Jul2009","DMY") & dateUpdate<date("01Apr2011","DMY")
replace period = "04/01/11 to 06/02/11" if dateUpdate>=date("01Apr2011","DMY") & dateUpdate<date("2Jun2011","DMY")
replace period = "06/02/11 to 06/18/12" if dateUpdate>=date("2Jun2011","DMY") & dateUpdate<date("18Jun2012","DMY")
replace period = "06/18/12 to 11/30/12" if dateUpdate>=date("18Jun2012","DMY") & dateUpdate<date("30Nov2012","DMY") /*Only one in which below6 matters*/
replace period = "11/30/12 to 02/19/13" if dateUpdate>=date("30Nov2012","DMY") & dateUpdate<date("19Feb2013","DMY")
replace period = "02/19/13 to 06/01/14" if dateUpdate>=date("19Feb2013","DMY") & dateUpdate<date("1Jun2014","DMY")
replace period = "06/01/14 to 04/18/15" if dateUpdate>=date("1Jun2014","DMY") & dateUpdate<date("18Apr2015","DMY")
format date* %tdCCYY.NN.DD

save ${TreatedData}/cadDomPesRs_idHh.dta, replace

*Creating bunching samples
forvalues i = 1/2{
	if `i' == 1{
		loc perText = "02/19/13 to 06/01/14"
		loc date = "021913"
	}
	else if `i' == 2{
		loc perText = "06/01/14 to 04/18/15"
		loc date = "060114"	
	}
	forvalues j=0/2{
		use ${TreatedData}/cadDomPesRs_idHh.dta, clear
		keep if per == "`perText'" & below15 == `j' & teens == 0
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
		sort ybar
		gen div3p5 = 3.5*(mod(ybar,3.5)==0)
		gen Ybar3p5 = sum(div3)-1.75
		replace Ybar3p5 = Ybar3p5-3.5 if div3p5 == 3.5
		replace Ybar3p5 = 0 if ybar == 0
		bysort Ybar3p5: gen ordering = _n
		bysort Ybar3p5: egen c3p5 = total(c)
		forvalues k = 2/5{
			gen ybar`k' = ybar^`k'
		}
		gen r1 = (mod(ybar,1) == 0)
		gen r5 = (mod(ybar,5) == 0)
		gen r10 = (mod(ybar,10) == 0)
		gen r25 = (mod(ybar,25) == 0)
		gen r50 = (mod(ybar,50) == 0)
		gen r100 = (mod(ybar,100) == 0)
		gen r25_3 = (ybar == 8 | ybar == 16 | ybar == 33 | ybar == 41 | ybar == 58 | ybar == 66 | ybar == 83 | ybar == 91 | ybar == 108 | ybar == 116 | ybar == 133 | ybar == 141 | ybar == 158 | ybar == 166 | ybar == 183 | ybar == 191)
		gen r50_4 = (ybar == 12 | ybar == 37 | ybar == 62 | ybar == 87 | ybar == 112 | ybar == 137 | ybar == 162 | ybar == 187)
		if `i' == 1{
			gen rMinWage = (ybar == 678 | ybar ==  339 | ybar ==  226 | ybar ==  169 | ybar ==  170 | ybar ==  724 | ybar ==  362 | ybar ==  241 | ybar ==  181)
		}
		else if `i' == 2{
			gen rMinWage = (ybar == 724 | ybar ==  362 | ybar ==  241 | ybar ==  181 | ybar ==  788 | ybar ==  394 | ybar ==  262.67 | ybar ==  197)
		}
		save ${TreatedData}/cadUnicoDomRs_`date'_`j'_bin.dta, replace
	}
}

*Random Sample Including FolhaIncome and CadUnicoIdHh (check date of Updates in Folha)
use ${TreatedData}/cadDomPesRs_idHh.dta, clear
merge 1:m idHh using ${TreatedData}/folhaIncomeCompressRs_hhMonth.dta, keepusing(dateFolha incomeFolhaPc)
rename _merge mcadFolInc
sort dateFolha
bysort idHh: gen last = (_n==_N)
gen monthfolhaMdom = int((dateFolha-dateUpdateDom)/30)
gen monthfolhaMpes = int((dateFolha-dateUpdatePes)/30)
gen incomefolhaMdom = incomeFolha - incomeDom
gen incomefolhaMpes = incomeFolha - incomePes
save ${TreatedData}/cadFolIncRs_idHhMon.dta, replace

*Random Sample Including Benefits and CadUnico idInd (check definition of dependents)
use ${TreatedData}/cadUnicoPesRs_idInd.dta, clear
merge 1:m idInd using ${TreatedData}/FolhaBenefitsRs_idIndMonth.dta, keepusing(idInd dateFolha datePayment eligible* status* benefit*)
keep if dateUpdatePes <= dateFolha

save ${TreatedData}/cadFolRs_idIndMon.dta, replace

capture log close
