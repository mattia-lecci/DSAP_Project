function D = cosDistance(T,v)
 % T defines the Template Matrix 1 or 2:
 % 1 = BinaryTemplate
 % 2 = Harmonic
 % v = Vector with extracted parameters
 % D Returns the String name of the Chord in a Cell
 
 
  d = 1:1:24; 
  c = 0;
  i = 0;
  Name = {'Cm', 'C', 'CH', 'Db', 'Dm', 'D', 'DH', 'Eb', 'Em', 'E', 'Fm', 'F', 'FH', 'Gb', 'Gm', 'G', 'GH', 'Ab', 'Am', 'A', 'AH', 'Bb', 'Bm', 'B'};

if T == 1 
 load('Binary_template.mat');
   for t = 1:length(v)
       
        d(t) = (norm(Bi_Template(t,:)-v)^2)/2;
      
   end
else
   load('Harmonic_template.mat');
    for t = 1:length(v)
       
        d(t) = (norm(Har_Template(t,:)-v)^2)/2;
      
    end
end

[c,i] = min(d);
D = Name(i);

end