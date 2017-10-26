function LogUpdates(S,x,x1,P,t,c1)

%LOGUPDATES Provide detailed 'story' information to a log-file.
%   LOGUPDATES(S,X,X1,P,T,C1) Writes or appends to a log-file for the given 
%   treatment (E,P) under single replicate (R=1) conditions, the switching 
%   information on any agent who's strategy this period is different to last 
%   period, including the composition of the coalition who was updating at this 
%   time.
%
%   See also SPRINTF FOPEN

fname = sprintf('logR1_p%.2f_e%.2f.txt', P.p, P.e);
strats = 'CD';

fid = fopen(fname, 'a');
if c1==1
    fprintf(fid, '--- %s ---\n', datestr(now,30));
elseif c1>1
    if any(x ~= x1)     % if a change
        old_s = strats(x(S)+1);
        new_s = strats(x1(S)+1);
        fprintf(fid, 't = %5.0f: agent(s) %s switched from %s to %s ...\n', t, mat2str(S'), old_s, new_s);
    end
end
fclose(fid);
