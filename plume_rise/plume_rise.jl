function Fb(vs,ds,Ts,Ta)
    const g = 9.807
    return g * vs * ds^2 * (Ts-Ta)/(4.*Ts)
end


function Fm(vs,ds,Ts,Ta)
    return vs^2 * ds^2 * Ta/(4.*Ts)
end


function max_z(istab, us, vs, ds, ts)
    
end
