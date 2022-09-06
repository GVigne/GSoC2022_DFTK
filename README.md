# GSoC2022_DFTK
GSoC 2022 - GPU programming for DFTK.jl, a density functional theory package in Julia. 

This project is part of [Google Summer of Code 2022](https://summerofcode.withgoogle.com/programs/2022/projects/GSUS0kxC).

Student: Guillaume Vigne

Mentors: Valentin Churavy, Michael Herbst, Antoine Levitt

A blog post summarizing my experience during the GSoC is available on Julia Forem [here](https://forem.julialang.org/guillaumevigne/gpu-programming-in-dftkjl-gsoc-2022-123k).

## Main pull requests
Main PR implementing GPU compatibility for the LOPBCG algorithm used in DFTK:
JuliaMolSim/DFTK.jl/pull/711

Main PR for implementing GPU compatibility for the other computations done in DFTK:
JuliaMolSim/DFTK.jl/pull/712

Mid-term draft PR:
JuliaMolSim/DFTK.jl/pull/697

From an end-user perpective, one can simply offload computations to the GPU by using the `array_type` argument when building the plane-wave basis. The rest of the code doesn't change for end-users. You can see an example [here](https://github.com/GVigne/DFTK.jl/blob/gpu_hpc/examples/gpu.jl).

## Issues encountered in DFTK
DFTK timer and multithreading issues:
JuliaMolSim/DFTK.jl/issues/718

LOBPCG fails unexpectedly because of NaNs in the arrays considered:
JuliaMolSim/DFTK.jl/pull/710

## Issues encountered with the GPU API in Julia
[Issue created](https://github.com/JuliaGPU/CUDA.jl/issues/1557) in CUDA.jl when encoutering scalar indexing with the identity matrix, followed by a PR implementing `iszero` and `isone` in GPUArrays.jl
https://github.com/JuliaGPU/GPUArrays.jl/pull/419

PR fixing `\` operator bug when using QR decomposition and rectangular matrices in CUDA.jl
https://github.com/JuliaGPU/CUDA.jl/pull/1584

3-argument `dot` operation in CUDA.jl. A workaround is implemented in DFTK, but it stores in memory the intermediate results.
https://github.com/JuliaGPU/CUDA.jl/issues/1565

Generalized `eigen` function in CUDA.jl. A workaround is implemented in DFTK, although only for `Hermitian` structures.
https://github.com/JuliaGPU/CUDA.jl/issues/1572


## Miscellaneous
GPU compatibility for the BlockArray structure:
JuliaArrays/BlockArrays.jl/issues/215

Discussion about the way to extract the base type of an array:
https://github.com/JuliaLang/julia/pull/46213
