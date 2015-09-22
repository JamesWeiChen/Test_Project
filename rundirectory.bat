cd build\code\

"C:\Program Files (x86)\Stata13\StataMP-64.exe" /e clean_pupil_raw_data_Feedback.do

cd ..\..\analysis\code\

matlab -noFigureWindows -nosplash -nodesktop -r draw_pupil_change_in_feedback_scr.m

pause


