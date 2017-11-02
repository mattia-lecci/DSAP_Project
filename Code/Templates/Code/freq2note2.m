%Code is written for equal temperament and A=440.
%Notes are displayed according to sharps. This can be overrided easily by changing the array definition below.

%Written by F?rat Civaner

%May music be with you.

function note = freq2note(freq)
    A4 = 440;

    notenames = { 'C' , 'C#', 'D' , 'D#' , 'E' , 'F' , 'F#', 'G' , 'G#' , 'A' , 'A#' , 'B' };

    centdif = floor( 1200 * log(freq/A4)/log(2) );

    notedif = floor(centdif/100);
    if(mod(centdif,100)>50)
       notedif = notedif + 1;
    end

    error = centdif-notedif*100;

    notenumber = notedif + 9 + 12*4; %count of half tones starting from C0.

    octavenumber = floor((notenumber)/12);

    place = mod(notenumber,12) + 1;

    note = strcat(notenames(place));
end