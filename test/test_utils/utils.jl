@inline function in_temporary_directory(f::Function)::Nothing
    original_directory = pwd()
    temporary_directory = mktempdir(; cleanup = true)
    atexit(() -> rm(temporary_directory; force = true, recursive = true))
    cd(temporary_directory)
    f()
    cd(original_directory)
    rm(temporary_directory; force = true, recursive = true)
    return nothing
end
