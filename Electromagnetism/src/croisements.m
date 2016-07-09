function resultat = croisements

global vec;

counter = 1;
for i = 1 : length(vec)
   xinit1 = vec(i,1);
   yinit1 = vec(i,2);
   xfin1 = vec(i,3);
   yfin1 = vec(i,4);
   for j = 1 : length(vec)
       xinit2 = vec(j,1);
       yinit2 = vec(j,2);
       xfin2 = vec(j,3);
       yfin2 = vec(j,4);
        %cas vertical
        if xinit1 == xfin1 && yinit2 == yfin2
             if yinit1 == yinit2 && xinit1 >= xinit2 && xinit1 <= xfin2
                 resultat(counter, 1) = xinit1;
                 resultat(counter, 2) = yinit1;
                 counter = counter + 1;
%                  plot ( xinit1,yinit1, 'ro');
             end
             if yfin1 == yinit2 && xinit1 >= xinit2 && xinit1 <= xfin2
                 resultat(counter, 1) = xinit1;
                 resultat(counter, 2) = yfin1;
                 counter = counter + 1;
%                  plot ( xinit1,yfin1, 'ro');
             end
        end
         %cas horizontal
        if yinit1 == yfin1 && xinit2 == xfin2
             if xinit1 == xinit2 && yinit1 >=yinit2 && yinit1<=yfin2
                 resultat(counter, 1) = xinit1;
                 resultat(counter, 2) =yinit1;
                 counter = counter + 1;
%                  plot ( xinit1, yinit1, 'ro');
             end
             if xfin1 == xinit2 && yinit1 >=yinit2 && yinit1<=yfin2
                 resultat(counter, 1) = xfin1;
                 resultat(counter, 2) = yinit1;
                 counter = counter + 1;
%                  plot ( xfin1, yinit1, 'ro');
             end
        end
   end
end 
end