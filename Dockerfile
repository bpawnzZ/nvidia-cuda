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
    && rm -rf /var/lib/apt/lists/*

# Install FFmpeg with NVIDIA support
RUN git clone https://git.ffmpeg.org/ffmpeg.git /tmp/ffmpeg && \
    cd /tmp/ffmpeg && \
    ./configure \
        --enable-nonfree \
        --enable-cuda-nvcc \
        --enable-libnpp \
        --enable-gpl \
        --enable-libx264 \
        --enable-libx265 \
        --enable-libfdk-aac \
        --enable-libmp3lame \
        --enable-libopus \
        --enable-libvpx \
        --enable-libass \
        --enable-nvenc \
        --enable-cuvid \
        --extra-cflags=-I/usr/local/cuda/include \
        --extra-ldflags=-L/usr/local/cuda/lib64 && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    rm -rf /tmp/ffmpeg

# Create working directories
RUN mkdir -p /root/input /root/output

# Set working directory
WORKDIR /root

# Copy processing script
COPY process_videos.sh /root/process_videos.sh
RUN chmod +x /root/process_videos.sh

# Default command
CMD ["/root/process_videos.sh"]
