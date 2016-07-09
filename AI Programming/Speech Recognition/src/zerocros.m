function [t,s]=zerocros(x,m)
% 0002 %ZEROCROS finds the zeros crossings in a signal [T,S]=(X,M)% find zero crossings in a signal
% 0003 % Inputs:  x = input waveform
% 0004 %          m = mode string containing:
% 0005 %              'p' - positive crossings only
% 0006 %              'n' - negative crossings only
% 0007 %              'b' - both (default)
% 0008 %              'r' - round to integer values
% 0009 %
% 0010 % Outputs: t = sample positions of zero crossings (not necessarily integers)
% 0011 %          s = estimated slope of x at the zero crossing
% 0012 %
% 0013 % This routine uses linear interpolation to estimate the position of a zero crossing
% 0014 % A zero crossing occurs between x(n) and x(n+1) iff (x(n)>=0) ~= (x(n+1)>=0)
% 0015 
% 0016 % Example: x=sin(2*pi*(0:1000)/200); x(1:100:1001)=0; zerocros(x);
% 0017 % Note that we get a zero crossing at the end but not at the start.


 if nargin<2
     m='b';
 end
 s=x>=0;
 k=s(2:end)-s(1:end-1);
 if any(m=='p')
     f=find(k>0);
 elseif any(m=='n')
     f=find(k<0);
 else
     f=find(k~=0);
 end
 s=x(f+1)-x(f);
 t=f-x(f)./s;
 if ~nargout
     n=length(x);
     plot(1:n,x,'-',t,zeros(length(t),1),'o');
 end
end