clear all
set more off
capture log close 
log using "${Logs}/hhComposition.log", replace

use ${TreatedData}/cadDomPesRs_idHh.dta, clear

file open Table using "${Text}/tab_hhComp.tex", write replace

local periods = `" "07/30/09 to 04/01/11" "04/01/11 to 06/02/11" "06/02/11 to 06/18/12" "06/18/12 to 11/30/12" "11/30/12 to 02/19/13" "02/19/13 to 06/01/14" "06/01/14 to 04/18/15" "'
local i = 0
foreach per in periods{
	loc i = `i'+1
	loc t = "02/19/13 to 06/01/14"
	count if period == "02/19/13 to 06/01/14"
	loc total1 = r(N)
	forvalues i = 0(1)4{
		count if period == "02/19/13 to 06/01/14" & below15 == `i'
		loc c1`i' = r(N)
		local p1`i': display %9.1f 100*`c1`i''/`total1'
	}
	count if period == "02/19/13 to 06/01/14" & below15 >= 5
	loc c15 = r(N)
	local p15: display %9.1f 100*`c15'/`total1'
}

file write Table "\begin{tabular}{crrrrrrr}" _n
file write Table "\toprule" _n
file write Table "Period \textbackslash{}Dependents & 0 & 1 & 2 & 3 & 4 & 5+ & Total \\" _n
file write Table "\midrule" _n
file write Table "`t1' & `c10' & `c11' & `c12' & `c13' & `c14' & `c15' & `total1' \\" _n
file write Table " & (`p10'\%) & (`p11'\%) & (`p12'\%) & (`p13'\%) & (`p14'\%) & (`p15'\%) & (100\%)\\" _n
file write Table "\bottomrule" _n
file write Table "\end{tabular}" _n
file close Table

capture log close
