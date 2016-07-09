function reflexionDouble(TX, RX, D)

global vec crois dessin;

[xlimG xlimD ylimH ylimB] = getLimites;

for i = 1:length(vec)
    
  xinit1 = vec(i,1);
  yinit1 = vec(i,2);
  xfin1  = vec(i,3);
  yfin1  = vec(i,4);
  for j = 1:length(vec)
      xinit2 = vec(j,1);
      yinit2 = vec(j,2); 
      xfin2  = vec(j,3);
      yfin2  = vec(j,4);
      if xinit1 == xfin1  % mur 1 vertical
          im1 = [(2*xinit1-TX(1)) (TX(2))];  % par rapport mur 1
                
                % mur 2 horizontal
                if yinit2 == yfin2 && j~=i 
                    im2 = [im1(1) ((2*yinit2)-im1(2))]; % par rapport mur 2
                    
                    % intersection avec le mur 2
                    xinter2 = ((yinit2-RX(2))*((RX(1)-im2(1))/(RX(2)-im2(2))))+RX(1);
                    yinter2 = yinit2; 
                    ref2 = [xinter2 yinter2];
                    % intersection avec le mur 1
                    xinter1 = xinit1; 
                    yinter1 = (((yinter2-im1(2))/(xinter2-im1(1)))*(xinit1-im1(1)))+im1(2);      
                    ref1 = [xinter1 yinter1];
                    
                    %Vérification qu'il n'y a pas de mur sur le chemin 
                    %entre récepteur et le deuxieme point de réfléxion
                
                    %Vérification qu'il n'y ait pas le dysfonctionnement de
                    %la méthode des images
                    %Entre l'emetteur et le deuxième point de réflexion
                    checkMurMethodeIm1 =((xinit1 < xinter2 && xinit1 > TX(1)) || (xinit1 > xinter2 && xinit1 < TX(1)));
                    %Entre le récepteur et le premier point de réflexion
                    checkMurMethodeIm2 = ((yinit2 < yinter1 && yinit2 > RX(2)) || (yinit2 > yinter1 && yinit2 < RX(2)));
                    checkMurMethodeIm = checkMurMethodeIm1 || checkMurMethodeIm2 ;
                    %Vérification que le point de réflexion se trouve bien
                    %sur le mur sur lequel on travail et pas un autre dans
                    %le prolongement
                    %Pour le premier point de réflexion
                    checkMurPosition1 = yinter1>yinit1 && yinter1<yfin1;
                    %Pour le deuxième point de réflexion
                    checkMurPosition2 = xinter2>xinit2 && xinter2<xfin2;
                    checkMurPosition = checkMurPosition1 && checkMurPosition2 ;
                    
                    %Si toutes les conditions sont remplies on dessine le
                    %rayon et on calcul ce qu'il y a à calculer
                    if(~checkMurMethodeIm && checkMurPosition)
                    
                        if(((ref2(1)<=xlimD && ref2(1)>=xlimG && ref2(2)>=ylimB && ref2(2)<=ylimH)&&...
                                ((ref2(1)<im1(1) && ref1(1)<im1(1) && ref1(1)>ref2(1))||...
                                (ref2(1)>im1(1) && ref1(1)>im1(1) && ref1(1)<ref2(1)))))
                            reflexionSurCroisement = false;
                            for k =1: length(crois)
                               if((abs(ref1(1)-crois(k,1)) < 1 && abs(ref1(2)-crois(k,2)) < 1) || (abs(ref2(1)-crois(k,1)) < 1 && abs(ref2(2)-crois(k,2)) < 1))
                                   reflexionSurCroisement = true;
                                   break;
                               end
                            end
                            if(~reflexionSurCroisement)
                                    thetaI1 = angleIncident(TX,ref1);
                                    thetaI2 = pi/2 - angleIncident (ref1,ref2);
                                 if distance(ref2,RX)
                                     calculeChampRefDouble(ref1, ref2, thetaI1, thetaI2, TX, RX ,D, im2);    
                                     if dessin
                                        line([ref2(1) RX(1)], [ref2(2) RX(2)]);
                                        line([TX(1) ref1(1)] , [TX(2) ref1(2)]);
                                        line([ref1(1) ref2(1)], [ref1(2) ref2(2)]);
                                     end
                                 end
                             
                            end
                        end
                    end
                end
                
                % mur 2 vertical
                if(xinit2 == xfin2 && j~=i) 
                    im2 = [(2*xinit2-im1(1)) im1(2)];
                    xinter2 = xinit2;
                    yinter2 = ((RX(2)-im2(2))/(RX(1)-im2(1)))*(xinter2-RX(1))+RX(2);
                    xinter1 = xinit1;
                    yinter1 = ((yinter2-im1(2))/(xinter2-im1(1)))*(xinit1-im1(1))+im1(2);

                    ref1 = [xinter1 yinter1];
                    ref2 = [xinter2 yinter2];

                           
                    checkMurMethodeIm1 =((xinit1 < xinter2&& xinit1 > TX(1)) || (xinit1 > xinter2 && xinit1 < TX(1)));
                    checkMurMethodeIm2 = ((xinit2 < xinter1 && xinit2 > RX(1)) || (xinit2 > xinter1 && xinit2 < RX(1)));
                    checkMurMethodeIm = checkMurMethodeIm1 || checkMurMethodeIm2 ;
                    checkMurPosition1 = yinter1>yinit1 && yinter1<yfin1;
                    checkMurPosition2 = yinter2>yinit2 && yinter2<yfin2;
                    checkMurPosition = checkMurPosition1 && checkMurPosition2 ;
                    if(~checkMurMethodeIm && checkMurPosition)
                        if(((ref2(1)<=xlimD && ref2(1)>=xlimG && ref2(2)>=ylimB && ref2(2)<=ylimH)&&...
                                ((ref2(1)<im1(1) && ref1(1)<im1(1) && ref1(1)>ref2(1))||...
                                (ref2(1)>im1(1) && ref1(1)>im1(1) && ref1(1)<ref2(1)))))
                            reflexionSurCroisement = false;
                            for k =1: length(crois)
                               if((abs(ref1(1)-crois(k,1)) < 1 && abs(ref1(2)-crois(k,2)) < 1) || (abs(ref2(1)-crois(k,1)) < 1 && abs(ref2(2)-crois(k,2)) < 1))
                                   reflexionSurCroisement = true;
                                   break;
                               end
                            end
                            if(~reflexionSurCroisement) 
                                thetaI1 = angleIncident(TX,ref1);
                                thetaI2 = angleIncident (ref1,ref2);
                                if distance(ref2,RX)
                                    calculeChampRefDouble(ref1, ref2, thetaI1, thetaI2, TX, RX,D, im2 );  
                                    if dessin
                                        line([ref2(1) RX(1)], [ref2(2) RX(2)]);
                                        line([TX(1) ref1(1)] , [TX(2) ref1(2)]);
                                        line([ref1(1) ref2(1)], [ref1(2) ref2(2)]);
                                    end
                                end
                            end
                        end
                    end
                end
      end 

      if(yfin1 == yinit1)% mur 1 horizontal
            im1 = [TX(1) 2*yinit1-TX(2)];
            % mur 2 horizontal
            if(yinit2 == yfin2 && j~=i)       
                im2 = [im1(1) ((2*yinit2)-im1(2))];
                % intersection avec le mur 2
                xinter2 = ((yinit2-RX(2))*((RX(1)-im2(1))/(RX(2)-im2(2))))+RX(1);   
                yinter2 = yinit2;
                ref2 = [xinter2 yinter2];
                
                % intersection avec le mur 1
                yinter1 = yinit1;
                xinter1 = (((xinter2-im1(1))/(yinter2-im1(2)))*(yinter1-im1(2)))+im1(1);      
                ref1 = [xinter1 yinter1];
                
        
                checkMurMethodeIm1 =((yinit1 < yinter2&& yinit1 > TX(2)) || (yinit1 > yinter2 && yinit1 < TX(2)));
                checkMurMethodeIm2 = ((yinit2 < yinter1 && yinit2 > RX(2)) || (yinit2 > yinter1 && yinit2 < RX(2)));
                checkMurMethodeIm = checkMurMethodeIm1 || checkMurMethodeIm2 ;
                checkMurPosition1 = xinter1>xinit1 && xinter1<xfin1;
                checkMurPosition2 = xinter2>xinit2 && xinter2<xfin2;
                checkMurPosition = checkMurPosition1 && checkMurPosition2 ;
                if( ~checkMurMethodeIm && checkMurPosition)
                    if((ref2(1)<=xlimD && ref2(1)>=xlimG && ref2(2)>=ylimB && ref2(2)<=ylimH)&&...
                            ((ref2(1)<im1(1) && ref1(1)<im1(1) && ref1(1)>ref2(1))||...
                            (ref2(1)>im1(1) && ref1(1)>im1(1) && ref1(1)<ref2(1))))
                        reflexionSurCroisement = false;
                        for k =1: length(crois)
                           if((abs(ref1(1)-crois(k,1)) < 1 && abs(ref1(2)-crois(k,2)) < 1) || (abs(ref2(1)-crois(k,1)) < 1 && abs(ref2(2)-crois(k,2)) < 1))
                               reflexionSurCroisement = true;
                               break;
                           end
                        end
                        if(~reflexionSurCroisement)
                                thetaI1 = pi/2 - angleIncident(TX,ref1);
                                thetaI2 = pi/2 - angleIncident (ref1,ref2);
                                if distance(ref2,RX)~=0   % si recepteur sur meme mur que ref2 -> reflexion simple
                                    calculeChampRefDouble(ref1, ref2, thetaI1, thetaI2, TX, RX , D, im2);  
                                    if dessin
                                        line([ref2(1) RX(1)], [ref2(2) RX(2)]);
                                        line([TX(1) ref1(1)] , [TX(2) ref1(2)]);
                                        line([ref2(1) ref1(1)], [ref2(2) ref1(2)]);
                                    end
                                end
                            
                        end
                    end
                end


            end
            
            % mur 2 vertical
            if(xinit2 == xfin2 && j~=i) 
                im2 = [(2*xinit2-im1(1)) im1(2)];
                xinter2 = xinit2;
                yinter2 = ((RX(2)-im2(2))/(RX(1)-im2(1)))*(xinter2-RX(1))+RX(2);

                yinter1 = yinit1;
                xinter1 = ((xinter2-im1(1))/(yinter2-im1(2)))*(yinter1-im1(2))+im1(1);

                ref1 = [xinter1 yinter1];
                ref2 = [xinter2 yinter2];

              
                checkMurMethodeIm1 =((yinit1 < yinter2&& yinit1 > TX(2)) || (yinit1 > yinter2 && yinit1 < TX(2)));
                checkMurMethodeIm2 = ((xinit2 < xinter1 && xinit2 > RX(1)) || (xinit2 > xinter1 && xinit2 < RX(1)));
                checkMurMethodeIm = checkMurMethodeIm1 || checkMurMethodeIm2 ;
                checkMurPosition1 = xinter1>xinit1 && xinter1<xfin1;
                checkMurPosition2 = yinter2>yinit2 && yinter2<yfin2;
                checkMurPosition = checkMurPosition1 && checkMurPosition2 ;

                if( ~checkMurMethodeIm && checkMurPosition)
                    if((ref2(1)<=xlimD && ref2(1)>=xlimG && ref2(2)>=ylimB && ref2(2)<=ylimH)&&...
                            ((ref2(1)<im1(1) && ref1(1)<im1(1) && ref1(1)>ref2(1))||...
                            (ref2(1)>im1(1) && ref1(1)>im1(1) && ref1(1)<ref2(1))))
                        reflexionSurCroisement = false;
                        for k =1: length(crois)
                           if((abs(ref1(1)-crois(k,1)) < 1 && abs(ref1(2)-crois(k,2)) < 1) || (abs(ref2(1)-crois(k,1)) < 1 && abs(ref2(2)-crois(k,2)) < 1))
                               reflexionSurCroisement = true;
                               break;
                           end
                        end
                        if(~reflexionSurCroisement)
                            thetaI1 = pi/2 -  angleIncident(TX,ref1);
                            thetaI2 = angleIncident (ref1,ref2);
                            if distance (ref2,RX) ~= 0
                                 calculeChampRefDouble(ref1, ref2, thetaI1, thetaI2, TX, RX, D, im2 );  
                                 if dessin
                                    line([ref2(1) RX(1)], [ref2(2) RX(2)]);
                                    line([TX(1) ref1(1)] , [TX(2) ref1(2)]);
                                    line([ref2(1) ref1(1)], [ref2(2) ref1(2)]);
                                 end
                            end
                        end
                    end
                end 
            end
      end
   end
end
   

   



