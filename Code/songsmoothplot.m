close all;
clear all;

load 'Result/CRP/smoothingsong';

stairs(numeric_argmax);
grid on;
ylim([0 31]);
xlim([0 143]);

title('Chords variation after processing HMM');
ylabel('Chord');
xlabel('Frame');
