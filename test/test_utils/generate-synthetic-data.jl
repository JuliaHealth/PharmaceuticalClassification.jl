@inline function generate_synthetic_rxnrel(io::IO)::Nothing
    lines = String[
        "123:456||CUI||789||CUI|has_ingredient|||RXNORM||||||",
        "456||CUI||789||CUI|has_ingredient|||RXNORM||||||",
        "123:456||CUI||789||CUI|consists_of|||RXNORM||||||",
        "456||CUI||789||CUI|consists_of|||RXNORM||||||",
    ]
    for line in lines
        println(io, line)
    end
    return nothing
end

@inline function generate_synthetic_rxnsat(io::IO)::Nothing
    lines = String[
        "1234567||||||||NDC||12345678901|||",
        "1234567|||||A01BC23|||ATC_LEVEL|ATC|5|||",
        "1234567|||||A01BC|||ATC_LEVEL|ATC|4|||",
        "1234567|||||A01B|||ATC_LEVEL|ATC|3|||",
        "1234567|||||A01|||ATC_LEVEL|ATC|2|||",
        "1234567|||||A|||ATC_LEVEL|ATC|1|||",
        "1234567||||||||FAKE_ENTRY|||||",
    ]
    for line in lines
        println(io, line)
    end
    return nothing
end
