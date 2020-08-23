@inline function countlines_filename(filename::AbstractString)
    num_lines = open(filename, "r") do io
        return countlines(io)
    end
    return num_lines
end
