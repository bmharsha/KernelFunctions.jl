module KernelFunctions

export kernelmatrix, kernelmatrix!, kerneldiagmatrix, kerneldiagmatrix!, kappa # Main matrix functions
export params, duplicate, set! # Helpers

export Kernel
export ConstantKernel, WhiteKernel, ZeroKernel
export SqExponentialKernel, ExponentialKernel, GammaExponentialKernel
export ExponentiatedKernel
export MaternKernel, Matern32Kernel, Matern52Kernel
export LinearKernel, PolynomialKernel
export RationalQuadraticKernel, GammaRationalQuadraticKernel
export KernelSum, KernelProduct

export Transform, SelectTransform, ChainTransform, ScaleTransform, LowRankTransform, IdentityTransform, FunctionTransform

export NystromFact, nystrom

using Compat
using Requires
using Distances, LinearAlgebra
using SpecialFunctions: logabsgamma, besselk
using ZygoteRules: @adjoint
using StatsFuns: logtwo
using StatsBase

const defaultobs = 2

"""
Abstract type defining a slice-wise transformation on an input matrix
"""
abstract type Transform end
abstract type Kernel{Tr<:Transform} end

include("utils.jl")
include("distances/dotproduct.jl")
include("distances/delta.jl")
include("transform/transform.jl")

for k in ["exponential","matern","polynomial","constant","rationalquad","exponentiated"]
    include(joinpath("kernels",k*".jl"))
end
include("matrix/kernelmatrix.jl")
include("kernels/kernelsum.jl")
include("kernels/kernelproduct.jl")
include("approximations/nystrom.jl")

include("generic.jl")

include("zygote_adjoints.jl")

function __init__()
    @require Kronecker="2c470bb0-bcc8-11e8-3dad-c9649493f05e" include("matrix/kernelkroneckermat.jl")
    @require PDMats="90014a1f-27ba-587c-ab20-58faa44d9150" include("matrix/kernelpdmat.jl")
end

end
