#!/bin/bash

# Define the base project directory
PROJECT_DIR="gcp-multiregion-vpc-lab"

# Create the main project directory
mkdir -p "$PROJECT_DIR"

# Create top-level Terraform files
touch "$PROJECT_DIR/main.tf"
touch "$PROJECT_DIR/variables.tf"
touch "$PROJECT_DIR/outputs.tf"

# Define module directories
MODULES=("vpc" "subnet" "firewall" "vm")

# Create module directories and their respective files
mkdir -p "$PROJECT_DIR/modules"
for module in "${MODULES[@]}"; do
    mkdir -p "$PROJECT_DIR/modules/$module"
    touch "$PROJECT_DIR/modules/$module/main.tf"
    touch "$PROJECT_DIR/modules/$module/variables.tf"
    touch "$PROJECT_DIR/modules/$module/outputs.tf"
done

echo "Estructura de archivos y directorios creada con éxito en '$PROJECT_DIR'"
