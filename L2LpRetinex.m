function [S,R]=L2LpRetinex(src)
% src: input RGB/gray image
% S: illumination; R: reflectance

% Default parameter setting
    lambda_s=0.01;
    lambda_r=0.001;
    lambda_b=0.15;
    vareps=0.01;
    K=25;
    r0=2;
    debug=true; % print debug information
    p=0.4; % norm variable p, typically set to 0.4
    eps=0.001;

    [h,w,kk]=size(src);
    n=h*w; % number of pixels
    if kk==1
        I=src;
        gray=src;
    else
        hsv=rgb2hsv(src);
        I=hsv(:,:,3);
        gray=rgb2gray(src);
    end

    B=convMax(single(I),r0); % bright channel prior
    B=guidedfilter(gray,B,20,eps); % use guided filer to refine bright channel
    S=I;                                % initialize S_0
    R=ones(size(I));                    % initialize R_0
    if debug==true
        fprintf('-- Stop iteration until eplison < %02f or K > %d\n',vareps,K);
    end
    for iter = 1:K
        preS=S;
        preR=R;
        %% Computing illumination
        S=I./R;
        if p~=0
            Sx=diff(S,1,2); Sx=padarray(Sx,[0 1],'post');
            Sy=diff(S,1,1); Sy=padarray(Sy,[1 0],'post');
            ux=max(abs(Sx),eps).^(p-2);
            uy=max(abs(Sy),eps).^(p-2);
            ux(:,end)=0;
            uy(end,:)=0;
            ux=ux(:);
            uy=uy(:);
            ux1=padarray(ux,h,'pre');
            ux1=ux1(1:end-h);
            uy1=padarray(uy,1,'pre');
            uy1=uy1(1:end-1);
            D=ux+ux1+uy+uy1;
            T=spdiags([-ux,-uy],[-h,-1],n,n);
            L=T+T'+spdiags(D,0,n,n);
            R2=R.^2;
            R2=spdiags(R2(:),0,n,n);
            A=R2+lambda_s*L+lambda_b*speye(n,n);
            b=R.*I+lambda_b*B;
            b=b(:);
            C=ichol(A,struct('michol','on'));
            [S,~]=pcg(A,b,0.01,40,C,C');
            S=reshape(S,h,w);
        else
            S=L0Smoothing(S); % using L0 norm
        end
        eplisonS=norm(S-preS,'fro')/norm(preS,'fro');

        %% Computing reflectance
        R=I./S;
        Rx=diff(R,1,2); Rx=padarray(Rx,[0 1],'post');
        Ry=diff(R,1,1); Ry=padarray(Ry,[1 0],'post');
        vx=ones(size(src,1),size(src,2));
        vy=ones(size(src,1),size(src,2));
        vx(:,end)=0;
        vy(end,:)=0;
        vx=vx(:);
        vy=vy(:);
        vx1=padarray(vx,h,'pre');
        vx1=vx1(1:end-h);
        vy1=padarray(vy,1,'pre');
        vy1=vy1(1:end-1);
        D=vx+vx1+vy+vy1;
        T=spdiags([-vx,-vy],[-h,-1],n,n);
        M=T+T'+spdiags(D,0,n,n);
        S2=S.^2;
        S2=spdiags(S2(:),0,n,n);
        A=S2+lambda_r*M;
        b=S.*I;
        b=b(:);
        C=ichol(A,struct('michol','on'));
        [R,~]=pcg(A,b,0.01,40,C,C');
        R=reshape(R,h,w);
        eplisonR=norm(R-preR,'fro')/norm(preR,'fro');

        %% iteration until convergence or reach the given maximum number
        if debug == true
                    fprintf('Iter #%d : eplisonS = %f; eplisonR = %f\n',iter,eplisonS,eplisonR);
        end
        if(eplisonS<vareps||eplisonR<vareps)
            break;
        end
    end
end