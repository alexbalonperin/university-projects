classes = [972781 3883370 41102 52 1126];
classes = [60593 229853 4166 70 16347];
labels = {'normal', 'DoS', 'Probe', 'U2R', 'R2L'};
bar(classes)
set(gca,'XTickLabel',labels)

ylabel('Number of examples')
xlabel('Class')
title('Distribution of examples over the different classes')

% add the values
for i=1:length(classes),
  TH(i) = text(i,classes(i),num2str(classes(i))) ;
end
% Use the handles TH to modify some properties
set(TH,'Horizontalalignment','center',...
'verticalalignment','bottom') ;
ymax = 4.5*10^6;
%set(gca,'YLim',[0 ymax]); 