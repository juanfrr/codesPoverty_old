clear all
set more off
capture log close 
log using "${Logs}/rais.log", replace

forvalues i=2012(1)2014{
	
	use ${TreatedData}/raisRs`i'.dta, clear
	keep idHh dataadmissodeclarada msdesligamento vlremunmdianom vlremundezembronom vlltimaremuneraoano cpf municpio
	order cpf municpio dataadmissodeclarada msdesligamento vlremunmdianom vlremundezembronom vlltimaremuneraoano
	rename municpio codmunRais
	rename dataadmissodeclarada dateAdm
	rename msdesligamento monthSep
	rename vlremunmdianom incomeAvg
	rename vlremundezembronom incomeDec
	rename vlltimaremuneraoano incomeLas
	tostring dateAdm, replace
	replace dateAdm = "0" + dateAdm if strlen(dateAdm) == 7
	gen dateAdm1 = date(dateAdm,"DMY")
	gen monthAdm = month(dateAdm1)
	replace monthAdm = 0 if dateAdm1<date("0101`i'","DMY")
		
	foreach var in incomeAvg incomeDec incomeLas{
		replace `var' = subinstr(`var',",",".",.)
		destring `var', replace force
	}
	
	gen id = _n
	expand 12
	recode monthSep (0=13)
	bysort id: gen month = _n
	gen incomeRais = 0 
	replace incomeRais = incomeAvg if month> monthAdm | month< monthSep
	replace incomeRais = incomeLas if month== 12 & incomeLas != .
	gen year = `i'
	tostring month, gen(months)
	tostring year, replace
	gen dates = year + "-" + months
	replace dates = year + "-0" + months if month <10
	gen date = date(dates,"YM")
	drop year month* dates
	save ${TreatedData}/raisRs`i'_indMonth.dta, replace  
	
	collapse (sum) incomeRais (firstnm) codmunRais,  by(idHh date)		
	label var incomeRais "Household Income"
	isid idHh date
	sort idHh date
	save ${TreatedData}/raisRs`i'_hhMonth.dta, replace
}

forvalues i=2012(1)2013{
	append using ${TreatedData}/raisRs`i'_hhMonth.dta
}
sort idHh date
format date %tdCCYY.NN.DD
save ${TreatedData}/raisRs_hhMonth.dta, replace

use ${TreatedData}/raisRs2012_indMonth.dta, clear
forvalues i=2013(1)2014{
	append using ${TreatedData}/raisRs`i'_indMonth.dta
}
format date dateAdm1 %tdCCYY.NN.DD
sort idHh cpf date
save ${TreatedData}/raisRs_indMonth.dta, replace

collapse (sum) incomeRais (firstnm) codmunRais,  by(cpf date)
label var incomeRais "Individual Income"
isid cpf date
sort cpf date
save ${TreatedData}/raisRs_cpfMonth.dta, replace
	
capture log close

