import Testing

@testable import Elementos
@testable import Teoria

/// La armonía negativa, la disposición por cuartas y la armonía modal.
@Suite struct NegativaYModalTests {
    // MARK: Armonía negativa

    @Test func notasNegativas() {
        let doMayor = Tonalidad(.do)
        #expect(doMayor.negativa(.do) == .sol)
        #expect(doMayor.negativa(.sol) == .do)
        #expect(doMayor.negativa(.mi) == Nota.mi.bemol)
        #expect(doMayor.negativa(.si) == Nota.la.bemol)
        #expect(doMayor.negativa(.re) == .fa)
        #expect(doMayor.negativa(.la) == Nota.si.bemol)
        // Reflejar dos veces deja la nota como estaba, y el eje no depende del modo.
        for nota in [Nota.do, .re, .mi, .fa, .sol, .la, .si, Nota.fa.sostenido] {
            #expect(doMayor.negativa(doMayor.negativa(nota)) == nota)
            #expect(Tonalidad(.do, .menor).negativa(nota) == doMayor.negativa(nota))
        }
        #expect(Tonalidad(.re).negativa(.re) == .la)
        #expect(Tonalidad(.re).negativa(Nota.fa.sostenido) == .fa)
    }

    @Test func acordesNegativos() {
        let doMayor = Tonalidad(.do)
        #expect(doMayor.negativo(Acorde("Do")) == Acorde("Dom"))
        #expect(doMayor.negativo(Acorde("Fa")) == Acorde("Solm"))
        #expect(doMayor.negativo(Acorde("Lam")) == Acorde(Nota.mi.bemol, .mayor))
        let dominante = doMayor.negativo(Acorde("Sol7"))
        #expect(Set(dominante?.notas ?? []) == [.do, .re, .fa, Nota.la.bemol])
        #expect(dominante?.inversion == 0)
        #expect(doMayor.negativos([Acorde("Do"), Acorde("Fa")]) == [Acorde("Dom"), Acorde("Solm")])
    }

    // MARK: Disposición por cuartas

    @Test func disposicionCuartal() {
        func formas(_ cifrado: String) -> [[Nota]] {
            Acorde(stringLiteral: cifrado).formas(.cuartal).map { $0.map(\.nota) }
        }
        // Rem7 en Re dórico: Re Sol Do Fa, Sol Do Fa Si y Do Fa Si Mi.
        #expect(formas("Rem7") == [[.re, .sol, .do, .fa], [.sol, .do, .fa, .si], [.do, .fa, .si, .mi]])
        #expect(formas("Sol7") == [[.fa, .si, .mi, .la]])
        // Por cuartas de verdad: cada voz, cinco o seis semitonos sobre la anterior.
        for cifrado in ["Rem7", "Sol7", "Do7M", "Do", "Lam7"] {
            for forma in Acorde(stringLiteral: cifrado).formas(.cuartal) {
                #expect(zip(forma, forma.dropFirst()).allSatisfy { [5, 6].contains($1.midi - $0.midi) }, "\(cifrado)")
            }
            #expect(!Acorde(stringLiteral: cifrado).disposiciones(.cuartal).isEmpty, "\(cifrado)")
        }
        #expect(DisposicionDeAcorde.cuartal.voces == 4)
        #expect(DisposicionDeAcorde.cuartal.conducir([Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")])?.count == 3)
    }

    // MARK: Armonía modal

    @Test func notaCaracteristica() {
        #expect(Escala(.re, .dorico).modoDeLaMayor == 2)
        #expect(Escala(.do, .mayor).modoDeLaMayor == 1)
        #expect(Escala(.la, .menorArmonica).modoDeLaMayor == nil)
        #expect(Escala(.re, .dorico).notaCaracteristica == .si)
        #expect(Escala(.mi, .frigio).notaCaracteristica == .fa)
        #expect(Escala(.fa, .lidio).notaCaracteristica == .si)
        #expect(Escala(.sol, .mixolidio).notaCaracteristica == .fa)
        #expect(Escala(.la, .menorNatural).notaCaracteristica == .fa)
        #expect(Escala(.si, .locrio).notaCaracteristica == .fa)
        #expect(Escala(.do, .mayor).notaCaracteristica == .si)
        #expect(Escala(.do, .blues).notaCaracteristica == nil)
    }

    @Test func acordesYCadenciasModales() {
        #expect(Escala(.re, .dorico).acordesCaracteristicos == [Acorde("Mim"), Acorde("Sol")])
        #expect(Escala(.re, .dorico).cadenciaModal == [Acorde("Sol"), Acorde("Rem")])
        #expect(Escala(.mi, .frigio).cadenciaModal == [Acorde("Fa"), Acorde("Mim")])
        #expect(Escala(.do, .lidio).cadenciaModal == [Acorde("Re"), Acorde("Do")])
        #expect(Escala(.sol, .mixolidio).cadenciaModal == [Acorde("Fa"), Acorde("Sol")])
        #expect(Escala(.la, .menorNatural).cadenciaModal == [Acorde("Fa"), Acorde("Lam")])
        #expect(Escala(.do, .mayor).cadenciaModal == [Acorde("Sol"), Acorde("Do")])
        #expect(Escala(.do, .blues).cadenciaModal == nil)
        #expect(Escala(.do, .blues).acordesCaracteristicos.isEmpty)
        // La característica está en cada acorde característico.
        for tipo in [TipoDeEscala.mayor, .dorico, .frigio, .lidio, .mixolidio, .menorNatural, .locrio] {
            let escala = Escala(.do, tipo)
            let nota = escala.notaCaracteristica
            #expect(nota != nil)
            #expect(escala.acordesCaracteristicos.allSatisfy { $0.notas.contains(nota!) })
            #expect(!escala.acordesCaracteristicos.isEmpty, "\(tipo)")
        }
    }
}
