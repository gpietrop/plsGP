---
editor_options: 
  markdown: 
    wrap: 72
---

# Genetic Specification Search for Composite-Based Structural Equation Modeling

R source code for the paper "Genetic Specification Search for
Composite-Based Structural Equation Modeling"

## Usage

To run the script with custom hyperparameters:

``` bash
Rscript main.R --model str1_small --modeDim 200 --popSize 200 --maxiter 100 --pcrossover 0.8 --seed_start 0 --seed_end 99
```

where the inputs arguments stand for: 
* `--model` Model to use (default:
`"str1_small"`) 
* `--modeDim` Sample size as an integer (default:
`100`) 
* `--popSize`: Population size as an integer (default: `200`) 
* `--maxiter`: Maximum number of iterations as an integer (default:
`100`) 
* `--pcrossover`: Crossover rate as a double (default: `0.8`) 
* `--seed_start`: First seed for the GA (default: `0`) 
* `--seed_end`: Last seed for the GA (default: `99`)
