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

The script will automatically generate a `results/` directory with the following structure:

- **results/**
  - **hyperparam_subdir/** (e.g., `5_20_TRUE` for `maxiter=5`, `popSize=20`, `treeRows=TRUE`)
    - **str1/** (or `str2/`, `str3/`, `str4/` depending on the model)
      - **model_name/** (e.g., `str1_small_100` for model name and sample size)
        - **seed_dataset_generated.csv**: Generated dataset for the corresponding seed.
        - **seed_hyperparameters.csv**: Configuration of hyperparameters used for the run.
        - **seed_time.csv**: Time taken for the GA execution.
        - **seed_best.csv**: Best SEM model structure found during the run (as an adjacency matrix).
        - **seed_fitness.csv**: Final fitness value of the best individual.
    - **p_values/** (Directory containing cumulative p-values)
      - **p_model_modeDim**: Cumulative p-values file for a specific model and sample size.

### Explanation of Outputs

- 📄 **`seed_dataset_generated.csv`**: Dataset generated during the specific GA run.
- ⚙️ **`seed_hyperparameters.csv`**: Hyperparameter settings used for that run.
- ⏱️ **`seed_time.csv`**: Total runtime of the GA execution for that seed.
- 🏆 **`seed_best.csv`**: Best model structure found, saved as an adjacency matrix.
- 💪 **`seed_fitness.csv`**: Fitness value of the best-found solution.
- 📊 **`p_values/p_model_modeDim`**: Aggregated p-values for all SEM path estimates, based on the specific model and sample size.