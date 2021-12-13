using CairoMakie
CairoMakie.activate!()

# Um gráfico simples de linha pode ser alcançado com uma síntaxe igualmente simples:
fig = scatterlines(1:10, 1:10)


# É importante salientar que todas as funções como scatterlines criam e retornam
# novos objetos Figure, Axis e plot em uma coleção chamada FigureAxisPlot. Estes
# são os métodos não-mutantes. Em oposição, temos os métodos mutantes (e.g.
# scatterlines!, note o !) que retornam um objeto plot que pode ser adicionado
# em qualquer Axis ou aplicado com current_figure().

# Dessa forma, é possível desempacotar o retorno em 3 objetos e, por exemplo,
# adicionar mais gráficosà figura e eixo retornados pelo método:


fig, ax, pltobj = scatterlines(1:10)
lines!(ax, x, (1:10).-1; label="line")
fig

# Ainda usando as funções não mutantes, é possível costumizar os gráficos através
# de atributos. A lista de atributos disponíveis pode ser obtida com:
pltobj.attributes
# onde pltobj é um objeto plot retornado pelos métodos mutantes ou não-mutantes
# Não apenas os objetos de plot possuem atributos, claro! Axis e Figuras também 
# podem ser costumizados.
# Use, por exemplo, ?Axis no terminal para obter a lista de atributos do Axis.

# Usando as funções não-mutantes, é possível definir as configurações do Axis, bem
# como da Figure.

lines(
    1:10,
    (1:10).^2;
    label="x²",
    linewidth=2,
    linestyle=nothing,
    figure=(;
        figure_padding=5,
        resolution=(600, 400), 
        ont="sans",
        backgroundcolor=:grey90,
        fontsize=16
    ),
    axis=(;
        xlabel="x",
        title="title",
        xgridstyle=:dash,
        ygridstyle=:dash
    )
)
scatterlines!(1:10, (10:-1:1).^2; label="Reverse(x)²")
axislegend("legend"; position=:ct)
current_figure()


# Contudo, minha forma predileta, até agora, é usar os métodos mutantes e controlar
# separadamente o Axis e a Figure para ter mais controle e dar mais clareza ao código.

x = 1:10
y = (10:-1:1).^2
z = rand(10)

fig = Figure(resolution=(600, 400), backgroundcolor=:grey90)
ax = Axis(
    fig[1, 1],
    backgroundcolor=:white,
    xgridstyle=:dash,
    ygridstyle=:dash
)
pltobj = scatter!(ax, x, y; color=z, label="scatters")
lines!(ax, x, 1.1y; label="line")
Legend(fig[2, 1:2], ax, "labels", orientation=:horizontal)
Colorbar(fig[1, 2], pltobj, label="colorbar")
fig






