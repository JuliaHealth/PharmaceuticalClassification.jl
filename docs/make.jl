using PharmaceuticalClassification
using Documenter

makedocs(;
    modules=[PharmaceuticalClassification],
    authors="Dilum Aluthge",
    repo="https://github.com/JuliaHealth/PharmaceuticalClassification.jl/blob/{commit}{path}#L{line}",
    sitename="PharmaceuticalClassification.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaHealth.github.io/PharmaceuticalClassification.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaHealth/PharmaceuticalClassification.jl",
)
