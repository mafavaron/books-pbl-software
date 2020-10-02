# Plotting functions, for illustrating plume rise evolution under different situations
#
# Scritto da: Patrizia Favaron
#
# Questo codice è coperto dalla licenza MIT.

function show_xmax(
    istab::Int32,           # Categoria di stabilità (1=A, 2=B, ..., 6=F)
    us::Float64,            # Velocità del vento alla quota del vertice della ciminiera (m/s)
    vs::Array{Float64,1},   # Velocità verticale dei fumi all'uscita dalla ciminiera (m/s)
    ds::Float64,            # Diametro della ciminiera al vertice (m)
    Ts::Array{Float64,1},   # Temperatura dei fumi all'uscita dalla ciminiera (K)
    Ta::Float64             # Temperatura ambiente (K)
)

    # Check parameters
    n = length(vs)
    if n != length(Ts)
        error "show_xmax:: error: Lengths of 'vs' and 'Ts' should be equal"
    end

    
end
