
pause on;
x = 0;
y=0;

h = figure;
x = finalTraj{1}(:, 1); y = finalTraj{1}(:, 2);

if length(x) > 15
    plot(x, y);
end

linkdata on;
pause;
for ind = 2:length(finalTraj); disp(ind); x = finalTraj{ind}(:, 1); y = finalTraj{ind}(:, 2); refreshdata(h);
    pause;
end

pause off;