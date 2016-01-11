clear all
set more off
capture log close 
log using "${Logs}/ipea.log", replace 
*Source ipeadata.gov.br

insheet using ${IPEA}/rendaPc2000_mun.csv, comma clear
drop if _n <= 2
keep v2 v4
rename v2 codmun
destring codmun, replace
replace codmun = floor(codmun/10)
rename v4 incomePc2000
label var incomePc2000 "2000 R$"
sum codmun
save ${TreatedData}/rendaPc2000_mun.dta, replace

insheet using ${IPEA}/area2010_mun.csv, comma clear
drop if _n <= 2
keep v2 v4
rename v2 codmun
destring codmun, replace
replace codmun = floor(codmun/10)
rename v4 area2010
label var area2010 "Municipal Area (Km2)"
sum codmun
save ${TreatedData}/area2010_mun.dta, replace

capture log close 
