clear all
set more off
capture log close 
log using "${Logs}/bunching.log", replace

foreach date in 021913 060114{
	if `date' == 021913{
		loc t1 = 70
		loc t2 = 140
		loc taux1 = 77
		loc taux2 = 154
		loc per = "02/19/13 to 06/01/14"
	}
	else if `date' == 060114{
		loc t1 = 77
		loc t2 = 154
		loc taux1 = 70
		loc taux2 = 140
		loc per = "06/01/14 to 04/18/15"
	}
	foreach p in raw res non non_div{
		forvalues i=0/2{
			use ${TreatedData}/cadUnicoDomRs_`date'_`i'_bin.dta, clear
			if "`p'" == "raw"{
				loc y = "c"
			}
			else if "`p'" == "res"{
				reg c r*
				predict double res if ybar<200, residuals
				loc y = "res"
				bysort Ybar3p5: egen res3p5 = total(res)
				bysort Ybar3p5: replace ordering = _n
			}
			else if "`p'" == "non"{
				keep if r5 == 0
				bysort Ybar3p5: replace ordering = _n
				drop c3p5
				bysort Ybar3p5: egen c3p5 = total(c)
				loc y = "c"
			}
			else if "`p'" == "non_div"{
				keep if r5 == 0 & r10 == 0 & r25 == 0 & r25_3 == 0 & r50_4 == 0 & rMin == 0
				bysort Ybar3p5: replace ordering = _n
				drop c3p5
				bysort Ybar3p5: egen c3p5 = total(c)
				loc y = "c"				
			}
			foreach bin in bin1 bin3p5{
				if "`bin'" == "bin1"{
					loc reg = "`y' ybar if ybar<200 & r1 == 1"
				}
				else if "`bin'" == "bin3p5"{
					loc reg = "`y'3p5 Ybar3p5 if ybar<200 & ordering == 1"
				}
				twoway (connected `reg', msize(small)) , ytitle(Number of Applicants, size(small) margin(small)) ///
				xtitle(Reported Income (Reais), size(small)) title(`i' dep. - `per', size(med) margin(medium)) /// 
				plotregion(color(white)) graphregion(color(white)) legend(off) xlabel( , labsize(small)) ///
				ylabel(, labsize(small)) xline(`t1', lcolor(red)) xline(`t2', lcolor(red))  xline(`taux1', lpattern(dash)) xline(`taux2', lpattern(dash))
				graph save "${Graphs}/bunching_`date'_`p'_`i'_`bin'.gph", replace
			}
		}
	}
}

foreach bin in bin1 bin3p5{
	foreach p in raw res non non_div{
		graph combine "${Graphs}/bunching_021913_`p'_0_`bin'.gph" "${Graphs}/bunching_021913_`p'_1_`bin'.gph" "${Graphs}/bunching_021913_`p'_2_`bin'.gph" ///
		"${Graphs}/bunching_060114_`p'_0_`bin'.gph" "${Graphs}/bunching_060114_`p'_1_`bin'.gph" "${Graphs}/bunching_060114_`p'_2_`bin'.gph"
		graph export "${Text}/bunching_`p'_`bin'.pdf", replace
	}
}
capture log close
