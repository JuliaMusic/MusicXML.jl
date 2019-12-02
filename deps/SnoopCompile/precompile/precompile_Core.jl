function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    precompile(Tuple{typeof(Core.throw_inexacterror), Symbol, Type{Int16}, UInt32})
    precompile(Tuple{typeof(Core.throw_inexacterror), Symbol, Type{Int8}, UInt32})
    precompile(Tuple{typeof(Core.Compiler.zero), Type{Int16}})
    precompile(Tuple{typeof(Core.Compiler.zero), Type{UInt8}})
    precompile(Tuple{typeof(Core.Compiler.zero), Type{Int8}})
end
