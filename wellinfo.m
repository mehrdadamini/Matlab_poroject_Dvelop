function out=wellinfo(info)
wellno=info.wellno;
sx=info.s(1);sy=info.s(2);sz=info.s(3);st=info.st;
out=zeros(sy, sx, sz, st);
for i=1:wellno
    prompt{2*i-1}=sprintf('%.0fth well position (X*Y):',i);
    prompt{2*i}=sprintf('%.0fth well Rate (bbl):',i);
    definput{2*i-1} = [char(string(round(sx-(sx/i)+1))), '*', char(string(round(sx-(sx/i)+1)))];
    definput{2*i} = char(string(-randi(150,1,"double")));
end
dlgtitle = 'Well positions';
dims = [1 35];
in = inputdlg(prompt,dlgtitle,dims,definput);
for i=1:size(in,1)/2
    temp='';count=1;
    for j=1:length(in{2*i-1})
    if in{2*i-1}(j)~='*' && j~=length(in{2*i-1})
        temp=[temp, in{2*i-1}(j)];
    elseif j==length(in{2*i-1})
        temp=[temp, in{2*i-1}(j)];
        test(count)=str2num(temp);
    elseif in{2*i-1}(j)=='*'
        test(count)=str2num(string(temp));
        count=count+1;
        temp='';
    end
    end
    location{i}=test;
end

for i=1:wellno
    out(location{i}(2), location{i}(1), :, :)=str2num(in{2*i});
end
end