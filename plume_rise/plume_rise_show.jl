# Plotting functions, for illustrating plume rise evolution under different situations
#
# Scritto da: Patrizia Favaron
#
# Questo codice è coperto dalla licenza MIT.

using Plots

function show_max_x_vs(
    us::Float64,            # Velocità del vento alla quota del vertice della ciminiera (m/s)
    vs_min::Float64,        # Velocità verticale minima dei fumi all'uscita dalla ciminiera (m/s)
    vs_max::Float64,        # Velocità verticale massima dei fumi all'uscita dalla ciminiera (m/s)
    ds::Float64,            # Diametro della ciminiera al vertice (m)
    Ts::Float64,            # Temperatura dei fumi all'uscita dalla ciminiera (K)
    Ta::Float64             # Temperatura ambiente (K)
)

    vs = range(vs_min, vs_max; length=100)

    max_x_vals = Array{Float64}(undef, length(vs), 2)
    for i in 1:length(vs)
        max_x_vals[i,1] = max_x(1, us, vs[i], ds, Ts, Ta) # Categoria A: convettività
        max_x_vals[i,2] = max_x(6, us, vs[i], ds, Ts, Ta) # Categoria F: stabilità
    end

    gr()    # Force graphic backend to GR
    plot(vs, max_x_vals, label = ["Cat. A" "Cat. F"])
    xlabel!("Vel. fumi (m/s)")
    ylabel!("x alla max altezza (m)")

    println(max_x_vals[1,1])
    println(max_x_vals[2,2])

    println(max_x_vals[length(vs),1])
    println(max_x_vals[length(vs),2])

end
