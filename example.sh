#!/bin/bash
# Define input and output directories
INPUT_DIR="/root/input"
OUTPUT_DIR="/root/output"
# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"
# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: ffmpeg is not installed. Please install it and try again."
    exit 1
fi
# Loop through all video files in the input directory
for input_file in "$INPUT_DIR"/*; do
    # Get the base filename without the directory
    filename=$(basename "$input_file")
    # Define the output file path
    output_file="$OUTPUT_DIR/${filename%.*}_hq.mp4"
    # Process the video using ffmpeg with NVIDIA GPU acceleration
    echo "Processing: $input_file"
    ffmpeg -hide_banner -loglevel error -i "$input_file" \
           -vf "scale=1920:1080" \
           -c:v hevc_nvenc \
           -preset slow \
           -profile:v main10 \
           -pix_fmt p010le \
           -b:v 0 \
           -rc vbr \
           -cq 18 \
           -rc-lookahead 32 \
           -spatial-aq 1 \
           -temporal-aq 1 \
           -c:a aac \
           -b:a 192k \
           -movflags +faststart \
           -stats \
           "$output_file"
    if [ $? -eq 0 ]; then
        echo "Processed: $input_file -> $output_file"
    else
        echo "Error processing: $input_file"
    fi
done
echo "All videos processed successfully!"
