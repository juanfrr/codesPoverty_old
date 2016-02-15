clear all
set more off
capture log close 
log using "${Logs}/randomSample.log", replace 

*CadunicoDomicilioRs201508 and Random Sample
insheet using "${CadastroUnico}/22082015/BRASIL/TB_DOMICILIO_BRASIL_22082015.csv", clear delimiter(";") names
rename cod_familiar_fam idHh
gen dateUpdateDom = date(dat_atualizacao_familia, "YMD")
replace idHh = int(idHh/100)
keep if dateUpdateDom >= date("2013.08.22","YMD") 
set seed 17
sample 5
isid idHh
sort idHh
save ${TreatedData}/cadUnicoDomComplete201508Rs_idHh.dta, replace
keep idHh dateUpdateDom
rename dateUpdateDom dateUpdateRs
isid idHh
sort idHh
save ${TreatedData}/randomSample_idHh.dta, replace

*CadunicoDomicilioRs201504
insheet using "${CadastroUnico}/Bases_abril_2015/TB_DOMICILIO_BRASIL.CSV/TB_DOMICILIO_BRASIL.csv", clear delimiter(";") names
rename cod_familiar_fam idHh
replace idHh = int(idHh/100)
gen dateUpdateDom = date(dat_atualizacao_familia, "YMD")
merge 1:1 idHh using ${TreatedData}/randomSample_idHh.dta
keep if _m == 3
isid idHh
sort idHh
save ${TreatedData}/cadUnicoDomComplete201504Rs_idHh.dta, replace

*CadunicoDomicilioRs201412
insheet using "${CadastroUnico}/13122014/TB_DOMICILIO_BRASIL_122014.csv", clear delimiter(";") names
rename cod_familiar_fam idHh
replace idHh = int(idHh/100)
gen dateUpdateDom = date(dat_atualizacao_familia, "YMD")
merge 1:1 idHh using ${TreatedData}/randomSample_idHh.dta
keep if _m == 3
isid idHh
sort idHh
save ${TreatedData}/cadUnicoDomComplete201412Rs_idHh.dta, replace

*CadunicoDomicilioRs201312
insheet using "${CadastroUnico}/20122013/TB_DOMICILIO_BRASIL_122013.csv", clear delimiter(";") names
rename cod_familiar_fam idHh
replace idHh = int(idHh/100)
gen dateUpdateDom = date(dat_atual_fam, "YMD")
merge 1:1 idHh using ${TreatedData}/randomSample_idHh.dta
keep if _m == 3
isid idHh
sort idHh
save ${TreatedData}/cadUnicoDomComplete201312Rs_idHh.dta, replace

*CadunicoDomicilioRs201212
insheet using "${CadastroUnico}/29122012/TB_DOMICILIO_BRASIL_122012.csv", clear delimiter(";") names
rename cod_familiar_fam idHh
replace idHh = int(idHh/100)
gen dateUpdateDom = date(dat_atual_fam, "YMD")
merge 1:1 idHh using ${TreatedData}/randomSample_idHh.dta
keep if _m == 3
isid idHh
sort idHh
save ${TreatedData}/cadUnicoDomComplete201212Rs_idHh.dta, replace

*CadunicoPessoaRs 201508 and RS
insheet using "${CadastroUnico}/22082015/BRASIL/TB_PESSOA_BRASIL.csv", clear delimiter(";") names
rename cod_familiar_fam idHh
replace idHh = int(idHh/100)
rename num_nis_pessoa_atual idInd
rename num_cpf_pessoa cpf
sort idHh
merge m:1 idHh using ${TreatedData}/randomSample_idHh.dta 
drop if _m == 1 
rename _m mCadPesRs
save ${TreatedData}/cadUnicoPesComplete201508Rs.dta, replace

preserve
bysort idInd: gen dup = _N
drop if dup > 1 
drop dup
keep idHh idInd cpf
isid idInd
sort idHh idInd
save ${TreatedData}/randomSample_idInd.dta, replace

restore
bysort cpf: gen dup = _N 
drop if dup > 1 
drop dup
isid cpf
sort cpf 
save ${TreatedData}/randomSample_cpf.dta, replace

*CadunicoPessoaRs 201504 and RS
insheet using "${CadastroUnico}/Bases_abril_2015/TB_PESSOA_BRASIL.csv", clear delimiter(";") names
rename cod_familiar_fam idHh
replace idHh = int(idHh/100)
rename num_nis_pessoa_atual idInd
rename num_cpf_pessoa cpf
sort idHh
merge m:1 idHh using ${TreatedData}/randomSample_idHh.dta 
drop if _m == 1 
rename _m mCadPesRs
save ${TreatedData}/cadUnicoPesComplete201504Rs.dta, replace

*CadunicoPessoaRs 201412 and RS
insheet using "${CadastroUnico}/13122014/TB_PESSOA_BRASIL_122014.csv", clear delimiter(";") names
rename cod_familiar_fam idHh
replace idHh = int(idHh/100)
rename num_nis_pessoa_atual idInd
rename num_cpf_pessoa cpf
sort idHh
merge m:1 idHh using ${TreatedData}/randomSample_idHh.dta 
drop if _m == 1 
rename _m mCadPesRs
save ${TreatedData}/cadUnicoPesComplete201412Rs.dta, replace

*CadunicoPessoaRs 201312 and RS
insheet using "${CadastroUnico}/20122013/TB_PESSOA_BRASIL_122013.csv", clear delimiter(";") names
rename cod_familiar_fam idHh
replace idHh = int(idHh/100)
rename num_nis_pessoa_atual idInd
rename num_cpf_pessoa cpf
sort idHh
merge m:1 idHh using ${TreatedData}/randomSample_idHh.dta 
drop if _m == 1 
rename _m mCadPesRs
save ${TreatedData}/cadUnicoPesComplete201312Rs.dta, replace

*CadunicoPessoaRs 201212 and RS
insheet using "${CadastroUnico}/29122012/TB_PESSOA_BRASIL_122012.csv", clear delimiter(";") names
rename cod_familiar_fam idHh
replace idHh = int(idHh/100)
rename num_nis_pessoa_atual idInd
rename num_cpf_pessoa cpf
sort idHh
merge m:1 idHh using ${TreatedData}/randomSample_idHh.dta 
drop if _m == 1 
rename _m mCadPesRs
save ${TreatedData}/cadUnicoPesComplete201212Rs.dta, replace

*Random Sample from FolhaBenefit
forvalues i=2012(1)2015{
	insheet using "${Folha}/folha_bfa_`i'_gp.csv", clear delimiter(";") names
	rename numdomicfamilia idHh
	replace idHh = int(idHh/100)
	sort idHh
	merge m:1 idHh using "${TreatedData}/randomSample_idHh.dta"
	drop if _m == 1 /*dropping obs in which only folhaBenefit is present*/
	unique idHh if _m == 2
	unique idHh if _m > 1 
	rename _m mFolhaBenRs
	tostring dt_validade_beneficio, replace
	tostring sitextra, replace
	tostring vigbvj, replace
	tostring vigextra, replace
	save "${TreatedData}/folhaBenefit`i'Rs_idHh.dta", replace
}

*Random Sample from FolhaIncome
forvalues i = 2012(1)2015{
	loc t = `i'-2011
	timer on `t'
	insheet using "${FolhaIncome}/Arquivo_folha_BFA_`i'.txt", clear delimiter(";") names
	rename numdomicfamilia idHh
	replace idHh = int(idHh/100) if date(rf_folha,"MY") >= date("01/06/2014", "DMY")
	merge m:1 idHh using ${TreatedData}/randomSample_idHh.dta
	drop if _m == 1
	rename _m mFolhaIncRs
	sort rf_folha idHh nistitular
	save "${TreatedData}/folhaIncome`i'Rs.dta", replace
}
timer list

use "${TreatedData}/folhaIncome2012Rs.dta", clear
forvalues i = 2013(1)2015{
	append using "${TreatedData}/folhaIncome`i'Rs.dta"
}
save "${TreatedData}/folhaIncomeRs.dta", replace 

*Random Sample from RAIS
forvalues y=2012(1)2014{
	foreach UF in AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO{
		insheet using "${RAIS}/`y'/`UF'`y'ID.txt", clear delimiter(";") names
		destring dataadmissodeclarada, replace force
		drop if cpf == 0
		sort cpf 
		merge m:1 cpf using ${TreatedData}/randomSample_cpf
		drop if _m == 1
		gen yearRais = `y'
		sort cpf
		*cpf is not id because same person could have multiple jobs
		save ${TreatedData}/raisRs`UF'`y'.dta, replace		
	}
	foreach UF in AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP{
		append using ${TreatedData}/raisRs`UF'`y'.dta
	}
	unique cpf if _m == 3
	unique cpf if _m > 1	
	keep if _m == 3
	drop _m
	save ${TreatedData}/raisRs`y'.dta, replace
	foreach UF in AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP TO{
		erase ${TreatedData}/raisRs`UF'`y'.dta
	}
}

capture log close 
