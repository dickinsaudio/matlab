function Y=GDFT(X)
% GDFT - Glenn's modified transform, for use in analysis
%
% Y=GDFT(X)
%
% Returns length/2 complex vector representing the half frequency bins of
% the FFT assuming input is real.
%
% Has lots of useful properties
% X = gdft(x)  Y = gdft(y)
% X*Y' = sum(x.*y) + i*sum(x.*imag(hilbert(y)))


if size(X,1)==1, X=X(:); Transpose=1; else Transpose=0; end;
Len=size(X,1)/2; Len=ceil(Len); if size(X,1)<(2*Len), X(2*Len,1)=0; end;
Z  =fft((X(1:Len,:) - X(Len+1:2*Len,:)*i) .* (exp(-(0:Len-1)'*i*pi/Len/2)*ones(1,size(X,2))));
Y(1:2:Len,:) = Z(1:floor((Len+1)/2),:)/sqrt(Len);
Y(2:2:Len,:) = conj(Z(Len:-1:ceil(Len/2+1),:))/sqrt(Len);

if Transpose, Y=Y.'; end;
