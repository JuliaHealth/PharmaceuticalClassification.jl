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

@inline function generate_synthetic_rxnsat(io::IO)::Nothing
    lines = String[
        "1234567||||||||NDC||12345678901|||",
        "1234567|||||A01BC23|||ATC_LEVEL|ATC|5|||",
        "1234567||||||||FAKE_ENTRY|||||",
    ]
    for line in lines
        println(io, line)
    end
    return nothing
end
