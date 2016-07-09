function distribution(obj)
   if strcmp(distr,'mixtGauss')
       obj.distr = gmdistribution(mu,sigma,p);
   elseif strcmp(distr,'Gauss')
       obj.distr = gmdistribution(mu,sigma,p);
   end
end