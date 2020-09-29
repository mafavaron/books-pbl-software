# Abbassamento del pennacchio per effetto di scia
# al vertice della ciminiera.
function h_prime(
    hs, # Altezza geometrica della ciminiera (m)
    vs, # Velocità verticale dei fumi all'uscita dalla ciminiera (m/s)
    ds, # Diametro della ciminiera al vertice (m)
    us  # Velocità del vento alla quota geometrica della ciminiera (m/s)
)
    if vs < 1.5*us
        hs_p = hs + 2*ds*(vs/us - 1.5)
    else
        hs_p = hs
    end
    return hs
end


function Fb(vs,ds,Ts,Ta)
    const g = 9.807
    return g * vs * ds^2 * (Ts-Ta)/(4.*Ts)
end


function Fm(vs,ds,Ts,Ta)
    return vs^2 * ds^2 * Ta/(4.*Ts)
end


function max_z(istab, us, vs, ds, ts)

end
