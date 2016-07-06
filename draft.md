# Urbs.jl - Energiesystem-Modellierung mit Julia

## Julia als Python Programmierer
High-level Programmiersprachen wie Matlab oder Python sind heute gerade im
akademischen Umfeld sehr beliebt, da sie generell komplizierte Sachverhalte
hinter einer Abstraktionsschicht verbergen und es dadurch auch unerfahrenen
Programmierern erleichtern, komplexe Programme zu realisieren. Im Gegensatz dazu
stehen Low-level Programmiersprachen (z.B. C, C++), welche größere Freiheiten im
Ablauf eines Programmes erlauben, andererseits durch ihre Komplexität und
maschinennahe Programmierung auch eine deutliche längere Einarbeitungs- und
Entwicklungszeit benötigen. Dabei ist der Performancegewinn durch die tiefgehende
Kontrolle meist nicht ausreichend genug, um einen Programmierer zum Wechseln zu
bewegen.

Die Entwicklung von Julia wurde davon motiviert, eine Sprache zu schaffen, welche die
einfache Programmierung von High-level und die Geschwindigkeit einer Low-level
Programmiersprache in sich vereint. Julia erreicht dies unter anderem  durch die
Integration von nützlichen Hilfsprogrammen, einen Just-in-time Compiler und ein
_dynamic type System_ wie es zum Beispiel auch Python enthält. Im Folgenden werden
die Auswirkungen dieser Designentscheidungen aus der Sicht eines Pythonprogrammierers
betrachtet.

### Der Just-in-time Compiler
- Just-in-time compiler vs skript sprachen
### Dynamic type System
- Dynamic type system: Variablen können einen beliebigen Typ haben, können aber auch eingeschränkt werden
- Object Oriented Programming vs Types und Functions
### Utilities und andere Unterschiede
- Arrays starten bei 1
- Built-in package manager (ähnlich zu pip) + shell + Hilfe
- function parameter, default values, keyword only parameter

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
	* array generation
	* Parameter in Typen speichern
- pure programming interface
- Besonderheiten:
	* transmission (doubled) -> legacy schalter

- Analyse (? welche Schritte sind relevant? nur solven oder auch anderes?)
	* kombinationstyp für parameter + model (+ variablen-ergebnisse?)
	* results speichern
	* pickel-ersatz? extraktion der variablen

## Vergleich mit URBS
- Reduziertes Model
- Speicher als Erhöhung der Solvetime
- kein plotting/Verarbeiten der Ergebnisse
- DIAGRAMME
	* benutzte Test-Modelle einführen
	* Zeit (overall, linear speedup, solver vs model)
	* Speicherplatz
