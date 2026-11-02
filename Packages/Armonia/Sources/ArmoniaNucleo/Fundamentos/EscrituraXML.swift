/// Lo que comparten los formatos de texto que escribe el motor (SVG, MusicXML, MEI) y los que escriben las apps.
public enum EscrituraXML {
    /// El texto con `&`, `<`, `>` y `"` escritos como entidades, para ponerlo en XML, dentro de una etiqueta o en
    /// el valor de un atributo: `EscrituraXML.escapar("Do \"mayor\" & <Mi>")` es
    /// «Do &quot;mayor&quot; &amp; &lt;Mi&gt;».
    public static func escapar(_ texto: String) -> String {
        var resultado = ""
        resultado.reserveCapacity(texto.utf8.count)
        for caracter in texto {
            switch caracter {
            case "&": resultado += "&amp;"
            case "<": resultado += "&lt;"
            case ">": resultado += "&gt;"
            case "\"": resultado += "&quot;"
            default: resultado.append(caracter)
            }
        }
        return resultado
    }
}
