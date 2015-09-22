clear
clc

codefolder = cd('../input');
inputfolder = cd(codefolder);
cd('../input');
filelist=dir('*.xlsx');
N = length(filelist);

for n = 1:N
    
    cd(inputfolder);
    data = xlsread(filelist(n,:).name);
    % trial_index	trial_time	 pupil_lf_5	 sx_li	 sy_li	 pupil_li	 commit_t	sample_message	left_interest_area_id	IA	
    % sx_r	sy_r	out_bound	smblink	pupil_r	blink_r	saccade_r	(11 ~ 17)
    % cd(codefolder);
    
    trial = data(:,1);
    p  = data(:,3);
    sx = data(:,4);
    sy = data(:,5);
    
    p_t = p(trial == 1);
    x_t = sx(trial == 1);
    y_t = sy(trial == 1);
    
    p_t = p_t / mean(p_t(1:200)) - 1;
    
    
end



time = 1:length(p_t);

plot(time,p_t*100)
set(gca,'FontSize',20)
xlabel('Time in Feedback Screen (ms)');
ylabel('% Change in Pupil Diameter');
xlim([0 length(p_t)])
%legend('Pupil Size','Location','best');
%set(legend,'FontSize',14);

cd('../output');
save Pupil_in_feedback_scr
saveas(gcf, 'Pupil_in_feedback_scr' ,'eps2c');

cd(codefolder);
