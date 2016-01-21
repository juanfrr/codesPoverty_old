clear all
set more off
capture log close 
log using "${Logs}/cadunicoPesDom.log", replace

/*Goal: Verify whether incomeDomPc == incomePes/hhSize
Conclusions: In general income is coherent for 21.4% (29.1%) of the households
			 In the second to last period income is coherent for 21.9%% (29.9%) of the households
			 In the last period income is coherent for 21.8% (29.6%) of the households
			 p25(incomeDomPc-incomePesPc) = -5 and p75(incomeDomPc-incomePesPc) = 83.33
			 41,084 observations or 3.2% (42,720 or 3.3%) have incomeDomPc = incomePesPc +50
			 Values within brackets are allowing for differences of up to 1 real (rounding issues)
			 Errors do not seem to come from particular dates
			 households with error = 50 are more likely to have 2 household members*/
			 
use ${TreatedData}/cadDomPesRs_idHh.dta, clear

count
count if incomeDomPc !=. & incomePesPc != .
gen incomeDomMPes = incomeDomPc -incomePesPc
sum incomeDomMPes, d

count if incomeDomMPes < .
count if incomeDomMPes == 0
count if abs(incomeDomMPes) < 1

count if per == "02/19/13 to 06/01/14" & abs(incomeDomMPes) < 1
count if per == "02/19/13 to 06/01/14" & abs(incomeDomMPes) == 0
count if per == "02/19/13 to 06/01/14" & abs(incomeDomMPes)< .

count if per == "06/01/14 to 04/18/15" & abs(incomeDomMPes) < 1
count if per == "06/01/14 to 04/18/15" & abs(incomeDomMPes) == 0
count if per == "06/01/14 to 04/18/15" & abs(incomeDomMPes)< .

count if incomeDomMPes == 50
count if incomeDomMPes > 49 & incomeDomMPes <51

sum incomeDomMPes, d

summdate dateUpdate if abs(incomeDomMPes) < 1
summdate dateUpdate if abs(incomeDomMPes) >= 1 & abs(incomeDomMPes)< .

tab hhSize if incomeDomMPes == 50
count if hhSizeDom == . & incomeDomMPes == 50
tab hhSize 

capture log close 
