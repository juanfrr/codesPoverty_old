clear all
set more off
capture log close 
log using "${Logs}/hhComposition.log", replace

*Table for all households
use ${TreatedData}/cadDomPesRs_idHh.dta, clear
keep if per == "06/01/14 to 04/18/15"
drop if teens == . | below15 == . | below6 == . | hhSize == . | teens > 0
file open Table using "${Text}/tab_hhComp.tex", write replace

file write Table "\begin{tabular}{crrrr|r}" _n
file write Table "\toprule" _n
file write Table "Members \textbackslash{}Dependents & 0 & 1 & 2 & 3+ & Total \\" _n
file write Table "\midrule" _n
forvalues i = 1/6{
	count 
	loc total = r(N)
	count if hhSize == `i'
	loc totalp`i' = r(N)
	forvalues j = 0(1)2{
		count if hhSize == `i' & below15 == `j'
		loc c`i'`j' = r(N)
		local p`i'`j': display %9.1f 100*`c`i'`j''/`total'
		count if below15 == `j'
		loc totald`j' = r(N)
		loc pd`j': display %9.1f 100*`totald`j''/`total'
	}
	count if hhSize == `i' & below15 >= 3
	loc c`i'3 = r(N)
	local p`i'3: display %9.1f 100*`c`i'3'/`total'
	local pp`i': display %9.1f 100*`totalp`i''/`total'
	count if below15 >= 3
	loc totald3 = r(N)
	loc pd3: display %9.1f 100*`totald3'/`total'
	file write Table "`i' & `c`i'0' & `c`i'1' & `c`i'2' & `c`i'3' & `totalp`i'' \\" _n
	file write Table " & (`p`i'0'\%) & (`p`i'1'\%) & (`p`i'2'\%) & (`p`i'3'\%) & (`pp`i''\%)\\" _n
}
count if hhSize > 6
loc totalp7 = r(N)
forvalues j = 0(1)2{
	count if hhSize > 6 & below15 == `j'
	loc c7`j' = r(N)
	local p7`j': display %9.1f 100*`c7`j''/`total'
}
count if hhSize == 7 & below15 >= 3
loc c73 = r(N)
local p73: display %9.1f 100*`c73'/`total'
local pp7: display %9.1f 100*`totalp7'/`total'
count if below15 >= 3
loc totald3 = r(N)
loc pd3: display %9.1f 100*`totald3'/`total'
file write Table "7 & `c70' & `c71' & `c72' & `c73' & `totalp7' \\" _n
file write Table " & (`p70'\%) & (`p71'\%) & (`p72'\%) & (`p73'\%) & (`pp7'\%)\\" _n
	
file write Table "\midrule" _n
file write Table "Total & `totald0' & `totald1' & `totald2' & `totald3' & `total' \\" _n
file write Table " & (`pd0'\%) & (`pd1'\%) & (`pd2'\%) & (`pd3'\%) & (100\%)\\" _n

file write Table "\bottomrule" _n
file write Table "\end{tabular}" _n
file close Table

*Table for composition in terms of infants and teens
file open Table using "${Text}/tab_hhComp_ti.tex", write replace
use ${TreatedData}/cadDomPesRs_idHh.dta, clear
keep if per == "06/01/14 to 04/18/15"
drop if teens == . | below15 == . | below6 == . | hhSize == .

file write Table "\begin{tabular}{crrr|r}" _n
file write Table "\toprule" _n
file write Table "Infants \textbackslash{}Teens & 0 & 1 & 2+ & Total \\" _n
file write Table "\midrule" _n

count 
loc total = r(N)
count if below6 == 0 & teens == 0
loc c11 = r(N)
loc p11: display %9.1f 100*(`c11'/`total')
count if below6 == 0 & teens == 1
loc c12 = r(N)
loc p12: display %9.1f 100*(`c12'/`total')
count if below6 == 0 & teens >= 2
loc c13 = r(N)
count if below6 == 0
loc p13: display %9.1f 100*(`c13'/`total')
loc i1 = r(N)
loc pi1: display %9.1f 100*(`i1'/`total')
file write Table "0 & `c11' & `c12' & `c13' & `i1' \\" _n
file write Table " & (`p11'\%) & (`p12'\%) & (`p13'\%) & (`pi1'\%)\\" _n

count if below6 > 0 & teens == 0
loc c21 = r(N)
loc p21: display %9.1f 100*(`c21'/`total')
count if below6 > 0 & teens == 1
loc c22 = r(N)
loc p22: display %9.1f 100*(`c22'/`total')
count if below6 > 0 & teens >= 2
loc c23 = r(N)
loc p23: display %9.1f 100*(`c23'/`total')
count if below6 > 0
loc i2 = r(N)
loc pi2: display %9.1f 100*(`i2'/`total')
file write Table "1+ & `c21' & `c22' & `c23' & `i2' \\" _n
file write Table " & (`p21'\%) & (`p22'\%) & (`p23'\%) & (`pi2'\%)\\" _n
file write Table "\midrule" _n

count if teens == 0
loc t1 = r(N)
loc pt1: display %9.1f 100*(`t1'/`total')
count if teens == 1
loc t2 = r(N)
loc pt2: display %9.1f 100*(`t2'/`total')
count if teens >= 2
loc t3 = r(N)
loc pt3: display %9.1f 100*(`t3'/`total')
file write Table "Total & `t1' & `t2' & `t3' & `total' \\" _n
file write Table " & (`pt1'\%) & (`pt2'\%) & (`pt3'\%) & (100\%)\\" _n

file write Table "\bottomrule" _n
file write Table "\end{tabular}" _n
file close Table

capture log close
