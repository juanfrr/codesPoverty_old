clear all
set more off
capture log close 
log using "${Logs}/maps.log", replace

*Source http://www.codegeo.com.br/2013/04/shapefiles-do-brasil-para-download.html
shp2dta using "${MapsIBGE}/municipios_2010", database("${TreatedData}/map") coordinates("${TreatedData}/coordinates") replace genid(id_stata)

use ${TreatedData}/map.dta, clear
rename codigo_ibg codmun
destring codmun, replace
replace codmun = floor(codmun/10)
sort codmun
save ${TreatedData}/map.dta, replace

use ${TreatedData}/evasionPC_mun.dta, clear
merge 1:1 codmun using "${TreatedData}/applicants_mun.dta"
drop _m
merge 1:1 codmun using "${TreatedData}/rendaPc2000_mun.dta"
drop _m
merge 1:1 codmun using "${TreatedData}/area2010_mun.dta"
drop _m
merge 1:1 codmun using "${TreatedData}/map.dta"
drop _m

gen indAppKm2 = numInd/area2010
gen hhAppKm2 = numHh/area2010
sort codmun

sum incomePc2000 indAppKm2 hhAppKm2 evasionPc, d
spmap incomePc2000 using "${TreatedData}/coordinates", id(id_stata) ndfcolor(gs9) clmethod(custom) clbreaks(0 50 100 150 200 250 300 350 400 450) ///
		fcolor(YlGnBu) legend(position(7)) osize(none) ocolor(none)
graph export "${Presentation}/incomePc2000.pdf", as(pdf) replace		

spmap indAppKm2 using "${TreatedData}/coordinates", id(id_stata) ndfcolor(gs9) clmethod(custom) clbreaks(0 .05 .1 .15 .4 .75 1 2 3 4) ///
		fcolor(YlGnBu) legend(position(7)) osize(none) ocolor(none)
graph export "${Presentation}/indAppKm2.pdf", as(pdf) replace

spmap hhAppKm2 using "${TreatedData}/coordinates", id(id_stata) ndfcolor(gs9) clmethod(custom) clbreaks(0 .02 .04 .06 .1 .16 .22 .3 .6 1.2) ///
		fcolor(YlGnBu) legend(position(7)) osize(none) ocolor(none)
graph export "${Presentation}/hhAppKm2.pdf", as(pdf) replace

spmap evasionPc using "${TreatedData}/coordinates", id(id_stata) ndfcolor(gs9) clmethod(custom) clbreaks(-580 0 100 200 300 350 400 450 500 550) ///
		fcolor(YlGnBu) legend(position(7)) osize(none) ocolor(none)
graph export "${Presentation}/evasionPc.pdf", as(pdf) replace		

capture log close
