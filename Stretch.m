function [ Y, R ] = Stretch( X, Tick, Period, R, Chan, Align, TickPos, RError )
% [ Y R ] = Stretch( X Tick Period )
%   Stretch a vector X to match a periodic repeat of a filtered version of Tick
%   X       is a column vector, assumed to be all at the same sample rate
%   Tick    is a short ideally broad band chirp or pulse
%   Period  is the desired period between the Ticks
%   R       approximation of the resample rate within 1% (default 1)
%   Chan    is the columns of X to use (default 0 = use the column sum)
%   Align   is the sample to align the decorrelated peak to ( default 0 = do not align)
%   TickPos is the estimated tick position ( defulat [0 0.05] )
%   RError  is the margin of error for R   ( default 0.01    ]
%   
% It is assumed that the tick occurs in the first 10% of the period.
% A tick at the end of X is optional and will be used if detected.

if (nargin<4)   R       = 1;            end;
if (nargin<5)   Chan    = 1:size(X,2);  end;
if (nargin<6)   Align   = 0;            end;
if (nargin<7)   TickPos = [0 0.05];     end;
if (nargin<8)   RError  = 0.01;         end;

if (Chan==0) Chan = 1:size(X,2); end;

P = round(Period/R);                            % Estimated period in the X domain;
Z = zeros(ceil(size(X,1)/P+1/2)*P,1);           % Create the working array for stretch estimation
Z(floor(P/2)+(1:size(X,1))) = sum(X(:,Chan),2); % Put it into the working space, offset by P/2
Z = reshape(Z,P,[]);                            % Turn it into a set of columns
Z = Z(floor(P/2) + (floor((TickPos(1)-RError)*P):ceil((TickPos(2)+RError)*P)),:);
Z = Convolve(Z,flipud(Tick));                   % Pull out the peaks with Tick matched (flipped)
Z = abs(hilbert(resample(Z,10,1)));             % Oversample to get a better set of peaks

[mx at] = max(Z);                               % Now read off the peaks
valid = mx > 0.25*median(mx);                   % Clean up tail enders
if (sum(valid(1:sum(valid)))~=sum(valid))
    error('Not consecutive valid Ticks');   
end;
at = at(1:sum(valid));

R = Period / (Period + mean(diff(at))/10);      % This is our actual resampling ratio

% Now we want to find the best P and Q such that P*Q<2^31 and P/Q ~ R  (PQ RQ^2)
% Note that P will be near an integer for Q and int about every 1/(R-1) points

n = (1:sqrt(2^31*(1-R)^2/R));                   % This is the possible number of points to check
if (isempty(n)) Y=X; warning('Sample Rate is too close to resample - check it is locked already');
else
    e = n./abs(1-R);                                % This is the error at those points
    [mn N] = min(abs(e-round(e)));                  % Usually will be very close
    Y = resample(X,round(e(N)*R),round(e(N)));      % This is pretty efficient as a polyphase, however
end;                                                % it will take a while (around 400x real time)

% Align by getting rid of a bit off the start
if (Align > 0)
    o = max(1,floor((at(1)/10 - RError*P - size(Tick,1))*R) - Align);
    Y = Y(o:end,:);
end;

                                                
                                                
                                                