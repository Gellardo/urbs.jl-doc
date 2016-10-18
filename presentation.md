---
title: Urbs.jl - Eine Julia-Implementierung des Urbs-Modells
author: Frank Schmidt
date: 19.10.2016
outertheme: infolines
---

# Motivation
##
- Python Packet Pyomo nicht geeignet für große Modelle
	* langsame Modellerzeugung
	* verursacht durch das Design von Pyomo
- JuMP als schnelle Alternative
	* Zielsetzung: einsteigerfreundlicher und schneller Solver
	* Performance vergleichbar mit kommerziellen Tools wie AMPL
	* implementiert in der jungen Programmiersprache Julia

## Julia
- high-Level Sprache
- Ähnlichkeiten mit Matlab und Python, aber auch C-Elemente
- nutzt einen Just-in-Time Compiler
- noch in der Entwicklung $\rightarrow$ Syntax noch nicht stabil
- einfache Installation von Paketen


# Kurzübersicht Urbs
## Prozesse
![Grundlagen des Modells](images/process.png)

## Prozesseigenschaften
- Jedes Element des Modells besitzt verschiedene Eigenschaften
	* grundlegende Eigenschaften: z.B. Kapazität, Kosten
	* spezielle Eigenschaften zur Modellierung der jeweiligen Eigenschaften: z.B. Effizienz, Anfangszustand bei Energiespeichern
- Basierend auf diesen Parametern generiert das Modell Gleichungen um den zeitlichen Ablauf zu beschreiben und zu begrenzen
$$\forall t \in T \forall p \in P . cap_{p,t} \leq maxcap_{p}$$
- Lineare Solver finden eine (kosten-)optimale Belegung der Variablen des Modells


# Programmatische Unterschiede
## Designentscheidungen
- Typen zur Zusammenfassung der Parameter
- Sets als Sammlung der Elemente eines Typs in einem Array $\rightarrow$ Index-gesteuerter Zugriff
- Umsetzung eines reduzierten Modells bestehend aus:
	* verschiedenen Standorten
	* Prozessen (sowohl mit beliebigen Mengen an Rohstoffen wie auch mit Wasser/Wind/...)
	* Transmissionen
	* Speichern
	* Nachfrage

## Beispiel-Constraint Python
```python
m.tra_tuples = pyomo.Set(
  within=m.sit*m.sit*m.tra*m.com,
  initialize=m.transmission.index
  )

m.def_transmission_output = pyomo.Constraint(
  m.tm, m.tra_tuples,
  rule=def_transmission_output_rule
  )

def def_transmission_output_rule(m, tm, sin, sout,
                                 tra, com):
  return (m.e_tra_out[tm, sin, sout, tra, com] ==
    m.e_tra_in[tm, sin, sout, tra, com] *
    m.transmission.loc[sin, sout, tra, com]['eff'])
```

## Beispiel-Constraint Python
```julia
type Transmission
	left
	right
	cap_init
	cap_min
	cap_max
	cost_fix
	cost_var
	cost_inv
	annuity_factor
	efficiency
end

@constraint(m,out_commidity[t = timeseries,tr = numtrans],
               trans_out[t, tr] == trans_in[t, tr]
			   * transmissions[tr].efficiency)
```

# Evaluierung von Urbs.jl
## Optimierung
![Zeit für die Optimierung in Abhängigkeit der Zeitschritte](images/solve.png)

## Modellerzeugung
![Zeit für die Modellerzeugung in Abhängigkeit der Zeitschritte](images/model.png)

## Speicherverbrauch
![Speicherverbrauch der Modellerzeugung in Abhängigkeit der Zeitschritte](images/memory.png)

## Future Work
- Erweiterung des Modells
- Auswertung und Visualisierung der Ergebnisse

## Ergebnis
- JuMP nah an der mathematischen Formel
- Modellierung von Sets nötig
- Modellerzeugung 500-1000 mal schneller als Pyomo

##
**Vielen Dank für ihre Aufmerksamkeit**
