function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    isdefined(Logging, Symbol("##handle_message#2")) && precompile(Tuple{getfield(Logging, Symbol("##handle_message#2")), Nothing, Base.Iterators.Pairs{Union{}, Union{}, Tuple{}, NamedTuple{(), Tuple{}}}, typeof(Base.CoreLogging.handle_message), Logging.ConsoleLogger, Base.CoreLogging.LogLevel, String, Module, String, Symbol, String, Int64})
    isdefined(Logging, Symbol("##handle_message#2")) && precompile(Tuple{getfield(Logging, Symbol("##handle_message#2")), Nothing, Base.Iterators.Pairs{Union{}, Union{}, Tuple{}, NamedTuple{(), Tuple{}}}, typeof(Base.CoreLogging.handle_message), Logging.ConsoleLogger, Base.CoreLogging.LogLevel, String, Nothing, Nothing, Symbol, Nothing, Int64})
end
