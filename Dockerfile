# Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM quay.io/pangeo/pytorch-notebook:2025.01.24

# Update pip and setuptools
RUN python -m pip install --upgrade pip setuptools 
RUN python -m pip install jupyterlab-nvidia-nsight

COPY apt.txt /tmp/apt.txt

USER root

RUN apt-get update && \
    xargs -a /tmp/apt.txt apt install -y && \
    apt-get autoremove -y && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm /tmp/apt.txt

USER ${NB_USER}

RUN git lfs install
RUN python -m pip install torchviz


SHELL ["/bin/bash", "-c"]

RUN python -m pip install "zarr[gpu] @ git+https://github.com/akshaysubr/zarr-python.git"


ENV _CUDA_COMPAT_TIMEOUT=90
