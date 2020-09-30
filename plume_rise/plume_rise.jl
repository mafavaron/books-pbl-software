# Stima della velocità del vento alla quota geometrica
# della ciminiera
function us(
    zr,    # Quota alla quale è misurato il vento (m)
    ur,    # Velocità del vento misurata alla quota 'zr' (m/s)
    hs,    # Altezza geometrica della ciminiera (m)
    istab, # Categoria di stabilità (1=A, 2=B, ..., 6=F)
    env_id # Identificatore di tipo ambiente (1=rurale, 2=urbano)
)

    # Basic parameter check
    if istab < 1 or istab > 6 or env_id < 1 or env_id > 2
        return missing
    end

    # Determina l'esponente in base alla stabilità
    # ed al tipo di ambiente
    p_rural = [0.07, 0.07, 0.10, 0.15, 0.35, 0.55]
    p_urban = [0.15, 0.15, 0.20, 0.25, 0.30, 0.30]
    if env_id == 1 # Rurale
        p = p_rural[istab]
    elseif env_id == 2 # Urbano
        p = p_urban[istab]
    else
        return missing
    end

    # Il calcolo vero e proprio
    us_value = ur*(hs/zr)^p
    return us_value

end


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


# Flusso di galleggiamento
function Fb(
    vs, # Velocità verticale dei fumi all'uscita dalla ciminiera (m/s)
    ds, # Diametro della ciminiera al vertice (m)
    Ts, # Temperatura dei fumi all'uscita dalla ciminiera (K)
    Ta  # Temperatura ambiente (K)
)
    const g = 9.807
    return g * vs * ds^2 * (Ts-Ta)/(4.*Ts)
end


function Fm(
    vs, # Velocità verticale dei fumi all'uscita dalla ciminiera (m/s)
    ds, # Diametro della ciminiera al vertice (m)
    Ts, # Temperatura dei fumi all'uscita dalla ciminiera (K)
    Ta  # Temperatura ambiente (K)
)
    return vs^2 * ds^2 * Ta/(4.*Ts)
end


function max_z(
    istab, # Categoria di stabilità (1=A, 2=B, ..., 6=F)
    hs, # Altezza geometrica della ciminiera (m)
    us, # Velocità del vento alla quota del vertice della ciminiera (m/s)
    vs, # Velocità verticale dei fumi all'uscita dalla ciminiera (m/s)
    ds, # Diametro della ciminiera al vertice (m)
    Ts, # Temperatura dei fumi all'uscita dalla ciminiera (K)
    Ta  # Temperatura ambiente (K)
)

    # Stable, or neutral/convective?
    if istab <= 4
        stable = true
    else
        stable = false
    end

    # Calcolo dei flussi di galleggiamento e
    # di quantità di moto
    fb = Fb(vs,ds,Ts,Ta)
    fm = Fm(vs,ds,Ts,Ta)

    # Stima della distanza sottovento alla quale
    # il pennacchio raggiunge la sua quota massima
    if stable
        if istab == 5
            s = 0.020
        else
            s = 0.035
        end
        xb = 2.0715 * us/sqrt(s)
        xm = 3.1415927/2. * us/sqrt(s)
    else
        if fb > 55
            xb = 119.0 * fb^(2./5.)
        elseif fb > 0.
            xb = 49.0 * fb^(5./8.)
        else
            xb = 4.0 * ds * (vs+3*ds)^2/(vs*ds)
        end
        xm = 4.0 * ds * (vs+3*ds)^2/(vs*ds)
    end

end
