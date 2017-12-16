clear all
close all

load 'Result/CENS/Test03Train07#1'

for i=1:size(errors,2)
    err(i,1) = errors(2,i);
    err(i,2) = errors(1,i);
end

b = bar(err);

b(2).FaceColor='r';

grid on;

ylim([0 1]); xlim([0 34]);

ylabel('Error');
xlabel('Song');

title('Error comparison');

legend('Before processing HMM', 'After processing HMM','Location','best');

