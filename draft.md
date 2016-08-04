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

Die Entwicklung von Julia wurde davon motiviert, eine Sprache zu schaffen,
welche die einfache Programmierung von High-level und die Geschwindigkeit einer
Low-level Programmiersprache in sich vereint. Julia erreicht dies unter anderem
durch die Integration von nützlichen Hilfsprogrammen, einen Just-in-time
Compiler und ein _dynamic type System_ wie es zum Beispiel auch Python enthält.
Im Folgenden werden die Auswirkungen dieser Designentscheidungen aus der Sicht
eines Pythonprogrammierers betrachtet.

### Der Just-in-time Compiler
Sprachen wie Python verwenden (standardmäßig) einen sogenannten Interpreter um
Programmcode direkt auszuführen. Dies bedeutet, dass der Interpreter  die
Befehle "ließt" und dann die entsprechenden Befehle ausführt. Im Gegensatz
hierzu erzeugt ein Just-in-time Compiler zunächst aus dem gegebenen
menschenlesbaren Quellcode maschienenlesbaren ausführbaren Maschienencode.
Dieser kann von dem Compiler optimiert werden, sodass die Performance des
Programmes im Allgemeinen besser ist als bei einem Interpreter. Eine
Besonderheit eines *Just-in-time* Compilers ist, dass dieser Übersetzungsprozess
nur für die Quellcode-Fragmente erfolgt, welche ausgeführt werden sollen. Gibt
es also beispielsweise Funktionen, welche nicht benutzt werden, so werden diese
nicht compiliert und dadurch Zeit gespart. Dies bedeutet aber wiederum, dass der
Programmstart im Allgemeinen durch die nötige Kompilierung verzögert wird. Um
die Nutzung eines dynamischen Typsystems nutzen zu können, kompiliert der
JiT-Compiler abhängig vom Typ der Parameter, was wiederum impliziert, dass
typunverträglichkeiten erst bei der Ausführung programmatisch erkannt werden.

### Dynamic type System
Ähnlich zu Python verzichtet auch Julia auf statische Typdefinitionen von
Variablen und speichert stattdessen den Typ einer Variable zur Laufzeit und
bestimmt Typänderungen durch eine Typ-Hierarchie oder durch Kopie des Types bei
Zuweisungen. Das führt dazu, dass aus
```julia
a = 1
b = a * 1.0
```
folgt dass `a` ein Integer ist und `b` ein Float (da bei einer Multiplikation
von unterschiedlichen Typen das Ergebnis den allgemeineren Typ annimmt). Jedoch
dann, im Unterschied zum Python-Standard, der Programmierer auch den Typ eines
Ausdrucks angeben.  Dies kann beispielsweise zur Dokumentation und Einschränkung
eines Funktionsparameters auf einen bestimmten Typen genutzt werden.

Die Nutzung von Dynamic Dispatch in Julia erlaubt es außerdem, einen
Funktionsnamen wiederzuverwenden, solange sich die Typen der Parameter
unterscheiden (ansonsten wird die vorherige Definition der Funktion
überschrieben). Folgendes Beispiel definiert erst die Konkatenation von zwei
Strings mithilfe von "+" (welche standardmäßig nicht definiert ist). Die
Anotation `x::String` besagt, dass `x` nur ein Wert mit einem Subtyp von
`String` zugewiesen werden darf.  Die zweite Funktion definiert für alle
möglichen Typen die Addition als die Stringkkonkatenation. Aufgrund der Dynamic
Dispatch Logik von Julia wird die allgemeine zweite Version von "+" nur
angewendet, wenn keine der spezielleren Versionen zutrifft. Hierbei ist zu
beachten, dass die Funktion für jede neue Typkombination von Parametern durch
den JiT-Compiler neu übersetzt wird, sobald diese bei der Ausführung des
Programmes benötigt wird. Dadurch fallen Typinkompatibilitäten der Parameter
erst auf, wenn dies zur Laufzeit des Programms entdeckt wird.

```julia
function +(x::String, y::String) #(1)
 return string(x,y)
end

function +(x, y) #(2)
 return string(x,y)
end

1 + 2 == 3 #+(Int, Int)
"foo" + "bar" == "foobar" #+(String,String) von (1)
"foo" + 1 == "foo1" #+(Any,Any) von (2) wird zu +(String, Int) kompiliert

```

**Objektorientiere Programmierung**

In Julia es gibt keine Objekte, nur Typen welche mit C-structs, also reinen
Datenspreichern gleichzusetzten sind. Dies bedeutet auch, dass alle Funktionen
welche mit dem neuen Typen interagieren sollen nicht (wie bei Objektorientierter
Programmierung) direkt mit dem Typen verbunden sind, sondern Julia dies erst bei
dem Funktionsaufruf über die Parametertypen erkennt und zuordnet.

Folgende "Klassen"-Definitionen definieren beide eine Datenstruktur `Point`
welche über zwei Attribute `x,y` verfügt. Über die Funktion `add` kann ein
`Point` auf einen anderen addiert werden. Zu beachten ist hier, dass der
Methodenname in Julia nach Konvention auf ein "!" endet, da er den inhalt eines
Parameters verändert, in diesem Fall die Werte der Attribute `x` und `y`.
Außerem bedeutet die Formulierung in Julia, dass der Aufruf der Funktion sich
leicht verändert, da die Variable mit Typ `Point` nicht wie gewohnt mit
`var.add(x)` aufgerufen wird, sondern als reiner Funktionsaufruf `add!(var,x)`.
Zusätzlich konstruiert Julia automatisch einen Defaultkonstruktor, welcher so
viele Parameter übernimmt, wie der Typ Attribute hat, also `var = Point(x,y)`.
Daneben kann man natürlich auch weitere eigene Konstruktoren angeben.
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
# julia
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
Dieser Abschnitt beschäftigt sich mit einer offenen Liste von  Besonderheiten
und Namenskonventionen bei der Verwendung von Julia.

**Arrays:** Insbesondere bei Arrays macht sich der Einfluss der Sprache Matlab
auf die Entwicklung von Julia bemerkbar. Einerseits ist der Index des ersten
Arrayelements anders als bei Python die 1. Außerdem ist es einfach möglich
Vektoren und Matrizen anzugeben. Zum Beispiel erzeugt `[1 2; 3 4]` eine 2x2
Matrix mit den Zeilenvektoren `1 2` und `3 4`.

**Funktionsparameter und Namenskonventionen:** Julia kennt grundsätzlich mehrere
Arten von Funktionsparametern: Normale Funktionsparameter, welche gegebenenfalls
mit Standardwerten belegt werden können, Keyword-Parameter, welche beim Aufruf
der Funktion mit Namen angegeben werden müssen sowie einen Defaultwert besitzen
müssen und einen Aggregationsparameter für eine variable Anzahl an Parametern.
Zu beachten ist hierbei, dass bei einer Funktionsdefinition zuerst die normalen
Parameter angegeben werden müssen und dann, durch ein `;` getrennt, die
Keyword-Parameter. In dem Beispiel haben wir zwei normale Parameter `a,b`, wobei
b, soweit nicht anders angegeben mit `1` belegt wird.  Dem Keyword-Parameter `c`
wird soweit nicht anders aufgerufen der Wert 2 zugewiesen und `args` enthält
alle überzähligen Parameter als Tupel.
```julia
function foo(a, b=1; c=2, args...)
    a, b, args, c
end

foo(1, 2, 3, 4, c=4) # returns (1,2,(3, 4),4)
```
Außerdem fällt auf, dass die Funktion `foo` keinen expliziten return-Befehl
enthält.  Dennoch liefert sie das Tupel `(a,b,args,c)` zurück, da Julia in einem
solchen Fall den Rü©kgabewert der letzten Zeile der Funktion zurückgibt.
Natürlich kann auch ein explizites `return` angegeben werden.

**Utilities:** Die Entwickler von Julia haben bei dem Entwurf der Sprache
bereits einige Dinge integriert, welche bei anderen Programmiersprachen erst
durch externe Tools verfügbar sind. So gibt es zur Installation von
Python-Paketen das Programm `pip`. In Julia hingegen ist die Paketverwaltung
direkt in die Basisfunktionalität der Sprache eingebaut. Das Modul `Pkg` kümmert
sich um die Installation und das Updaten von externen Modulen. Diese werden
standardmäßig im Verzeichnis des aktuellen Benutzers abgelegt, sodass keine
Administratorrechte nötig sind.
```julia
# Installation eines offiziellen Pakets von pkg.julialang.org
Pkg.install("Calculus")

# Installation eines Pakets von Github unter dem Namen "Modul"
Pkg.clone("https://github.com/user/repo.git", "Modul")

# Update aller installierten Pakete und deren Abhängigkeiten
Pkg.update()
```

Zwei weitere Dinge, welche vor allem die Programmierung mit Hilfe eines Terminals
erleichtern ist die Integration einer Shell und der Dokumentation in Form einer
durchsuchbaren Hilfe. Durch den Druck von ";" in der interaktiven
Julia-Kommandozeile können einzelne Shell-Befehle ausgeführt werden, ohne die
Julia-Umgebung zu verlassen.  Dokumentationsstrings von Funktionen oder Types im
Quellcode können über die Hilfe in der Julia-Kommandozeile angezeigt werden.
Hierzu wird einfach "?" vorangestellt und danach der gesuchte Begriff
eingegeben. In dem Beispiel wird "?test" den String über der Funktionsdefinition
zurückgeben.
```julia
"Dies ist der Docstring der Testfunktion"
function test()
	return true
end
```


## Lineare Optimierung mit JuMP
Die Hauptmotivation dieser Arbeit war die Evaluierung der Open-Souce Bibliothek
JuMP.jl in Hinsicht auf die Verwendung zur Lösung von Problemen aus dem Bereich
der liniaren Optimierung. Insbesondere der Vergleich mit der auf Python
baiserenden Grundlage Pyomo des Programmes URBS im Bereich der Performance bei
großen Problemstellungen wird verglichen werden. Außerdem beherrscht JuMP auch
weitere Problemklassen, welche hier jedoch nicht von Bedeutung sind. Zudem
befindet sich JuMP ebenso wie Julia noch in der aktiven Entwicklung, weshalb die
Spezifikation noch öfteren Veränderungen unterworfen ist.

### Einfaches Beispiel
Als einfachen Einstieg wird das triviale Problem
$$ \max_{x,y} x+y_{} $$
$$ s.t.\; x \leq 3 \land y \leq 2 $$
in JuMP formuliert und gelöst. Zunächst wird das Paket JuMP importiert und ein
leeres Modell erzeugt.  Anschließend werden dem Modell erst Variablen und dann
die begleitenden Gleichungen hinzugefügt. Hierzu werden anstatt von Funktionen
Makros genutzt, um die jeweiligen Anweisungen umzusetzen. Makros unterscheiden
sich in der Verwendung lediglich durch das vorangestellte "@" von Funktionen,
werden jedoch dazu genutzt, um während der Laufzeit des Programmes angepassten
Code zu generieren. Abschließend wird des Modell gelöst und das Ergebnis des als
Objective gegebenen Terms mit dem richtigen Ergebnis verglichen.

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

### Grundlagen der Linearen Optimierung **Variablen:** Nach der Erstellung eines
Modells muss diesem zunächst eine Menge an Variablen zugewiesen werden, welche
später während der Optimierung verändert werden dürfen. Um eine Variable dem
Modell `m` hinzuzufügen muss das Makro `@variable` aufgerufen werden. Hierbei
können bereits erste Einschränkungen auf die Variable angewendet werden. So
können optional Ober- und Untergrenzen angegeben werden, ein ganzer Vektor an
Variablen auf einmal definiert und der Type der Variable festgelegt werden. Ohne
weitere Einschränkungen ist die definierte Variable automatisch eine
unbeschränkte Fließkommazahl.
```julia
@variable(m, 0 <= x <= 5) # x als Fließkommazahl zwischen 0 und 5
@variable(m, y[1:5], Int) # y als 5-elementiger Vektor aus Ganzzahlen
```
**Bedingungen und Objective**
Die wohl Wichtigste Angabe des Modells ist die zu optimierende Gleichung. Diese
wird über das Makro `@objective` festgelegt, wobei der zweite Parameter die Art
der Optimierung (Min oder Max) angibt, während der dritte Parameter die zu
optimierende Gleichung enthält.

Zusätzlich gibt es Bedingungen welche die Lösung erfüllen muss, um für das
Problem gültig zu sein. Hierfür wird das Makro `@constraint` genutzt. _TODO:
einzelne constraint, mehrere constraints in einem, efficient sums_

**Solver**
TODO
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
	* pickel-ersatz? extraktion der variablen: JLD paket

## Vergleich mit URBS
- Reduziertes Model
- Speicher als Erhöhung der Solvetime
- kein plotting/Verarbeiten der Ergebnisse
- DIAGRAMME
	* benutzte Test-Modelle einführen
	* Zeit (overall, linear speedup, solver vs model)
	* Speicherplatz


------------
Sources:
- http://julialang.org/publications/
- http://julia.readthedocs.io/en/release-0.4/
- https://arxiv.org/abs/1508.01982v2 (JuMP-paper)
- http://www.juliaopt.org/JuMP.jl/0.13/
