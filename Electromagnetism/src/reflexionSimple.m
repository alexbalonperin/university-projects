function reflexionSimple(TX, RX, D) 

global vec crois dessin;

for i = 1 : length(vec)
   xinit = vec(i,1);
   yinit = vec(i,2);
   xfin = vec(i,3);
   yfin = vec(i,4);
   %cas vertical
   if xinit == xfin 
       im = [(2*xinit-TX(1)) (TX(2))];
       yinter = (((RX(2)-im(2))/(RX(1)-im(1)))*(xinit-im(1)))+im(2);
       ref = [(xinit) (yinter)];       
       
    
      
       checkMurMethodeIm =((xinit < RX(1) && xinit > TX(1)) || (xinit > RX(1) && xinit < TX(1)));
       checkMurPosition = yinter>yinit && yinter<yfin ;

       if( ~checkMurMethodeIm && checkMurPosition)
           reflexionSurCroisement = false;
           for k =1: length(crois)
               if(abs(ref(1)-crois(k,1)) < 1 && abs(ref(2)-crois(k,2)) < 1)
                   reflexionSurCroisement = true;
                   break;
               end
           end
           if(~reflexionSurCroisement)  
                
                if distance(ref,RX) ~= 0
                    thetaI = angleIncident(TX,ref);
                    calculeChampRefSimple ( ref, TX,RX, thetaI,D, im);
                    if dessin
                       line([ref(1) RX(1)], [ref(2) RX(2)], 'Color', 'g'); 
                       line([TX(1) ref(1)] , [TX(2) ref(2)], 'Color', 'g');
                    end
                end
             
          end
       end
   end
   %cas horizontal
   if(yinit == yfin)
       im = [(TX(1)) (2*yinit-TX(2))];
        xinter = ((yinit-im(2))/((RX(2)-im(2))/(RX(1)-im(1))))+im(1);
        ref = [xinter yinit];
       
        

       checkMurMethodeIm = ((yinit < RX(2) && yinit > TX(2)) || (yinit > RX(2) && yinit < TX(2)));
       checkMurPosition = xinter > xinit &&  xinter < xfin;

       if(~checkMurMethodeIm && checkMurPosition ) 
           reflexionSurCroisement = false;
            for k =1: length(crois)
               if(abs(ref(1)-crois(k,1)) < 1 && abs(ref(2)-crois(k,2)) < 1)
                   reflexionSurCroisement = true;
                   break;
               end
           end
           if(~reflexionSurCroisement)
               if distance(ref,RX) ~=0  % si recepteur est sur le meme mur que ref -> onde directe
                   thetaI = pi/2 - angleIncident (TX,ref);
                   calculeChampRefSimple(ref,TX,RX,thetaI,D, im);
                   if dessin
                       line([ref(1) RX(1)], [ref(2) RX(2)], 'Color', 'g'); 
                       line([TX(1) ref(1)] , [TX(2) ref(2)], 'Color', 'g');
                   end
               end
           end
       end
    end
end

end


