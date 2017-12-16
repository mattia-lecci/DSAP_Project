clear all
close all
clc

results =...
   [24.17, 20.08, 24.96;
    23.04, 17.79, 20.38;
    14.58,  6.94, 11.81;
    13.61,  6.39, 12.64;
    10.56,  4.17,  7.92;
    10.00,  4.31,  7.78];

classifiers = {'Template (Binary)','Template (Harmonic)',...
    'GMM','SVM (linear)','SVM (poly,3)','SVM (RBF)'};
leg = {'CLP','CENS','CRP'};

figure
b = bar(results); grid on
b(2).FaceColor = 'g';
b(3).FaceColor = 'r';
set(gca,'XTickLabels',classifiers)
set(gca,'XTickLabelRotation',20)
legend(leg)
ylabel('Error Rate')
title('Single Chord Experiment Results')