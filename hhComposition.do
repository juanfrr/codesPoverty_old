clear all
set more off
capture log close 
log using "${Logs}/hhComposition.log", replace

*Table for all households
use ${TreatedData}/cadDomPesRs_idHh.dta, clear
drop if teens == . | below15 == . | below6 == . | per == "" 
file open Table using "${Text}/tab_hhComp.tex", write replace

file write Table "\begin{tabular}{crrrrrr|r}" _n
file write Table "\toprule" _n
file write Table "Period \textbackslash{}Dependents & 0 & 1 & 2 & 3 & 4 & 5+ & Total \\" _n
file write Table "\midrule" _n
forvalues i = 1/7{
	if `i' == 1{
		loc per = "07/30/09 to 04/01/11"
	}	
	else if `i' == 2{
		loc per = "04/01/11 to 06/02/11" 
	}
	else if `i' == 3{
		loc per = "06/02/11 to 06/18/12" 
	}
	else if `i' == 4{
		loc per = "06/18/12 to 11/30/12" 
	}
	else if `i' == 5{
		loc per = "11/30/12 to 02/19/13" 
	}
	else if `i' == 6{
		loc per = "02/19/13 to 06/01/14" 
	}
	else if `i' == 7{
		loc per = "06/01/14 to 04/18/15"
	}
	loc t`i' = "`per'"
	count 
	loc total = r(N)
	count if period == "`per'"
	loc totalp`i' = r(N)
	forvalues j = 0(1)4{
		count if period == "`per'" & below15 == `j'
		loc c`i'`j' = r(N)
		local p`i'`j': display %9.1f 100*`c`i'`j''/`total'
		count if below15 == `j'
		loc totald`j' = r(N)
		loc pd`j': display %9.1f 100*`totald`j''/`total'
	}
	count if period == "`per'" & below15 >= 5
	loc c`i'5 = r(N)
	local p`i'5: display %9.1f 100*`c`i'5'/`total'
	local pp`i': display %9.1f 100*`totalp`i''/`total'
	count if below15 >= 5
	loc totald5 = r(N)
	loc pd5: display %9.1f 100*`totald5'/`total'
	file write Table "`t`i'' & `c`i'0' & `c`i'1' & `c`i'2' & `c`i'3' & `c`i'4' & `c`i'5' & `totalp`i'' \\" _n
	file write Table " & (`p`i'0'\%) & (`p`i'1'\%) & (`p`i'2'\%) & (`p`i'3'\%) & (`p`i'4'\%) & (`p`i'5'\%) & (`pp`i''\%)\\" _n
}
file write Table "\midrule" _n
file write Table "Total & `totald0' & `totald1' & `totald2' & `totald3' & `totald4' & `totald5' & `total' \\" _n
file write Table " & (`pd0'\%) & (`pd1'\%) & (`pd2'\%) & (`pd3'\%) & (`pd4'\%) & (`pd5'\%) & (100\%)\\" _n

file write Table "\bottomrule" _n
file write Table "\end{tabular}" _n
file close Table

*Table for composition in terms of infants and teens
file open Table using "${Text}/tab_hhComp_ti.tex", write replace

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

*Table for households with 0 teens in the last 2 periods and with 0,1 or 2 dependents
use ${TreatedData}/cadDomPesRs_idHh.dta, clear
drop if below6 == . | teens > 0 | below15 > 2 | per == "" 
keep if per == "02/19/13 to 06/01/14" | per == "06/01/14 to 04/18/15"
file open Table using "${Text}/tab_hhComp_t0.tex", write replace

file write Table "\begin{tabular}{crrr|r}" _n
file write Table "\toprule" _n
file write Table "Period \textbackslash{}Dependents & 0 & 1 & 2 & Total \\" _n
file write Table "\midrule" _n
forvalues i = 1/2{

	if `i' == 1{
		loc per = "02/19/13 to 06/01/14" 
	}
	else if `i' == 2{
		loc per = "06/01/14 to 04/18/15"
	}
	loc t`i' = "`per'"
	count 
	loc total = r(N)
	count if period == "`per'"
	loc totalp`i' = r(N)
	forvalues j = 0(1)2{
		count if period == "`per'" & below15 == `j'
		loc c`i'`j' = r(N)
		local p`i'`j': display %9.1f 100*`c`i'`j''/`total'
		count if below15 == `j'
		loc totald`j' = r(N)
		loc pd`j': display %9.1f 100*`totald`j''/`total'
	}
	local pp`i': display %9.1f 100*`totalp`i''/`total'
	count if below15 >= 5
	loc totald5 = r(N)
	loc pd5: display %9.1f 100*`totald5'/`total'
	file write Table "`t`i'' & `c`i'0' & `c`i'1' & `c`i'2' & `totalp`i'' \\" _n
	file write Table " & (`p`i'0'\%) & (`p`i'1'\%) & (`p`i'2'\%) & (`pp`i''\%)\\" _n
}
file write Table "\midrule" _n
file write Table "Total & `totald0' & `totald1' & `totald2' & `total' \\" _n
file write Table " & (`pd0'\%) & (`pd1'\%) & (`pd2'\%) & (100\%)\\" _n

file write Table "\bottomrule" _n
file write Table "\end{tabular}" _n
file close Table

*Table for all households with k teens and l infants
forvalues k = 0/2{
	use ${TreatedData}/cadDomPesRs_idHh.dta, clear
	drop if teens == . | below15 == . | below6 == .  | per == ""
	if `k' == 2{
		keep if teens >= `k'
	}
	else{
		keep if teens == `k'
	}
	save ${TreatedData}/cadDomPesRs_idHh_`k'.dta, replace
	forvalues l =0/1{
		use ${TreatedData}/cadDomPesRs_idHh_`k'.dta, clear
		if `l' == 1{
			keep if below6 >= `l'
		}
		else{
			keep if below6 == `l'
		}

		file open Table using "${Text}/tab_hhComp_t`k'i`l'.tex", write replace

		file write Table "\begin{tabular}{crrrrrr|r}" _n
		file write Table "\toprule" _n
		file write Table "Period \textbackslash{}Dependents & 0 & 1 & 2 & 3 & 4 & 5+ & Total \\" _n
		file write Table "\midrule" _n
		forvalues i = 1/7{
			if `i' == 1{
				loc per = "07/30/09 to 04/01/11"
			}	
			else if `i' == 2{
				loc per = "04/01/11 to 06/02/11" 
			}
			else if `i' == 3{
				loc per = "06/02/11 to 06/18/12" 
			}
			else if `i' == 4{
				loc per = "06/18/12 to 11/30/12" 
			}
			else if `i' == 5{
				loc per = "11/30/12 to 02/19/13" 
			}
			else if `i' == 6{
				loc per = "02/19/13 to 06/01/14" 
			}
			else if `i' == 7{
				loc per = "06/01/14 to 04/18/15"
			}
			loc t`i' = "`per'"
			count 
			loc total = r(N)
			count if period == "`per'"
			loc totalp`i' = r(N)
			forvalues j = 0(1)4{
				count if period == "`per'" & below15 == `j'
				loc c`i'`j' = r(N)
				local p`i'`j': display %9.1f 100*`c`i'`j''/`total'
				count if below15 == `j'
				loc totald`j' = r(N)
				loc pd`j': display %9.1f 100*`totald`j''/`total'
			}
			count if period == "`per'" & below15 >= 5
			loc c`i'5 = r(N)
			local p`i'5: display %9.1f 100*`c`i'5'/`total'
			local pp`i': display %9.1f 100*`totalp`i''/`total'
			count if below15 >= 5
			loc totald5 = r(N)
			loc pd5: display %9.1f 100*`totald5'/`total'
			file write Table "`t`i'' & `c`i'0' & `c`i'1' & `c`i'2' & `c`i'3' & `c`i'4' & `c`i'5' & `totalp`i'' \\" _n
			file write Table " & (`p`i'0'\%) & (`p`i'1'\%) & (`p`i'2'\%) & (`p`i'3'\%) & (`p`i'4'\%) & (`p`i'5'\%) & (`pp`i''\%)\\" _n
		}
		file write Table "\midrule" _n
		file write Table "Total & `totald0' & `totald1' & `totald2' & `totald3' & `totald4' & `totald5' & `total' \\" _n
		file write Table " & (`pd0'\%) & (`pd1'\%) & (`pd2'\%) & (`pd3'\%) & (`pd4'\%) & (`pd5'\%) & (100\%)\\" _n

		file write Table "\bottomrule" _n
		file write Table "\end{tabular}" _n
		file close Table

	}
	erase ${TreatedData}/cadDomPesRs_idHh_`k'.dta
}

capture log close
