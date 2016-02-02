clear all
set more off
capture log close 
log using "${Logs}/createVariables.log", replace

*Datasets to describe selection
use ${TreatedData}/raisCadRs_idHh.dta, clear
gen uf = floor(codmun/10000)
gen ufRais = floor(codmunRais/10000)
gen formal1 = (formal > 0 & formal <.)
gen formalAll = (formal == workingAge & formal <.)
gen hhSize = hhSizeDom
replace hhSize = hhSizePes if hhSize == . | hhSizeDom == 0
gen incomePesPc = incomePes/hhSize
gen incomeRaisPc = incomeRais/hhSize
gen incomeBfPc = incomeDomPc
replace incomeBfPc = incomePesPc if incomeBfPc == .
gen evasionPc = incomeRaisPc-incomeBfPc
save ${TreatedData}/raisCadCompleteRs_idHh.dta, replace

*Dataset for maps with average evasion
collapse evasionPc, by(codmun)
drop if codmun == .
isid codmun
sort codmun
save ${TreatedData}/evasionPc_mun.dta, replace
 
*Dataset for maps with density of beneficiaries and
use ${TreatedData}/cadDomPesRs_idHh.dta, clear
gen numHh = 1
gen numInd = hhSizeDom
replace numInd = hhSizePes if hhSizeDom == 0 |  hhSizeDom == .
collapse (sum) numHh numInd, by(codmun)
isid codmun
sort codmun
save ${TreatedData}/applicants_mun.dta, replace

***Creating bunching samples
*RAIS, Cadunico Pessoa and domicilio
foreach level in Dom Pes Rais{
	forvalues j=0/2{
		use ${TreatedData}/raisCadCompleteRs_idHh.dta, clear
		keep if date >= date("1Jun2014","DMY") & below15 == `j' & teens == 0
		bysort income`level'Pc: gen c = _N
		bysort income`level'Pc: gen aux = _n
		keep if c == aux & income`level'Pc <1000
		keep income`level'Pc c
		sort income`level'Pc
		gen aux = 100*(income[_n+1]-income)
		replace aux = 1 if aux == .
		expand aux, gen(dup)
		sort income dup
		replace c = 0 if dup == 1
		gen ybar = _n/100-0.01
		keep c ybar
		sort ybar
		
		gen div3p5 = 3.5*(mod(ybar,3.5)==0)
		gen Ybar3p5 = sum(div3)-1.75
		replace Ybar3p5 = Ybar3p5-3.5 if div3p5 == 3.5
		replace Ybar3p5 = 0 if ybar == 0
		bysort Ybar3p5: gen order3p5 = _n
		bysort Ybar3p5: egen c3p5 = total(c)
		
		gen div1 = (mod(ybar,1)==0)
		gen Ybar1 = sum(div1)-.5
		replace Ybar1 = Ybar1-1 if div1 == 1
		replace Ybar1 = 0 if ybar == 0
		bysort Ybar1: gen order1 = _n
		bysort Ybar1: egen c1 = total(c)
		
		foreach var in ybar Ybar3p5 Ybar1{
			forvalues k = 2/5{
				gen `var'`k' = `var'^`k'
			}
		}
		
		gen r1 = (mod(ybar,1) == 0)
		gen r5 = (mod(ybar,5) == 0)
		gen r10 = (mod(ybar,10) == 0)
		gen r25 = (mod(ybar,25) == 0)
		gen r50 = (mod(ybar,50) == 0)
		gen r100 = (mod(ybar,100) == 0)
		gen r25_3 = (ybar == 8 | ybar == 16 | ybar == 33 | ybar == 41 | ybar == 58 | ybar == 66 | ybar == 83 | ybar == 91 | ybar == 108 | ybar == 116 | ybar == 133 | ybar == 141 | ybar == 158 | ybar == 166 | ybar == 183 | ybar == 191)
		gen r50_3 = (ybar == 16 | ybar == 33 | ybar == 66 | ybar == 83 | ybar == 91 | ybar == 116 | ybar == 133 | ybar == 166 | ybar == 183)
		gen r50_4 = (ybar == 12 | ybar == 37 | ybar == 62 | ybar == 87 | ybar == 112 | ybar == 137 | ybar == 162 | ybar == 187)
		gen rMinWage = (ybar == 724 | ybar ==  362 | ybar ==  241 | ybar ==  181 | ybar ==  788 | ybar ==  394 | ybar ==  262.67 | ybar ==  197)
		
		save ${TreatedData}/`level'Rs_060114_`j'_bin.dta, replace
	}
}

*Cadunico Domicilio for formal1 and formalAll
foreach sel in All 1{
	forvalues j=0/2{
		use ${TreatedData}/raisCadCompleteRs_idHh.dta, clear
		keep if date >= date("1Jun2014","DMY") & below15 == `j' & teens == 0 & formal`sel' == 1
		bysort incomeDomPc: gen c = _N
		bysort incomeDomPc: gen aux = _n
		keep if c == aux & incomeDomPc <1000
		keep incomeDomPc c
		sort incomeDomPc
		gen aux = 100*(income[_n+1]-income)
		replace aux = 1 if aux == .
		expand aux, gen(dup)
		sort income dup
		replace c = 0 if dup == 1
		gen ybar = _n/100-0.01
		keep c ybar
		sort ybar
		
		gen div3p5 = 3.5*(mod(ybar,3.5)==0)
		gen Ybar3p5 = sum(div3)-1.75
		replace Ybar3p5 = Ybar3p5-3.5 if div3p5 == 3.5
		replace Ybar3p5 = 0 if ybar == 0
		bysort Ybar3p5: gen order3p5 = _n
		bysort Ybar3p5: egen c3p5 = total(c)
		
		gen div1 = (mod(ybar,1)==0)
		gen Ybar1 = sum(div1)-.5
		replace Ybar1 = Ybar1-1 if div1 == 1
		replace Ybar1 = 0 if ybar == 0
		bysort Ybar1: gen order1 = _n
		bysort Ybar1: egen c1 = total(c)
		
		foreach var in ybar Ybar3p5 Ybar1{
			forvalues k = 2/5{
				gen `var'`k' = `var'^`k'
			}
		}
		
		gen r1 = (mod(ybar,1) == 0)
		gen r5 = (mod(ybar,5) == 0)
		gen r10 = (mod(ybar,10) == 0)
		gen r25 = (mod(ybar,25) == 0)
		gen r50 = (mod(ybar,50) == 0)
		gen r100 = (mod(ybar,100) == 0)
		gen r25_3 = (ybar == 8 | ybar == 16 | ybar == 33 | ybar == 41 | ybar == 58 | ybar == 66 | ybar == 83 | ybar == 91 | ybar == 108 | ybar == 116 | ybar == 133 | ybar == 141 | ybar == 158 | ybar == 166 | ybar == 183 | ybar == 191)
		gen r50_3 = (ybar == 16 | ybar == 33 | ybar == 66 | ybar == 83 | ybar == 91 | ybar == 116 | ybar == 133 | ybar == 166 | ybar == 183)
		gen r50_4 = (ybar == 12 | ybar == 37 | ybar == 62 | ybar == 87 | ybar == 112 | ybar == 137 | ybar == 162 | ybar == 187)
		gen rMinWage = (ybar == 724 | ybar ==  362 | ybar ==  241 | ybar ==  181 | ybar ==  788 | ybar ==  394 | ybar ==  262.67 | ybar ==  197)
		
		save ${TreatedData}/Dom`sel'Rs_060114_`j'_bin.dta, replace
	}
}

capture log close
