clear all
set more off
capture log close 
log using "${Logs}/selection.log", replace

/*Goal: Tab merge of Cadunico and Rais
Conclusions: */

use ${TreatedData}/cadRaisRs_cpfMonth.dta, clear
keep if date >= date("01/01/2012","MDY") & date < date("01/01/2015","MDY")
file open Table using "${Text}/tab_selection.tex", write replace

count if formal == 0
loc c11 = r(N)
count if formal == 1
loc c12 = r(N)

use ${TreatedData}/raisCadCompleteRs_idHh.dta, clear
keep if dateUpdateDom >= date("01/01/2012","MDY") & dateUpdateDom < date("01/01/2015","MDY")
count if formal1 == 0
loc c21 = r(N)
count if formal1 == 1
loc c22 = r(N)

count if formalAll == 0
loc c31 = r(N)
count if formalAll == 1
loc c32 = r(N)

forvalues i = 1/3{
	loc total`i' = `c`i'1'+`c`i'2'
	forvalues j = 1/2{
		local p`i'`j': display %9.1f 100*`c`i'`j''/`total`i''
	}
}

file write Table "\begin{tabular}{crr|r}" _n
file write Table "\toprule" _n
file write Table " & Only BF & Formal Empl. & Total \\" _n
file write Table "\midrule" _n

forvalues i = 1/3{
	if `i' == 1{
		loc lab = "Individuals"
	}
	else if `i' == 2{
		loc lab = "Hhs (1 formal empl)"
	}
	else if `i' == 3{
		loc lab = "Hhs (All formal empl)"
	}
	file write Table "`lab' & `c`i'1' & `c`i'2' & `total`i'' \\" _n
	file write Table " & (`p`i'1'\%) & (`p`i'2'\%) & (100\%) \\" _n
}

*bysort idHh: egen nAdults = total(numAdults)
file write Table "\bottomrule" _n
file write Table "\end{tabular}" _n
file close Table

capture log close 
