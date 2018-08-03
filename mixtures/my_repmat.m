function B = my_repmat(A,siz,N)
%REPMAT Replicate and tile an array.
%   B = repmat(A,M,N) creates a large matrix B consisting of an M-by-N
%   tiling of copies of A. The size of B is [size(A,1)*M, size(A,2)*N].
%   The statement repmat(A,N) creates an N-by-N tiling.
%
%   B = REPMAT(A,[M N]) accomplishes the same result as repmat(A,M,N).
%
%   B = REPMAT(A,[M N P ...]) tiles the array A to produce a
%   multidimensional array B composed of copies of A. The size of B is
%   [size(A,1)*M, size(A,2)*N, size(A,3)*P, ...].
%
%   REPMAT(A,M,N) when A is a scalar is commonly used to produce an M-by-N
%   matrix filled with A's value and having A's CLASS. For certain values,
%   you may achieve the same results using other functions. Namely,
%      REPMAT(NAN,M,N)           is the same as   NAN(M,N)
%      REPMAT(SINGLE(INF),M,N)   is the same as   INF(M,N,'single')
%      REPMAT(INT8(0),M,N)       is the same as   ZEROS(M,N,'int8')
%      REPMAT(UINT32(1),M,N)     is the same as   ONES(M,N,'uint32')
%      REPMAT(EPS,M,N)           is the same as   EPS(ONES(M,N))
%
%   Example:
%       repmat(magic(2), 2, 3)
%       repmat(uint8(5), 2, 3)
%
%   Class support for input A:
%      float: double, single
%
%   See also BSXFUN, MESHGRID, ONES, ZEROS, NAN, INF.

%   Copyright 1984-2010 The MathWorks, Inc.
%   $Revision: 1.17.4.17 $  $Date: 2010/08/23 23:08:12 $





if size(A,1)==1
    nelems = prod(double(siz));
    % Since B doesn't exist, the first statement creates a B with
    % the right size and type.  Then use scalar expansion to
    % fill the array. Finally reshape to the specified size.
    B(nelems) = A;
    if ~isequal(B(1), B(nelems)) || ~(isnumeric(A) || islogical(A))
        % if B(1) is the same as B(nelems), then the default value filled in for
        % B(1:end-1) is already A, so we don't need to waste time redoing
        % this operation. (This optimizes the case that A is a scalar zero of
        % some class.)
        B(:) = A;
    end
    B = reshape(B,siz);
    
else %if ismatrix(A) && numel(siz) == 2
    %[m,n] = size(A);
    
    B = A(:, ones(siz(2), 1));
    
    
end
