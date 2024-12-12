##BASE IMAGE:
ARG BASE_IMAGE="rocm/pytorch:rocm6.3_ubuntu22.04_py3.10_pytorch_release_2.5.0_preview"

FROM ${BASE_IMAGE} as BASE
USER root

RUN mkdir /app
ARG COMMON_WORKDIR=/app/
WORKDIR ${COMMON_WORKDIR}

COPY ./Dockerfile ${COMMON_WORKDIR}
COPY ./tuned_gemm_csv ${COMMON_WORKDIR}/tuned_gemm_csv

RUN pip install text_generation==0.7.0 simple_parsing==0.1.5 dashscope==1.18.0 loguru==0.7.2 prettytable==3.10.0  modelscope matplotlib jsonschema cloudpickle


ARG ARG_PYTORCH_ROCM_ARCH="gfx942"
ENV PYTORCH_ROCM_ARCH=${ARG_PYTORCH_ROCM_ARCH}

WORKDIR ${COMMON_WORKDIR}

ARG TRITON_REPO="https://github.com/ROCm/triton.git"
ARG TRITON_BRANCH="shared/triton-moe-opt"
RUN pip uninstall -y triton \
    && [ ! -d "triton" ] || rm -rf triton \
    && git clone ${TRITON_REPO} \
    && cd triton \
    && git checkout ${TRITON_BRANCH} \
    && cd python \
    && pip install .

ARG FA_REPO="https://github.com/ROCm/flash-attention.git"
ARG FA_COMMIT="7153673c1a3c7753c38e4c10ef2c98a02be5f778"
RUN pip uninstall -y flash-attn \
    && [ ! -d "flash-attention" ] || rm -rf flash-attention \
    && git clone ${FA_REPO} \
    && cd flash-attention \
    && git checkout ${FA_COMMIT} \
    && git submodule update --init \
    && MAX_JOBS=64 GPU_ARCHS=${PYTORCH_ROCM_ARCH} python setup.py install

ARG VLLM_REPO="https://github.com/ROCm/vllm.git"
ARG VLLM_BRANCH="moe_final_v0.6.0_Nov19"
ARG REPO_NAME="rocm_vllm"
RUN pip uninstall -y vllm \
    && git clone ${VLLM_REPO} ${REPO_NAME}\
    && cd ${REPO_NAME} \
    && git checkout ${VLLM_BRANCH} \
    && pip install -r requirements-rocm.txt \
    && python3 setup.py develop \
    && python3 setup_cython.py build_ext --inplace

ENV TORCH_BLAS_PREFER_HIPBLASLT=1
ENV VLLM_USE_ROCM_CUSTOM_PAGED_ATTN=1
ENV HIP_FORCE_DEV_KERNARG=1
ENV VLLM_USE_TRITON_FLASH_ATTN=0
ENV PYTORCH_TUNABLEOP_FILENAME=/app/tuned_gemm_csv/afo_tune_device_%d_full.csv
ENV PYTORCH_TUNABLEOP_TUNING=0
ENV PYTORCH_TUNABLEOP_ENABLED=0
# ENV FUSED_MOE_PERSISTENT=1
# ENV VLLM_MOE_PADDING=128
# ENV VLLM_MOE_SHUFFLE=1
# ENV TRITON_HIP_USE_NEW_STREAM_PIPELINE=1
# ENV VLLM_SCHED_PREFILL_COUNT=0
# ENV HIP_VISISBLE_DEVICES=0,1,2,3,4,5,6,7
