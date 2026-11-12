# ``Armonia``

Motor de armonía tonal en Swift, con la API en español.

## Overview

Todo se apoya en un mismo sistema de coordenadas —la **línea de quintas** y el **plano quintas ×
octavas**—, que conserva la ortografía de las notas (Fa♯ ≠ Sol♭, 4ª aumentada ≠ 5ª disminuida)
y reduce casi todas las operaciones a sumas de enteros.

```swift
import Armonia

Acorde("Sol7/Si").posicionCerrada(octava: 3)   // [Si3, Re4, Fa4, Sol4]
Escala("La menor armónica").cifradosRomanos(cuatriadas: true)
Tonalidad.identificar(midi: [69, 71, 72, 74, 76, 77, 80, 81]).first   // La menor
```

## Topics

### Artículos

- <doc:ElModelo>
- <doc:Acordes>
- <doc:Escalas>
- <doc:EscalasDelMundo>
- <doc:Tonalidad>
- <doc:NotacionYPartitura>
- <doc:MelodiaYRitmo>
- <doc:AfinacionYRepresentaciones>
- <doc:Trastes>
- <doc:Postonal>
- <doc:Convenciones>

### Fundamentos

- ``Nota``
- ``Alteracion``
- ``Tipografia``
- ``Altura``
- ``VentanaDeQuintas``
- ``Intervalo``
- ``Candidato``

### Acordes y escalas

- ``Acorde``
- ``TipoDeAcorde``
- ``AcordeConNombre``
- ``CardinalDeAcorde``
- ``EstadisticasDeAcorde``
- ``EstadisticasDeConjunto``
- ``RelacionEntreConjuntos``
- ``RelacionDeForte``
- ``RelacionEntreAcordes``
- ``AjusteTonal``
- ``EstadisticasDeAfinacionJusta``
- ``PsicoacusticaDeAcorde``
- ``DisposicionDeVoces``
- ``GrupoDeHindemith``
- ``ProminenciaDeFundamental``
- ``TriadasContenidas``
- ``DisposicionDeAcorde``
- ``Escala``
- ``TipoDeEscala``
- ``ModoGregoriano``
- ``ManoGuidoniana``
- ``SecuenciaDeEscala``
- ``CambioDeGrado``
- ``EscalaBebop``
- ``PentatonicaSobreElAcorde``
- ``Mano``
- ``DigitacionDePiano``
- ``TecladoDePiano``
- ``RelojDeClasesDeAltura``
- ``RelojDeAlturas``
- ``CicloSimetrico``
- ``Tetracordo``
- ``DivisionEnTetracordos``
- ``TetracordoDelSistemaPerfecto``
- ``FragmentoDeLaEscala``
- ``CakraDeMela``
- ``InicioDeNotasGuia``
- ``EscalaVecina``
- ``EscaleraDeBrillo``
- ``CardinalDeEscala``
- ``Epoca``
- ``Lugar``
- ``Continente``
- ``Pais``
- ``PeriodoMusical``
- ``EstadisticasDeEscala``
- ``IntervalosGenericosDeEscala``
- ``EstadisticasTonalesDeEscala``
- ``PsicoacusticaDeEscala``
- ``PropiedadDeRothenberg``
- ``CombinatoriedadHexacordal``
- ``RelacionEntreEscalas``
- ``Tonalidad``
- ``AnalisisArmonico``
- ``EstadisticasDeProgresion``
- ``TensionDeLerdahl``
- ``Cadencia``
- ``EsquemaArmonico``
- ``ProgresionConNombre``
- ``RecorridoTonal``
- ``Coral``
- ``Armonizacion``
- ``CoralArmonizado``
- ``NotaDeLaMelodia``
- ``NotaExtranaEnLaMelodia``
- ``NotaExtrana``
- ``Contrapunto``
- ``FaltaDeContrapunto``
- ``ContrapuntoAVariasVoces``
- ``FaltaEntreVoces``

### Mástil y digitaciones

- ``Encordado``
- ``Mastil``
- ``PosicionEnElMastil``
- ``Digitacion``
- ``ArpegioEnElMastil``
- ``EscalaEnElMastil``
- ``FormaCAGED``

### Ritmo

- ``Duracion``
- ``FiguraConPuntillos``
- ``Compas``
- ``Tempo``
- ``RitmoArmonico``
- ``AcordeConDuracion``
- ``AcordeConInicio``
- ``Voz``
- ``Frase``
- ``MotivoMelodico``
- ``Swing``
- ``Polirritmia``
- ``RitmoConNombre``
- ``FamiliaDeRitmo``
- ``GolpeDeRitmo``
- ``EstadisticasDeRitmo``

### Exportación

- ``FormatoDePartitura``
- ``SignoMicrotonal``

### Importación

- ``PiezaImportada``
- ``NotaDeLaPieza``
- ``ErrorDeLecturaDeFichero``

### Errores

- ``ErrorDeArmonia``
- ``ErrorAlLeer``
- ``MotivoDeLectura``
- ``ErrorDeLectura``
- ``ErrorDeLecturaDeTeoria``
- ``ErrorDeLecturaDePartitura``
- ``ErrorDeLecturaDeUIL``
