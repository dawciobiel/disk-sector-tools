#!/bin/bash

# The script is used for compilation and linking using NASM of the source code file given as the launch parameter.
# Author: Dawid Bielecki - dawciobiel
# GitHub: https://github.com/dawciobiel
# Usage:
#   ./build.bash <nasm_source_file>

# Setting up variables for syntax highlighting of text
source ./colors

# Displaying an empty line
echo -e ""

# Checking if a file was provided as an argument
if [ -z "$1" ]; then
  echo -e "Usage: $0 <source_file>\n"
  exit 1
fi

# Variable containing the source file name
SOURCE_FILE=$1

# Checking if the file exists
if [ ! -f "$SOURCE_FILE" ]; then
  echo -e "${RED}File [ $SOURCE_FILE ] does not exist.${NC}\n"
  exit 2
fi

# Variable containing the executable file name (without extension)
OUTPUT_FILE="${SOURCE_FILE%.*}"

# Compiling the ASM file using NASM
echo -e "Compiling [ $SOURCE_FILE ]"
nasm -f elf64 -o "$OUTPUT_FILE.obj" "${SOURCE_FILE}"
# Displaying an empty line
echo -e ""

# Checking if the compilation was successful
if [ $? -ne 0 ]; then
  echo -e "\n${RED}Compilation error.${NC}\n"
  exit 3
fi

# Linking the object file
echo -e "Linking [ ${OUTPUT_FILE}.obj ]"
ld "${OUTPUT_FILE}.obj" -o "${OUTPUT_FILE}.elf64"

# Checking if the linking was successful
if [ $? -ne 0 ]; then
  echo -e "\n${RED}Linking error.${NC}\n"
  exit 4
fi

# Print success message
echo -e "\n${GREEN}Executable file [ ${YELLOW}${OUTPUT_FILE}.elf64 ]${NC}\n"

# List content of current folder
ls -1pl --color=always
