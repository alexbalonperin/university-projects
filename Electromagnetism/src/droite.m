function res = droite(x1,y1,x2,y2, param , orientation)
    a = (y2 - y1)/(x2 - x1);
    b = (-a * x1) + y1;
if(strcmp( orientation, 'ver'))
    x = param;
    res = a*x + b;
  
elseif (strcmp( orientation, 'hor'))
    y = param;
    res = (y - b)/a;
end

end