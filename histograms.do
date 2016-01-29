clear all
set more off
capture log close 
log using "${Logs}/histograms.log", replace

*Cadunico Domicilio (no need to use Pessoa as there were no missings)
use ${TreatedData}/cadUnicoDomRs_idHh.dta, clear

count if dateUpdateDom<date("06/01/2014","MDY") & incomeDomPc > 52.5 & incomeDomPc < 98
local N: display %19.0f r(N)
histogram incomeDomPc if dateUpdateDom<date("06/01/2014","MDY") ///
& incomeDomPc > 52.5 & incomeDomPc < 99.75, width(3.5) start(52.501)  play(${Codes}/before_first) ///
title("First Threshold (Before)") text(.075 86 "`N' obs.") ylabel(0(0.05)0.1) xlabel(70 (7) 77)
graph save ${Graphs}/cadDomRs_firstBefore, replace 

count if dateUpdateDom<date("06/01/2014","MDY") & incomeDomPc > 119 & incomeDomPc < 168
local N: display %19.0f r(N)
histogram incomeDomPc if dateUpdateDom<date("06/01/2014","MDY") ///
& incomeDomPc > 119 & incomeDomPc < 168, width(3.5) start(119.001) play(${Codes}/before_second) ///
title("Second Threshold (Before)") text(.075 158 "`N' obs.") ylabel(0(0.05)0.1) xlabel(140 (14) 154)
graph save ${Graphs}/cadDomRs_secondBefore, replace

graph combine ${Graphs}/cadDomRs_firstBefore.gph ${Graphs}/cadDomRs_secondBefore.gph, col(2)
graph export ${Presentation}/fig_cadDomRs_Before.pdf, replace

count if dateUpdateDom>date("06/01/2014","MDY") & incomeDomPc > 52.5 & incomeDomPc < 98
local N: display %19.0f r(N)
histogram incomeDomPc if dateUpdateDom>date("07/01/2014","MDY") ///
& incomeDomPc > 52.5 & incomeDomPc < 99.75, width(3.5) start(52.501)  play(${Codes}/after_first) ///
title("First Threshold (After)") text(.075 86 "`N' obs.") ylabel(0(0.05)0.1) xlabel(70 (7) 77)
graph save ${Graphs}/cadDomRs_firstAfter, replace 

count if dateUpdateDom>date("06/01/2014","MDY") & incomeDomPc > 119 & incomeDomPc < 168
local N: display %19.0f r(N)
histogram incomeDomPc if dateUpdateDom>date("06/01/2014","MDY") ///
& incomeDomPc > 119 & incomeDomPc < 168, width(3.5) start(119.001) play(${Codes}/after_second) ///
title("Second Threshold (After)") text(.075 158 "`N' obs.") ylabel(0(0.05)0.1) xlabel(140 (14) 154)
graph save ${Graphs}/cadDomRs_secondAfter, replace

graph combine ${Graphs}/cadDomRs_firstAfter.gph ${Graphs}/cadDomRs_secondAfter.gph, col(2)
graph export ${Presentation}/fig_cadDomRs_After.pdf, replace

*Rais 
use ${TreatedData}/raisCadCompleteRs_idHh.dta, clear

count if date<date("06/01/2014","MDY") & incomeDomPc > 52.5 & incomeDomPc < 98
local N: display %19.0f r(N)
histogram incomeRaisPc if date<date("06/01/2014","MDY") ///
& incomeRaisPc > 52.5 & incomeRaisPc < 98, width(3.5) start(52.501)  play(${Codes}/before_first) ///
title("First Threshold (Before)") text(.075 86 "`N' obs.") ylabel(0(0.05)0.1) xlabel(70 (7) 77)
graph save ${Graphs}/raisRs_firstBefore, replace

count if date<date("06/01/2014","MDY") & incomeRaisPc > 119 & incomeRaisPc < 168
local N: display %19.0f r(N)
histogram incomeRaisPc if date<date("06/01/2014","MDY") ///
& incomeRaisPc > 119 & incomeRaisPc < 168, width(3.5) start(119.001) play(${Codes}/before_second) ///
title("Second Threshold (Before)") text(.075 158 "`N' obs.") ylabel(0(0.05)0.1) xlabel(140 (14) 154)
graph save ${Graphs}/raisRs_secondBefore, replace

graph combine ${Graphs}/raisRs_firstBefore.gph ${Graphs}/raisRs_secondBefore.gph, col(2)
graph export ${Presentation}/fig_raisRs_Before.pdf, replace

count if date>date("06/01/2014","MDY") & incomeDomPc > 52.5 & incomeDomPc < 98
local N: display %19.0f r(N)
histogram incomeRaisPc if date>date("06/01/2014","MDY") ///
& incomeRaisPc > 52.5 &incomeRaisPc < 98, width(3.5) start(52.501) play(${Codes}/after_first) ///
title("First Threshold (After)") text(.075 86 "`N' obs.") ylabel(0(0.05)0.1) xlabel(70 (7) 77)
graph save ${Graphs}/raisRs_firstAfter, replace

count if date>date("06/01/2014","MDY") & incomeRaisPc > 119 & incomeRaisPc < 168
local N: display %19.0f r(N)
histogram incomeRaisPc if date>date("06/01/2014","MDY") ///
& incomeRaisPc > 119 & incomeRaisPc < 168, width(3.5) start(119.001) play(${Codes}/after_second) ///
title("Second Threshold (After)") text(.075 158 "`N' obs.") ylabel(0(0.05)0.1) xlabel(140 (14) 154)
graph save ${Graphs}/raisRs_secondAfter, replace

graph combine ${Graphs}/raisRs_firstAfter.gph ${Graphs}/raisRs_secondAfter.gph, col(2)
graph export ${Presentation}/fig_raisRs_After.pdf, replace

*Evasion
use ${TreatedData}/raisCadCompleteRs_idHh.dta, clear

count
local T: display %7.0f r(N)
count if evasionPc < 2000 & evasionPc > -500
local N: display %7.0f r(N)
histogram evasionPc if evasionPc < 2000 & evasionPc > -500, title("(a) All") ///
text(.0015 1200 "`N' out of `T' obs.") ylabel(0(0.001)0.003) play(${Codes}/evasion) width(50) start(-500)
graph save ${Graphs}/evasion, replace
graph export ${Presentation}/fig_evasion.pdf, replace

count if uf == ufRais
local T: display %7.0f r(N)
count if uf == ufRais & evasionPc < 2000 & evasionPc > -500
local N: display %7.0f r(N)
histogram evasionPc if date>date("06/01/2014","MDY") & evasionPc < 2000 & evasionPc > -500, title("(b) Same State") ///
text(.0015 1200 "`N' out of `T' obs.") ylabel(0(0.001)0.003) play(${Codes}/evasion) width(50) start(-500)
graph save ${Graphs}/evasionState, replace
graph export ${Presentation}/fig_evasionState.pdf, replace

count if codmun == codmunRais
local T: display %7.0f r(N)
count if codmun == codmunRais & evasionPc < 2000 & evasionPc > -500
local N: display %7.0f r(N)
histogram evasionPc if date>date("06/01/2014","MDY") & evasionPc < 2000 & evasionPc > -500, title("(c) Same Municipality") ///
text(.0015 1200 "`N' out of `T' obs.") ylabel(0(0.001)0.003) play(${Codes}/evasion) width(50) start(-500)
graph save ${Graphs}/evasionMunicipality, replace
graph export ${Presentation}/fig_evasionMunicipality.pdf, replace

graph combine ${Graphs}/evasion.gph ${Graphs}/evasionState.gph ${Graphs}/evasionMunicipality.gph, col(1)
graph export ${Text}/fig_evasionRs.png, replace

* Relation between third party and reported income

use ${TreatedData}/raisCadCompleteRs_idHh.dta, clear

preserve

replace incomeRaisPc = 0 if incomeRaisPc <=50
forvalues i=100(100)900{
	replace incomeRaisPc = `i' if incomeRaisPc > `i'-50 & incomeRaisPc <= `i'+50
}
replace incomeRaisPc = 1000 if incomeRaisPc > 950
tab incomeRaisPc
collapse incomeBfPc, by(incomeRaisPc)
label var incomeBfPc "Reported Income"
label var incomeRaisPc "3rd Party Reported Income"
graph twoway scatter incomeBfPc incomeRaisPc
graph export ${Presentation}/incomeRaisBf.pdf, replace

restore

replace incomeBfPc = 0 if incomeBfPc <=20
forvalues i=40(40)360{
	replace incomeBfPc = `i' if incomeBfPc > `i'-20 & incomeBfPc <= `i'+20
}
replace incomeBfPc = 400 if incomeBfPc > 380
tab incomeBfPc
collapse incomeRaisPc, by(incomeBfPc)
label var incomeBfPc "Reported Income"
label var incomeRaisPc "3rd Party Reported Income"
graph twoway scatter incomeRaisPc incomeBfPc
graph export ${Presentation}/incomeBfRais.pdf, replace

capture log close
