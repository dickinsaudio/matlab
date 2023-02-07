%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RingPlot
%
% Plot a set of values given in terms of integer colormap and angle.  Works out the grid points to
% put a flat facet at each point with the correct colour.  Looks a bit better than a mesh for the same points
% when representing polar plots.
%
% 


function RingPlot(X, Angles, R1, R2, Type)

if (nargin<5) Type = 0; end;
if (nargin<4 || isempty(R2))      R2 = 1; end;
if (nargin<3 || isempty(R1))      R1 = 0.25; end;
if (nargin<2 || isempty(Angles)) Angles = (0:size(X,1)-1)/size(X,1)*360; end;

% Get the angles in order
Angles    = Angles(:)';
Angles    = mod(Angles,360);
[ tmp I ] = sort(Angles);
if (diff(Angles(I([1 2])))==0) I = I(2:end); end;
Angles = Angles(I);
X      = X(I,:);

if (Type == 0)              % Surface with data as the vertices
    Radii = (0:size(X,2)-1)/(size(X,2)-1)*(R2-R1)+R1;
    R  = kron(Radii,ones(size(X,1)+1,1));
    TH = kron(ones(1,size(X,2)),Angles([1:end 1])'); 
    PatchX = R .* cos(TH/180*pi);
    PatchY = R .* sin(TH/180*pi);
    surf(PatchX, PatchY, X([1:end 1],:),'linestyle','none'); shading interp; view(2);
elseif (Type == 1)          % Flat patch for each data point    
    % Create a set of angles that split, and stepped radii
    Split = filter([.5 .5],1,[Angles(end)-360 Angles Angles(1)+360]); Split = Split(2:end);
    Radii = (0:size(X,2))/size(X,2)*(R2-R1)+R1;
    % Now for each point, create the patch matrix
    R  = kron(                  [ [1 1]'*Radii(1:end-1); [1 1]'*Radii(2:end);                ],ones(1,size(X,1)));
    TH = kron(ones(1,size(X,2)),[        Split(1:end-1); [1 1]'*Split(2:end); Split(1:end-1) ]); 
    PatchX = R .* cos(TH/180*pi);
    PatchY = R .* sin(TH/180*pi);
    patch(PatchX, PatchY, X(:)' ,'linestyle','none'); shading flat;
elseif (Type == 2)          % Interpolated patch around angle, patch for each ring
    Split = Angles([1:end 1]);
    Radii = (0:size(X,2))/size(X,2)*(R2-R1)+R1;
    R  = kron(                  [ [1 1]'*Radii(1:end-1); [1 1]'*Radii(2:end);                ],ones(1,size(X,1)));
    TH = kron(ones(1,size(X,2)),[        Split(1:end-1); [1 1]'*Split(2:end); Split(1:end-1) ]); 
    PatchX = R .* cos(TH/180*pi);
    PatchY = R .* sin(TH/180*pi);
    XL    = X(:)';
    XR    = X([2:end 1],:); XR=XR(:)';
    patch(PatchX, PatchY, [ XL; XR; XR; XL;] ,'linestyle','none'); shading interp;
end;    




