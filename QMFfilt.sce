function [ou,H0,H1]=attenuation(t)

    P=poly(1./sqrt(2),"z","coeff")
    Q=poly([0,1/sqrt(2)],"z","coeff")
    z2=poly([0,0,1],"z","coeff")

    for i=1:4
        Pn=cos(t(i))*P+sin(t(i))*Q;
        Qn=sin(t(i))*P -cos(t(i))*Q;
        P=Pn;
        Q=Qn*z2
    end

    H0=coeff(P);
    H1=coeff(Q);H1=H1(3:length(H1));
    
    [x,fr]=frmag(H0,100);
    ou=sum(x(60:100).^2)
endfunction

function [f,g,ind]=cost(t,ind)
    f=attenuation(t);
    g=derivative(attenuation,t)
endfunction


pi=asin(1)*2;
x0=pi/3*[1;2;3;4];

[fopt,xopt]=optim(cost,pi/8*[1;1;1;1]);
[ou,H0,H1]=attenuation(xopt);

[xo,fr]=frmag(H0,100);

[x1,fr]=frmag(H1,100);
figure(0);
clf
plot(fr,20*log(xo)/log(10),"r",fr,20*log(x1)/log(10),"m")
ah=gca();ah.grid=[1,1,0];
xlabel("Normalized Frequency")
ylabel("Response in dB")
ah.auto_scale="off"
ah.data_bounds=[0,-60;.5,4.95]
