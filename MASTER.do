********************************************************************************
**************** MASTER PROGRAM: OPTIMAL ANTI-POVERTY PROGRAMS ***************************
********************************************************************************

clear all

/************************************************************/

global root "D:/juanrios"
global RawData "${root}/RawData"
global TreatedData "${root}/TreatedData"
global Poverty "${root}/Copy/Projects/Poverty"

global Text "${Poverty}/textPoverty"
global Presentation "${Poverty}/Presentation/today"
global Codes "${Poverty}/codesPoverty"
global Logs "${Poverty}/Codes/Logs"
global Graphs "${Poverty}/Graphs"
global Tables "${Poverty}/Tables"

global CadastroUnico "${RawData}/CadastroUnico/Bases_abril_2015"
global RAIS "${RawData}/RAIS"
global Condicionalidades "${RawData}/Condicionalidades"
global Folha "${RawData}/Folha"
global FolhaIncome "${RawData}/Arquivo_folha_BFA"
global GADM "${RawData}/BRA_adm"
global MapsIBGE "${RawData}/MapsIBGE"
global IPEA "${RawData}/IPEA"

set more off, perm

*** CLEANING DATA ***

run "${Codes}/randomSample.do"
run "${Codes}/cadunicoPessoa.do"
run "${Codes}/cadunicoDomicilio.do"
run "${Codes}/rais.do"
run "${Codes}/folhaIncome.do"
run "${Codes}/folhaBenefit.do"
run "${Codes}/ipea.do"

*** MERGING AND APPENDING DATA ***

run "${Codes}/merge.do"

*** CREATING MODEL VARIABLES ***

run "${Codes}/createVariables.do"

*** ANALYZING DATA ***
  
run "${Codes}/histograms.do"
run "${Codes}/maps.do"
run "${Codes}/bunching.do"
run "${Codes}/hhComposition.do"

*** ESTIMATING ELASTICITIES ***

