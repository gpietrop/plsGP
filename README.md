# Genetic Specification Search for Composite-Based Structural Equation Modeling

R source code for the paper *"Genetic Specification Search for Composite-Based Structural Equation Modeling"*.

## Overview
This repository provides an implementation of a Genetic Algorithm (GA) for conducting specification searches in composite-based Structural Equation Modeling (SEM). 
The algorithm searches for the best SEM structure by optimizing model fit criteria using evolutionary strategies.

## Requirements 
The following R packages are required: 
- `GA`
- `optparse`
- `cSEM`

You can install the necessary packages using:

```r
install.packages(c("GA", "optparse"))
# For cSEM, use:
install.packages("cSEM", repos = "https://csem.org")
```

## Directory Structure
- `src`: Contains all R source file 
- `results/`: Stores outputs from runs, including datasets, fitenss results and p-values
- `run_str{n}.sh/`: Is the script to run all the experiments for a specific structural model structure
- `README.md`: Is the .md file that contain all the information to run the code

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

## Output

The script will automatically generate a `results/` directory with the following structure:

- **results/**
  - **[hyperparam_subdir]/**: Subdirectory based on hyperparameters (e.g., population size, max iterations, tree row usage)
    - **str1/**: Results for models starting with `"str1"`
      - **[model_name]/**: Subfolder for a specific model and dimension
        - **[seed]_dataset_generated.csv**: Generated dataset for a specific run
        - **[seed]_hyperparameters.csv**: Hyperparameter configuration for the GA run
        - **[seed]_time.csv**: Time taken to complete the GA run
        - **[seed]_best.csv**: Best model structure found during the run (as an adjacency matrix)
        - **[seed]_fitness.csv**: Final fitness value of the best individual
    - **p_values/**: Directory containing cumulative p-values for SEM path estimates
      - **p_[model]_[modeDim]**: P-values file for a specific model and sample size

### Explanation of Outputs

- **`[seed]_dataset_generated.csv`**: Contains the generated dataset for a specific run.
- **`[seed]_hyperparameters.csv`**: Stores the hyperparameter configuration for the corresponding GA run.
- **`[seed]_time.csv`**: Records the total execution time for the GA run.
- **`[seed]_best.csv`**: Contains the best SEM model structure found during the run, typically represented as an adjacency matrix.
- **`[seed]_fitness.csv`**: Fitness value of the best individual from the run.
- **`p_values/p_[model]_[modeDim]`**: Aggregated p-values across all possible SEM connections for a specific model and sample size.

