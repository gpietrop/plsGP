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
- `run_str{n}.sh/`: Script to run all the experiments for a specific structural model structure
- `README.md`: This documentation file containing all necessary information to run the code

## Usage

To run the script with custom hyperparameters:

``` bash
Rscript src/main.R --model str1_small --modeDim 200 --popSize 200 --maxiter 100 --pcrossover 0.8 --seed_start 0 --seed_end 99
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

## 📂 `src/` Folder Overview  

The `src/` folder contains the main scripts required to execute the method. Below is a description of each file (apart from `main.R` already described above):  

### 📝 `analysis.R`  
This script provides a function, **`process_folder()`**, which analyzes the results obtained from different runs. The function computes summary statistics and metrics based on the results stored in a specified folder.  

#### 🔹 Usage:  
```r
str_id <- "str1"
effect_size <- "high"
sample_size <- "100"
name_folder <- "200_100_TRUE"
process_folder(name_folder, str_id, effect_size, sample_size, print_frequent = TRUE, print_examples = FALSE)
```
#### 🔹 Parameters:  
- **`name_folder`**: The name of the folder inside the `results/` directory where the results are stored.  
- **`str_id`**: The structure identifier (`"str1"`, `"str2"`, `"str3"`, or `"str4"`).  
- **`effect_size`**: The effect size of the experiment (`"small"`, `"medium"`, or `"high"`).  
- **`sample_size`**: The sample size used in the experiment (e.g., `100`, `250`, or `500`, as in the reference paper).  
- **`print_frequent`**: If `TRUE`, prints the most frequently found matrices across different runs.  
- **`print_examples`**: If `TRUE`, displays example matrices that either contain or are contained in the original model.  

#### 🔹 Output:  
By default, `process_folder()`:
- Returns the **mean of all matrices** generated in different runs.  
- Computes **accuracy and the parsimonious rate**, as reported in **Table 1** of the reference paper.  
- Optionally, prints the **most frequent matrices** found by the model (`print_frequent = TRUE`).  
- Optionally, provides **examples of matrices** contained within or containing the original model (`print_examples = TRUE`).  

* `analysis_utils.R`, `fitness_utils.R`, `utils.R`
* `ga_operators.R`
* `hyperparameters.R`
* `my_fitness.R`
* `run_model.R`

## Output

The script will automatically generate a `results/` directory with the following structure:


- **results/**
  - **hyperparam_subdir/** (e.g., `5_20_TRUE` for `maxiter=5`, `popSize=20`, `treeRows=TRUE`)
    - **str1/** (or `str2/`, `str3/`, `str4/` depending on the model)
      - **model_name/** (e.g., `str1_small_100` for model name and sample size)
        - **seed_dataset_generated.csv** 
        - **seed_hyperparameters.csv**
        - **seed_time.csv**
        - **seed_best.csv**
        - **seed_fitness.csv**
    - **p_values/** (Directory containing cumulative p-values)
      - **p_model_modeDim**

### Explanation of Outputs

- 📄 **`seed_dataset_generated.csv`**: Dataset generated during the specific GA run.
- ⚙️ **`seed_hyperparameters.csv`**: Hyperparameter settings used for that run.
- ⏱️ **`seed_time.csv`**: Total runtime of the GA execution for that seed.
- 🏆 **`seed_best.csv`**: Best model structure found, saved as an adjacency matrix.
- 💪 **`seed_fitness.csv`**: Fitness value of the best-found solution.
- 📊 **`p_values/p_model_modeDim`**: Aggregated p-values for all SEM path estimates, based on the specific model and sample size.
