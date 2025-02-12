gen gender_code=1
replace gender_code=0 if Gender =="Female"

gen treated_code=0
replace treated_code=1 if treated =="with fellow"

encode time_period, generate(time_period_num)
replace work_affiliation_overlap = 0 if missing(work_affiliation_overlap)
replace subfield_overlap = 0 if missing(subfield_overlap)
replace PhDInstitution_overlap = 0 if missing(PhDInstitution_overlap)
replace institution_overlap = 0 if missing(institution_overlap)

gen log_TimefromPhDtofellow = log(TimefromPhDtofellow +1)
gen log_Totalpubs = log(Totalpubs +1)
gen log_Totalcites = log(Totalcites +1)
gen log_Totalcollaborators = log(Totalcollaborators +1)
gen log_fellow_Collaborator_times = log(fellow_Collaborator_times +1)
gen log_collaboration_recency = log(collaboration_recency +1)

//"is_fellow" means No. of collaborators with whom new electees collaborated when those collaborators were already fellows
//"no_fellow" means No. of collaborators with whom the collaboration may have preceded their election to fellow 
gen log_is_fellow = log(is_fellow +1)
gen log_no_fellow = log(no_fellow +1)

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
reg log_TimefromPhDtofellow institution_overlap log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num if treated =="with fellow"
estimates store model5

reg log_TimefromPhDtofellow subfield_overlap log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num if treated =="with fellow"
estimates store model6

reg log_TimefromPhDtofellow log_fellow_Collaborator_times log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num if treated =="with fellow"
estimates store model7

 reg log_TimefromPhDtofellow log_collaboration_recency  log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num if treated =="with fellow"
estimates store model8

reg log_TimefromPhDtofellow fellow_citaiton_10 log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num if treated =="with fellow"
estimates store model9

reg log_TimefromPhDtofellow fellow_productivity_10  log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num if treated =="with fellow"
estimates store model10

reg log_TimefromPhDtofellow log_is_fellow  log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num if treated =="with fellow"
estimates store model11

reg log_TimefromPhDtofellow log_no_fellow  log_Totalpubs log_Totalcites log_Totalcollaborators i.time_period_num if treated =="with fellow"
estimates store model12

esttab model1  model3 model4 model5 model6 model7 model8 model9  model11 model2 using reg_time_to_fellow.csv, star(* 0.10 ** 0.05 *** 0.01) replace cells(b(fmt(3) star) se(fmt(3) par)) stats(N r2, fmt(3) labels("Number of obs" "R-squared")) csv