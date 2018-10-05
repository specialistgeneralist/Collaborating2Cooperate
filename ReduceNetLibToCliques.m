function [Glib_out] = ReduceNetLibToCliques(Glib)

%REDUCENETLIBTOCLIQUES reduce a GLIB, for k>3, only to complete sub-graphs 
%(cliques).

% .. for each block
for i = 1:numel(Glib)
    tic
    fprintf(' --> working on block %.0f (of %.0f) in Glib ... ', i, numel(Glib));
    % .. for each replicate
    out_lib = Glib(i).lib;
    parfor r = 1:numel(Glib(i).lib);
        lib = Glib(i).lib(r);
        sM = lib.sM;
        M = lib.M;
        G = lib.G;
        n0 = numel(sM);
        ix_keep = find(lib.sM <= 2);
        ix_check = find(lib.sM >= 3);
        is_clique = [];
        % .. check coalitions of size > 2
        if ~isempty(ix_check)
            is_clique = logical(zeros(numel(ix_check),1));
            for j = 1:numel(ix_check)
                v = M(ix_check(j),:);
                g = G(v,v);
                is_clique(j) = iscomplete_adj(g);
            end
        end
        ix_keep = union(ix_keep, ix_check(is_clique));
        out_lib(r).M  = M(ix_keep,:);
        out_lib(r).sM = sM(ix_keep,1);
        n1 = numel(sM(ix_keep,1));
        %fprintf('     r%.0f: was %.0f groups, now %.0f ... \n', r, n0, n1);
    end
    Glib(i).lib = out_lib;
    fprintf('done. (took %.0fs)\n', toc)
end

Glib_out = Glib;

