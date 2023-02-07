function h = subplot(m,n,p,varargin)
persistent handles M N Left Right Top Bottom HGap VGap; 
if (isstr(m) && strcmp(m,'layout')) Left=n;   Right=p;   Top=varargin{1}; Bottom=varargin{2}; HGap=varargin{3}; VGap=varargin{4}; h=0; return; end;
if (isempty(Left))                  Left=.04; Right=.01; Top=.05; Bottom = 0.02; HGap   = 0.01; VGap   = 0.01; end;
if (isstr(m))   m = sscanf(m,'%d'); end;
if (m>100)      p = mod(m,10);  n = floor(mod(m,100)/10);   m = floor(m/100);  end;
if (m>1000)     p = mod(m,100); n = floor(mod(m,1000)/100); m = floor(m/1000); end;
if (~exist('handles') || isempty(M)) handles = zeros(m*n,1); M=m; N=n; end;
if (isempty(get(gcf,'CurrentAxes'))) handles = zeros(m*n,1); M=m; N=n; end;
if (M~=m | N~=n)                     handles = zeros(m*n,1); M=m; N=n; end;
if (length(p)==2) x = p(2)-1;       y = M-p(1);    p=(M-y-1)*n+x+1;
else              x = mod(p-1,n);   y = M-ceil(p/n); end;
if (x>=n || x<0 || y>=m || y<0) error('Subfigure exceeds dimensions.'); end;
if (handles(p)>0) h = handles(p); try set(gcf,'CurrentAxes',h); catch end; return; end;

Width  = (1 - Left - Right - (N-1)*HGap) / N;
Height = (1 - Top - Bottom - (M-1)*VGap) / M;
X      = Left +   x*(Width+HGap);
Y      = Bottom + y*(Height+VGap);

h = axes('position',[ X Y Width Height ]);
handles(p) = h;


