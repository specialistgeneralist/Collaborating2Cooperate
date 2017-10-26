function adj2dot(A,varargin)

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


% DEFAULTS -------------------------------------------------------------- %
width = [];		% set to auto
height = [];
G_type = 'digraph';
G_fixedsize = 'true';
G_layout = 'neato';
edge_sym = '->';
N_shape = 'circle';
N_style = 'filled';
N_color = 'black';
N_fillcolor = 'red';
N_width = '0.3';			% in inches
N_label = '""';
A_style = 'normal';
A_size = 0.5;
% ----------------------------------------------------------------------- %

% checks
if not(size(A,1)==size(A,2))
	error('Input matrix must be square!');
	return
end

% options
col_v = 0;
if nargin > 1
    col_v = 1;
    vColid = varargin{1};
    Cols = varargin{2};
end

% graph or digraph?
is_sym = 0;
is_sym = isequal(triu(A),tril(A)');
if is_sym
	G_type = 'graph';
	edge_sym = '--';
end

% put header info into output file
fid = fopen('net.dot','w');
fprintf(fid,'%s G {\n',G_type);
if is_sym==0
	fprintf(fid,'  edge [arrowhead="%s",arrowsize=%4.1f];\n',A_style,A_size);
end
fprintf(fid,'  layout=%s;\n',G_layout);
fprintf(fid,'  fixedsize=%s;\n',G_fixedsize);
if col_v
    fprintf(fid,'  node [shape=%s,style=%s,color=%s,width=%s,label=%s];\n',...
        N_shape,N_style,N_color,N_width,N_label);
else
    fprintf(fid,'  node [shape=%s,style=%s,color=%s,fillcolor=%s,width=%s,label=%s];\n',...
        N_shape,N_style,N_color,N_fillcolor,N_width,N_label);
end

% place nodes
if col_v
    for i = 1:length(A)
        fprintf(fid,'  ND_%s [label="%s",fillcolor=%s];\n',int2strL(i,3),int2str(i),Cols{vColid(i)});
    end
end
for i = 1:length(A)
	if is_sym
		J = find(A(i,i:length(A)));
		J = J + i - 1;
	else
		J = find(A(i,:));
	end
	if J
		for j = J
            fprintf(fid,'  ND_%s %s ND_%s;\n',int2strL(i,3),edge_sym,int2strL(j,3));
		end
	end
end

% finish up
fprintf(fid,'  }');
fclose(fid);




