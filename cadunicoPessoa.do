clear all
set more off
capture log close 
log using "${Logs}/cadunicoPessoa.log", replace

use ${TreatedData}/cadUnicoCompleteRs.dta, clear
bysort idInd: gen dup = _N
drop if dup > 1 /*37 obs (<0.01%)*/
drop dup
sort idInd
isid idInd
save ${TreatedData}/cadUnicoCompleteRs_idInd.dta, replace

keep idHh dta_cadastramento_memb dta_atual_memb cpf idInd cd_ibge cod_sexo_pessoa dta_nasc_pessoa cod_parentesco_rf_pessoa cod_deficiencia_memb cod_sabe_ler_escrever_memb ///
ind_frequenta_escola_memb cod_curso_frequenta_memb cod_ano_serie_frequenta_memb cod_curso_frequentou_pessoa_memb cod_ano_serie_frequentou_memb ///
cod_concluiu_frequentou_memb cod_principal_trab_memb val_remuner_emprego_memb val_renda_bruta_12_meses_memb
foreach d in dta_cadastramento_memb dta_atual_memb dta_nasc_pessoa{
	gen aux = length(`d')
	tab aux
	drop aux
	gen `d'_s =substr(`d',1,7)
}
gen codmun = floor(cd_ibge/10)
gen dateUpdatePes = date(dta_atual_memb_s, "YM")
label var dateUpdatePes "Update Date for the Individual"
gen dateRegisterInd = date(dta_cadastramento_memb_s, "YMD")
label var dateRegisterInd "Register Date for the Individual"
gen dateBirth = date(dta_nasc_pessoa_s, "YMD")
label var dateBirth "Birth Date"
rename cod_deficiencia_memb disable
label var disable "1-Yes;2-No"
rename cod_sexo_pessoa gender
label var gender "1-Male;2-Female"
rename cod_parentesco_rf_pessoa relative
rename cod_sabe_ler_escrever_memb literate
label var literate "1-Yes;2-No"

*Generating years of schooling
gen schooling = 1 if  cod_curso_frequentou_pessoa_memb <= 3 | (cod_curso_frequentou_pessoa_memb == 4 & cod_ano_serie_frequentou_memb == 1)
forvalues j = 4(6)10{
	forvalues i = 1(1)4{
		replace schooling = `i' if  cod_curso_frequentou_pessoa_memb == `j' & cod_ano_serie_frequentou_memb == `i'
	}	
	replace schooling = 4 if  cod_curso_frequentou_pessoa_memb == `j' & cod_ano_serie_frequentou_memb >= 4 & cod_ano_serie_frequentou_memb < 10
	replace schooling = 2.5 if  cod_curso_frequentou_pessoa_memb == `j' & (cod_ano_serie_frequentou_memb == 10 | cod_ano_serie_frequentou_memb == .)
}
forvalues j = 5(6)11{
	forvalues i = 5(1)8{
		replace schooling = `i' if  cod_curso_frequentou_pessoa_memb == `j' & cod_ano_serie_frequentou_memb == `i'
	}
	replace schooling = 5 if  cod_curso_frequentou_pessoa_memb == `j' & cod_ano_serie_frequentou_memb <= 4
	replace schooling = 8 if  cod_curso_frequentou_pessoa_memb == `j' & cod_ano_serie_frequentou_memb == 9
	replace schooling = 6.5 if  cod_curso_frequentou_pessoa_memb == `j' & (cod_ano_serie_frequentou_memb == 10 | cod_ano_serie_frequentou_memb == .)
}
forvalues j=6(1)7{
	forvalues i =1(1)9{
		replace schooling = `i' if  cod_curso_frequentou_pessoa_memb == `j' & cod_ano_serie_frequentou_memb == `i'
	}	
	replace schooling = 5 if  cod_curso_frequentou_pessoa_memb == `j' & (cod_ano_serie_frequentou_memb == 10 | cod_ano_serie_frequentou_memb == .)
}
forvalues j = 8(1)9{
	forvalues i = 1(1)4{
		loc years = 8+`i'
		replace schooling = `years' if  cod_curso_frequentou_pessoa_memb == `j' & cod_ano_serie_frequentou_memb == `i'
	}
	replace schooling = 12 if  cod_curso_frequentou_pessoa_memb == `j' & cod_ano_serie_frequentou_memb >= 5 & cod_ano_serie_frequentou_memb < 10
	replace schooling = 10.5 if  cod_curso_frequentou_pessoa_memb == `j' & (cod_ano_serie_frequentou_memb == 10 | cod_ano_serie_frequentou_memb == .)
}
replace schooling = 10.5 if cod_curso_frequentou_pessoa_memb == 12
replace schooling = 16 if cod_curso_frequentou_pessoa_memb == 13
replace schooling = 1 if cod_curso_frequentou_pessoa_memb == 14
replace schooling = 0 if cod_curso_frequentou_pessoa_memb == 15
tab cod_curso_frequentou_pessoa_memb if schooling == ., m
rename ind_frequenta_escola_memb schoolAttendant
rename cod_curso_frequenta_memb educLevelCurrent
rename cod_ano_serie_frequenta_memb educYearWithinLevelCurrent
rename cod_curso_frequentou_pessoa_memb educLevelHighest
rename cod_ano_serie_frequentou_memb educYearWithinLevelHighest
rename cod_concluiu_frequentou_memb highestEducLevelCompleted
rename cod_principal_trab_memb workType
rename val_remuner_emprego_memb incomeLast
label var incomeLast "Income in the last month"
rename val_renda_bruta_12_meses_memb incomeYear
label var incomeYear "Income in the last 12 months"
bysort idHh: gen aux = _n
bysort idHh: gen hhSizePes = _N
isid idInd
sort idInd
format date* %tdCCYY.NN.DD
save ${TreatedData}/cadUnicoPesRs_idInd.dta, replace

**Defining heads of the households by age during update
gen ageUpdate = floor((date(dta_atual_memb,"YMD")-date(dta_nasc_pessoa,"YMD"))/365)
gen numAdults = (age>17 & age<66)
gen below6 = (age <=6 & age >=0)
gen below15 = (age <= 15 & age >= 0)
gen teens = (age <= 18 & age > 15)
gen adults = (age > 18)

*Ordering people by: 65->16 then 66->814 then 15->0
gen mAge = age
replace mAge = -age if age >=16 & age <=65
replace mAge = 900-age if age<16
recode relative (3/11 = 3), gen(relativeMod)
replace relativeMod = 3 if relativeMod == .
sort idHh relativeMod mAge

bysort idHh: gen member = _n
gen educHead = .
replace educHead = schooling if member == 1
gen genderHead = .
replace genderHead = gender if member == 1
gen ageHead = .
replace ageHead = ageUpdate if member == 1
gen partner = 0
replace partner = (relative == 2)
gen educPartner = .
replace educPartner = schooling if relative == 2

gen incomePes = min(incomeLast, incomeYear)

collapse (mean) dateUpdatePes hhSizePes (firstnm) codmun (sum) incomePes numAdults below6 below15 teens adults partner (first) educHead ageHead genderHead educPartner, by(idHh)	
gen uf = int(codmun/100000)
gen educHeadEx = (educHead !=.)
replace educHead = 0 if educHead == .
gen educHead2 = educHead^2
gen educPartnerEx = (educPartner !=.)
replace educPartner = 0 if educPartner == .
gen educPartner2 = educPartner^2
gen ageHead2 = ageHead^2
keep if dateUpdatePes > date("01/30/2009","MDY") & dateUpdatePes<date("04/01/2015","MDY")
format date* %tdCCYY.NN.DD
sort idHh
isid idHh

save ${TreatedData}/cadUnicoPesRs_idHh.dta, replace

capture log close
