%% set-up

%initializing the colors we'll use
colors = hsv(100); 
%surf(peaks); colormap(colors)
%colormap(colors(79,:)) %shows what color row 1 is

trialnum = 120;
R = randperm(120);


%setting the color conditions
colorrand = [repelem(1,20),repelem(2,20),repelem(3,20),repelem(4,20),repelem(5,20),repelem(6,20)]; %a set containing a color instance for each trial
%color_cond = datasample(colorrand,trialnum,'Replace',false); %randomly choses the color from colorrand without replacement
color_cond = colorrand(R);


%setting the congruency conditions
congrurand = repmat([0 0 1 1],1,30); % 1= congruent 0= incongruent
congru_cond = congrurand(R);
%congru_cond = datasample(congrurand,trialnum,'Replace',false); %randomly chooses congruency condition

%randomizing whether the 2 colored circles will be the same or different
difference_cond = repmat([0 1 0 1],1,30);
difference_cond = difference_cond(R);
%difference_cond = datasample(differencerand,trialnum,'Replace',false);

%word lists
wordlist1 = {'ketchup', 'tomato', 'strawberry', 'apple', 'rose'}; %red wordlist
wordlist2 = {'sun', 'lemon', 'banana', 'corn', 'bee'}; %yellow wordlist
wordlist3 = {'water', 'whale', 'sky', 'sapphire', 'ocean'}; %blue wordlist
wordlist4 = {'carrot', 'copper', 'fire', 'tiger', 'clementine'}; %orange wordlist
wordlist5 = {'plum', 'grape', 'eggplant', 'amethyst', 'lavender'}; %purple wordlist
wordlist6 = {'kiwi', 'grass', 'broccoli', 'frog', 'lime'}; %green wordlist

wordlist = cat(3,wordlist1, wordlist2, wordlist3, wordlist4, wordlist5, wordlist6);

%randomizing which word will be pulled from the word list
wordindexrand = [repelem(1,24),repelem(2,24),repelem(3,24),repelem(4,24),repelem(5,24)];
wordindex = datasample(wordindexrand,trialnum);

%color vectors
colorvec1 = [colors(1,:); colors(3,:); colors(4,:); colors(5,:); colors(98,:); colors(95,:)]; %red
colorvec2 = [colors(13,:); colors(14,:); colors(15,:); colors(16,:); colors(17,:); colors(18,:)]; %yellow
colorvec3 = [colors(57,:); colors(58,:); colors(59,:); colors(60,:); colors(61,:); colors(62,:)]; %blue
colorvec4 = [colors(6,:); colors(7,:); colors(8,:); colors(9,:); colors(10,:); colors(11,:)]; %orange
colorvec5 = [colors(74,:); colors(75,:); colors(76,:); colors(77,:); colors(78,:); colors(79,:)]; %purple
colorvec6 = [colors(35,:); colors(38,:); colors(40,:); colors(42,:); colors(43,:); colors(45,:);]; %green

colorvec = cat(3, colorvec1, colorvec2, colorvec3, colorvec4, colorvec5, colorvec6);



%data vector which will be filled with experimental data and saved
dat = [];
headers = {'trial','cond','rt','accuracy'}; %could easily add variables but for ease I opted not
%for accuracy, a correct trial is 1, incorrect is 0

%note; check ginput for "F" and "J" key:
%[x y b] = ginput(1)

%% experimental loop

%collecting participant's initials in order to save data later
%% 

clc;
sn = input('Please type your initials: ','s');
filename = ['color_task_' sn '.mat'];

%display instruction
display('You will see a word and then 2 dots in each trial');
display('press F if the dots are in same color');
display('or press J if they are in different color');

%displays a blank figure which we will draw into on each trial
figure(1); clf; set(gcf,'color','w');
axis off equal; axis([-3 3 -3 3])
leftcircle = [-1.5, 0]; %x-y coordinates of left circle
rightcircle = [1.5, 0]; %x-y coordinates of right circle




for t = 1:size(color_cond,2)

    current_color = color_cond(t);

    %congruent trials
    if congru_cond(t) == 1 %for congurent trials

        axis off equal; axis([-3 3 -3 3])
        current_string = wordlist{:,wordindex(t),current_color};
        wordshown = text(0, 0, current_string, 'fontsize',24, 'HorizontalAlignment','center');
        pause(1); clf

        if difference_cond(t) == 1 %no difference between colors in task
            trialcolor = datasample(colorvec(:,:,current_color),1);
            plot([leftcircle(1) rightcircle(1)], [leftcircle(2) rightcircle(2)], '.', 'color', trialcolor, 'markersize', 150);
        elseif difference_cond(t) == 0 %different colors
            trialcolor = datasample(colorvec(:,:,current_color),2, 'Replace',false);
            plot(leftcircle(1), leftcircle(2), '.', 'color', trialcolor(1,:), 'markersize', 150);
            hold on
            plot(rightcircle(1), rightcircle(2), '.', 'color', trialcolor(2,:), 'markersize', 150);
            hold off
        end
        

    

    %incongruent trials
    elseif congru_cond(t) == 0 %for incongruent trials

        incongruentmapping = [2, 1, 4, 3, 6, 5];
        current_incongruentcolor = incongruentmapping(current_color);

        axis off equal; axis([-3 3 -3 3])
        current_string = wordlist{:,wordindex(t),current_incongruentcolor};
        wordshown = text(0, 0, current_string, 'fontsize',24, 'HorizontalAlignment','center');
        pause(1); clf

            if difference_cond(t) == 1 %no difference between colors in task
                trialcolor = datasample(colorvec(:,:,current_color),1);
                plot([leftcircle(1) rightcircle(1)], [leftcircle(2) rightcircle(2)], '.', 'color', trialcolor, 'markersize', 150);
            elseif difference_cond(t) == 0 %different colors
                trialcolor = datasample(colorvec(:,:,current_color),2, 'Replace',false);
                plot(leftcircle(1), leftcircle(2), '.', 'color', trialcolor(1,:), 'markersize', 150);
                hold on
                plot(rightcircle(1), rightcircle(2), '.', 'color', trialcolor(2,:), 'markersize', 150);
                hold off
            end
            
        
    end
    tic
    axis off equal; axis([-3 3 -3 3]);

    valid_resp = 0;
    while valid_resp == 0
        [x y b] = ginput(1);
        if b == 102
            resp = 1; %F = same
            valid_resp = 1;

        elseif b == 106 %J = diff
            resp = 0;
            valid_resp = 1;
        end
    end
    rt(t) = toc;

    %save data for each trial in dat
    dat(t,1) = t;
    dat(t,2) = congru_cond(t);
    dat(t,3) = rt(t); %reaction time; use tic when presented and end with rt=toc
    dat(t,4) = resp == difference_cond(t);



    pause(0.5); clf
   
end

close(1)

%save data
save(filename, 'dat','headers');





