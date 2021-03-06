function adj2dot(A,varargin)

%ADJ2DOT Automatically write a DOT net file from an adjacency matrix.
%   ADJ2DOT(A) Writes a simple DOT file that can be opened with e.g. Graphviz 
%   from the adjacency matrix A. A is assumed to be symmetric (undirected graph) 
%   and square. The output file 'net.dot' is produced in the current working 
%   directory.
%
%   ADJ2DOT(...,VCOLID,COLS) Allows for vertex colouring. VCOLID is a vector of 
%   length num_vertices (SIZE(A,1)) indicating the colour index to be used from 
%   the string array COLS (e.g. COLS = {'red' 'white' 'blue'}). COLS can be 
%   drawn from any colours that the Graphviz language understands, noting that 
%   some colours (e.g. hex) require additional quotation marks surrounding them 
%   to be legal (e.g. "<colour>").
%
%See also FPRINTF GRAPHVIZ.ORG

% ADJ2DOT
%   A translation implementation for taking adjacency matrices to
%   .DOT (graphviz) syntax, for use with graphviz's DOT, or web-
%   based DOT.PY.
% AUTHOR
%   (c) S.Angus, December 2006 (unsw)
% INPUTS
%   (A) Adjacency matrix.
% OUTPUT
%   |dot.gv| the .gv output file


% .. default: we work with an undirected graph (symmetric A)
IS_SYM = 1;
EDGE_SYM = '--';
DOTFNAME = 'net.dot';

% .. default headers for dot file
G_header = sprintf([
    '// DOT file auto-generated by ADJ2DOT\n' ...
    '// Copyright (c) 2017 Simon D Angus, MIT License\n' ...
    '// https://opensource.org/licenses/MIT\n\n' ...
    'graph G {\n' ...
    '   graph [\n' ...
    '     dim=4,\n' ...
    '     epsilon=0.0001,\n' ...
    '     fixedsize=true,\n' ...
    '     layout=fdp,\n' ...
    '     nodesep=0.4,\n' ...
    '     sep=0.5,\n' ...
    '     splines=true ];'] );
N_header = sprintf([
    '   node [\n' ...
    '     shape=circle,\n' ...
    '     style=filled,\n' ...
    '     width=0.3 ];']);

% .. input checks
if not(size(A,1)==size(A,2))
	error('Input matrix must be square.');
	return
end
if not(isequal(triu(A),tril(A)'))
    error('Input matrix expected to be symmetric.');
    return
end

% .. options
col_v = 0;
if nargin > 1
    col_v = 1;
    vColid = varargin{1};
    Cols = varargin{2};
end

% .. put header info into output file
fid = fopen(DOTFNAME,'w');
fprintf(fid,'%s\n', G_header);
fprintf(fid,'%s\n', N_header);

% .. place nodes separately, if we have colouring instructions
my_space = char(32*ones(1,8));
if col_v
    for i = 1:length(A)
        fprintf(fid,'%sND_%s [label="%s",fillcolor=%s];\n', my_space, int2strL(i,3), int2str(i), Cols{vColid(i)});
    end
end
% .. place edges
for i = 1:length(A)
	if IS_SYM
		J = find(A(i,i:length(A)));
		J = J + i - 1;
	else
		J = find(A(i,:));
	end
	if J
		for j = J
            fprintf(fid,'%sND_%s %s ND_%s;\n', my_space, int2strL(i,3), EDGE_SYM, int2strL(j,3));
		end
	end
end

% finish up
fprintf(fid,'   }');
fclose(fid);
