# rocm_mi308_vllm_docker
MI308 ROCm vllm inference dockerfile and poplular LLM models tuning files(.csv format)

```
  Dockerfile                 # Dockerfile

  tuned_gemm_csv/            # fp16/fp8 GEMM tuned files
```

tuning files(.csv format) suppot model:
| Model | DataType | TP |
|----------|----------|----------|
| Qwen2-7B| fp16/fp8 | 1 2 |
| Qwen2-72B| fp16/fp8 | 2 4 8 |
| Llama3-8B| fp16/fp8 | 1 2 |
| Llama3-70B| fp16/fp8 | 2 4 8 |
| Mixtral-8x7B| fp16/fp8 | 1 2 |
| Mixtral-8x22B| fp16/fp8 | 2 4 8 |

## Build docker images
```
docker build -f Dockerfile -t rocm_vllm:rocm6.3_mi308_ubuntu22.04_py3.10_vllm_0.6.4 .
```

## AI Software VERSION:
- Torch: 2.5.1+gitabbfe77
- vLLM: 
- - branch: moe_final_v0.6.0_Nov19
- - commit: 069647efd3117789cf032896ab52d0045e630eeb
- Triton:
- - branch: shared/triton-moe-opt
- - commit: 43ba7507f5386c4d5f2ceac4a3a9216f4b891ead
- flash-attn:
- - branch: main
- - commit: 7153673c1a3c7753c38e4c10ef2c98a02be5f778

## ROCm VERSION:
- rocm-dev VERSION: 6.3.1.60301-40~22.04
- rocm-device-libs VERSION: 1.0.0.60301-40~22.04
- rocm-libs VERSION: 6.3.1.60301-40~22.04
- hsa-rocr-dev VERSION: 1.14.0.60301-40~22.04
- hip VERSION: 6.3.42131
- hsa-runtime64 VERSION: 1.14.60301
- amd_comgr VERSION: 2.8.0
- rocrand VERSION: 3.2.0
- hiprand VERSION: 2.11.0
- rocblas VERSION: 4.3.0
- hipblas VERSION: 2.3.0
- hipblaslt VERSION: 0.10.0
- miopen VERSION: 3.3.0
- hipfft VERSION: 1.0.17
- hipsparse VERSION: 3.1.2
- rccl VERSION: 2.21.5
- rocprim VERSION: 3.3.0
- hipcub VERSION: 3.3.0
- rocthrust VERSION: 3.3.0
- hipsolver VERSION: 2.3.0
- hiprtc VERSION: 6.3.42131