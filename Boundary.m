function [T,u]=Boundary(info,T,BC,u,n)
%% Before first time step: 
s=info.s;
if n==0
    u(:,:,:,n+1)=info.IC;
end
    %% Set all blocks
    P = ( u(2:info.s(2)+1,1:info.s(1)+1,2:info.s(3)+1) + u(2:info.s(2)+1,2:info.s(1)+2,2:info.s(3)+1) )/2; % Taking average of pressure values between two blocks
    b=eval(info.B);m=eval(info.mu);
    T.x(:,:,:,n+1)=( 1.127 .* info.A{1} .* info.k{1} ) ./ ( m .* info.Delta(1) .* b );clear('b', 'm', 'P');
    P = ( u(1:info.s(2)+1,2:info.s(1)+1,2:info.s(3)+1) + u(2:info.s(2)+2,2:info.s(1)+1,2:info.s(3)+1) )/2; % Taking average of pressure values between two blocks
    b=eval(info.B);m=eval(info.mu);
    T.y(:,:,:,n+1)=( 1.127 .* info.A{2} .* info.k{2} ) ./ ( m .* info.Delta(2) .* b );clear('b', 'm', 'P');
    P = ( u(2:info.s(2)+1,2:info.s(1)+1,1:info.s(3)+1) + u(2:info.s(2)+1,2:info.s(1)+1,2:info.s(3)+2) )/2; % Taking average of pressure values between two blocks
    b=eval(info.B);m=eval(info.mu);
    T.z(:,:,:,n+1)=( 1.127 .* info.A{3} .* info.k{3} ) ./ ( m .* info.Delta(3) .* b );clear('b', 'm', 'P');

%% For any time step: Set boundary blocks
    %% West
    if info.Choice{1,1} == 'Pressure Gradient Specified'
        T.x(:, 1, :, n+1) = BC.W;
        u(:, 1, :, n+1) = u(:, 2, :, n+1) - BC.W*info.Delta(1);
    else
        u(:, 1, :, n+1) = BC.W;
        P = ( u(2:info.s(2)+1, 1, 2:info.s(3)+1, n+1) + u(2:info.s(2)+1, 2, 2:info.s(3)+1, n+1) )/2;
        b = eval(info.B); m = eval(info.mu);
        T.x(:, 1, :, n+1) = ( 1.127 .* info.A{1}(:, 1) .* info.k{1}(:, 1) ) ./ ( m .* info.Delta(1) .* b );clear('b', 'm', 'P');
    end
    %% East
    if info.Choice{1,2} == 'Pressure Gradient Specified'
        T.x(:, s(1)+1, :, n+1) = BC.E;
        u(:, s(1)+2, :, n+1) = u(:, s(1)+1, :, n+1) + BC.E*info.Delta(1);
    else
        u(:, info.s(1)+2, :, n+1) = BC.E;
        P = ( u(2:info.s(2)+1, info.s(1)+1, 2:info.s(3)+1, n+1) + u(2:info.s(2)+1, info.s(1)+2, 2:info.s(3)+1, n+1) )/2;
        b = eval(info.B); m = eval(info.mu);
        T.x(:, info.s(1)+1, :, n+1) = ( 1.127 .* info.A{1}(:, info.s(1)+1) .* info.k{1}(:, info.s(1)+1) ) ./ ( m .* info.Delta(1) .* b );clear('b', 'm', 'P');
    end
    %% South
    if info.Choice{1,3} == 'Pressure Gradient Specified' 
        T.y(1, :, :, n+1) = BC.S;
        u(1, :, :, n+1) = u(2, :, :, n+1) - BC.S*info.Delta(2);
    else
        u(1, :, :, n+1) = BC.S;
        P = ( u(2, 2:info.s(1)+1, 2:info.s(3)+1, n+1) + u(1, 2:info.s(1)+1, 2:info.s(3)+1, n+1) )/2;
        b = eval(info.B); m = eval(info.mu);
        T.y(1, :, :, n+1) = ( 1.127 .* info.A{2}(1, :) .* info.k{2}(1, :) ) ./ ( m .* info.Delta(2) .* b );clear('b', 'm', 'P');
    end
    %% North
    if info.Choice{1,4} == 'Pressure Gradient Specified'
        T.y(s(2)+1, :, :, n+1) = BC.N;
        u(s(2)+2, :, :, n+1) = u(s(2)+1, :, :, n+1) + BC.N*info.Delta(2);
    else
        u(info.s(2)+2, :, :, n+1) = BC.N;
        P = ( u(info.s(2)+1, 2:info.s(1)+1, 2:info.s(3)+1, n+1) + u(info.s(2)+2, 2:info.s(1)+1, 2:info.s(3)+1, n+1) )/2;
        b = eval(info.B); m = eval(info.mu);
        T.y(info.s(2)+1, :, :, n+1) = ( 1.127 .* info.A{2}(info.s(2)+1, :) .* info.k{2}(info.s(2)+1, :) ) ./ ( m .* info.Delta(2) .* b );clear('b', 'm', 'P');
    end
    %% Bottom
    if info.Choice{1,5} == "Pressure Gradient Specified" 
        T.z(:, :, 1, n+1) = BC.B;
        u(:, :, 1, n+1) = u(:, :, 2, n+1) - BC.B*info.Delta(3);
    else
        u(:, :, 1, n+1) = BC.B;
        P = ( u(2:info.s(2)+1, 2:info.s(1)+1, 1, n+1) + u(2:info.s(2)+1, 2:info.s(1)+1, 2, n+1) )/2;
        b = eval(info.B); m = eval(info.mu);
        T.z(:, :, 1, n+1) = ( 1.127 .* info.A{3}(:, :, 1) .* info.k{3}(:, :, 1) ) ./ ( m .* info.Delta(3) .* b );clear('b', 'm', 'P');
    end
    %% Up
    if info.Choice{1,6} == "Pressure Gradient Specified" 
        T.z(:, :, s(3)+1, n+1) = BC.U;
        u(:, :, s(3)+2, n+1) = u(:, :, s(3)+1, n+1) + BC.U*info.Delta(3);
    else
        u(:, :, info.s(3)+2, n+1) = BC.B;
        P = ( u(2:info.s(2)+1, 2:info.s(1)+1, info.s(3)+1, n+1) + u(2:info.s(2)+1, 2:info.s(1)+1, info.s(3)+2, n+1) )/2;
        b = eval(info.B); m = eval(info.mu);
        T.z(:, :, info.s(3)+1, n+1) = ( 1.127 .* info.A{3}(:, :, info.s(3)+1) .* info.k{3}(:, :, info.s(3)+1) ) ./ ( m .* info.Delta(3) .* b );clear('b', 'm', 'P');
    end
end