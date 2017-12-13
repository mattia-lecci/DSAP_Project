function predgauss = gaussianPrediction(gaussianMixt, chord)

    predgauss = categorical (length(chord),1);

    for i=1:length(chord)
        obj = chord(i,:);
        predgauss(i,1)=gaussianMin(gaussianMixt, obj);
    end       
end