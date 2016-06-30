# Urbs.jl

## Julia as a Python Programmer
- idea: mixture of matlab & python with speed similar to compiled languages
- typ-freie sprache
- arrays start at 1
- built-in package manager (similar to pip)
- Just-in-time compiler vs skript sprache
- objects vs types and functions (c-style)

## Using JuMP
### basic example
```
stuff
```
### foundations for linear programming
- variables + objective
- constraints
- how to choose a solver
- more matrix oriented in comparison to Pyomo
	* no sets -> organize as arrays
	* using indices instead of elements of a set

## Model
- consists of
	* Sites
	* Processes
	* ...
- parameters
- variables

### hard parts
- excel reading
- pure programming interface
- array generation
- transmission (doubled)

## Comparison to URBS
- just the basic model
- no plotting/processing of the results
- DIAGRAMS
	* time (overall, linear speedup, solver vs model
	* space
