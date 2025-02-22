#!/bin/bash

# The script is used on macOS 10.12+ for compilation and linking using NASM of the source code file given as the launch parameter.
#
# Author: Dawid Bielecki - dawciobiel
# GitHub: https://github.com/dawciobiel
# Version: beta
# Requirements: macOS 10.12 or newer
#
# Usage:
#   ./build-macos.bash <nasm_source_file>


# Setting up variables for syntax highlighting of text
source ./colors_varialbes

# Displaying an empty line
echo -e ""

# Checking if a file was provided as an argument
if [ -z "$1" ]; then
  echo -e "Usage: $0 <source_file>\n"
  exit 1
fi

# Variable containing the source file name
SOURCE_FILE="$1"

# Checking if the file exists
if [ ! -f "$SOURCE_FILE" ]; then
  echo -e "${RED}File [ $SOURCE_FILE ] does not exist.${NC}\n"
  exit 2
fi

# Variable containing the executable file name (without extension)
OUTPUT_FILE="${SOURCE_FILE%.*}"

# Compiling the ASM file using NASM
echo -e "Compiling [ $SOURCE_FILE ]"
nasm -f macho64 -o "$OUTPUT_FILE.o" "$SOURCE_FILE"
# Displaying an empty line
echo -e ""

# Checking if the compilation was successful
if [ $? -ne 0 ]; then
  echo -e "\n${RED}Compilation error.${NC}\n"
  exit 3
fi

# Linking the object file
echo -e "Linking [ ${OUTPUT_FILE}.o ]"
ld -macosx_version_min 10.12 -lSystem -o "${OUTPUT_FILE}.out" "${OUTPUT_FILE}.o"

# Checking if the linking was successful
if [ $? -ne 0 ]; then
  echo -e "\n${RED}Linking error.${NC}\n"
  exit 4
fi

# Print success message
echo -e "\n${GREEN}Executable file [ ${YELLOW}${OUTPUT_FILE}.out ]${NC}\n"

# List content of current folder
ls -1pl
