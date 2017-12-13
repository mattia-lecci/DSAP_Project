clear all
close all

load 'Result/CRP/Test03Train07#1'

plot(errors(2,:));

grid on;

ylim([0 1.2]);
xlim([1 33]);

ylabel('Error');
xlabel('Song');

title('Error comparison');

hold on;

plot(errors(1,:));

legend('Before processing HMM', 'After processing HMM');

