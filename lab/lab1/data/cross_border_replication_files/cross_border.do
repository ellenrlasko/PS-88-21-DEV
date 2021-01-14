*	----------------------------------------------------------------------------*	File Name:   cross_border.do                          *	Author:      Arindrajit Dube, Oeindrila Dube, and Omar Garc’a-Ponce                      *	Date:        March, 2013                         *	Purpose:     Replicate tables & figures from "Cross-Border Spillover: U.S.  
*                Gun Laws and Violence in Mexico." APSR, 2013, 107(3):397-417.                                                                                                      *	Software:    Stata/MP 12.1
*	----------------------------------------------------------------------------

* set global path
* set directory

*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	TABLE I: Descriptive Statistics 
*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------

cap log close
log using "Descriptive_statistics.log", replace

*	--------------------------------------------------
*	Variables from main data set 2002-2006
*	--------------------------------------------------


set more off
clear all
set mem 2g
use "$path/cross_border_main.dta"

*   Panel-level variables 2002-2006
sum pop homicide_pc homdguns_pc nonhomdeath_pc nongunhom_pc rifles_pc rifles_2plus_pc handguns_pc handguns_2plus_pc lexptotalpc ltot4drugs_value_mexp1 lmarijuana_hectaresp1 lpoppy_hectaresp1 ltotal_4drugs_value18 ldeportable18 lport_ave_earn18 port_emp_rat18 if mindist18<=.1 

*   Cross-sectional variables
sum NCAseg18xpost if border==1 & year==2005
sum mindist18 mindistNCA18 negdist18 negdistNCA18 highway lpci_dollarsxpost schoolrat6_24xpost if mindist18<=.1 & year==2005 

*	---------------------------------------------------------
*	Variables from political competition data set 2002-2006
*	---------------------------------------------------------

clear all
set mem 2g
use "$path/cross_border_competition.dta"

sum m_lt_pre_exp m_m_pre_exp m_db_pre_exp m_g_pre_exp nppm0204p if year==2005


*	---------------------------------------
*	Panel-level variables 1992-1996
*	---------------------------------------

clear all
set mem 2g
use "$path/cross_border_1992_1996.dta"

gen homicide_pc = (homicide/pop)*1000
gen homdguns_pc = (homdguns/pop)*1000
sum pop homicide_pc homdguns_pc lexptotalpc2 lmarijuana_area2p1  lpoppy_area2p1 lport_ave_earn18 port_emp_rat18 if mindist18<=.1 & year>=1992 & year<=1996

cap log close

*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	TABLE II: The FAWB Expiration and Violence in Mexican Municipios 
*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------

clear
use "$path/cross_border_main.dta"
tsset muncode year, yearly

*	-----------------------------------
*	PANEL A: Homicides
*	-----------------------------------

	*** NCAseg18 no controls ***
	# delimit; 
	qui xi:  xtpoisson homicide  NCAseg18xpost i.year  if border==1, fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost using table2.xls,  replace  se bdec(3) tdec(3) nocons  nor  noni excel; 
	
	*** NCAseg18 with size and drug, immigration, econonomic controls ***
	# delimit; 
	qui xi:  xtpoisson homicide  NCAseg18xpost i.year  
	lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc 
	ldeportable18  lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18  
	if border==1, fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost using table2.xls,   se bdec(3) tdec(3) nocons  nor  noni excel; 

	*** negdistNCA18 ***
	
	* no control
	# delimit; 
	qui xi:  xtpoisson homicide	negdistNCA18xpost  i.year  if mindist18<=.1, fe vce(robust) exp(pop);	 	 
	outreg2 negdistNCA18xpost   using  table2.xls,  se bdec(3) tdec(3) nocons  nor  noni excel; 
	
	* overall distance control
	# delimit; 
	qui xi:  xtpoisson homicide	negdistNCA18xpost  negdist18xpost i.year   if mindist18<=.1  , fe vce(robust) exp(pop);
	outreg2 negdistNCA18xpost   using  table2.xls,  se bdec(3) tdec(3) nocons  nor  noni excel; 
	
	* negdistNCA18 with additional Income, Immigration and Drugs controls***	
	# delimit; 
	qui xi:  xtpoisson homicide  negdistNCA18xpost negdist18xpost i.year
	lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  
	lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
	if mindist18<=.1, fe vce(robust) exp(pop);
	outreg2 negdistNCA18xpost using  table2.xls, se bdec(3) tdec(3) nocons  nor  noni excel; 

# delimit cr

*	-----------------------------------
*	PANEL B: Gun-related homicides
*	-----------------------------------

	*** NCAseg18 no controls ***
	# delimit; 
	qui xi:  xtpoisson homdguns  NCAseg18xpost i.year  if border==1  , fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost using  table2.xls,   se bdec(3) tdec(3) nocons  nor  noni excel; 
	
	*** NCAseg18 with size and drug, immigration, econonomic controls ***
	# delimit; 
	qui xi:  xtpoisson homdguns  NCAseg18xpost i.year  lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 if border==1  , fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost using table2.xls,   se bdec(3) tdec(3) nocons  nor  noni excel; 
	
	*** negdistNCA18  ***
	
	* no control
	# delimit; 
	qui xi:  xtpoisson homdguns	negdistNCA18xpost  i.year  if mindist18<=.1  , fe vce(robust) exp(pop);
	outreg2 negdistNCA18xpost   using  table2.xls,  se bdec(3) tdec(3) nocons  nor  noni excel; 
	
	* overall distance control
	# delimit; 
	qui xi:  xtpoisson homdguns	negdistNCA18xpost  negdist18xpost i.year   if mindist18<=.1  , fe vce(robust) exp(pop);
	outreg2 negdistNCA18xpost   using  table2.xls,  se bdec(3) tdec(3) nocons  nor  noni excel; 
	
	*** negdistNCA18 with additional Income, Immigration and Drugs controls***	
	# delimit; 
	qui xi:  xtpoisson homdguns negdistNCA18xpost negdist18xpost i.year
	lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
	if mindist18<=.1  , fe vce(robust) exp(pop);
	outreg2 negdistNCA18xpost using  table2.xls, se bdec(3) tdec(3) nocons  nor  noni excel; 

# delimit cr


*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	TABLE III: The FAWB Expiration and Violence - Quarterly Effects
*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------

clear all
use "$path/cross_border_quarterly.dta"
tsset muncode qid


* interpolating controls at quarterly level 
local vlist "lport_ave_earn18  port_emp_rat18  lexptotalpc ldeportable18  lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1 ltotal_4drugs_value18"
 
foreach v of local vlist {
	rename `v' `v'_old
	g `v' = `v'_old if quarter==1
	replace `v' = L.`v' + (1/4)*(F3.`v' - L.`v') if quarter==2
	replace `v' = L2.`v' + (2/4)*(F2.`v' - L2.`v') if quarter==3
	replace `v' = L3.`v' + (3/4)*(F1.`v' - L3.`v') if quarter==4
}


forval j = 1/4 {
	g F`j'negdistNCA18xpost = F`j'.negdistNCA18xpost
	g L`j'negdistNCA18xpost = L`j'.negdistNCA18xpost 
}

 
*	-----------------------------------
*	PANEL A: Homicides
*	-----------------------------------

	*** negdistNCA18 : controlling for overall distance ***
	
	qui xi:  xtpoisson homicide 	negdistNCA18xpost negdist18xpost i.qid  ///
	  if mindist18<=.1 & qid >=12 & qid<=27, fe vce(robust) exp(pop)
	
	outreg2 negdistNCA18xpost using  table3_quarters.xls, se bdec(3) tdec(3) nocons  nor  noni excel replace
	
	
 	*** negdistNCA18 with (imputed) Income, Immigration and Drugs controls ***	
	 qui xi:  xtpoisson homicide  negdistNCA18xpost negdist18xpost i.qid ///
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  ///
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 ///
	 if mindist18<=.1 &  qid>=12 & qid <=27 , fe vce(robust) exp(pop)
	
	outreg2 negdistNCA18xpost using  table3_quarters.xls, se bdec(3) tdec(3) nocons  nor  noni excel 


	*** leads/lags in negdistNCA18 with (imputed) Income, Immigration and Drugs controls ***	

 	qui xi: xtpoisson homicide  F*negdistNCA18xpost negdistNCA18xpost L*negdistNCA18xpost negdist18xpost   i.qid ///
	lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  ///
	lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 ///
 	i.qid if mindist18<=.1 &  qid>=12 & qid <=27 , fe vce(robust) exp(pop)

 	outreg2 F4negdistNCA18xpost F3negdistNCA18xpost F2negdistNCA18xpost F1negdistNCA18xpost negdistNCA18xpost ///
 	L1negdistNCA18xpost L2negdistNCA18xpost L3negdistNCA18xpost L4negdistNCA18xpost ///
 	using  table3_quarters.xls, se bdec(3) tdec(3) nocons  nor  noni excel

*	-----------------------------------
*	PANEL B: Gun-related Homicides
*	-----------------------------------

	*** negdistNCA18 with mindist18<.1 : controlling for overall distance ***
	
	 qui xi:  xtpoisson homdguns 	negdistNCA18xpost negdist18xpost i.qid  ///
	 if mindist18<=.1 & qid >=12 & qid<=27, fe vce(robust) exp(pop)
	
	outreg2 negdistNCA18xpost using  table3_quarters.xls, se bdec(3) tdec(3) nocons  nor  noni excel
	
 	*** negdistNCA18 with Full set (imputed) Income, Immigration and Drugs controls***	
	 qui xi:  xtpoisson homdguns  negdistNCA18xpost negdist18xpost i.qid ///
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  ///
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 ///
	 if mindist18<=.1 &  qid>=12 & qid <=27 , fe vce(robust) exp(pop)
	
	outreg2 negdistNCA18xpost using  table3_quarters.xls, se bdec(3) tdec(3) nocons  nor  noni excel 

	*** leads/lags in negdistNCA18 with (imputed) Income, Immigration and Drugs controls***	

 	qui xi: xtpoisson homdguns  F*negdistNCA18xpost negdistNCA18xpost L*negdistNCA18xpost negdist18xpost   i.qid ///
	lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  ///
	lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 ///
 	i.qid if mindist18<=.1 &  qid>=12 & qid <=27 , fe vce(robust) exp(pop)

 	outreg2 F4negdistNCA18xpost F3negdistNCA18xpost F2negdistNCA18xpost F1negdistNCA18xpost negdistNCA18xpost ///
 	L1negdistNCA18xpost L2negdistNCA18xpost L3negdistNCA18xpost L4negdistNCA18xpost ///
 	using  table3_quarters.xls, se bdec(3) tdec(3) nocons  nor  noni excel


*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	TABLE IV: The FAWB Expiration and Gun Seizures 
*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------

clear all
set mem 2g
use "$path/cross_border_main.dta"
tsset muncode year, yearly

# delimit; 
	 qui xi:  xtpoisson rifles negdistNCA18xpost negdist18xpost  i.year  
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18  
	 if mindist18<=.1  , fe vce(robust) exp(pop);
	 outreg2 negdistNCA18xpost     using table4_guns.xls, replace se bdec(3) tdec(3) nocons  nor  noni excel; 
# delimit; 
foreach var of varlist  rifles_2plus  handguns handguns_2plus {; 
	 qui xi:  xtpoisson `var' negdistNCA18xpost negdist18xpost  i.year   
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
	 if mindist18<=.1  , fe vce(robust) exp(pop);
	 outreg2 negdistNCA18xpost     using table4_guns.xls, se bdec(3) tdec(3) nocons  nor  noni excel; 
	}; 

# delimit cr 


*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	TABLE V: The 1994 FAWB Passage and Violence in Mexican Municipios
*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------

clear all
set mem 2g
use "$path/cross_border_1992_1996.dta"
tsset muncode year, yearly
 


*	-----------------------------------
*	PANEL A: Homicides
*	-----------------------------------

	*** NCAseg18 no controls ***
	# delimit;
	qui xi:  xtpoisson homicide  NCAseg18xpost i.year  if border==1 , fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost using  table5_earlyperiod.xls, replace se bdec(3) tdec(3) nocons  nor  noni excel; 
	*** NCAseg18 income and drug controls ***
	# delimit;
	qui xi:  xtpoisson homicide  NCAseg18xpost i.year 
	lexptotalpc2  lport_ave_earn18 port_emp_rat18
	lmarijuana_area2p1 lpoppy_area2p1  
	if border==1 , fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost using  table5_earlyperiod.xls,  se bdec(3) tdec(3) nocons  nor  noni excel; 
	
	*** negdistNCA18 ***
	
	* no controls
	# delimit;
	qui xi:  xtpoisson homicide	negdistNCA18xpost  i.year  if mindist18<=.1 , fe vce(robust) exp(pop);
	outreg2 negdistNCA18xpost   using  table5_earlyperiod.xls,  se bdec(3) tdec(3) nocons  nor  noni excel; 
	
	* controlling for overall distance 
	# delimit;
	qui xi:  xtpoisson homicide	negdistNCA18xpost negdist18xpost i.year  if mindist18<=.1 , fe vce(robust) exp(pop);
	outreg2 negdistNCA18xpost  using  table5_earlyperiod.xls,  se bdec(3) tdec(3) nocons  nor  noni excel; 
	
	* income and drug controls 
	# delimit;
	qui xi:  xtpoisson homicide	negdistNCA18xpost  negdist18xpost 
	lexptotalpc2  lport_ave_earn18 port_emp_rat18
	lmarijuana_area2p1 lpoppy_area2p1  
	if mindist18<=.1 , fe vce(robust) exp(pop);
	outreg2 negdistNCA18xpost  using  table5_earlyperiod.xls,  se bdec(3) tdec(3) nocons  nor  noni excel; 

# delimit cr
	 
*	-----------------------------------
*	PANEL B: Gun-related Homicides
*	-----------------------------------
 
	*** NCAseg18 no controls ***
	
	# delimit;
	qui xi:  xtpoisson homdguns  NCAseg18xpost i.year  if border==1 , fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost using  table5_earlyperiod.xls,  se bdec(3) tdec(3) nocons  nor  noni excel; 
	
	*** NCAseg18 w/ income and drug controls ***
	# delimit;
	qui xi:  xtpoisson homdguns  NCAseg18xpost i.year 
	lexptotalpc2  lport_ave_earn18 port_emp_rat18
	lmarijuana_area2p1 lpoppy_area2p1  
	if border==1 , fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost using  table5_earlyperiod.xls,  se bdec(3) tdec(3) nocons  nor  noni excel; 
	
	*** negdistNCA18 ***
	
	* no controls 
	
	# delimit;
	qui xi:  xtpoisson homdguns	negdistNCA18xpost  i.year  if mindist18<=.1 , fe vce(robust) exp(pop);
	outreg2 negdistNCA18xpost   using  table5_earlyperiod.xls,  se bdec(3) tdec(3) nocons  nor  noni excel; 
	
	* controlling for overall distance 
	# delimit;
	qui xi:  xtpoisson homdguns	negdistNCA18xpost negdist18xpost i.year  if mindist18<=.1 , fe vce(robust) exp(pop);
	outreg2 negdistNCA18xpost  using  table5_earlyperiod.xls,  se bdec(3) tdec(3) nocons  nor  noni excel; 
	
	* income and drug controls 
	# delimit;
	qui xi:  xtpoisson homdguns	negdistNCA18xpost  negdist18xpost 
	lexptotalpc2  lport_ave_earn18 port_emp_rat18
	lmarijuana_area2p1 lpoppy_area2p1  
	if mindist18<=.1 , fe vce(robust) exp(pop);
	outreg2 negdistNCA18xpost  using  table5_earlyperiod.xls,  se bdec(3) tdec(3) nocons  nor  noni excel; 

# delimit cr
	
*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	TABLE VI: Heterogeneous Effects by Elec. Competition and Drug Trafficking 
*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------

clear all
set mem 2g
use "$path/cross_border_competition.dta"
tsset muncode year, yearly
 

# delimit; 
foreach var of varlist homicide homdguns {; 

	* FULL SAMPLE 
	# delimit; 	
	qui xi:  xtpoisson  `var'  negdistNCA18xpost  negdist18xpost i.year 
	negdistNCA18xpostxm_lt_pre_exp  postxm_lt_pre_exp	negdist18xpostxm_lt_pre_exp
	if mindist18<=.1  , fe vce(robust) exp(pop); 
	outreg2  negdistNCA18xpost  negdistNCA18xpostxm_lt_pre_exp   using table6_comp_`var'.xls, replace se bdec(3) tdec(3) nocons  nor  noni excel; 

	* DRUG SAMPLE
	# delimit; 
	qui xi:  xtpoisson  `var'  negdistNCA18xpost  negdist18xpost i.year
	negdistNCA18xpostxm_lt_pre_exp  postxm_lt_pre_exp	negdist18xpostxm_lt_pre_exp
	if mindist18<=.1   & nppm0204p==1, fe vce(robust) exp(pop); 
	outreg2  negdistNCA18xpost  negdistNCA18xpostxm_lt_pre_exp  using table6_comp_`var'.xls, se bdec(3) tdec(3) nocons  nor  noni excel; 
	
** LT - MOLINAR - DB - GOLOSOV --- WITH CONTROLS 

	# delimit;
	local comp2 "m_lt_pre_exp m_m_pre_exp m_db_pre_exp m_g_pre_exp";

	foreach y of local comp2 {; 

	* FULL SAMPLE
	
	# delimit; 	
	qui xi:  xtpoisson  `var'  negdistNCA18xpost  negdist18xpost i.year 
	negdistNCA18xpostx`y'   postx`y'	negdist18xpostx`y'
	lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18	
	lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18
	if mindist18<=.1  , fe vce(robust) exp(pop); 
	outreg2  negdistNCA18xpost  negdistNCA18xpostx`y'   using table6_comp_`var'.xls, se bdec(3) tdec(3) nocons  nor  noni excel; 
 
	* DRUG SAMPLE
	
	# delimit; 	
	qui xi:  xtpoisson  `var'  negdistNCA18xpost  negdist18xpost i.year 
	negdistNCA18xpostx`y'   postx`y'	negdist18xpostx`y'
	lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18	
	lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18
	if mindist18<=.1   & nppm0204p==1, fe vce(robust) exp(pop); 
	outreg2  negdistNCA18xpost  negdistNCA18xpostx`y'   using table6_comp_`var'.xls, se bdec(3) tdec(3) nocons  nor  noni excel; 
		}; 
	}; 

# delimit cr

*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	FIGURE I: Political Competition over Time 
*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------



clear all
set mem 2g
use "$path/figure1_data.dta"

egen mean_lt = mean(lt_index) , by(year)
egen yeartag = tag(year)

twoway line mean_lt year if yeartag==1 & year>=1990 & year<=2010, /// 
xtitle("Year") ytitle("Mean Effective Numer of Parties - LT Index") xline(1994 2004, lpat(dash) lcolor(black)) ylabel(1.25(.25)2.5) /// 
xaxis(1,2) xlabel(1994 "FAWB Passage" 2004 "FAWB Expiration", axis(2)) xtitle("" , axis(2)) ///
lcolor(blue) lw(thick)  graphregion(fcolor(white)) scheme(s1mono)

graph save Figure1_political_competition_over_time.gph, replace



*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	FIGURE IV: Violence in Municipios Bordering CA vs Other Border States
*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------

clear all
set mem 2g
use "$path/cross_border_main.dta"

keep if border==1  

collapse (sum) homicide homdguns nongunhom suicdguns , by(NCAseg18 year)

* Graph
#delimit;
twoway 
line homicide year if NCAseg18==0, lcolor(blue) lpattern(-.-) lwidth(thick) ||
line homicide year if NCAseg18==1, lcolor(cranberry) lpattern(.) lwidth(thick)
graphregion(color(white)) legend(region(color(white)) col(3) order(1 "CA" 2 "AZ, NM, TX")) 
xline(2004, lcolor(gray) lpattern(-)) ylabel(, angle(0)) scale(1) ylabel(0(100)700)
xtitle("Year") ytitle("Count") aspect(1.0) title("All Homicides", margin(medsmall)) name(homds, replace);


twoway 
line homdguns year if NCAseg18==0, lcolor(blue) lpattern(-.-) lwidth(thick) ||
line homdguns year if NCAseg18==1, lcolor(cranberry) lpattern(.) lwidth(thick)
graphregion(color(white)) legend(region(color(white)) col(3) order(1 "CA" 2 "AZ, NM, TX")) 
xline(2004, lcolor(gray) lpattern(-)) ylabel(, angle(0)) scale(1) ylabel(0(100)700)
xtitle("Year") ytitle("Count") aspect(1.0) title("Gun-related Homicides", margin(medsmall)) name(homdguns, replace);

graph combine homds homdguns;

#delimit;
twoway 
line nongunhom year if NCAseg18==0, lcolor(blue) lpattern(-.-) lwidth(thick) ||
line nongunhom year if NCAseg18==1, lcolor(cranberry) lpattern(.) lwidth(thick)
graphregion(color(white)) legend(region(color(white)) col(3) order(1 "CA" 2 "AZ, NM, TX")) 
xline(2004, lcolor(gray) lpattern(-)) ylabel(, angle(0)) scale(1) ylabel(0(100)700)
xtitle("Year") ytitle("Count") aspect(1.0) title("Non-gun Homicides", margin(medsmall))name(nongunhom, replace);

#delimit;
twoway 
line suicdguns year if NCAseg18==0, lcolor(blue) lpattern(-.-) lwidth(thick) ||
line suicdguns year if NCAseg18==1, lcolor(cranberry) lpattern(.) lwidth(thick)
graphregion(color(white)) legend(region(color(white)) col(3) order(1 "CA" 2 "AZ, NM, TX")) 
xline(2004, lcolor(gray) lpattern(-)) ylabel(, angle(0)) scale(1) ylabel(0(100)700)
xtitle("Year") ytitle("Count") aspect(1.0) title("Gun-related Suicides", margin(medsmall)) name(suicdguns, replace);


graph combine homds homdguns nongunhom suicdguns, col(2) iscale(0.4);
graph save Figure4_violence_by_border_segment.gph, replace; 


# delimit cr

*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	FIGURE V: Time Paths of Violence Using Annual and Quarterly Data
*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------


*	------------------------------------
*	PANEL A: Effect by Year
*	------------------------------------ 

clear all
set mem 2g
use "$path/cross_border_main.dta"

	keep if mindist18<=.1
	
 	xi i.year*negdistNCA18 , pre(_yin) noomit

	xi:  xtpoisson homicide  _yinyeaXneg_2002 _yinyeaXneg_2003 _yinyeaXneg_2005 _yinyeaXneg_2006 negdist18xpost lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost ///
	schoolrat6_24xpost lexptotalpc ldeportable18  lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1 ///
	ltotal_4drugs_value18 i.year if mindist18<=.1  , fe vce(robust) exp(pop)
 
	mat b = e(b)
	mat V = e(V)
	
	mat mymat1 = [ b[1,1] \ b[1,2] \ 0 \ b[1,3] \ b[1,4] ]
	mat mymat_full = [mymat1, [sqrt(V[1,1]) \ sqrt(V[2,2]) \ 0 \ sqrt(V[3,3]) \ sqrt(V[4,4]) ]]

	mat list mymat_full
	
	xi:  xtpoisson homdguns  _yinyeaXneg_2002 _yinyeaXneg_2003 _yinyeaXneg_2005 _yinyeaXneg_2006 negdist18xpost lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost ///
	schoolrat6_24xpost lexptotalpc ldeportable18  lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1 ///
	 ltotal_4drugs_value18 i.year if mindist18<=.1  , fe vce(robust) exp(pop)

	mat b = e(b)
	mat V = e(V)
	
	mat mymat2 = [ b[1,1] \ b[1,2] \ 0 \ b[1,3] \ b[1,4] ]
	mat mymat_full = [mymat_full, mymat2, [sqrt(V[1,1]) \ sqrt(V[2,2]) \ 0 \ sqrt(V[3,3]) \ sqrt(V[4,4]) ]]
	
	mat list mymat_full

* eliminate dataset from active memory and create dataset of regression coefficients to plot in the figure
drop _all
svmat mymat_full
desc
 rename mymat_full1 homicide
 rename mymat_full2 homicide_se
 rename mymat_full3 homdguns
 rename mymat_full4 homdguns_se
 g homicide_ub = homicide + homicide_se*1.96
 g homicide_lb = homicide - homicide_se*1.96
 g homdguns_ub = homdguns + homdguns_se*1.96
 g homdguns_lb = homdguns - homdguns_se*1.96

g year = 2001 + _n

sort year

twoway line homicide year, lcolor(blue) || line homicide_ub year, lcolor(blue) lpat(dash) || line homicide_lb year, lcolor(blue) lpat(dash) /// 
saving(Figure5_PanelA_homicide_annual_effect.gph, replace) legend(off) graphregion( color(white)) xsize(3) ysize(3) title("") xtitle("Year") ytitle("Homicides") ///
xline(2004,lcolor(black) lpat(dash)) name(homdsyear, replace) aspect(0.8)

twoway line homdguns year, lcolor(blue) || line homdguns_ub year, lcolor(blue) lpat(dash) || line homdguns_lb year, lcolor(blue) lpat(dash) ///
saving(Figure5_PanelA_gun_homicide_annual_effect.gph, replace) legend(off) graphregion( color(white)) xsize(3) ysize(3) title("") xtitle("Year") ytitle("Gun Related Homicides") ///
xline(2004,lcolor(black) lpat(dash)) name(homdgunsyear, replace) aspect(0.8)

graph combine homdsyear homdgunsyear
graph save Figure5_PanelA_annual_effect.gph, replace


 
*	------------------------------------
*	PANEL B: Quarter Time Shift Placebos
*	------------------------------------ 


clear all
set mem 1800m 
set more off

use "$path/cross_border_quarterly.dta"

tsset muncode qid
cap drop negdistNCA18xpost2
cap drop negdist18xpost2

gen negdistNCA18xpost2 = negdistNCA18xpost
gen negdist18xpost2 = negdist18xpost
 
* interpolating controls at quarterly level 
local vlist "lport_ave_earn18  port_emp_rat18 lexptotalpc ldeportable18  lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1 ltotal_4drugs_value18"

foreach v of local vlist {
	rename `v' `v'_old
	g `v' = `v'_old if quarter==1
	replace `v' = L.`v' + (1/4)*(F3.`v' - L.`v') if quarter==2
	replace `v' = L2.`v' + (2/4)*(F2.`v' - L2.`v') if quarter==3
	replace `v' = L3.`v' + (3/4)*(F1.`v' - L3.`v') if quarter==4
}
 
 xi: xtpoisson homicide  D.L(-4/3).negdistNCA18xpost2 L4.negdistNCA18xpost2 negdist18xpost2 i.qid lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost ///
 schoolrat6_24xpost lexptotalpc ldeportable18  lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1 ///
  ltotal_4drugs_value18 i.year if mindist18<=.1 &  qid>=12 & qid <=27 , fe vce(robust) exp(pop)
  
	mat b = e(b)
	mat V = e(V)
	
	mat mymat1 = [b[1,1], sqrt(V[1,1])]
	
	forval j = 2/9 {
	 mat mymat1 = mymat1\[b[1,`j'], sqrt(V[`j',`j'])]
	}
 
 xi: xtpoisson homdguns  D.L(-4/3).negdistNCA18xpost2 L4.negdistNCA18xpost2 negdist18xpost2 i.qid lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost ///
 schoolrat6_24xpost lexptotalpc ldeportable18  lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1 ///
  ltotal_4drugs_value18 i.year if mindist18<=.1 &  qid>=12 & qid <=27 , fe vce(robust) exp(pop)
 

	mat b = e(b)
	mat V = e(V)
	
	mat mymat2 = [b[1,1], sqrt(V[1,1])]
	
	forval j = 2/9 {
	 mat mymat2 = mymat2\[b[1,`j'], sqrt(V[`j',`j'])]
	}
 
mat mymat = [mymat1, mymat2]


drop _all
svmat mymat
desc
 rename mymat1 homicide
 rename mymat2 homicide_se
 rename mymat3 homdguns
 rename mymat4 homdguns_se
 
 g homicide_ub = homicide + homicide_se*1.96
 g homicide_lb = homicide - homicide_se*1.96
 g homdguns_ub = homdguns + homdguns_se*1.96
 g homdguns_lb = homdguns - homdguns_se*1.96

g quarter = -5 + _n

sort quarter

label define qtrlab -4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4+"

label values quarter qtrlab

 twoway line homicide quarter, lcolor(blue) lwidth(medthick) || ///
 line homicide_ub quarter, lcolor(blue) lpat(dash) lwidth(medthick) || /// 
 line homicide_lb quarter, lcolor(blue) lpat(dash) lwidth(medthick) xline(0,lcolor(black) lpat(dash))  /// 
 legend(off) xtitle(Quarters since Policy Change) ///
 ytitle(Homicides) graphregion( fcolor(white)) xsize(3) ysize(3) plotregion(lcolor(black)) ///
 xlabel(-4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4+") name(left) aspect(0.8)

 twoway line homdguns quarter, lcolor(blue) lwidth(medthick) || ///
 line homdguns_ub quarter, lcolor(blue) lpat(dash) lwidth(medthick) || ///
 line homdguns_lb quarter, lcolor(blue) lpat(dash) lwidth(medthick) xline(0,lcolor(black) lpat(dash))  ///
 legend(off) xtitle(Quarters since Policy Change) ///
 ytitle(Gun-related Homicides) graphregion( fcolor(white)) xsize(3) ysize(3) plotregion(lcolor(black)) ///
 xlabel(-4 "-4" -3 "-3" -2 "-2" -1 "-1" 0 "0" 1 "1" 2 "2" 3 "3" 4 "4+") name(right) aspect(0.8)

graph combine left right
graph save Figure5_PanelB_quarterly.gph, replace


*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	FIGURE VI: Estimated Additional Deaths by Electoral Competition
*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------

clear all
set mem 2g
use "$path/cross_border_competition.dta"
tsset muncode year, yearly
 

*** HOMICIDE
	xi:  xtpoisson  homicide negdistNCA18xpost  negdist18xpost i.year ///
	negdistNCA18xpostxm_lt_pre_exp   postxm_lt_pre_exp	negdist18xpostxm_lt_pre_exp ///
	lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18	///
	lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 ///
	if mindist18<=.1  , fe vce(robust) exp(pop) 
	
	
	foreach j in -1 -0.5 0 0.5 1 {
	 	lincom negdistNCA18xpost + negdistNCA18xpostxm_lt_pre_exp*`j'*.41 
	  local b = r(estimate)
	  local lb = r(estimate) - r(se)*1.96
	  local ub = r(estimate) + r(se)*1.96
	  
	  scalar n = 1153 - 1153/[ 1 + 0.43*(exp(`b'/10) -1) ] 
	  scalar nlb = 1153 - 1153/[ 1 + 0.43*(exp(`lb'/10) -1) ] 
	  scalar nub = 1153 - 1153/[ 1 + 0.43*(exp(`ub'/10) -1) ] 
	  	  
	  	  
	  if `j' == -1 {
	  	matrix lincommat = [`j', n, nlb, nub]
	  }
	  else {
	  	matrix lincommat = [lincommat \ [`j', n, nlb, nub] ]
	  }
	
   }	 
   
   matrix list lincommat

* Save matrix   
svmat lincommat, names(homds)
rename homds1 LTsd_homds
rename homds2 homds
rename homds3 homdsLB
rename homds4 homdsUB  
 
*** GUN HOMICIDES
	xi:  xtpoisson  homdguns negdistNCA18xpost  negdist18xpost i.year ///
	negdistNCA18xpostxm_lt_pre_exp   postxm_lt_pre_exp	negdist18xpostxm_lt_pre_exp ///
	lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18	///
	lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 ///
	if mindist18<=.1  , fe vce(robust) exp(pop) 
	
	foreach j in -1 -0.5 0 0.5 1 {
	 	lincom negdistNCA18xpost + negdistNCA18xpostxm_lt_pre_exp*`j'*.41 
	  local b = r(estimate)
	  local lb = r(estimate) - r(se)*1.96
	  local ub = r(estimate) + r(se)*1.96
	  
	  scalar n = 738 - 738/[ 1 + 0.43*(exp(`b'/10) -1) ] 
	  scalar nlb = 738 - 738/[ 1 + 0.43*(exp(`lb'/10) -1) ] 
	  scalar nub = 738 - 738/[ 1 + 0.43*(exp(`ub'/10) -1) ] 
	  	  
	  	  
	  if `j' == -1 {
	  	matrix lincommat = [`j', n, nlb, nub]
	  }
	  else {
	  	matrix lincommat = [lincommat \ [`j', n, nlb, nub] ]
	  }
	
   }	 
   
   matrix list lincommat

	 
* Save matrix 
svmat lincommat, names(hguns)
rename hguns1 LTsd_hguns
rename hguns2 hguns
rename hguns3 hgunsLB
rename hguns4 hgunsUB 
	 

* To generate graph
keep hguns* homds* LTsd*
drop if hguns==. 

#delimit;
twoway 
rcap homdsUB homdsLB LTsd_homds, lcolor(gray) lwidth(medthick)  || 
scatter homds LTsd_homds, mcolor(black)
graphregion(color(white)) legend(off) 
ylabel(-400(200)600, angle(0)) scale(0.8) xlabel(-1(0.5)1)
xtitle("LT index Std. Dev.") ytitle("Estimated Additional Deaths") aspect(0.8) title("Homicides", margin(large)) name(Figure6_homicide, replace);
;

twoway 
rcap hgunsUB hgunsLB LTsd_hguns, lcolor(gray) lwidth(medthick) || 
scatter hguns LTsd_hguns, mcolor(black)
graphregion(color(white)) legend(off)
ylabel(-400(200)600, angle(0)) scale(0.8) xlabel(-1(0.5)1)
xtitle("LT index Std. Dev.") ytitle("Estimated Additional Deaths") aspect(0.8) title("Gun-related Homicides", margin(large)) name(Figure6_gun_homicides, replace);
;

graph combine Figure6_homicide Figure6_gun_homicides; 

# delimit cr

graph save Figure6_competition_interaction_effects.gph, replace



	**************************************************
	***************** A P P E N D I X ****************
	**************************************************

*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	TABLE A2: The FAWB Expiration and Violence across Demographic Groups
*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------

clear all
use "$path/cross_border_appendix.dta"
tsset muncode year, yearly


set more off
# delimit; 
	 xi: xtpoisson homicidenm negdistNCA18xpost negdist18xpost   i.year 
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
	 if mindist18<=.1  , fe vce(robust) exp(pop);
	outreg2 negdistNCA18xpost using tableA2_subgroups.xls, replace se bdec(3) tdec(3) nocons  nor  noni excel; 
	
# delimit; 
foreach var of varlist nhs18_homd notnhs18_homd men1830_nhs_homd  notmen1830_nhs_homd {; 
	 xi:  xtpoisson `var' 	negdistNCA18xpost negdist18xpost  i.year 
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
   if mindist18<=.1  , fe vce(robust) exp(pop);
	outreg2 negdistNCA18xpost using tableA2_subgroups.xls, se bdec(3) tdec(3) nocons  nor  noni excel; 
	}; 

foreach var of varlist homdgunsnm nhs18_hguns notnhs18_hguns men1830_nhs_hguns notmen1830_nhs_hguns {; 
	 xi:  xtpoisson `var' 	negdistNCA18xpost negdist18xpost   i.year 
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18   
	 if mindist18<=.1  , fe vce(robust) exp(pop);
	outreg2 negdistNCA18xpost using tableA2_subgroups.xls, se bdec(3) tdec(3) nocons  nor  noni excel; 
	};

# delimit cr 


*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	TABLE A3: Robustness Checks using the Proximity Specification 
*	----------------------------------------------------------------------------
*	---------------------------------------------------------------------------- 

clear all
use "$path/cross_border_appendix.dta"
tsset muncode year, yearly

local outcomes "homicide homdguns" 
set more off

# delimit; 
foreach out of local outcomes {; 
	***  1  repeat baseline 
	# delimit; 
	 xi:  xtpoisson `out'  negdistNCA18xpost negdist18xpost   i.year 
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18    
	 if mindist18<=.1  , fe vce(robust) exp(pop);
	outreg2  negdistNCA18xpost negdist18xpost  using tableA3_robustness_proximity_`out'.xls,  replace se bdec(3) tdec(3) nocons  nor  noni   excel; 
	***  2 negative binomial specification
	# delimit; 
	xi:  xtnbreg `out' negdistNCA18xpost negdist18xpost i.year 
	lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  
	lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
	if mindist18<=.1  , fe exp(pop); 	 
	outreg2  negdistNCA18xpost negdist18xpost  using tableA3_robustness_proximity_`out'.xls,  se bdec(3) tdec(3) nocons  nor  noni   excel; 
	***  3  post vs. i.year
	# delimit; 
	 xi:  xtpoisson `out'  negdistNCA18xpost negdist18xpost   post  
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18  
	 if mindist18<=.1  , fe vce(robust) exp(pop);
	outreg2  negdistNCA18xpost negdist18xpost  using tableA3_robustness_proximity_`out'.xls,  se bdec(3) tdec(3) nocons  nor  noni   excel; 
	
	***  4  with port and linear time trends 
	# delimit; 
	 xi:  xtpoisson `out'  negdistNCA18xpost negdist18xpost  post negdistNCA18year negdist18year 
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
	 if mindist18<=.1  , fe vce(robust) exp(pop);
	outreg2  negdistNCA18xpost negdist18xpost  using tableA3_robustness_proximity_`out'.xls,   se bdec(3) tdec(3) nocons  nor  noni   excel; 
	***  5  highway restriction
	# delimit; 
	 xi:  xtpoisson `out'  negdistNCA18xpost negdist18xpost  i.year
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18   
	 if mindist18<=.1   & highway==1, fe vce(robust) exp(pop);
	outreg2  negdistNCA18xpost negdist18xpost   using tableA3_robustness_proximity_`out'.xls, se bdec(3) tdec(3) nocons  nor  noni   excel;  
	***  6  control for non-hom death and nongunhom ***
	 # delimit; 
	 xi:  xtpoisson `out'  negdistNCA18xpost negdist18xpost  i.year  
	 nongunhom  nonhomdeath
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
	 if mindist18<=.1  , fe vce(robust) exp(pop);
	 outreg2  negdistNCA18xpost negdist18xpost   nonhomdeath nongunhom using tableA3_robustness_proximity_`out'.xls, se bdec(3) tdec(3) nocons  nor  noni  excel;  
	***  7  adding enforcement 
	# delimit; 
	 xi:  xtpoisson `out'  negdistNCA18xpost negdist18xpost   i.year 
	 detainees_drugwarpc port_enfpc18 
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18   
	 if mindist18<=.1  , fe vce(robust) exp(pop);
	outreg2  negdistNCA18xpost negdist18xpost   nonhomdeath nongunhom using tableA3_robustness_proximity_`out'.xls, se bdec(3) tdec(3) nocons  nor  noni  excel;  
}; 

# delimit cr 


clear all
use "$path/cross_border_appendix.dta"
tsset muncode year, yearly
local outcomes "nongunhom" 
set more off

# delimit; 
foreach out of local outcomes {; 
	***  1  repeat baseline 
	# delimit; 
	 xi:  xtpoisson `out'  negdistNCA18xpost negdist18xpost  i.year 
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18    
	 if mindist18<=.1  , fe vce(robust) exp(pop);
	outreg2  negdistNCA18xpost negdist18xpost  using tableA3_robustness_proximity_`out'.xls,  replace se bdec(3) tdec(3) nocons  nor  noni   excel; 
	***  2 negative binomial specification
	# delimit; 
	xi:  xtnbreg `out' negdistNCA18xpost negdist18xpost i.year 
	lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  
	lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 if mindist18<=.1  , fe exp(pop); 
	outreg2  negdistNCA18xpost negdist18xpost  using tableA3_robustness_proximity_`out'.xls,  se bdec(3) tdec(3) nocons  nor  noni   excel; 
	***  3  post vs. i.year
	# delimit; 
	 xi:  xtpoisson `out'  negdistNCA18xpost negdist18xpost  post  
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18  
	 if mindist18<=.1  , fe vce(robust) exp(pop);
	outreg2  negdistNCA18xpost negdist18xpost  using tableA3_robustness_proximity_`out'.xls,  se bdec(3) tdec(3) nocons  nor  noni   excel; 
	***  4  with port and linear time trends 
	# delimit; 
	 xi:  xtpoisson `out'  negdistNCA18xpost negdist18xpost post negdistNCA18year negdist18year 
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
	 if mindist18<=.1  , fe vce(robust) exp(pop);
	outreg2  negdistNCA18xpost negdist18xpost  using tableA3_robustness_proximity_`out'.xls,   se bdec(3) tdec(3) nocons  nor  noni   excel; 
	***  5  highway restriction
	# delimit; 
	 xi:  xtpoisson `out'  negdistNCA18xpost negdist18xpost  i.year
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18   
	 if mindist18<=.1   & highway==1, fe vce(robust) exp(pop);
	outreg2  negdistNCA18xpost negdist18xpost   using tableA3_robustness_proximity_`out'.xls, se bdec(3) tdec(3) nocons  nor  noni   excel;  

	
	***  7  adding enforcement 
	# delimit; 
	 xi:  xtpoisson `out'  negdistNCA18xpost negdist18xpost   i.year 
	 detainees_drugwarpc port_enfpc18 
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18   
	 if mindist18<=.1  , fe vce(robust) exp(pop);
	outreg2  negdistNCA18xpost negdist18xpost   nonhomdeath nongunhom using tableA3_robustness_proximity_`out'.xls, se bdec(3) tdec(3) nocons  nor  noni  excel;  
};

# delimit cr

*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	TABLE A4: Robustness Checks using the Segment Specification 
*	----------------------------------------------------------------------------
*	---------------------------------------------------------------------------- 


clear all
use "$path/cross_border_appendix.dta"
tsset muncode year, yearly

local outcomes "homicide homdguns" 
set more off

# delimit; 
foreach out of local outcomes {; 
	***  1  repeat baseline 
	# delimit; 
	 xi:  xtpoisson `out'  NCAseg18xpost   i.year 
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18    
	if border==1  , fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost  using tableA4_robustness_segment_`out'.xls,  replace se bdec(3) tdec(3) nocons  nor  noni   excel; 
	***  2 negative binomial specification
	# delimit; 
	xi:  xtnbreg `out' NCAseg18xpost i.year 
	lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  
	lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
	if border==1  , fe exp(pop); 
	outreg2  NCAseg18xpost  using tableA4_robustness_segment_`out'.xls,  se bdec(3) tdec(3) nocons  nor  noni   excel; 
	***  3  post vs.  i.year   
	# delimit; 
	 xi:  xtpoisson `out'  NCAseg18xpost   post  
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18  
	if border==1  , fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost  using tableA4_robustness_segment_`out'.xls,  se bdec(3) tdec(3) nocons  nor  noni   excel; 
	***  4  with port and linear time trends 
		# delimit; 
	 xi:  xtpoisson `out'  NCAseg18xpost  post NCAseg18year
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
	if border==1  , fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost  using tableA4_robustness_segment_`out'.xls,   se bdec(3) tdec(3) nocons  nor  noni   excel; 
	***  5  highway restriction
	# delimit; 
	 xi:  xtpoisson `out'  NCAseg18xpost  i.year
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18   
	if border==1   & highway==1, fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost   using tableA4_robustness_segment_`out'.xls, se bdec(3) tdec(3) nocons  nor  noni   excel; 
	***  6  control for non-hom death and nongunhom ***
	 # delimit; 
	 xi:  xtpoisson `out'  NCAseg18xpost  i.year  
	 nongunhom  nonhomdeath
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
	if border==1  , fe vce(robust) exp(pop);
	 outreg2  NCAseg18xpost   nonhomdeath nongunhom using tableA4_robustness_segment_`out'.xls, se bdec(3) tdec(3) nocons  nor  noni  excel;  
	***  7  adding enforcement 
	# delimit; 
	 xi:  xtpoisson `out'  NCAseg18xpost   i.year 
	 detainees_drugwarpc port_enfpc18 
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18   
	if border==1  , fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost   nonhomdeath nongunhom using tableA4_robustness_segment_`out'.xls, se bdec(3) tdec(3) nocons  nor  noni  excel;  
}; 

# delimit cr 

clear all
use "$path/cross_border_appendix.dta"
tsset muncode year, yearly

local outcomes "nongunhom" 
set more off

# delimit; 
foreach out of local outcomes {; 
	***  1  repeat baseline 
	# delimit; 
	 xi:  xtpoisson `out'  NCAseg18xpost  i.year 
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18    
	if border==1  , fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost  using tableA4_robustness_segment_`out'.xls,  replace se bdec(3) tdec(3) nocons  nor  noni   excel; 
	***  2 negative binomial specification
	# delimit; 
	xi:  xtnbreg `out' NCAseg18xpost i.year 
	lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  
	lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
	if border==1  , fe exp(pop); 
	outreg2  NCAseg18xpost  using tableA4_robustness_segment_`out'.xls,  se bdec(3) tdec(3) nocons  nor  noni   excel; 
	***  3  post vs.  i.year  
	# delimit; 
	 xi:  xtpoisson `out'  NCAseg18xpost  post  
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18  
	if border==1  , fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost  using tableA4_robustness_segment_`out'.xls,  se bdec(3) tdec(3) nocons  nor  noni   excel; 
	***  4  with port and linear time trends 
	# delimit;
	 xi:  xtpoisson `out'  NCAseg18xpost post  NCAseg18year
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
	if border==1  , fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost  using tableA4_robustness_segment_`out'.xls,   se bdec(3) tdec(3) nocons  nor  noni   excel; 
	***  5  highway restriction
	# delimit; 
	 xi:  xtpoisson `out'  NCAseg18xpost  i.year
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18   
	if border==1   & highway==1, fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost   using tableA4_robustness_segment_`out'.xls, se bdec(3) tdec(3) nocons  nor  noni   excel;  
 
 
 
	***  7  adding enforcement 
	# delimit; 
	 xi:  xtpoisson `out'  NCAseg18xpost   i.year 
	 detainees_drugwarpc port_enfpc18 
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18   
	if border==1  , fe vce(robust) exp(pop);
	outreg2  NCAseg18xpost   nonhomdeath nongunhom using tableA4_robustness_segment_`out'.xls, se bdec(3) tdec(3) nocons  nor  noni  excel;  
};

# delimit cr 


*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	TABLE A5: The Effect of the FAWB Expiration on Suicides and Accidents 
*	----------------------------------------------------------------------------
*	---------------------------------------------------------------------------- 
clear
use "$path/cross_border_appendix.dta"
tsset muncode year, yearly


# delimit; 
	 qui xi:  xtpoisson suicide  negdistNCA18xpost negdist18xpost  i.year  
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18  
	 if mindist18<=.1  , fe vce(robust) exp(pop);
	outreg2 negdistNCA18xpost     using tableA5_suicide_accident.xls, replace se bdec(3) tdec(3) nocons  nor  noni excel; 
# delimit; 
foreach var of varlist  suicdguns	 suicdotharms accident {; 
	 qui xi:  xtpoisson `var' negdistNCA18xpost negdist18xpost  i.year   
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
	 if mindist18<=.1  , fe vce(robust) exp(pop);
	 outreg2 negdistNCA18xpost     using tableA5_suicide_accident.xls, se bdec(3) tdec(3) nocons  nor  noni excel; 
	}; 
	
# delimit cr 
	

*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	TABLE A6: Robustness to Spatial Confounds 
*	----------------------------------------------------------------------------
*	---------------------------------------------------------------------------- 

local outcomes "homicide homdguns" 
set more off
foreach out of local outcomes {
	
	** control for size
	 
 	use "$path/cross_border_appendix.dta", clear 
	tsset muncode year, yearly
	
	** area control 
	 
	 xi:  xtpoisson `out'  negdistNCA18xpost negdist18xpost  i.year  areaxpost ///
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 /// 
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 ///
	 if mindist18<=.1  , fe vce(robust) exp(pop) ///
	 
	 outreg2 negdistNCA18xpost using  tableA6_`out'_col_1_3.xls, replace se bdec(3) tdec(3) nocons  nor  noni excel 

 	use "$path/cross_border_edge_dist.dta", clear 
	tsset muncode year, yearly 
	
	** use edge distance 
	 
	 xi:  xtpoisson `out'  negdistNCA18xpost negdist18xpost i.year ///
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  ///
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 ///
	 , fe vce(robust) exp(pop)
	 
	 outreg2 negdistNCA18xpost using  tableA6_`out'_col_1_3.xls, se bdec(3) tdec(3) nocons  nor  noni excel 
	
	** edge distance and area control 
	 
	use "$path/cross_border_edge_dist.dta", clear 
	tsset muncode year, yearly
 

	 xi:  xtpoisson `out'  negdistNCA18xpost negdist18xpost i.year areaxpost ///
	 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 ///  
	 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 ///
	 , fe vce(robust) exp(pop)
	 
	outreg2 negdistNCA18xpost using  tableA6_`out'_col_1_3.xls, se bdec(3) tdec(3) nocons  nor  noni excel 
	} 


	** control for lag neighbor outcome
	
	use "$path/cross_border_appendix.dta", clear 
	tsset muncode year, yearly
	 
local outcomes "homicide homdguns" 
set more off
 
foreach out of local outcomes {
		xi:  xtpoisson `out'	negdistNCA18xpost negdist18xpost L`out'_avg_lag  i.year  /// 
		 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 /// 
		 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 ///
		if mindist18<=.1  , fe vce(robust) exp(pop)
		
		outreg2 negdistNCA18xpost  negdistNCA18xpost  L`out'_avg_lag using  tableA6_`out'_col_4_5.xls, replace se bdec(3) tdec(3) nocons  nor  noni excel
	
	
	xi:  xtpoisson `out'	negdistNCA18xpost negdist18xpost  L`out'_avg_lag  L`out'_avg  i.year  ///
		 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  ///
		 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18  ///
		 if mindist18<=.1  , fe vce(robust) exp(pop) 
		 
		outreg2 negdistNCA18xpost  negdistNCA18xpost  L`out'_avg_lag  L`out'_avg using   tableA6_`out'_col_4_5.xls, se bdec(3) tdec(3) nocons  nor  noni excel
	
	}
	 

 

*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	TABLE A7: Robustness to Specific U.S. Border States
*	----------------------------------------------------------------------------
*	---------------------------------------------------------------------------- 
 
local outcomes "homicide homdguns" 
set more off

# delimit; 
foreach out of local outcomes {; 

	* drop TX
	# delimit; 
		xi:  xtpoisson `out' negdistNCA18xpost negdist18xpost  i.year   if mindist18<=.1   & nearestport18TX==0, fe vce(robust) exp(pop);
		outreg2  negdistNCA18xpost  using tableA7_dropstate_`out'.xls,  replace se bdec(3) tdec(3) nocons  nor  noni   	excel; 
	* drop TX with controls 
	# delimit; 
		 xi:  xtpoisson `out' negdistNCA18xpost negdist18xpost i.year    
		 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18  
		 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
		 if mindist18<=.1   & nearestport18TX==0, fe vce(robust) exp(pop);
		outreg2  negdistNCA18xpost  using tableA7_dropstate_`out'.xls,  se bdec(3) tdec(3) nocons  nor  noni   	excel; 
	* drop AZ
	# delimit; 
		xi:  xtpoisson `out' negdistNCA18xpost negdist18xpost  i.year   if mindist18<=.1   & nearestport18AZ==0, fe vce(robust) exp(pop);
		outreg2  negdistNCA18xpost  using tableA7_dropstate_`out'.xls,  se bdec(3) tdec(3) nocons  nor  noni   	excel; 
	* drop AZ with controls
	# delimit; 
		 xi:  xtpoisson `out' negdistNCA18xpost negdist18xpost    i.year 
		 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
		 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18   
		 if mindist18<=.1   & nearestport18AZ==0, fe vce(robust) exp(pop);
		outreg2  negdistNCA18xpost  using tableA7_dropstate_`out'.xls,  se bdec(3) tdec(3) nocons  nor  noni   	excel; 
	* drop NM
	# delimit; 
		xi:  xtpoisson `out' negdistNCA18xpost negdist18xpost  i.year   if mindist18<=.1   & nearestport18NM==0, fe vce(robust) exp(pop);
		outreg2  negdistNCA18xpost  using tableA7_dropstate_`out'.xls,  se bdec(3) tdec(3) nocons  nor  noni   	excel; 
	* drop NM with controls 
	# delimit; 
		 xi:  xtpoisson `out' negdistNCA18xpost negdist18xpost  i.year  
		 lport_ave_earn18  port_emp_rat18 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable18 
		 lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value18 
		if mindist18<=.1   & nearestport18NM==0, fe vce(robust) exp(pop);
		outreg2  negdistNCA18xpost  using tableA7_dropstate_`out'.xls,  se bdec(3) tdec(3) nocons  nor  noni   	excel; 
		
		}; 

# delimit cr 


*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	TABLE A8: Robustness to Different Definitions of Entry Ports
*	----------------------------------------------------------------------------
*	---------------------------------------------------------------------------- 
 
set more off

clear
use "$path/cross_border_treatments.dta"
tsset muncode year, yearly

local outcomes "homicide homdguns" 
# delimit; 
foreach out of local outcomes {; 
	
	xi:  xtpoisson `out'  negdistNCA22xpost negdist22xpost i.year
	lport_ave_earn22  port_emp_rat22 lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable22 
	lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value22  
	if mindist22<=.1  , fe vce(robust) exp(pop);
	outreg2 negdistNCA22xpost using  tableA8_alternative_port_treat_`out'.xls, replace se bdec(3) tdec(3) nocons  nor  noni excel; 

	# delimit;
	foreach n of numlist 18 1630 20 16 141 17 145 13  {; 
	xi:  xtpoisson `out'  negdistNCA`n'xpost negdist`n'xpost i.year
	lport_ave_earn`n'  port_emp_rat`n' lpci_dollarsxpost schoolrat6_24xpost lexptotalpc ldeportable`n'  
	lmarijuana_hectaresp1 lpoppy_hectaresp1  ltot4drugs_value_mexp1  ltotal_4drugs_value`n' 
	if mindist`n'<=.1  , fe vce(robust) exp(pop);
	outreg2 negdistNCA`n'xpost using   tableA8_alternative_port_treat_`out'.xls, se bdec(3) tdec(3) nocons  nor  noni excel; 
		}; 
	}; 

# delimit cr 


*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	FIGURE A1: Political Competition Prior to the 1994 and 2004 Treatments
*	----------------------------------------------------------------------------
*	---------------------------------------------------------------------------- 
 
clear all
set mem 2g
use "$path/figure1_data.dta"

cap drop period2
recode year 1992/1995=1 2002/2005=2 nonm=., g(period2)
cap label drop labperiod2
label def labperiod2 1 "1992-1995" 2 "2002-2005"
label values period2 labperiod2
 
 qui sum lt_index if period2==1
 global meanbefore = r(mean)
 qui sum lt_index if period2==2
 global meanafter = r(mean)
 
twoway histogram lt_index if period2==1 , ///
ylabel(0(1)3) xlabel(1(.5)3.5) gap(50) ytitle(Frequency) ///
xline($meanbefore, lpat(dash) lcolor(black)) xtitle(Effective Number of Parties - LT Index) ///
acolor(gs5) graphregion(fcolor(white)) scheme(s1mono)

graph save FigureA1_PanelA_political_competition_early.gph, replace

twoway histogram lt_index if period2==2 , /// 
ylabel(0(1)3) xlabel(1(.5)3.5)  gap(50) ytitle(Frequency) ///
 xline($meanafter, lpat(dash) lcolor(black))xtitle(Effective Number of Parties - LT Index) ///
 acolor(gs5) graphregion(fcolor(white)) scheme(s1mono)

graph save FigureA1_PanelB_political_competition_late.gph, replace


*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	FIGURE A4: Distribution of Outcomes
*	----------------------------------------------------------------------------
*	---------------------------------------------------------------------------- 

clear all
set mem 2g
use "$path/cross_border_main.dta"

gen hom_pop_10k = 10000*homicide/pop
replace hom_pop_10k = 40 if hom_pop_10k>40 & homicide<.

replace homicide = 40 if homicide>40 & homicide<.

swilk homicide homdguns hom_pop_10k if  mindist18<.1   
sfrancia homicide homdguns hom_pop_10k if  mindist18<.1   

histogram homicide if  mindist18<.1  , ///
normal normopts(lcolor(teal) lwidth(medthick))   xlabel( 10 "10" 20 "20" 30 "30" 40 "40+") ///
bin(40) barw(.7) lcolor(gs5 )  fcolor(gs5) xtitle("Homicide Counts") ///
graphregion( color(white)) xsize(3) ysize(3) 

graph save FigureA4_PanelA.gph, replace

kdensity hom_pop_10k if hom_pop_10k<=40 & mindist18<.1  , bw(1) ///
normal normopts(lcolor(teal) lwidth(medthick)) lcolor(black) lwidth(medthick) lpat(dash) ///
xtitle("Homicides per 10,0000 Population") ///
graphregion( color(white)) xsize(3) ysize(3) title("")

graph save FigureA4_PanelB.gph, replace


*	----------------------------------------------------------------------------
*	----------------------------------------------------------------------------
*	FIGURE A6: Effects on Violence by Distance Bands
*	----------------------------------------------------------------------------
*	---------------------------------------------------------------------------- 
 
clear all
set mem 2g
use "$path/figureA6_data.dta"

#delimit;
twoway 
rspike homds_UB homds_LB distance, lcolor(gray) || 
scatter homds_coeff distance, mcolor(black)
graphregion(color(white)) legend(off) 
yline(0, lcolor(gray) lpattern(-)) ylabel(-4(2)16, angle(0)) scale(0.8) ylabel(-4(2)16) xlabel(0(50)500)
xtitle("Distance Band (miles)") ytitle("Point Estimate") aspect(1) title("Homicides", margin(medsmall)) name(homds_dist, replace);
;

#delimit;
twoway 
rspike homdguns_UB homdguns_LB distance, lcolor(gray) ||
scatter homdguns_coeff distance, mcolor(black) 
graphregion(color(white)) legend(off) 
yline(0, lcolor(gray) lpattern(-)) ylabel(-4(2)16, angle(0)) scale(0.8) ylabel(-4(2)16) xlabel(0(50)500)
xtitle("Distance Band (miles)") ytitle("Point Estimate") aspect(1) title("Gun-related Homicides", 
margin(medsmall)) name(homdguns_dist, replace);
;

graph combine homds_dist homdguns_dist;

graph save FigureA6.gph, replace;

# delimit cr 
