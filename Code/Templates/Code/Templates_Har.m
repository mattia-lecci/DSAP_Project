clear all;


s = 0.6;
V_s = [1, s, s^2, s^3, s^4, s^5];
V = [1, 2, 3, 4, 5, 6];
R = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];


VC = 261.63*V;%Vector frequencies
VCH = 277.18*V;
VD = 293.66*V;
VDH = 311.13*V;
VE = 329.63*V;
VF = 349.23*V; 
VFH = 369.99*V;
VG = 392.00*V;
VGH = 415.30*V;
VA = 440.00*V;
VAH = 466.16*V;
VB = 493.88*V;



C_s = VC.*V_s;  % Vector amplitude multiplication
CH_s = VCH.*V_s;
D_s = VD.*V_s;
DH_s = VDH.*V_s;
E_s = VE.*V_s;
F_s = VF.*V_s;
FH_s = VFH.*V_s;
G_s = VG.*V_s;
GH_s = VGH.*V_s;
A_s = VA.*V_s;
AH_s = VAH.*V_s;
B_s = VB.*V_s;

C_notes = removeOctave(freq2note(VC)); %  Vector with notes
CH_notes = removeOctave(freq2note(VCH));
D_notes = removeOctave(freq2note(VD));
DH_notes = removeOctave(freq2note(VDH));
E_notes = removeOctave(freq2note(VE));
F_notes = removeOctave(freq2note(VF));
FH_notes = removeOctave(freq2note(VFH));
G_notes = removeOctave(freq2note(VG));
GH_notes = removeOctave(freq2note(VGH));
A_notes = removeOctave(freq2note(VA));
AH_notes = removeOctave(freq2note(VAH));
B_notes = removeOctave(freq2note(VB));

Sc = sprintf('%s*', C_notes{:});
C_notes = sscanf(Sc, '%f*').';
Sch = sprintf('%s*', CH_notes{:});
CH_notes = sscanf(Sch, '%f*').';
Sd = sprintf('%s*', D_notes{:});
D_notes = sscanf(Sd, '%f*').';
Sdh = sprintf('%s*', DH_notes{:});
DH_notes = sscanf(Sdh, '%f*').';
Se = sprintf('%s*', E_notes{:});
E_notes = sscanf(Se, '%f*').';
Sf = sprintf('%s*', F_notes{:});
F_notes = sscanf(Sf, '%f*').';
Sfh = sprintf('%s*', FH_notes{:});
FH_notes = sscanf(Sfh, '%f*').';
Sg = sprintf('%s*', G_notes{:});
G_notes = sscanf(Sg, '%f*').';
Sgh = sprintf('%s*', GH_notes{:});
GH_notes = sscanf(Sgh, '%f*').';
Sa = sprintf('%s*', A_notes{:});
A_notes = sscanf(Sa, '%f*').';
Sah = sprintf('%s*', AH_notes{:});
AH_notes = sscanf(Sah, '%f*').';
Sb = sprintf('%s*', B_notes{:});
B_notes = sscanf(Sb, '%f*').';



C_t = [C_notes; C_s];
CH_t = [CH_notes; CH_s];
D_t = [D_notes; D_s];
DH_t = [DH_notes; DH_s];
E_t = [E_notes; E_s];
F_t = [F_notes; F_s];
FH_t = [FH_notes; FH_s];
G_t = [G_notes; G_s];
GH_t = [GH_notes; GH_s];
A_t = [A_notes; A_s];
AH_t = [AH_notes; AH_s];
B_t = [B_notes; B_s];




% C Triad 
C = R;
for i = 1 : 6
 
C(C_t(1,i)) =    C(C_t(1,i)) + C_t(2,i);  
C(E_t(1,i)) =    C(E_t(1,i)) + E_t(2,i);  
C(G_t(1,i)) =    C(G_t(1,i)) + G_t(2,i);      
end   

% Cm Triad 
Cm = R;
for i = 1 : 6
 
Cm(C_t(1,i)) =    Cm(C_t(1,i)) + C_t(2,i);  
Cm(DH_t(1,i)) =    Cm(DH_t(1,i)) + DH_t(2,i);  
Cm(G_t(1,i)) =    Cm(G_t(1,i)) + G_t(2,i);      
end   

% C# Triad 
CH = R;
for i = 1 : 6
 
CH(CH_t(1,i)) =    CH(CH_t(1,i)) + CH_t(2,i);  
CH(E_t(1,i)) =    CH(E_t(1,i)) + E_t(2,i);  
CH(GH_t(1,i)) =    CH(GH_t(1,i)) + GH_t(2,i);      
end  


% Db Triad 
Db = R;
for i = 1 : 6
 
Db(CH_t(1,i)) =    Db(CH_t(1,i)) + CH_t(2,i);  
Db(F_t(1,i)) =    Db(F_t(1,i)) + F_t(2,i);  
Db(GH_t(1,i)) =    Db(GH_t(1,i)) + GH_t(2,i);      
end  


% Dm Triad 
Dm = R;
for i = 1 : 6
 
Dm(D_t(1,i)) =    Dm(D_t(1,i)) + D_t(2,i);  
Dm(F_t(1,i)) =    Dm(F_t(1,i)) + F_t(2,i);  
Dm(A_t(1,i)) =    Dm(A_t(1,i)) + A_t(2,i);      
end  

% D Triad 
D = R;
for i = 1 : 6
 
D(D_t(1,i)) =    D(D_t(1,i)) + D_t(2,i);  
D(FH_t(1,i)) =    D(FH_t(1,i)) + FH_t(2,i);  
D(A_t(1,i)) =    D(A_t(1,i)) + A_t(2,i);      
end  

% DH Triad 
DH = R;
for i = 1 : 6
 
DH(DH_t(1,i)) =    DH(DH_t(1,i)) + DH_t(2,i);  
DH(FH_t(1,i)) =    DH(FH_t(1,i)) + FH_t(2,i);  
DH(AH_t(1,i)) =    D(AH_t(1,i)) + AH_t(2,i);      
end  


% Eb Triad 
Eb = R;
for i = 1 : 6
 
Eb(DH_t(1,i)) =    Eb(DH_t(1,i)) + DH_t(2,i);  
Eb(G_t(1,i)) =    Eb(G_t(1,i)) + G_t(2,i);  
Eb(AH_t(1,i)) =    Eb(AH_t(1,i)) + AH_t(2,i);      
end 


% E Triad 
E = R;
for i = 1 : 6
 
E(E_t(1,i)) =    E(E_t(1,i)) + E_t(2,i);  
E(G_t(1,i)) =    E(G_t(1,i)) + G_t(2,i);  
E(B_t(1,i)) =    E(B_t(1,i)) + B_t(2,i);      
end 


% Em Triad 
Em = R;
for i = 1 : 6
 
Em(E_t(1,i)) =    Em(E_t(1,i)) + E_t(2,i);  
Em(GH_t(1,i)) =    Em(GH_t(1,i)) + GH_t(2,i);  
Em(B_t(1,i)) =    Em(B_t(1,i)) + B_t(2,i);      
end 


% F Triad 
F = R;
for i = 1 : 6
 
F(F_t(1,i)) =    F(F_t(1,i)) + F_t(2,i);  
F(A_t(1,i)) =    F(A_t(1,i)) + A_t(2,i);  
F(C_t(1,i)) =    F(C_t(1,i)) + C_t(2,i);      
end 


% Fm Triad 
Fm = R;
for i = 1 : 6
 
Fm(F_t(1,i)) =    Fm(F_t(1,i)) + F_t(2,i);  
Fm(GH_t(1,i)) =    Fm(GH_t(1,i)) + GH_t(2,i);  
Fm(C_t(1,i)) =    Fm(C_t(1,i)) + C_t(2,i);      
end 


% Fm Triad 
FH = R;
for i = 1 : 6
 
FH(FH_t(1,i)) =    FH(FH_t(1,i)) + FH_t(2,i);  
FH(A_t(1,i)) =    FH(A_t(1,i)) + A_t(2,i);  
FH(CH_t(1,i)) =    FH(CH_t(1,i)) + CH_t(2,i);      
end 


% Gb Triad 
Gb = R;
for i = 1 : 6
 
Gb(FH_t(1,i)) =    Gb(FH_t(1,i)) + FH_t(2,i);  
Gb(GH_t(1,i)) =    Gb(GH_t(1,i)) + GH_t(2,i);  
Gb(CH_t(1,i)) =    Gb(CH_t(1,i)) + CH_t(2,i);      
end 


% G Triad 
G = R;
for i = 1 : 6
 
G(G_t(1,i)) =    G(G_t(1,i)) + G_t(2,i);  
G(B_t(1,i)) =    G(B_t(1,i)) + B_t(2,i);  
G(D_t(1,i)) =    G(D_t(1,i)) + D_t(2,i);      
end 


% Gm Triad 
Gm = R;
for i = 1 : 6
 
Gm(G_t(1,i)) =    Gm(G_t(1,i)) + G_t(2,i);  
Gm(AH_t(1,i)) =    Gm(AH_t(1,i)) + AH_t(2,i);  
Gm(D_t(1,i)) =    Gm(D_t(1,i)) + D_t(2,i);      
end


% GH Triad 
GH = R;
for i = 1 : 6
 
GH(GH_t(1,i)) =    GH(GH_t(1,i)) + GH_t(2,i);  
GH(B_t(1,i)) =    GH(B_t(1,i)) + B_t(2,i);  
GH(DH_t(1,i)) =    GH(DH_t(1,i)) + DH_t(2,i);      
end


% Ab Triad 
Ab = R;
for i = 1 : 6
 
Ab(GH_t(1,i)) =    Ab(GH_t(1,i)) + GH_t(2,i);  
Ab(C_t(1,i)) =    Ab(C_t(1,i)) + C_t(2,i);  
Ab(DH_t(1,i)) =    Ab(DH_t(1,i)) + DH_t(2,i);      
end


% Am Triad 
Am = R;
for i = 1 : 6
 
Am(A_t(1,i)) =    Am(A_t(1,i)) + A_t(2,i);  
Am(C_t(1,i)) =    Am(C_t(1,i)) + C_t(2,i);  
Am(E_t(1,i)) =    Am(E_t(1,i)) + E_t(2,i);      
end


% A Triad 
A = R;
for i = 1 : 6
 
A(A_t(1,i)) =    A(A_t(1,i)) + A_t(2,i);  
A(CH_t(1,i)) =    A(CH_t(1,i)) + CH_t(2,i);  
A(E_t(1,i)) =    A(E_t(1,i)) + E_t(2,i);      
end


% AH Triad 
AH = R;
for i = 1 : 6
 
AH(AH_t(1,i)) =    AH(AH_t(1,i)) + AH_t(2,i);  
AH(CH_t(1,i)) =    AH(CH_t(1,i)) + CH_t(2,i);  
AH(F_t(1,i)) =    AH(F_t(1,i)) + F_t(2,i);      
end


% Bb Triad 
Bb = R;
for i = 1 : 6
 
Bb(AH_t(1,i)) =    Bb(AH_t(1,i)) + AH_t(2,i);  
Bb(D_t(1,i)) =    Bb(D_t(1,i)) + D_t(2,i);  
Bb(F_t(1,i)) =    Bb(F_t(1,i)) + F_t(2,i);      
end


% Bm Triad 
Bm = R;
for i = 1 : 6
 
Bm(B_t(1,i)) =    Bm(B_t(1,i)) + B_t(2,i);  
Bm(D_t(1,i)) =    Bm(D_t(1,i)) + D_t(2,i);  
Bm(FH_t(1,i)) =    Bm(FH_t(1,i)) + FH_t(2,i);      
end


% B Triad 
B = R;
for i = 1 : 6
 
B(B_t(1,i)) =    B(B_t(1,i)) + B_t(2,i);  
B(DH_t(1,i)) =    B(DH_t(1,i)) + DH_t(2,i);  
B(FH_t(1,i)) =    B(FH_t(1,i)) + FH_t(2,i);      
end



Cm(~Cm) = 0.005;  %zeros
C(~C) = 0.005;
CH(~CH) = 0.005;
Db(~Db) = 0.005;
D(~D) = 0.005;
Dm(~Dm) = 0.005;
DH(~DH) = 0.005;
Eb(~Eb) = 0.005;
Em(~Em) = 0.005;
E(~E) = 0.005;
F(~F) = 0.005;
Fm(~Fm) = 0.005;
FH(~FH) = 0.005;
Gb(~Gb) = 0.005;
Gm(~Gm) = 0.005;
G(~G) = 0.005;
GH(~GH) = 0.005;
A(~A) = 0.005;
Ab(~Ab) = 0.005;
Am(~Am) = 0.005;
AH(~AH) = 0.005;
Bb(~Bb) = 0.005;
Bm(~Bb) = 0.005;
B(~B) = 0.005;

Cm = Cm/norm(Cm);  %norm
C = C/norm(C);
CH = CH/norm(CH);
Db = Db/norm(Db);
D = D/norm(D);
Dm = Dm/norm(Dm);
DH = DH/norm(DH);
Eb = Eb/norm(Eb);
Em = Em/norm(Em);
E = E/norm(E);
F = F/norm(F);
Fm = Fm/norm(Fm);
FH = FH/norm(FH);
Gb = Gb/norm(Gb);
Gm = Gm/norm(Gm);
G = G/norm(G);
GH = GH/norm(GH);
A = A/norm(A);
Ab = Ab/norm(Ab);
Am = Am/norm(Am);
AH = AH/norm(AH);
Bb = Bb/norm(Bb);
Bm = Bm/norm(Bm);
B = B/norm(B);

Har_Template = [Cm; C; CH; Db; Dm; D; DH; Eb; Em; E; Fm; F; FH; Gb; Gm; G; GH; Ab; Am; A; AH; Bb; Bm; B];

save('Harmonic_Template.mat','Har_Template');