clear all
set more off
capture log close 
log using "${Logs}/folhaBenefit.log", replace 

use "${TreatedData}/folhaBenefit2012RS_idHh.dta", clear
forvalues i=2013/2015{
	append using "${TreatedData}/folhaBenefit`i'RS_idHh.dta"
}

rename id sequencialNumber
rename prog program
label var prog "BF = 0694"
rename uf state
gen date = date(rf_folha,"MY")
rename cd_agencia bankBranch
rename nm_agencia bankBranchName
rename nm_responsavel nameHeadHh
gen dateBirthHead = date(data_nasc_rl,"DMY")
rename nistitular idHead
gen dateInitialPayment = date(competinicial,"MY")
gen datePayment = date(competfolha,"MY")
rename vlrbasico benefitBasic
rename vlrbvg benefitPregnant
rename vlrbvn benefitNursingMother
rename vlrvar06 benefit0to6
rename vlrvar715 benefit7to15
rename vlrbvj benefitYoung
rename vlrbsp benefitExtremePoverty
rename vlrextra benefitExtraordinary
rename vlrtotal benefitTotalHh
rename sitbasico statusBasic
rename sitbvg statusPregnant
rename sitbvn statusNursingMother
rename sitvariavel status0to15
rename sitbvj statusYoung
rename sitextra statusExtraordinary
rename sitfam statusHhD
gen datePregnant = date(vigbvg,"DMY") 
gen dateNursingMother = date(vigbvn,"DMY")
gen date0to15 = date(vigvar,"DMY")
rename vigbvj dateYoung /*gen dateYoung = date(vigbvj,"DMY")*/
rename vigextra dateExtraordinary /*gen dateExtraordinary = date(vigextra,"DMY")*/
rename cep zipcode
rename nisdependente idInd 
gen dateBirth = date(dtnascdep,"DMY")
rename qtdbas eligibleBasic
rename qtdbvg eligiblePregnant
rename qtdbvn eligibleNursingMother
rename qtdvar0a6 eligible0to6
rename qtdvar7a15 eligible7to15
rename qtdbvj eligibleYoung
rename qtdbsp eligibleExtremePoverty
rename qtdtextra eligibleExtraordinary
rename qtdtitular headOfHh
rename qtdfam0a6 hhWith0to6
rename qtdfam7a15 hhWith7to15
rename sexotit headSex
rename sexodep sex
rename inep schoolCode
rename ibgeesc schoolCodmun
rename dt_validade_beneficio dateLastUpdate/*gen dateLastUpdate = date(dt_validade_beneficio,"DMY")*/
gen year = year(date)
gen month = month(date)
*CHECK WITH FOLHA (OLD) 2012
*CHECK WITH FOLHA 2012
*CHECK WITH FOLHA 2012
*CHECK WITH FOLHA 2012
/*foreach name in Payment InitialPayment LastUpdate Pregnant NursingMother 0to15 Young Extraordinary{
	gen year`name' = year(date`name')
	gen month`name' = month(date`name')
}*/
keep idInd idHh date* year* month* benefit* status* eligible* hhWith*
order idInd idHh year month  
bysort idInd date datePayment: gen dup = _N
drop if dup > 1 /*92 observations deleted*/
drop dup 
drop if idInd == . | year == . | month == . | yearPayment == . | monthPayment == . /*1 observation deleted*/
isid idInd year month yearPayment monthPayment
sort idInd year month yearPayment monthPayment
save ${TreatedData}/FolhaBenefitsRs_idIndMonth.dta, replace

capture log close 
