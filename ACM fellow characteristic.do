
// use "ACM fellow characteristic.dta",clear

gen gender_code=1
replace gender_code=0 if Gender =="Female"

gen treated_code=0
replace treated_code=1 if treated =="with fellow"

encode time_period, generate(time_period_num)

replace work_affiliation_overlap = 0 if missing(work_affiliation_overlap)
replace subfield_overlap = 0 if missing(subfield_overlap)
replace PhDInstitution_overlap = 0 if missing(PhDInstitution_overlap)
replace workphdinstitution_overlap = 0 if missing(workphdinstitution_overlap)
replace collaborationrecency = 0 if missing(collaborationrecency)

gen log_TimefromPhDtofellow = log(TimefromPhDtofellow +1)
gen log_Totalpubs = log(Totalpubs +1)
gen log_Totalcites = log(Totalcites +1)
gen log_Totalcollaborators = log(Totalcollaborators +1)
gen log_Collaborationfrequency = log(Collaborationfrequency +1)
gen log_collaborationrecency = log(collaborationrecency +1)


//all electees
reg log_TimefromPhDtofellow treated_code log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num
estimates store model1

reg log_TimefromPhDtofellow treated_code##gender_code log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num
estimates store model2

// electees collaborating with former fellow
reg log_TimefromPhDtofellow work_affiliation_overlap log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num if treated =="with fellow"
estimates store model3

reg log_TimefromPhDtofellow PhDInstitution_overlap log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num if treated =="with fellow"
estimates store model4
reg log_TimefromPhDtofellow workphdinstitution_overlap log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num if treated =="with fellow"
estimates store model5

reg log_TimefromPhDtofellow subfield_overlap log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num if treated =="with fellow"
estimates store model6

reg log_TimefromPhDtofellow log_Collaborationfrequency log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num if treated =="with fellow"
estimates store model7

 reg log_TimefromPhDtofellow log_collaborationrecency  log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num if treated =="with fellow"
estimates store model8

reg log_TimefromPhDtofellow Fellowcitationlog log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num if treated =="with fellow"
estimates store model9

reg log_TimefromPhDtofellow Fellowproductivitylog  log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num if treated =="with fellow"
estimates store model10

esttab model1 model2 model3 model4 model5 model6 model7 model8 model9 model10 using reg_time_to_fellowv1.csv, star(* 0.10 ** 0.05 *** 0.01) replace cells(b(fmt(3) star) se(fmt(3) par)) stats(N r2, fmt(3) labels("Number of obs" "R-squared")) csv