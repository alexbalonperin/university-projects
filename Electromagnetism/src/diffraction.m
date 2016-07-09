function diffraction(TX, RX, ptinit, ptfin)

global vec dessin;

% condition1 = true;
% condition2 = true;
for i=1 : length(vec)
    for j=1:length(vec)
        if ptinit(i,1) == ptfin(j,1) && ptinit(i,2) == ptfin(j,2) && ptinit(i,3) ~= ptfin(j,3)
            ptinit(i,3)=1;
            ptfin(j,3) =1;
%                 condition1 = false;
%                 condition2 = false;
        end
    end
    if ptinit(i,3) == 0
%      if condition1
        ptDiffraction = [ptinit(i,1) ptinit(i,2)];
        calculChampDiffraction(TX, RX, ptDiffraction);
        if dessin
            line([TX(1) ptinit(i,1)],[TX(2) ptinit(i,2)],'Color', 'g');
%             line([ptinit(i,1) RX(1)],[ptinit(i,2) RX(2)], 'Color','g');
            plot(ptinit(i,1), ptinit(i,2),'go');
        end
   
    end
    if ptfin(i,3) == 0
%     if condition2
        ptDiffraction = [ptfin(i,1) ptfin(i,2)];
        calculChampDiffraction(TX, RX, ptDiffraction);
        if dessin
            line([TX(1) ptfin(i,1)],[TX(2) ptfin(i,2)], 'Color','r');
%             line([ptfin(i,1) RX(1)],[ptfin(i,2) RX(2)],'Color', 'r');
            plot(ptfin(i,1), ptfin(i,2) , 'ro');
        end
    end
end


 
   



