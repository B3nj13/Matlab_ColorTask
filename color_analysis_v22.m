subjectfiles = {'color_task_AR.mat','color_task_BK.mat', 'color_task_HN.mat', 'color_task_KE.mat', 'color_task_sw.mat'};
accslow = [];
accFast = [];
meanRT_cond1 = [];
meanRT_cond0 = [];
BMD = []; % empty vector for bootstrap mean differences
for s = 1:length(subjectfiles)%loops over how every many subjects are in the list above

    %load the s'ths participants file (only works if files are all in the same directory)
    load(subjectfiles{s})

    %finding cong and incong trial indicies
    congtrials = find(dat(:,2) == 1);
    incongtrials =  find(dat(:,2) == 0);

    meanRT_cond1(s) = mean(dat(congtrials,3)); 
    meanRT_cond0(s) = mean(dat(incongtrials,3)); 

    rangeRT = range(dat(:,3));
    minRT = min(dat(:,3));
    maxRT = max(dat(:,3));
    halfrange = rangeRT/2;
    slowRTpointer = minRT+halfrange;
    fastRTpointer = maxRT-halfrange+.0001;
    slowindices = find(dat(:,3) <= slowRTpointer);
    fastindices =  find(dat(:,3) >= fastRTpointer);
    accfast(s) = mean(dat(fastindices,4))*100; %mult by 100 for percent accurate
    accslow(s) = mean(dat(slowindices,4))*100;

    figure 
    name = {'color match';'not matching'};
    bar([meanRT_cond1(s) meanRT_cond0(s)],'FaceColor',[0 .7 .5])%shows mean reaction time of 1(1) congruent trials and 0(2) incongruent trials
    title('Mean reaction time')
    set(gca,'xticklabel',name)
    ylabel('Time in seconds')

    figure
    name = {'fast';'slow'};    
    bar([accfast(s) accslow(s)],'FaceColor',[1 1 .5])%shows mean accuracy of (1)fast trials and (2)slow trials
    title('trial speed accuracy')
    set(gca,'xticklabel',name)
    ylabel('percent correct')
    %bootstrap analysis since our DV is RT, which has an underlying positive skew
    for i = 1:10000
        bs_cong = RandSel(dat(congtrials,3),60); % the second input is the length(V1), or, the original sample size
        bs_incong = RandSel(dat(incongtrials,3),60);
        BMD(s,i) = mean(bs_cong)-mean(bs_incong);
    end


end
%overall graph of mean reaction time across incogruent and congruent trials
mean1 = mean(meanRT_cond1)
mean2 = mean(meanRT_cond0)
figure
name = {'color match';'not matching'}
bar([mean1 mean2],'FaceColor',[.2 .8 .8])
title('Overall Mean Reaction Time')
set(gca,'xticklabel',name)
ylabel('Time in seconds')

%Overall accuracy dependent on fast and slow trials
mean3 = mean(accfast)
mean4 = mean(accslow)
figure
name = {'fast';'slow'}
bar([mean3 mean4],'FaceColor',[.9 .3 .9])
title('Overall Trial Speed Accuracy')
set(gca,'xticklabel',name)
ylabel('percent correct')

[h,p,ci,stat] = ttest(meanRT_cond1, meanRT_cond0) %fail to reject the null; p=0.6422

BMD = cat(2,BMD(1,:),BMD(2,:),BMD(3,:),BMD(4,:),BMD(5,:));
figure; histogram(BMD)
title('Bootstrap Analysis')
xlabel('means')
ylabel('frequency')
% 95% confidence interval
lower_bounds = quantile(BMD,.025); % -0.2262
upper_bounds = quantile(BMD,.975); % 0.4387
%zero crosses our 95% confidence interval providing evidence that we
%did not commit a Type II error in our first analysis; we are now more
%confident that we should fail to reject the null.
