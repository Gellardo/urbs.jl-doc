% Urbs.jl - Eine Julia-Implementierung des Urbs-Modells
% Frank Schmidt
% 19.10.2016

# Motivation
##
- Python Packet Pyomo nicht geeignet für große Modelle
	* langsame Modellerzeugung
	* verursacht durch das Design von Pyomo
- JuMP als schnelle Alternative
	* Zielsetzung: einsteigerfreundlicher und schneller Solver
	* Performance vergleichbar mit kommerziellen Tools wie AMPL
	* implementiert in der jungen Programmiersprache Julia


# Kurzübersicht Urbs
## Prozesse
- Picture **TODO**

## Prozesseigenschaften
- Jeder Prozess besitzt verschiedene Eigenschaften
	* grundlegende Eigenschaften: z.B. Kapazität, Kosten
	* spezielle Eigenschften zur Modellierung der jeweiligen Eigenschaften: z.B. Standpunkt(e) des Prozesses, Effizienz, Anfangszustand bei Energiespeichern
- Basierend auf diesen Parametern generiert das Modell Gleichungen um den zeitlichen Ablauf zu beschreiben und zu begrenzen
$$\forall t \in T . cap_{process,t} \leq maxcap_{process}$$
- Lineare Solver finden eine (kosten-)optimale Belegung der Variablen des Modells

# Julia
##
- high level sprache
- ähnlichkeiten mit matlab und python, aber auch c-elemente
- jit compiled
- noch in der entwicklung $\rightarrow$ Syntax noch nicht stabil
- einfache Installation von Paketen

# Programmatische Unterschiede
## Designentscheidungen
- Typen zur Zusammenfassung der Parameter
- Sammlung aller Elemente eines Typs in einem Array $\rightarrow$ index-gesteuerter Zugriff
- Umsetzung von eines reduzierten Modells bestehend aus:
	* verschiedenen Standorten
	* Prozessen (sowohl mit beliebigen Mengen an Rohstoffen wie auch mit Wasser/Wind/...)
	* Transmissionen
	* Speichern

##
- Constraint einmal Python, einmal julia

# Testergebnisse
## Optimierung
![Zeit für die Modellerzeugung und Optimierung in Abhängigkeit der Zeitschritte](images/solve.png)

## Time
![Zeit für die Modellerzeugung in Abhängigkeit der Zeitschritte](images/model.png)

## Memory
![Speicherverbrauch der Modellerzeugung in Abhängigkeit der Zeitschritte](images/memory.png)

