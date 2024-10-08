#!/bin/bash

# Initialize Conda
eval "$(conda shell.bash hook)"
conda activate plsGP

# Array of models and dimensions
models=("str3_small" "str3_med")
dimensions=(100 250 500)

# Run R scripts in parallel
for model in "${models[@]}"; do
    for dim in "${dimensions[@]}"; do
        echo "Running Rscript for model $model with modeDim $dim"
        Rscript main_timing.R --model=$model --modeDim=$dim &
    done
done

# Wait for all background processes to finish
wait

echo "All tasks have been launched."

