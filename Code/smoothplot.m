clear all;
close all;

load 'Result/CRP/smoothing07'

y1 = smoothing(2,:);
y2 = smoothing(1,:);

for i=1:size(smoothing,2)
    y(i,1) = y1(i);
    y(i,2) = y2(i);
end

bar(y,1);
ylim([0 200]);
hold on;
grid on;
legend('Before processing HMM', 'After processing HMM');
xlabel('Song');
ylabel('Chords varation');
title('Chords variation per song');