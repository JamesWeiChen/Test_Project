clear
*cd C:\Users\James\Documents\ELET_Data\Feedback_Scr
cd "C:\Users\James\Dropbox\Test_Project\build\code"
* Build Do Code Directory, better if we can use relative path

cd ..\input
set more off 

*local filelist 03141314.xls
local filelist: dir . files "*.xls"

foreach fn of local filelist {

disp "`fn'"
import delimited "`fn'"

drop if trial_index < 3
replace trial_index = trial_index - 2

g sx_r = left_gaze_x
g sy_r = left_gaze_y
g pupil_r = left_pupil_size
g blink_r = left_in_blink
g saccade_r = left_in_saccade

/*r = raw*/

g out_bound = 0

replace out_bound = 1  if left_gaze_x > 1920-1
replace out_bound = 1  if left_gaze_x < 0
replace out_bound = 1  if left_gaze_y > 1080-1
replace out_bound = 1  if left_gaze_y < 0

/*look outside the screen (partial blink)*/

replace left_pupil_size=. if out_bound == 1

/* drop pupil size if out of screen*/

*replace left_gaze_y =.    if left_pupil_size ==.
*replace left_gaze_x =.    if left_pupil_size ==.

replace left_in_blink = 1   if left_pupil_size ==.

/*see out of bound as blink*/

g d = 1
replace d = d + d[_n-1] if trial_index==trial_index[_n-1]
rename d trial_time

/*define trial time*/

tsset trial_index trial_time

tssmooth ma smblink = left_in_blink , window(100 1 100)
replace smblink = 1 if smblink > 0
replace left_pupil_size=. if smblink == 1

replace left_gaze_y =.    if left_pupil_size ==.
replace left_gaze_x =.    if left_pupil_size ==.

g time = _n
ipolate left_pupil_size time, gen(pupil_li) epolate
ipolate left_gaze_x time, gen(sx_li) epolate
ipolate left_gaze_y time, gen(sy_li) epolate
*csipolate left_pupil_size time, gen(pupil_li2)

/*li = linear interpolation*/

drop left_gaze_y left_gaze_x left_pupil_size left_in_blink left_in_saccade timestamp  time

tssmooth ma pupil_lf_5 = pupil_li , window(44 1 44)
/* 5 Hz low pass filter*/

order  trial_index trial_time pupil_lf_5 sx_li sy_li pupil_li sample_message left_interest_area_id left_interest_area_label sx_r sy_r out_bound smblink pupil_r blink_r saccade_r

g filename = "`fn'"
replace filename = substr(filename,1,8)
local ffn=filename

*cd C:\Users\James\Desktop\Data_3\
cd ..\output

*save "`ff'.dta" ,replace
export excel "`ffn'.xlsx", firstrow(variables) replace missing(" ")

cd ..\input

clear
}
