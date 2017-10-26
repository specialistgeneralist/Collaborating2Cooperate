function [C,varargout] = GetAllCoalitions_k(G,Ctypes,K)

%GETALLCOALITIONS_k Find all possible coalitions, given G and K.
%   C = GETALLCOALITIONS_K(G,CTYPES,K) creates data structure C containing all 
%   possible coalitions of size 2..K amongst CTYPE=1 agents based on graph G and 
%   vector of CTYPES [n,1]. If no K>1 coaltions are found C returns [].
%
%   [C,M,sM] = GETALLCOALITIONS_K(...) Provides matrix M, a logical matrix, 
%   with n cols, and num unique coalitions (including singletons) rows. Each 
%   row defines a unique coalition by the 1s in the horizontal vector length N, 
%   and a vector [n,1] sM which provides the size of each coalitional row in M.
%
%   Algorithm:
%    1. Start with coaltions of size 2
%    2. If C(k2) is nonempty, then, for each k > 2 {
%         .. build k size coaltions using k-1 coalitions as blocks
%         .. i.e. for each block in preceeding k-level, get adjacent
%            nodes to block-members, construct trial new blocks
%            check if these new-blocks are known, if so, drop,
%            otherwise, remember
%         .. stop when no blocks of size k can be found.}
%  
%   Structure of C:
%    C().k     the value of k for this level of search
%    C().ix    the unique ids capable of forming a block at this level
%    C(k).c =[i1 j1 ... k1]  rows are coalitions
%           [i2 j2 ... k1]
%           [.. .. ... ..]
%
%See also UNIQUE ISMEMBER

% History
% 2014-09-25: Initial coding, building on |GetAllCoaltions.m|
% 2017-08-25: Added fast return for k=1 case

if K==1
    C = [];
    varargout{1} = [];
    varargout{2} = [];
    return
end

% // Nulify and nodes who are non-C
N = size(G,1);
ix_co = find(Ctypes==1);
mask = zeros(size(G)); mask(ix_co,ix_co)=1;
cG = G.*mask;

% // K=2 Primitives amongst C-type vertices
if isempty(ix_co)
	C = [];
else
    [I,J] = find(triu(cG,1));			% [I J] contains edge set of cG
	if isempty(I)
		C = [];
	else
        ij = [I J];
        C.k = 2;
		C.ix = unique(ij);					% unique ids
		C.c = unique(ij,'rows');			% matrix of pairs
	end
end

% // For k > 2, build coalitions from primitives
if (K > 2) & (isempty(C)==0)
	posn = 1;
	for k = 3:K
	    blocks = C(posn).c;
	    n_bl = size(blocks,1);                 % num blocks to work with at previous k
	    new_blocks = [];
	
	    for bl = 1:n_bl
	        ix = blocks(bl,:);
	        [I,J] = find(cG(ix,:));
	        if isempty(J)==0
	            js = unique(setdiff(J,ix));     % ids not in ix, adjacent to ix vertices
	            pos_blocks = sort([ones(numel(js),1)*ix js],2,'ascend');
	            if isempty(new_blocks)
	                new_blocks = pos_blocks;
	            else
	                new_ix = find(1 - ismember(pos_blocks,new_blocks,'rows'));
	                new_blocks = [new_blocks; pos_blocks(new_ix,:)];
	            end
	        end
	    end
	    if isempty(new_blocks)
			break
	    else
	        posn = posn+1;
	        C(posn).k = k;
	        C(posn).ix = unique(new_blocks);
	        C(posn).c = new_blocks;
	    end
	end
end

% // Convert to useful structure
if nargout > 1
	M = logical(zeros(N,N));
	ix = sub2ind(size(M),[1:N]',[1:N]');
	M(ix) = 1;
	for i = 1:numel(C)
		c = C(i).c;
		n_c = size(c,1);
		m = logical(zeros(n_c,N));
		ix = sub2ind(size(m),[1:n_c]'*ones(1,C(i).k),c);
		m(ix) = 1;
		M = [M; m];
	end
	varargout{1} = M;
	varargout{2} = sum(M')';	% coalition sizes in M
end


