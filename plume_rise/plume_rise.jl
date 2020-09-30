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
    if istab < 1 || istab > 6 || env_id < 1 || env_id > 2
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
    return hs_p
end


# Flusso di galleggiamento
function Fb(
    vs, # Velocità verticale dei fumi all'uscita dalla ciminiera (m/s)
    ds, # Diametro della ciminiera al vertice (m)
    Ts, # Temperatura dei fumi all'uscita dalla ciminiera (K)
    Ta  # Temperatura ambiente (K)
)
    G = 9.807
    return G * vs * ds^2 * (Ts-Ta)/(4. * Ts)
end


function Fm(
    vs, # Velocità verticale dei fumi all'uscita dalla ciminiera (m/s)
    ds, # Diametro della ciminiera al vertice (m)
    Ts, # Temperatura dei fumi all'uscita dalla ciminiera (K)
    Ta  # Temperatura ambiente (K)
)
    return vs^2 * ds^2 * Ta/(4. * Ts)
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
            xb = 119.0 * fb^(2. / 5.)
        elseif fb > 0.
            xb = 49.0 * fb^(5. / 8.)
        else
            xb = 4.0 * ds * (vs + 3. * ds)^2/(vs*ds)
        end
        xm = 4.0 * ds * (vs + 3. * ds)^2/(vs*ds)
    end
    xmax = max(xb, xm)

    # Calcolo della differenza di Temperatura
    # critica
    if stable
        delta_t_crit = 0.019582 * Ts * vs * sqrt(s)
    else
        if fb < 55.0
            delta_t_crit = 0.0297 * Ts * vs^(1. / 3.) / ds^(2. / 3.)
        else
            delta_t_crit = 0.00575 * Ts * vs^(2.  /3.) / us^(1. / 3.)
        end
    end

    # Stima della quota massima raggiunta dal pennacchio
    delta_t = max(Ts - Ta, 0.)
    hps = h_prime(hs, vs, ds, us)
    if stable
        if delta_t > delta_t_crit
            hmax = hps + 2.6 * (Fb / (us * s))^(1. / 3.)
        else
            hmax = hps + 1.5 * (Fb / (us * sqrt(s)))^(1. / 3.)
        end
    else
        if delta_t > delta_t_crit
            if fb < 55.
                hmax = hps + 21.425 * fb^(3. / 4.) / us
            else
                hmax = hps + 38.75 * fb^(3. / 5.) / us
            end
        else
            hmax = hps + 3. * ds * vs / us
        end
    end

    # Leave
    return hmax

end
