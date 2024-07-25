#!/bin/bash

# Define the parameters
DATASET_PATHS=(
    "/home/gpietrop/plsGP/results_paper/200_100_TRUE/str3/str3_small_100/0_dataset_generated.csv"
    "/home/gpietrop/plsGP/results_paper/200_100_TRUE/str3/str3_med_100/0_dataset_generated.csv"
)

POP_SIZE=100
MAX_ITER=200


# Loop over each dataset path
for DATASET_PATH in "${DATASET_PATHS[@]}"; do
    Rscript main_bootstrap.R \
        --dataset_path="$DATASET_PATH" \
        --popSize=$POP_SIZE \
        --maxiter=$MAX_ITER \
        --model="str3_med" \
        --pmutation=1.0 \
        --pcrossover=0.8 \
        --seed_start=0 \
        --seed_end=99 \
        --treeRows=TRUE &
done

