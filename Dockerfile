FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gpg \
    ca-certificates \
    make \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
    | gpg --dearmor \
    > /usr/share/keyrings/oneapi-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" \
    > /etc/apt/sources.list.d/oneAPI.list

RUN apt-get update && apt-get install -y \
    intel-oneapi-compiler-fortran \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-lc"]

WORKDIR /workspace

COPY requirements.txt /workspace/requirements.txt
RUN python3 -m pip install --upgrade pip setuptools wheel && \
    python3 -m pip install --break-system-packages -r /workspace/requirements.txt

COPY . /workspace

RUN source /opt/intel/oneapi/setvars.sh && \
    cd src && \
    make clean || true && \
    make fortran_compiler=ifx

CMD ["/bin/bash"]
