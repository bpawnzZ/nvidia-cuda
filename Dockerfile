FROM nvidia/cuda:12.2.2-devel-ubuntu22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libswscale-dev \
    libavfilter-dev \
    libx264-dev \
    libx265-dev \
    libnuma-dev \
    libvpx-dev \
    libfdk-aac-dev \
    libmp3lame-dev \
    libopus-dev \
    libass-dev \
    libssl-dev \
    pkg-config \
    yasm \
    nasm \
    libtool \
    autoconf \
    automake \
    libva-dev \
    libvdpau-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    libxcb-shape0-dev \
    libxcb1-dev \
    libx11-dev \
    libxv-dev \
    libxext-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install FFmpeg with NVIDIA support
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Install NVIDIA NPP library from CUDA toolkit
RUN apt-get update && apt-get install -y \
    libnpp-12-2 \
    libnpp-dev-12-2 \
    && rm -rf /var/lib/apt/lists/*

# Verify FFmpeg installation with NVIDIA support
RUN ffmpeg -version && \
    ffmpeg -hwaccels | grep cuda && \
    ffmpeg -codecs | grep nvenc

# Create working directories
RUN mkdir -p /root/input /root/output

# Set working directory
WORKDIR /root

# Copy processing script
COPY process_videos.sh /root/process_videos.sh
RUN chmod +x /root/process_videos.sh

# Default command
CMD ["/root/process_videos.sh"]
