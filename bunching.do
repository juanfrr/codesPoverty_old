clear all
set more off
capture log close 
log using "${Logs}/bunching.log", replace

*CadUnico Dom, Pes and RAIS
foreach level in Dom Pes Rais{
	foreach p in raw res non non_div{
		forvalues dep=0/2{
			use ${TreatedData}/`level'Rs_060114_`dep'_bin.dta, clear
			if "`p'" == "raw"{
				loc y = "c"
			}
			else if "`p'" == "res"{
				reg c r*
				predict double res if ybar<200, residuals
				loc y = "res"
				foreach wd in 3p5 1{
					bysort Ybar`wd': egen res`wd' = total(res)
					bysort Ybar`wd': replace order`wd' = _n
				}	
			}
			else if "`p'" == "non"{
				keep if r5 == 0
				drop c3p5 c1
				foreach wd in 3p5 1{
					bysort Ybar`wd': replace order`wd' = _n					
					bysort Ybar`wd': egen c`wd' = total(c)
				}
				loc y = "c"
			}
			else if "`p'" == "non_div"{
				keep if r5 == 0 & r10 == 0 & r25 == 0 & r25_3 == 0 & r50_4 == 0 & rMin == 0
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
			}
		}
	}


	foreach bin in bin1 bin3p5{
		foreach p in raw res non non_div{
			graph combine "${Bunching}/`level'_060114_`p'_0_`bin'.gph" "${Bunching}/`level'_060114_`p'_1_`bin'.gph" "${Bunching}/`level'_060114_`p'_2_`bin'.gph"
			graph export "${Bunching}/`level'_`p'_`bin'.pdf", replace
		}
	}
}

*CadUnico Domicilio with formal1 and formalAll
foreach sel in All 1{
	foreach p in raw res non non_div{
		forvalues dep=0/2{
			use ${TreatedData}/Dom`sel'Rs_060114_`dep'_bin.dta, clear
			if "`p'" == "raw"{
				loc y = "c"
			}
			else if "`p'" == "res"{
				reg c r*
				predict double res if ybar<200, residuals
				loc y = "res"
				foreach wd in 3p5 1{
					bysort Ybar`wd': egen res`wd' = total(res)
					bysort Ybar`wd': replace order`wd' = _n
				}	
			}
			else if "`p'" == "non"{
				keep if r5 == 0
				drop c3p5 c1
				foreach wd in 3p5 1{
					bysort Ybar`wd': replace order`wd' = _n					
					bysort Ybar`wd': egen c`wd' = total(c)
				}
				loc y = "c"
			}
			else if "`p'" == "non_div"{
				keep if r5 == 0 & r10 == 0 & r25 == 0 & r25_3 == 0 & r50_4 == 0 & rMin == 0
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
			}
		}
	}


	foreach bin in bin1 bin3p5{
		foreach p in raw res non non_div{
			graph combine "${Bunching}/Dom`sel'_060114_`p'_0_`bin'.gph" "${Bunching}/Dom`sel'_060114_`p'_1_`bin'.gph" "${Bunching}/Dom`sel'_060114_`p'_2_`bin'.gph"
			graph export "${Bunching}/Dom`sel'_`p'_`bin'.pdf", replace
		}
	}
}

capture log close

/*Cadunico
foreach level in Dom Pes{
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
			forvalues dep=0/2{
				use ${TreatedData}/cadUnico`level'Rs_`date'_`dep'_bin.dta, clear
				if "`p'" == "raw"{
					loc y = "c"
				}
				else if "`p'" == "res"{
					reg c r*
					predict double res if ybar<200, residuals
					loc y = "res"
					foreach wd in 3p5 1{
						bysort Ybar`wd': egen res`wd' = total(res)
						bysort Ybar`wd': replace order`wd' = _n
					}	
				}
				else if "`p'" == "non"{
					keep if r5 == 0
					drop c3p5 c1
					foreach wd in 3p5 1{
						bysort Ybar`wd': replace order`wd' = _n					
						bysort Ybar`wd': egen c`wd' = total(c)
					}
					loc y = "c"
				}
				else if "`p'" == "non_div"{
					keep if r5 == 0 & r10 == 0 & r25 == 0 & r25_3 == 0 & r50_4 == 0 & rMin == 0
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
					xtitle(Reported Income (Reais), size(small)) title(`dep' dep. - `per', size(med) margin(medium)) /// 
					plotregion(color(white)) graphregion(color(white)) legend(off) xlabel( , labsize(small)) ///
					ylabel(, labsize(small)) xline(`t1', lcolor(red)) xline(`t2', lcolor(red))  xline(`taux1', lpattern(dash)) xline(`taux2', lpattern(dash))
					graph save "${Bunching}/`level'_`date'_`p'_`dep'_`bin'.gph", replace
				}
			}
		}
	}

	foreach bin in bin1 bin3p5{
		foreach p in raw res non non_div{
			graph combine "${Bunching}/`level'_021913_`p'_0_`bin'.gph" "${Bunching}/`level'_021913_`p'_1_`bin'.gph" "${Bunching}/`level'_021913_`p'_2_`bin'.gph" ///
			"${Bunching}/`level'_060114_`p'_0_`bin'.gph" "${Bunching}/`level'_060114_`p'_1_`bin'.gph" "${Bunching}/`level'_060114_`p'_2_`bin'.gph"
			graph export "${Bunching}/`level'_`p'_`bin'.pdf", replace
		}
	}
}


