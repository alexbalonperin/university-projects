function [ptinit ptfin] = aretesPortes

global vec;

ptinit = zeros(length(vec), 3);
ptfin = zeros(length(vec), 3);

for i = 1:length(vec)
    
    ptinit(i,1) = vec(i,1);
    ptinit(i,2) = vec(i,2);
    ptinit(i,3) = 0;
    ptfin(i,1) = vec(i,3);
    ptfin(i,2) = vec(i,4);
    ptfin(i,3) = 0; 
end

% Recherches des Intersections de points avec mur (1=intersection, 0=libre)

for i = 1 : length(vec)
    
      xinit = vec(i,1);
      yinit = vec(i,2);
      xfin  = vec(i,3);
      yfin  = vec(i,4);
      for j = 1 : length(vec)
        xj1 = vec(j,1);
        yj1 = vec(j,2);
        xj2 = vec(j,3);
        yj2 = vec(j,4);

        if yfin == yinit && j~=i                                  % mur i horizontal
            if yj1 == yinit && xinit <= xj1 && xj1 <= xfin
                for k = 1  : length(vec)
                   if xj1 == ptinit(k,1) && yj1 == ptinit(k,2)
                      ptinit(k,3) = 1; 
                   end
                end
            end
            
            if yj2 == yinit && xinit <= xj2 && xj2 <= xfin 
                for k = 1 : length(vec)
                   if xj2 == ptfin(k,1) && yj2 == ptfin(k,2)
                      ptfin(k,3) = 1; 
                   end
                end
            end
             
        
        end
        if xfin == xinit && j~=i                                  % mur i vertical
            if xj1 == xinit && yinit <= yj1 && yj1 <= yfin
                for k = 1 :  length(vec)
                   if xj1 == ptinit(k,1) && yj1 == ptinit(k,2)
                      ptinit(k,3) = 1; 
                   end
                end
                
            end
            if xj2 == xinit && yinit <= yj2 && yj2 <= yfin
                for k = 1 : length(vec)
                   if xj2 == ptfin(k,1) && yj2 == ptfin(k,2)
                      ptfin(k,3) = 1;    
                   end
                end
            end
        end
      end   
end