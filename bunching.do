clear all
set more off
capture log close 
log using "${Logs}/bunching.log", replace

*CadUnico Dom, Pes and RAIS
foreach level in Dom Pes Rais{
	foreach p in raw non{
		forvalues dep=0/2{
			use ${TreatedData}/`level'Rs_060114_`dep'_bin.dta, clear
			if "`p'" == "raw"{
				loc y = "c"
			}
			else if "`p'" == "non"{
				keep if r5 == 0 & r50_3 == 0 & r50_4 == 0 & rMinWage == 0
				drop c3p5 c1
				foreach wd in 3p5 1{
					bysort Ybar`wd': replace order`wd' = _n					
					bysort Ybar`wd': egen c`wd' = total(c)
				}
				loc y = "c"
			}
			foreach bin in bin1 bin3p5{
				if "`bin'" == "bin1"{
					loc reg = "`y'1 Ybar1 if ybar<200 & order1 == 1"
				}
				else if "`bin'" == "bin3p5"{
					loc reg = "`y'3p5 Ybar3p5 if ybar<200 & order3p5 == 1"
				}
				twoway (connected `reg', msize(small)) , ytitle(Number of Applicants, size(small) margin(small)) ///
				xtitle(Reported Income (Reais), size(small)) title(`dep' dep. - 06/01/14 to 04/18/15, size(med) margin(medium)) /// 
				plotregion(color(white)) graphregion(color(white)) legend(off) xlabel( , labsize(small)) ///
				ylabel(, labsize(small)) xline(77, lcolor(red)) xline(154, lcolor(red))
				graph save "${Bunching}/`level'_060114_`p'_`dep'_`bin'.gph", replace
				if ("`level'" == "Dom" | "`level'" == "Rais") & "`p'" == "non" & "`bin'" == "bin3p5" & `dep' != 1{
					graph export "${Presentation}/`level'_060114_`p'_`dep'_`bin'.pdf", replace
				}
			}
		}
	}


	foreach bin in bin1 bin3p5{
		foreach p in raw non{
			graph combine "${Bunching}/`level'_060114_`p'_0_`bin'.gph" "${Bunching}/`level'_060114_`p'_1_`bin'.gph" "${Bunching}/`level'_060114_`p'_2_`bin'.gph"
			graph export "${Bunching}/`level'_`p'_`bin'.pdf", replace
		}
	}
}

*CadUnico Domicilio with formal1 and formalAll
foreach sel in All 1{
	foreach p in raw non{
		forvalues dep=0/2{
			use ${TreatedData}/Dom`sel'Rs_060114_`dep'_bin.dta, clear
			if "`p'" == "raw"{
				loc y = "c"
			}
			else if "`p'" == "non"{
				keep if r5 == 0 & r50_3 == 0 & r50_4 == 0 & rMinWage == 0			
				drop c3p5 c1
				foreach wd in 3p5 1{
					bysort Ybar`wd': replace order`wd' = _n					
					bysort Ybar`wd': egen c`wd' = total(c)
				}
				loc y = "c"
			}
			foreach bin in bin1 bin3p5{
				if "`bin'" == "bin1"{
					loc reg = "`y'1 Ybar1 if ybar<200 & order1 == 1"
				}
				else if "`bin'" == "bin3p5"{
					loc reg = "`y'3p5 Ybar3p5 if ybar<200 & order3p5 == 1"
				}
				twoway (connected `reg', msize(small)) , ytitle(Number of Applicants, size(small) margin(small)) ///
				xtitle(Reported Income (Reais), size(small)) title(`dep' dep. - 06/01/14 to 04/18/15, size(med) margin(medium)) /// 
				plotregion(color(white)) graphregion(color(white)) legend(off) xlabel( , labsize(small)) ///
				ylabel(, labsize(small)) xline(77, lcolor(red)) xline(154, lcolor(red))
				graph save "${Bunching}/Dom`sel'_060114_`p'_`dep'_`bin'.gph", replace
				if ("`sel'" == "1") & "`p'" == "non" & "`bin'" == "bin3p5" & `dep' != 1{
					graph export "${Presentation}/Dom`sel'_060114_`p'_`dep'_`bin'.pdf", replace
				}
			}
		}
	}


	foreach bin in bin1 bin3p5{
		foreach p in raw non{
			graph combine "${Bunching}/Dom`sel'_060114_`p'_0_`bin'.gph" "${Bunching}/Dom`sel'_060114_`p'_1_`bin'.gph" "${Bunching}/Dom`sel'_060114_`p'_2_`bin'.gph"
			graph export "${Bunching}/Dom`sel'_`p'_`bin'.pdf", replace
		}
	}
}

capture log close


