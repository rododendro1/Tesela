import ArmoniaNucleo

extension TipoDeEscala {
    /// Nombre en español ("dórico"), inglés ("dorian"), catalán ("dòric"), gallego ("dórico"),
    /// euskera ("doriarra"), portugués ("dórico"), francés ("dorien"), italiano ("dorico"), alemán
    /// ("dorisch"), occitano ("dorian"), ruso ("дорийский"), griego ("δώριος"), aragonés ("dórico") o
    /// asturiano ("dóricu"). Un tipo
    /// sin nombre conocido en ese idioma (como un modo de una escala propia) usa su nombre español.
    public func nombre(en notacion: Notacion) -> String {
        // El español es el del propio tipo (un tipo propio puede coincidir en intervalos con uno del catálogo).
        if notacion.textos == .espanol { return nombre }
        // Los nombres propios de otras tradiciones (Kafi, Hitzaz…) son los mismos en todos los idiomas, salvo
        // los que se traducen (las escalas andinas, los tetracordos…): se buscan por su nombre, no por el tipo.
        return NombresDeEscalas.de(notacion.textos).nombre(de: self) ?? nombre
    }
}
