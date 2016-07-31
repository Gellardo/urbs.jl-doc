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
Sprachen wie Python verwenden (standardmäßig) einen sogenannten Interpreter um
Programmcode direkt auszuführen. Dies bedeutet, dass der Interpreter  die Befehle "ließt"
und dann die entsprechenden Befehle ausführt. Im Gegensatz hierzu erzeugt ein Just-in-time
Compiler zunächst aus dem gegebenen menschenlesbaren Quellcode maschienenlesbaren
ausführbaren Maschienencode. Dieser kann von dem Compiler optimiert werden, sodass die
Performance des Programmes im Allgemeinen besser ist als bei einem Interpreter. Eine
Besonderheit eines *Just-in-time* Compilers ist, dass dieser Übersetzungsprozess nur für
die Quellcode-Fragmente erfolgt, welche ausgeführt werden sollen. Gibt es also
beispielsweise Funktionen, welche nicht benutzt werden, so werden diese nicht compiliert
und dadurch Zeit gespart. Dies bedeutet aber wiederum, dass der Programmstart im
Allgemeinen durch die nötige Kompilierung verzögert wird. Um die Nutzung eines dynamischen
Typsystems nutzen zu können, kompiliert der JiT-Compiler abhängig vom Typ der Parameter,
was wiederum impliziert, dass typunverträglichkeiten erst bei der Ausführung
programmatisch erkannt werden.

### Dynamic type System
Ähnlich zu Python verzichtet auch Julia auf statische Typdefinitionen von Variablen und
speichert stattdessen den Typ einer Variable zur Laufzeit und bestimmt Typänderungen durch
eine Typ-Hierarchie oder durch Kopie des Types bei Zuweisungen. Das führt dazu, dass aus
```julia
a = 1
b = a * 1.0
```
folgt dass `a` ein Integer ist und `b` ein Float (da bei einer Multiplikation von
unterschiedlichen Typen das Ergebnis den allgemeineren Typ annimmt). Jedoch dann, im
Unterschied zum Python-Standard, der Programmierer auch den Typ eines Ausdrucks angeben.
Dies kann beispielsweise zur Dokumentation und Einschränkung eines Funktionsparameters auf
einen bestimmten Typen genutzt werden.

Die Nutzung von Dynamic Dispatch in Julia erlaubt es außerdem, einen Funktionsnamen
wiederzuverwenden, solange sich die Typen der Parameter unterscheiden (ansonsten wird die
vorherige Definition der Funktion überschrieben). Folgendes Beispiel definiert erst die
Konkatenation von zwei Strings mithilfe von "+" (welche standardmäßig nicht definiert
ist). Die Anotation `x::String` besagt, dass `x` nur ein Wert mit einem Subtyp von
`String` zugewiesen werden darf.  Die zweite Funktion definiert für alle möglichen Typen
die Addition als die Stringkkonkatenation. Aufgrund der Dynamic Dispatch Logik von Julia
wird die allgemeine zweite Version von "+" nur angewendet, wenn keine der spezielleren
Versionen zutrifft. Hierbei ist zu beachten, dass die Funktion für jede neue
Typkombination von Parametern durch den JiT-Compiler neu übersetzt wird, sobald diese bei
der Ausführung des Programmes benötigt wird. Dadurch fallen Typinkompatibilitäten der
Parameter erst auf, wenn dies zur Laufzeit des Programms entdeckt wird.

```julia
function +(x::String, y::String) //(1)
 return string(x,y)
end

function +(x, y) //(2)
 return string(x,y)
end

1 + 2 == 3 //+(Int, Int)
"foo" + "bar" == "foobar" //+(String,String) von (1)
"foo" + 1 == "foo1" //+(Any,Any) von (2) wird zu +(String, Int) kompiliert

```

- Object Oriented Programming vs Types und Functions
In Julia es gibt keine Objekte, nur Typen welche mit C-structs, also reinen
Datenspreichern gleichzusetzten sind. Dies bedeutet auch, dass alle Funktionen welche mit
dem neuen Typen interagieren sollen nicht (wie bei Objektorientierter Programmierung)
direkt mit dem Typen verbunden sind, sondern Julia dies erst bei dem Funktionsaufruf über
die Parametertypen erkennt und zuordnet.

Folgende "Klassen"-Definitionen sind definieren beide eine Datenstruktur `Point` welche
über zwei Attribute `x,y` verfügt. Über die Funktion `add` kann ein `Point` auf einen
anderen addiert werden. Zu beachten ist hier, dass der Methodenname in Julia nach
Konvention auf ein "!" endet, da er den inhalt eines Parameters verändert, in diesem Fall
die Werte der Attribute `x` und `y`. Außerem bedeutet die Formulierung in Julia, dass der
Aufruf der Funktion sich leicht verändert, da die Variable mit Typ `Point` nicht wie
gewohnt mit `var.add(x)` aufgerufen wird, sondern als reiner Funktionsaufruf `add!(var,x)`.
Zusätzlich konstruiert Julia automatisch einen Defaultkonstruktor, welcher so viele
Parameter übernimmt, wie der Typ Attribute hat, also `var = Point(x,y)`. Daneben kann man
natürlich auch weitere eigene Konstruktoren angeben.
```Python
# python
class Point:
	def __init__(self, x, y):
		self.x = x
		self.y = y
	def add(self, Point p):
		self.x += p.x
		self.y += p.y
```
```julia
// julia
type Point
	x::Int
	y::Int
end

function add!(p1::Point, p2::Point)
	p1.x += p2.x
	p1.y += p2.y
end
```

### Utilities und andere Unterschiede
Dieser Abschnitt beschäftigt sich mit einer offenen Liste von  Besonderheiten und
Namenskonventionen bei der Verwendung von Julia.

**Arrays:**
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
