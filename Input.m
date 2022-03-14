function out=Input
opts.Defaultbtn='OK';
opts.Interpreter = 'tex';
opts.Resize='on';
dims = [1 45];
%
%% Griding data
% The first loop is just for convinient. You see that plus sign? That's the
% reason.
for k=1
promptgrid={'Length (X*Y*Z)_{ft}:', '\Delta (X*Y*Z)_{ft}:',...
    'Examination time (Days):','\Deltat (Days):','Maximum Waiting time (min):'};
for i=1:length(promptgrid)
promptgrid{i}=['\fontsize{10}',promptgrid{i}];
end
definput = {'4000*3000*75','1000*1000*75','360','10','60'};
dlgtitle='Input Griding data...';
datagrid = inputdlg(promptgrid,dlgtitle,dims,definput,opts);
for j=1:2
count=0;container='';
for i=1:length(datagrid{j})
    if datagrid{j}(i)~='*'
        container=[container,datagrid{j}(i)];
        if i==length(datagrid{j})
            count=count+1;
            test(j,count)=double(string(container));
            container='';
            count=0;
        end
    else
        count=count+1;
        test(j,count)=double(string(container));
        container='';
    end
end
end
out.Length=test(1,:);out.Delta=test(2,:);out.Time=double(string(datagrid{3}));out.Dt=double(string(datagrid{4}));
out.s=(out.Length)./(out.Delta);
out.st=(out.Time)/(out.Dt);
end

%% Non-Constant variables
for k=1
dlgtitle='Non-Constant data...';
promptnon={'A_{x}','A_{y}','A_{z}',...
    'K_{x} (mD):','K_{y} (mD):','K_{z} (mD):'...
    ,'B (RB/STB):','\mu_{l} (cp):'};
for i=1:length(promptnon)
promptnon{i}=['\fontsize{10}',promptnon{i}];
end
definput = {char(string(out.Delta(2)*out.Delta(3))), char(string(out.Delta(1)*out.Delta(3))), char(string(out.Delta(1)*out.Delta(2))),...
    '15','15','15','1','10'};
datanon = inputdlg(promptnon,dlgtitle,dims,definput,opts);
out.A{1}=datanon{1};out.A{2}=datanon{2};out.A{3}=datanon{3};
out.k{1}=datanon{4};out.k{2}=datanon{5};out.k{3}=datanon{6};
out.B=datanon{7};out.mu=datanon{8};
end
%% Constant Variables
for k=1
dlgtitle='Constant data...';
promptcte={'Tolerance:','Initial Pressure (psi):','\bf\phi:',...
    'B_{0} (RB/STB):','C_{l} (psi^{-1}):','Number of Wells:'};
for i=1:length(promptcte)
promptcte{i}=['\fontsize{10}',promptcte{i}];
end
definput = {'0.001','6000','0.18','1','3.5*10^-6','1'};
datacte = inputdlg(promptcte,dlgtitle,dims,definput,opts);
out.Tol=double(string(datacte{1}));out.IC=double(string(datacte{2}));
out.Phi=double(string(datacte{3}));out.Bo=double(string(datacte{4}));
out.c=str2num(string(datacte{5}));out.wellno=str2num(string(datacte{6}));
end
%% Boundary Choosing

%% Constants calculations
out.Vb=out.Delta(1)*out.Delta(2)*out.Delta(3);out.Etha=(5.615*out.Bo*out.Dt)/(out.Vb*out.Phi*out.c);
%% Turning non-constant variables to constant variables
for k=1
%syms X Y Z P
%X
out.A{1}=corr(out.A{1});
out.k{1}=corr(out.k{1});
a=zeros(out.s(2),out.s(1)+1,out.s(3));
b=zeros(out.s(2),out.s(1)+1,out.s(3));
for k=1:out.s(3)
for j=1:out.s(2)
for i=1:out.s(1)+1
X=(2*i-1)*out.Delta(1);
Y=(j-1)*out.Delta(2);
Z=(2*k-1)*out.Delta(3);
a(j,i,k)=eval(out.A{1});
b(j,i,k)=eval(out.k{1});
end
end
end
out.A{1}=a;
out.k{1}=b.*(10^-3);

%Y
out.A{2}=corr(out.A{2});
out.k{2}=corr(out.k{2});
a=zeros(out.s(2)+1,out.s(1),out.s(3));
b=zeros(out.s(2)+1,out.s(1),out.s(3));
for k=1:out.s(3)
for j=1:out.s(2)+1
for i=1:out.s(1)
X=(i-1)*out.Delta(1);
Y=(2*j-1)*out.Delta(2);
Z=(2*k-1)*out.Delta(3);
a(j,i,k)=eval(out.A{2});
b(j,i,k)=eval(out.k{2});
end
end
end
out.A{2}=a;
out.k{2}=b.*(10^-3);

%Az
out.A{3}=corr(out.A{3});
out.k{3}=corr(out.k{3});
a=zeros(out.s(2),out.s(1),out.s(3)+1);
b=zeros(out.s(2),out.s(1),out.s(3)+1);
for k=1:out.s(3)+1
for j=1:out.s(2)
for i=1:out.s(1)
X=(2*i-1)*out.Delta(1);
Y=(2*j-1)*out.Delta(2);
Z=(k-1)*out.Delta(3);
a(j,i,k)=eval(out.A{3});
b(j,i,k)=eval(out.k{3});
end
end
end
out.A{3}=a;
out.k{3}=b.*(10^-3);

%B & mu
out.B=corr(out.B);out.mu=corr(out.mu);
end
    function out2=corr(in)
        in(in=='x')='X';
        in(in=='y')='Y';
        in(in=='z')='Z';
        in(in=='p')='P';
        in=str2sym(in);
        out2=in;
    end
end