function Y = ConvolveChannels(X,hi)
    Y = zeros(size(X,1)+size(hi,1)-1,size(hi,3));
    fprintf('Creating %d Channel Output - This could take a while\n',size(hi,3));
    parfor (s=1:size(hi,3))
        Y(:,s) = sum(Convolve(X,hi(:,:,s)),2);
    end;
