close all;
clear all;

load 'Result/CRP/smoothingsong';

subplot(1,2,1);

stairs(numeric_obs);
grid on;
ylim([0 31]);
xlim([0 143]);

title('Chords variation before processing HMM');
ylabel('Chord');
xlabel('Frame');

subplot(1,2,2);

stairs(numeric_argmax);
grid on;
ylim([0 31]);
xlim([0 143]);

title('Chords variation after processing HMM');
ylabel('Chord');
xlabel('Frame');
