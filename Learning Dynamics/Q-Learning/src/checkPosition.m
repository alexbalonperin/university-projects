function [action] = checkPosition(s, action)

global xmax ymax actionsX actionsY;

x = s(1);
y = s(2);

actionX = actionsX(action);
actionY = actionsY(action);

%gauche
if x == 1
    %coin bas gauche
    if y == 1    
        if actionY < 0 && actionX < 0
            num =  ceil(2*rand());
           if num == 1 
                action = 3;
           else 
               action = 1;
           end
        elseif actionX < 0
            action = 3;
        elseif actionY < 0
            action = 1;
        end
    %coin haut gauche   
    elseif y == ymax
         if actionY > 0 && actionX < 0
            num =  ceil(2*rand());
           if num == 1 
                action = 4;
           else 
               action = 1;
           end
        elseif actionX < 0
            action = 4;
        elseif actionY > 0
            action = 1;
        end
    %gauche
    else
         if actionX < 0
             if action == 2
               num =  ceil(2*rand());
               if num == 1 
                    action = 3;
               else 
                   action = 4;
               end
             elseif action == 8
                 action = 3;
             elseif action == 6
                 action = 4;
             end
         end
    end
%droite
elseif x == xmax  
     %coin bas droite
    if y == 1    
        if actionY < 0 && actionX > 0
            num =  ceil(2*rand());
           if num == 1 
               action = 3;
           else 
               action = 2;
           end
        elseif actionX > 0
            action = 3;
        elseif actionY < 0
            action = 2;
        end
    %coin haut droite  
    elseif y == ymax
         if actionY > 0 && actionX > 0
            num =  ceil(2*rand());
           if num == 1 
               action = 4;
           else 
               action = 2;
           end
        elseif actionX > 0
            action = 4;
        elseif actionY > 0
            action = 2;
        end
    %droite
    else       
         if actionX > 0
             if action == 1
               num =  ceil(2*rand());
               if num == 1 
                    action = 3;
               else 
                   action = 4;
               end
             elseif action == 5
                 action = 3;
             elseif action == 7
                 action = 4;
             end
         end
    end
%en bas
elseif y == 1
    if actionY < 0
         if action == 4
           num =  ceil(2*rand());
           if num == 1 
               action = 1;
           else 
               action = 2;
           end
         elseif action == 6
             action = 2;
         elseif action == 7
             action = 1;
         end
    end
%en haut
elseif y == ymax
    if actionY > 0
         if action == 3
           num =  ceil(2*rand());
           if num == 1 
               action = 1;
           else 
               action = 2;
           end
         elseif action == 8
             action = 2;
         elseif action == 5
             action = 1;
         end
    end    
end