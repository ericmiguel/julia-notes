#=
O módulo de datas oferece dois caminhos para lidar com datas: Date e Datetime. Um
representa o tempo com precisão diária, enquanto o outro representa o tempo com
precisão na casa dos milisegundos, respectivamente, mas ambos são subtipos do tipo
abstrato TimeType.

O motivo para a existência de dois tipos é simples: objetos Date são mais simples,
pois dispensam a necessidade de lidar com horas, minutos, segundos e todas as
considerações usuais, como fusohorário, horário de verão e afins. Ou seja: se
o necessário for apenas lidar com dias, anos ou meses, use Date. Se a granularidade
necessária formaior, use Datetime.

Ambos Date e Datetime são, essencialmente, wrappers imutáveis de objetos Int64.
O Datetime ignora timezones por natureza (naive, no vocabulário Python).
Funcionalidades envolvendo timezones podem ser adquiridas através do módulo
TimeZones.jl

Documentação original: https://docs.julialang.org/en/v1/stdlib/Dates/#Adjuster-Functions
=#

import Dates


# =============================================================
# Constructors
# =============================================================

Dates.DateTime(2021)
Dates.DateTime(2021, 1)
Dates.DateTime(2021, 1, 1)
Dates.DateTime(2021, 1, 1, 12)
Dates.DateTime(2021, 1, 1, 12, 30)
Dates.DateTime(2021, 1, 1, 12, 30, 59)
Dates.DateTime(2021, 1, 1, 12, 30, 59, 1)

Dates.Date(2021)
Dates.Date(2021, 1)
Dates.Date(2021, 1, 1)
Dates.Date(Dates.Year(2013), Dates.Month(7), Dates.Day(1))
Dates.Date(Dates.Month(7), Dates.Year(2013))

# Objetos também podem ser instanciados com strings
Dates.Date("2021-01-01")

# A biblioteca possui alguns constructors utilitários
Dates.now()
Dates.today()


# =============================================================
# Formatação
# =============================================================

df = Dates.DateFormat("y-m-d")
Dates.Date("2021-01-01", df)

# Também é possível formatar os objetos por broadcasting
anos = ["2020", "2021"]
Dates.Date.(anos, Dates.DateFormat("yyyy"))


# =============================================================
# Durações e comparações
# =============================================================

dt1 = Dates.Date(1900, 1, 1)
dt2 = Dates.Date(2000, 1, 2)

# subtrair Dates retornará a diferença em dias.
# subtrair Datetimes retornará a diferença em milisegundos.
dt1 - dt2
dt2 - dt1

dt1 < dt2
dt1 > dt2

# Nota: operações envolvendo +, * e / não são suportadas.


# =============================================================
# Accessor functions
# =============================================================

Dates.year(dt1)
Dates.month(dt1)
Dates.day(dt1)

# Funções de acesso composto são oferecidas por conveniência
Dates.yearmonth(dt1)
Dates.monthday(dt1)
Dates.yearmonthday(dt1)


# =============================================================
# Query functions
# Funções de query oferecem informações de calendário sobre objetos TimeType
# =============================================================

Dates.dayofweek(dt1)
Dates.dayname(dt1)
Dates.monthname(dt1)
Dates.daysinmonth(dt1)
Dates.dayofyear(dt1)
Dates.isleapyear(dt1)


# Dayname e monthname podem receber um parâmetro de locale opcional com nomes
# de dias e meses de outras linguagens/ locales, assim como as abreviações.

# namely dayabbr and monthabbr. First the mapping is loaded into the LOCALES variable:

meses = [
    "janeiro", "fevereiro", "março", "abriç", "maio", "junho",
    "julho", "agosto", "setembro", "outubro", "novembro", "dezembro"
];

abreviacao_meses = [
    "jan","feb","mar","abr","mai","jun",
    "jul","ago","set","out","nov","dec"
];

dias = ["segunda", "terça", "quarta", "quinta", "sexta", "sábado", "domingo"];

abreviacoa_dias = ["seg", "ter", "qua", "qui", "sex", "sáb", "dom"];

Dates.LOCALES["brasil"] = Dates.DateLocale(
    meses, abreviacao_meses, dias, abreviacoa_dias
);

Dates.dayabbr(dt1; locale="brasil")
Dates.dayname(dt1; locale="brasil")
Dates.monthabbr(dt1; locale="brasil")
Dates.monthname(dt1; locale="brasil")


# =============================================================
# Aritimética com datas
# =============================================================

# A princípio, a ordem das operações não afeta o resultado:
Dates.Date(2000, 1, 29) + Dates.Day(1) + Dates.Month(1)
Dates.Date(2000, 1, 29) + Dates.Month(1) + Dates.Day(1)

# Contudo, a ordem pode se tornar muito importante, se alguma ordem for forçada:
(Dates.Date(2000, 1, 29) + Dates.Day(1)) + Dates.Month(1)
(Dates.Date(2000, 1, 29) + Dates.Month(1)) + Dates.Day(1)

# O que está acontecendo no exemplo acima?
# Quando solicitamos que 1 mês seja adicionado à data, o valor do dia é verificado.
# Se o dia for maior que o máximo do mês, o dia é aproximado (para baixo)
# para o máximo do mês. Com esse exemplo, podemos perceber que o design da biblioteca
# é sempre somar os "tempos" ordenadamente: primeiro anos, depois meses, depois dias
# e assim por diante. Se nenhuma ordem for forçada, o comportamento
# será bastante canônico.


# As operações podem ser feitas com ranges!
dr1 = Dates.Date(2021, 1, 29):Dates.Day(1):Dates.Date(2021, 2, 3);
collect(dr1)

dr2 = Dates.Date(2021, 1, 29):Dates.Month(1):Dates.Date(2021, 07, 29);
collect(dr2)


# =============================================================
# Adjuster Functions
# Para auxiliar nas operações, a biblioteca oferece funções de ajuste
# que facilitam cálculos mais complexos.
# =============================================================

dt1 = Dates.Date(2000, 6, 3)

# ajusta a data pra a segunda-feira da data da semana inputada
Dates.firstdayofweek(dt1)

# ajusta para o último dia do mês da data inputada
Dates.lastdayofmonth(dt1)

# Retorna true se o dia da semana de X for terça 
e_terca = x -> Dates.dayofweek(x) == Dates.Tuesday; 
# # 2021-12-25 foi um sábado
Dates.tonext(e_terca, Dates.Date(2021, 12, 25)) 

# O mesmo acima, porém escrito de uma forma mais conveniente:
Dates.tonext(Dates.Date(2021, 12, 25), Dates.Tuesday)

# A formulação acima pode ser útil para expressões mais complexas:
Dates.tonext(Dates.Date(2021, 12, 25)) do x
    # Return true on the 4th Thursday of November (Thanksgiving)
    Dates.dayofweek(x) == Dates.Thursday &&
    Dates.dayofweekofmonth(x) == 4 &&
    Dates.month(x) == Dates.November
end

# A função filter do pacote Base pode ser usada para filtrar datas válidas
# dadas certas condições:
dr = Dates.Date(2021):Dates.Day(1):Dates.Date(2022);
filter(dr) do x
    Dates.dayofweek(x) == Dates.Tue &&
    Dates.April <= Dates.month(x) <= Dates.Nov &&
    Dates.dayofweekofmonth(x) == 2
end