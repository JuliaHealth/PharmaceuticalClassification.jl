using PharmaceuticalClassification
using Documenter

makedocs(;
    modules=[PharmaceuticalClassification],
    authors="Dilum Aluthge, Brown Center for Biomedical Informatics, JuliaHealth organization, and contributors",
    repo="https://github.com/JuliaHealth/PharmaceuticalClassification.jl/blob/{commit}{path}#L{line}",
    sitename="PharmaceuticalClassification.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaHealth.github.io/PharmaceuticalClassification.jl",
        assets=String[],
    ),
    pages=[
        "Home"     => "index.md",
        "Examples" => "examples.md",
        "API"      => "api.md",
    ],
    strict = true,
)

deploydocs(;
    repo="github.com/JuliaHealth/PharmaceuticalClassification.jl",
)
