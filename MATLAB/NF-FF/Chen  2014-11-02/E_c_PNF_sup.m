function E_c_NF_sup = E_c_PNF_sup( r_c_near,f,freq )
%assume all inf diople in the direction

%% contents
c = 3e8;
lamda = c/freq;
mu0 = 4*pi*1e-7;
e0 = 8.854187817e-12;
eta = sqrt(mu0/e0);
k = 2*pi/lamda;
I0 = 1;
len = lamda/50;
%%
thetaZ = -90*(pi/180);
cp_A_c = [cos(thetaZ),-sin(thetaZ),0;sin(thetaZ),cos(thetaZ),0;0,0,1];
c_A_cp = [cos(-thetaZ),-sin(-thetaZ),0;sin(-thetaZ),cos(-thetaZ),0;0,0,1];
%%
E_c_NF_sup = zeros(size(r_c_near,1),3);
for rIndex=1:size(r_c_near,1);
    r_c_near_test = r_c_near(rIndex,:);
    E_c_NF_mat = zeros(size(f,1),3);
    for fIndex = 1:size(f,1);
        rp_c = r_c_near_test-f(fIndex,:);
        rp_c = rp_c';
        rp_cp = cp_A_c * rp_c;
        xp = rp_cp(1);
        yp = rp_cp(2);
        zp = rp_cp(3);
        rp = sqrt(xp^2+yp^2+zp^2);
        thetap = acos(zp/rp);
        phip = atan(yp/xp);
        Ep_rp_NF = ((eta*I0*len*cos(thetap))/(2*pi*rp^2))*(1+1/(1i*k*rp))*exp(-1i*k*rp);
        Ep_thetap_NF = (1i*eta*k*I0*len*sin(thetap)/(4*pi*rp))*(1+1/(1i*k*rp)-1/(k^2*rp^2))*exp(-1i*k*rp);
        Ep_phip_NF = 0;
        Ep_sp_NF = [Ep_rp_NF;Ep_thetap_NF;Ep_phip_NF];
        cp_T_sp = [sin(thetap)*cos(phip),cos(thetap)*cos(phip),-sin(phip); ...
                   sin(thetap)*sin(phip),cos(thetap)*sin(phip),cos(phip); ...
                  cos(thetap),          -sin(thetap),         0];
        E_c_NF = c_A_cp*cp_T_sp*Ep_sp_NF;
        E_c_NF_mat(fIndex,:) = E_c_NF;
    end
    E_c_NF_sup_oneP = sum(E_c_NF_mat,1);
    E_c_NF_sup(rIndex,:) = E_c_NF_sup_oneP;
end

end

