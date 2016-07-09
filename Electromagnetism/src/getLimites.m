function [xlimG xlimD ylimH ylimB] = getLimites

global vec;

xlimG = vec(1,1);
xlimD = vec(1,2);
ylimH = vec(1,3);
ylimB = vec(1,4);

% affichage des murs
for i= 1 : length(vec)
   if(vec(i,1)<xlimG)
       xlimG = vec(i,1);
   end
   if(vec(i,3)>xlimD)
       xlimD = vec(i,3);
   end
   if(vec(i,2)<ylimB)
       ylimB = vec(i,2);
   end
   if(vec(i,4)>ylimH)
       ylimH = vec(i,4);
   end
end
end