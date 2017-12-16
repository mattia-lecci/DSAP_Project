function [D,E,Z] = templateDecision(v,T)
 % T defines the Template Matrix 1 or 2:
 % 1 = BinaryTemplate
 % 2 = Harmonic
 % v = Vector with extracted parameters
 % D Returns the String name of the Chord in a Cell
 
 
 
  d = 1:1:24; 
  e = 1:1:24;
  z = 1:1:24; 
  c = 0;
  i = 0;
  y = 0;
  f = 0;
  u = 0;
  m = 0;
  
  Name = {'Cm', 'C', 'CH', 'Db', 'Dm', 'D', 'DH', 'Eb', 'Em', 'E', 'Fm', 'F', 'FH', 'Gb', 'Gm', 'G', 'GH', 'Ab', 'Am', 'A', 'AH', 'Bb', 'Bm', 'B'};

if T == 1 
 load('Binary_Template.mat');
    for t = 1:24
        d(t) = (norm(Bi_Template(t,:)-v)^2)/2; 
        e(t) = norm(Bi_Template(t,:)-v);
        z(t) = 1-(dot(Bi_Template(t,:),v)/(norm(Bi_Template)*norm(v)));
   end
else
   load('Harmonic_Template.mat');
    for t = 1:24
       
        d(t) = (norm(Har_Template(t,:)-v)^2)/2;
        e(t) = norm(Har_Template(t,:)-v);
        z(t) = 1-(dot(Har_Template(t,:),v)/(norm(Har_Template)*norm(v)));

    end
end

[c,i] = min(d);
D = Name(i);

[f,y] = min(e);
E = Name(y);

[u,m] = min(z);
Z = Name(m);

end