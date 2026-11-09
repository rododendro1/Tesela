// swift-format-ignore-file
// Tabla de datos, una fila por línea: no se formatea.
// Los nombres de las progresiones del catálogo en catalán. Qué es cada campo, en `NombresDeProgresiones.swift`.

extension NombresDeProgresiones {
    static let catalan = NombresDeProgresiones([
        .init(.cadenciaPerfecta, "cadència perfecta"),
        .init(.cadenciaPlagal, "cadència plagal"),
        .init(.cadenciaRota, "cadència trencada"),
        .init(.semicadencia, "semicadència"),
        .init(.cadenciaFrigia, "cadència frígia"),
        .init(.cadenciaNapolitana, "cadència napolitana"),
        .init(.cadenciaConSextaAumentada, "cadència amb sisena augmentada", variantes: ["cadència amb sexta augmentada"]),
        .init(.quintasDescendentes, "progressió per cinquenes", alias: ["cercle de cinquenes"]),
        .init(.romanesca, "romanesca"),
        .init(.pachelbel, "cànon de Pachelbel"),
        .init(.monte, "monte"),
        .init(.fonte, "fonte"),
        .init(.ponte, "ponte"),
        .init(.doReMi, "do-re-mi"),
        .init(.folia, "fòlia"),
        .init(.bajoDeLamento, "baix de lament"),
        .init(.iiVI, "ii–V–I"),
        .init(.iiV, "ii–V"),
        .init(.iiVIMenor, "ii–V–i menor"),
        .init(.turnaround, "turnaround"),
        .init(.backdoor, "backdoor"),
        .init(.blues, "blues de 12 compassos"),
        .init(.bluesMenor, "blues menor"),
        .init(.rhythmChanges, "rhythm changes"),
        .init(.coltrane, "canvis de Coltrane"),
        .init(.ejePop, "I–V–vi–IV"),
        .init(.deLos50, "progressió dels anys 50"),
        .init(.eolica, "♭VI–♭VII–I"),
        .init(.andaluza, "cadència andalusa"),
    ])
}
