clear all
set more off
capture log close 
log using "${Logs}/dates.log", replace

/*Goal: Check when if the last update in Folha happened together with the last update in Cadastro
Conclusions: 61.44% of the households' updates in folha happens 2 months after the cadunico update
			88.54% happens up to a year after the update
			99% of the income in folha after the last update coincides precisely with CadunicoDom*/

use ${TreatedData}/cadFolIncRs_idHhMon.dta, clear

/*Note that if dateFolha < dateUpdateDom & last == 1 is because in the last update in cad the household did not change their
income in the last update, so last actually refers to a previous cad update */
tab monthfolhaMdom if last == 1 & monthfolhaMdom >= 0
*61% of the updates that I can get with the data are in the 2 months following cadunico domicilio
tab monthfolhaMpes if last == 1 & monthfolhaMpes >= 0
*same is true for cadunico pessoa


sum incomefolhaMdom if last == 1 & monthfolhaMdom >= 0, detail
*coincides for 98% of the distribution
sum incomefolhaMpes if last == 1 & incomefolhaMpes >= 0, detail
*large part of the distribution has incomeFolhaPc > incomePes

capture log close 
