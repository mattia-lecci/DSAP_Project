close all;
clear all;

load 'Result/CENS/smoothingsinglesong';

subplot(1,2,1);

stairs(s2);
grid on;
ylim([0 31]);
xlim([0 143]);

title('Chords variation before processing HMM');
ylabel('Chord');
xlabel('Frame');

subplot(1,2,2);

stairs(s1);
grid on;
ylim([0 31]);
xlim([0 143]);

title('Chords variation after processing HMM');
ylabel('Chord');
xlabel('Frame');
