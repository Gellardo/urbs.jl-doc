# Urbs.jl

## Julia as a Python Programmer
- Grundidee: Mischung High-level Programmiersprache (wie Matlab/Python) und der Geschwindigkeit von kompilierten Sprachen
- Dynamic type system: Variablen können einen beliebigen Typ haben, können aber auch eingeschränkt werden
- Arrays starten bei 1
- Built-in package manager (ähnlich zu pip)
- Just-in-time compiler vs skript sprachen
- Object Oriented Programming vs Types und Functions

## Lineare Optimierung mit JuMP
### Einfaches Beispiel
```julia
using JuMP

m = Model()
@variable(m, x >= 0)
@variable(m, y >= 0)

@objective(m, Max, x+y)

@constraint(m, x <= 3)
@constraint(m, y <= 2)

solve(m)
getobjectivevalue(m) == 5
```

### Grundlagen der Linearen Optimierung
- Variablen und Objective
- Bedingungen und Summen
- Solver-Einstellungen
- more matrix oriented in comparison to Pyomo
	* keine Mengen -> Daten müssen selbst durch Arrays organisiert werden
	* Verbindung zwischen Modell und Daten durch Arrayindizes

## Reduziertes Urbs Model
- Modellbausteine mit Parametern und Variablen
	* Sites
	* Processes
	* ...

### Implementierungsschritte
- excel reading
- array generation
- pure programming interface
- transmission (doubled)

## Vergleich mit URBS
- Reduziertes Model
- Speicher als Erhöhung der Solvetime
- kein plotting/Verarbeiten der Ergebnisse
- DIAGRAMME
	* Zeit (overall, linear speedup, solver vs model)
	* Speicherplatz
