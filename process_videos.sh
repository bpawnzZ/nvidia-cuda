#!/bin/bash

# Define input and output directories
INPUT_DIR="/root/input"
OUTPUT_DIR="/root/output"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through all video files in the input directory
for input_file in "$INPUT_DIR"/*; do
    # Get the base filename without the directory
    filename=$(basename "$input_file")
    
    # Define the output file path
    output_file="$OUTPUT_DIR/${filename%.*}_1080p.mp4"
    
    # Process the video using ffmpeg with NVIDIA GPU acceleration
    echo "Processing: $input_file"
    ffmpeg -hide_banner -loglevel error -i "$input_file" \
           -vf "scale=1920:1080" \
           -c:v hevc_nvenc \
           -preset slow \
           -profile:v main10 \
           -pix_fmt p010le \
           -b:v 2125k \
           -maxrate 2500k \
           -bufsize 4250k \
           -rc vbr_hq \
           -rc-lookahead 32 \
           -spatial-aq 1 \
           -temporal-aq 1 \
           -cq 23 \
           -c:a aac \
           -b:a 128k \
           -movflags +faststart \
           "$output_file"
    
    echo "Processed: $input_file -> $output_file"
done

echo "All videos processed successfully!"
