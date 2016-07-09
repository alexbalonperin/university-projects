function [counterH counterV] = checkIntersection(pt1,pt2)

global vec;

% dist = [];
counterH = 0;
counterV = 0;
for i = 1 : length(vec)
   xinit = vec(i,1);
   yinit = vec(i,2);
   xfin = vec(i,3);
   yfin = vec(i,4);
   
     %cas horizontal
    if yinit == yfin
       if pt2(1) ~= pt1(1)
                xinter = droite(pt1(1), pt1(2), pt2(1), pt2(2), yinit,'hor');
                entreRetE = ( pt1(2) < yinit && pt2(2) > yinit ) || ( pt1(2) > yinit && pt2(2)<yinit);
                
                rencontreUnMur = xinit < xinter && xinter < xfin  ;
                if entreRetE && rencontreUnMur
%                     plot ( xinter, yinit, 'ro');
                    counterH = counterH + 1 ;
                end
       else
             %si l'onde rencontre un mur
              if  ((yinit<pt1(2) && yinit>pt2(2)) || (yinit>pt1(2) && yinit<pt2(2))) && ( pt2(1)>xinit && pt2(1)<xfin ) 
%                     plot ( pt2(1), yinit, 'o');
                     counterH = counterH + 1 ;
              end  
        end
    end
  
     %cas vertical
    if xinit == xfin
         if pt2(1) ~= pt1(1)
            yinter = droite(pt1(1), pt1(2), pt2(1), pt2(2),xinit, 'ver');
            entreRetE = ( pt1(1) < xinit && pt2(1) > xinit ) || ( pt1(1) > xinit && pt2(1)<xinit);
            rencontreUnMur = (yinit < yinter && yinter < yfin);
            if entreRetE && rencontreUnMur
%                  plot ( xinit,yinter, 'go');
                  counterV = counterV + 1 ;
            end
         else 
             %si l'onde rencontre un mur           
              if  ((xinit<pt1(1) && xinit>pt2(1)) || (xinit>pt1(1) && xinit<pt2(1))) && ( pt2(2)>yinit && pt2(2)<yfin ) 
%                     plot ( xinit, pt2(2), 'o');
                      counterV = counterV + 1 ;
               end 
         end
    end
end
end


