// El módulo `Armonia` no tiene código propio: reexporta los de cada capa y de cada familia, de modo que
// `import Armonia` da la API de siempre. Quien solo necesite una capa puede importarla sola
// (`import Teoria` trae los Elementos, de que depende, pero no las Partituras ni los Diagramas;
// `import Formatos`, las Partituras con sus formatos de fichero).

@_exported import Diagramas
@_exported import Elementos
@_exported import Formatos
@_exported import Partituras
@_exported import Polifonia
@_exported import Teoria
@_exported import Trastes
