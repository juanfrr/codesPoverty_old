clear all
set more off
capture log close 
log using "${Logs}/cadunicoDomicilio.log", replace

use ${TreatedData}/cadUnicoDomCompleteRs_idHh.dta, clear

keep idHh cd_ibge dat_atualizacao_familia dat_cadastramento_fam vlr_renda_media_fam num_cpf_entrevistador_fam qtd_comodos_domic_fam cod_agua_canalizada_fam cod_abaste_agua_domic_fam ///
cod_escoa_sanitario_domic_fam cod_destino_lixo_domic_fam cod_iluminacao_domic_fam cod_calcamento_domic_fam qtd_pessoas_domic_fam qtd_familias_domic_fam
foreach d in dat_atualizacao_familia dat_cadastramento_fam{
	gen aux = length(`d')
	tab aux
	drop aux
	gen `d'_s=substr(`d',1,7)
}
gen dateUpdateDom = date(dat_atualizacao_familia_s, "YM")
label var dateUpdateDom "Update Date for the Household"
gen dateRegisterHh = date(dat_cadastramento_fam_s, "YM")
label var dateRegisterHh "Register Date for the Household"
gen codmun = floor(cd_ibge/10)
rename vlr_renda_media_fam incomeDomPc
label var incomeDomPc "Household per capita Income"
rename num_cpf_entrevistador_fam cpfInt
label var cpfInt "Interviewer's CPF"
rename  qtd_comodos_domic_fam numRooms
rename cod_agua_canalizada_fam waterPiped
rename cod_abaste_agua_domic_fam waterSupply
rename cod_escoa_sanitario_domic_fam sanitation
rename cod_destino_lixo_domic_fam garbage
rename cod_iluminacao_domic_fam light
rename cod_calcamento_domic_fam paving
rename qtd_pessoas_domic_fam hhSizeDom
rename qtd_familias_domic_fam numFamilies

gen numRoomsEx = (numRooms !=.)
replace numRooms = 0 if numRooms == .
keep if dateUpdateDom > date("01/30/2009","MDY") & dateUpdateDom<date("04/01/2015","MDY")

isid idHh
sort idHh
save ${TreatedData}/cadUnicoDomRs_idHh.dta, replace

capture log close
