function Y=IGDFT(X)
% IGDFT - Glenn's modified transform, for use in analysis
%
% Y=IGDFT(X)
%
% Reverse operation of GFDT.
%

if size(X,1)==1, X=X(:); Transpose=1; else Transpose=0; end; Len=size(X,1);
X = [X(1:2:Len,:); conj(X(fliplr(2:2:Len),:))];
Y = ifft(X,Len) .* (exp((0:Len-1)'*i*pi/Len/2)*ones(1,size(X,2))) * sqrt(Len);
Y = [real(Y);-imag(Y)];
if Transpose, Y=Y.'; end;
