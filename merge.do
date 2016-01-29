clear all
set more off
capture log close 
log using "${Logs}/merge.log", replace

*Random Sample to describe selection
use ${TreatedData}/cadUnicoPesRs_idInd.dta, clear
keep if date >= date("01/01/2012","MDY") & date < date("01/01/2015","MDY")
merge m:1 cpf date using ${TreatedData}/raisRs_cpfMonth.dta
drop if _m == 2 
gen formal = (_m == 3)
rename _m mPesRais
save ${TreatedData}/cadRaisRs_cpfMonth.dta, replace

*Random Sample to describe selection for RAIS, histograms and bunching
bysort idHh (incomeRais): gen allmissing = mi(incomeRais[1])
collapse (sum) formal workingAge incomeRais below15 teens incomePes (mean) hhSize codmunRais (min) allmissing, by (idHh date) 
replace incomeRais = . if allmissing
drop allmissing
isid idHh
merge 1:1 idHh using  ${TreatedData}/cadUnicoDomRs_idHh.dta, keepusing(hhSizeDom dateUpdateDom incomeDomPc codmun)
rename _m mPesRaisDom
isid idHh
save ${TreatedData}/raisCadRs_idHh.dta, replace

*Random Sample for Cadunico Pessoa e Domicilio (for Household Composition and Check income)
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
