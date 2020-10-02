# Plotting functions, for illustrating plume rise evolution under different situations
#
# Scritto da: Patrizia Favaron
#
# Questo codice è coperto dalla licenza MIT.

using Plotly

function show_max_x_vs(
    istab::Int32,           # Categoria di stabilità (1=A, 2=B, ..., 6=F)
    us::Float64,            # Velocità del vento alla quota del vertice della ciminiera (m/s)
    vs_min::Float64,        # Velocità verticale minima dei fumi all'uscita dalla ciminiera (m/s)
    vs_max::Float64,        # Velocità verticale massima dei fumi all'uscita dalla ciminiera (m/s)
    ds::Float64,            # Diametro della ciminiera al vertice (m)
    Ts::Float64,            # Temperatura dei fumi all'uscita dalla ciminiera (K)
    Ta::Float64             # Temperatura ambiente (K)
)

    delta_vs = (vs_max - vs_min) / 10

    vs = 

end
