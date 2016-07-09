function vec = Plan
% Le vecteur VEC contient le plan du UA4.
% Attention la puissance et le débit ne doivent pas être déterminer 
% dans la zone au centre sitée entre x =[13 27] et y=[4 34] mais les murs 
% entourant cette zone interviennet dans les calculs de réflexions, 
% transmissions et diffractions.
vec = [0 0 42 0;
    42 0 42 46;
    42 46 0 46;
    0 46 0 0;
    6 0 6 1.5;
    6 2.5 6 4;
    0 4 11.5 4;
    11 0 11 1;
    11 3 11 4;
    12.5 4 31 4;
    32 4 33 4;
    35 4 42 4;
    35 2 35 0;
    13 4 13 34;
    7 34 33 34;
    27 34 27 4;
    35 34 42 34;
    35 34 35 33;
    35 32 35 26;
    35 25 35 23;
    35 22 35 16;
    35 15 35 13;
    35 12 35 6;
    35 5 35 3;
    35 24 42 24;
    35 14 42 14;
    33 4 33 8;
    33 9 33 16;
    33 17 33 19;
    33 20 33 26;
    33 27 33 29;
    33 30 33 34;
    27 28 33 28;
    27 24 33 24;
    27 19 33 19;
    27 14 33 14;
    27 8 33 8;
    33 36 33 46;
    33 42 34 42;
    35 42 40 42;
    41 42 42 42;
    31 36 33 36;
    24 36 30 36;
    23 36 23 46;
    21 36 23 36;
    14 36 20 36;
    13 36 13 46;
    5 36 8 36;
    9 36 13 36;
    0 15 13 15;
    7 15 7 28;
    7 29 7 32;
    7 33 7 34;
    7 29 13 29;
    5 35 5 46;
    5 15 5 17;
    5 18 5 21;
    5 22 5 26;
    5 27 5 31;
    5 32 5 34;
    0 19 5 19;
    0 24 5 24;
    0 29 5 29;
    0 34 5 34;
    0 38 1 38;
    2 38 5 38;
    0 42 3 42;
    4 42 5 42];

for i = 1 : length(vec)
   xinit = vec(i,1);
   yinit = vec(i,2);
   xfin = vec(i,3);
   yfin = vec(i,4);
   %réarrangement par ordre croissant
   if xinit > xfin
        vec(i,1) = xfin;
        vec(i,3) = xinit;
   end
   if yinit > yfin
       vec(i,2) = yfin;
       vec(i,4) = yinit;
   end
   line([xinit xfin], [yinit yfin]);
end

%RedZone
x =[13 27]; 
y=[4 34];
% line([x(1) x(2)], [y(1) y(1)],'Color','r');
% line([x(1) x(2)], [y(2) y(2)],'Color','r');
% line([x(1) x(1)] , [y(1) y(2)],'Color','r');
% line([x(2) x(2)] , [y(1) y(2)],'Color','r');
