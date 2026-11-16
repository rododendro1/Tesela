import Elementos

// MARK: - El catálogo de ritmos
//
// Los ritmos con nombre: las líneas de tiempo del Caribe y del África occidental, los compases del flamenco, los tāla
// de la India, los iqa'at árabes, los aksak de los Balcanes y los usul turcos, los modos rítmicos de Notre Dame y unas
// danzas. Cada uno con su patrón en notación de caja, su agrupación, la figura de su pulso y la obra donde se lee. Los
// nombres en los otros idiomas están en `Ritmos/Nombres/`.

extension RitmoConNombre {
    // MARK: Líneas de tiempo

    /// Tres golpes en ocho pulsos, 3 + 3 + 2: el ritmo euclídeo E(3, 8), base del son, la habanera y el baião.
    public static let tresillo = RitmoConNombre(
        nombre: "tresillo", patron: "x..x..x.", agrupacion: [2, 2, 2, 2], unidad: 8, familia: .lineaDeTiempo,
        referencias: [.toussaint2013], lugares: [.pais(.cuba)])
    /// Cinco golpes en ocho pulsos, el ritmo del danzón: E(5, 8), girado.
    public static let cinquillo = RitmoConNombre(
        nombre: "cinquillo", patron: "x.xx.xx.", agrupacion: [2, 2, 2, 2], unidad: 8, familia: .lineaDeTiempo,
        referencias: [.toussaint2013], lugares: [.pais(.cuba)])
    /// El tresillo con un golpe más en el cuarto tiempo: el ritmo de la habanera y del tango.
    public static let habanera = RitmoConNombre(
        nombre: "habanera", patron: "x..xx.x.", agrupacion: [2, 2, 2, 2], unidad: 8, familia: .lineaDeTiempo,
        estilos: [.clasica], referencias: [.toussaint2013], lugares: [.pais(.cuba)])
    /// La clave 3-2 del son cubano: tres golpes en el primer compás y dos en el segundo.
    public static let claveDeSon = RitmoConNombre(
        nombre: "clave de son", patron: "x..x..x...x.x...", agrupacion: [4, 4, 4, 4], unidad: 16,
        familia: .lineaDeTiempo, alias: ["clave 3-2"], referencias: [.toussaint2013], lugares: [.pais(.cuba)])
    /// La clave de son empezada por su segundo compás: dos golpes y luego tres.
    public static let claveDeSonDosTres = RitmoConNombre(
        nombre: "clave de son 2-3", patron: "..x.x...x..x..x.", agrupacion: [4, 4, 4, 4], unidad: 16,
        familia: .lineaDeTiempo, alias: ["clave 2-3"], referencias: [.toussaint2013], lugares: [.pais(.cuba)])
    /// La clave de la rumba: la de son con el tercer golpe un pulso más tarde.
    public static let claveDeRumba = RitmoConNombre(
        nombre: "clave de rumba", patron: "x..x...x..x.x...", agrupacion: [4, 4, 4, 4], unidad: 16,
        familia: .lineaDeTiempo, referencias: [.toussaint2013], lugares: [.pais(.cuba)])
    /// La clave de la bossa nova: la de son con el último golpe un pulso más tarde. De 1958, el año de «Chega de
    /// saudade» de João Gilberto.
    public static let bossaNova = RitmoConNombre(
        nombre: "bossa nova", patron: "x..x..x...x..x..", agrupacion: [4, 4, 4, 4], unidad: 16, familia: .lineaDeTiempo,
        estilos: [.jazz], referencias: [.toussaint2013], anio: 1958, lugares: [.pais(.brasil)])
    /// La línea de tiempo del soukous congoleño, una de las seis claves de Toussaint.
    public static let soukous = RitmoConNombre(
        nombre: "soukous", patron: "x..x..x...xx....", agrupacion: [4, 4, 4, 4], unidad: 16, familia: .lineaDeTiempo,
        referencias: [.toussaint2013], tradicion: .africa, lugares: [.pais(.congo)])
    /// La línea de tiempo shiko de Nigeria, la más regular de las seis claves de Toussaint.
    public static let shiko = RitmoConNombre(
        nombre: "shiko", patron: "x...x.x...x.x...", agrupacion: [4, 4, 4, 4], unidad: 16, familia: .lineaDeTiempo,
        referencias: [.toussaint2013], tradicion: .africa, lugares: [.pais(.nigeria)])
    /// La línea de tiempo del gahu, la danza de los ewe de Ghana.
    public static let gahu = RitmoConNombre(
        nombre: "gahu", patron: "x..x..x...x...x.", agrupacion: [4, 4, 4, 4], unidad: 16, familia: .lineaDeTiempo,
        referencias: [.toussaint2013], tradicion: .africa, lugares: [.pais(.ghana)])
    /// El patrón estándar de doce pulsos del África occidental y de la santería cubana: E(7, 12), girado.
    public static let bembe = RitmoConNombre(
        nombre: "bembé", patron: "x.x.xx.x.x.x", agrupacion: [3, 3, 3, 3], unidad: 8, familia: .lineaDeTiempo,
        alias: ["patrón estándar"], referencias: [.toussaint2013], tradicion: .africa,
        lugares: [.pais(.ghana), .pais(.nigeria), .pais(.cuba)])
    /// Las palmas de los venda de Sudáfrica: E(5, 12), el ritmo euclídeo de cinco golpes en doce pulsos.
    public static let palmasVenda = RitmoConNombre(
        nombre: "palmas venda", patron: "x..x.x..x.x.", agrupacion: [3, 3, 3, 3], unidad: 8, familia: .lineaDeTiempo,
        referencias: [.toussaint2005, .toussaint2013], tradicion: .africa, lugares: [.pais(.sudafrica)])
    /// La línea de tiempo fume-fume de Ghana: cinco golpes del patrón estándar, E(5, 12) girado.
    public static let fumeFume = RitmoConNombre(
        nombre: "fume-fume", patron: "x.x.x..x.x..", agrupacion: [3, 3, 3, 3], unidad: 8, familia: .lineaDeTiempo,
        referencias: [.toussaint2013], tradicion: .africa, lugares: [.pais(.ghana)])
    /// El collar de la samba brasileña: E(7, 16), siete golpes en dieciséis pulsos.
    public static let samba = RitmoConNombre(
        nombre: "samba", patron: "x..x.x.x..x.x.x.", agrupacion: [4, 4, 4, 4], unidad: 16, familia: .lineaDeTiempo,
        referencias: [.toussaint2005], lugares: [.pais(.brasil)])
    // MARK: Flamenco

    /// El compás de doce tiempos de la soleá, con los acentos en el 3, el 6, el 8, el 10 y el 12.
    public static let solea = RitmoConNombre(
        nombre: "soleá", patron: "ooxooxoxoxox", agrupacion: [3, 3, 2, 2, 2], unidad: 8, familia: .flamenco,
        alias: ["soleares"], estilos: [.flamenco], referencias: [.fernandez2004], lugares: [.region(.andalucia)])
    /// El compás de la bulería: el de la soleá contado desde el 12.
    public static let buleria = RitmoConNombre(
        nombre: "bulería", patron: "xooxooxoxoxo", agrupacion: [3, 3, 2, 2, 2], unidad: 8, familia: .flamenco,
        alias: ["bulerías"], estilos: [.flamenco], referencias: [.fernandez2004], lugares: [.region(.andalucia)])
    /// El compás de la seguiriya: doce pulsos en cinco tiempos desiguales, 2 + 2 + 3 + 3 + 2.
    public static let seguiriya = RitmoConNombre(
        nombre: "seguiriya", patron: "x.x.x..x..x.", agrupacion: [2, 2, 3, 3, 2], unidad: 8, familia: .flamenco,
        alias: ["siguiriya"], estilos: [.flamenco], referencias: [.fernandez2004], lugares: [.region(.andalucia)])
    /// El compás de las alegrías, de la familia de las cantiñas: el de la soleá, más ligero.
    public static let alegrias = RitmoConNombre(
        nombre: "alegrías", patron: "ooxooxoxoxox", agrupacion: [3, 3, 2, 2, 2], unidad: 8, familia: .flamenco,
        estilos: [.flamenco], referencias: [.fernandez2004], lugares: [.region(.andalucia)])
    /// El compás de la guajira: el seis por ocho y el tres por cuatro alternados, contados desde el 12.
    public static let guajira = RitmoConNombre(
        nombre: "guajira", patron: "xooxooxoxoxo", agrupacion: [3, 3, 2, 2, 2], unidad: 8, familia: .flamenco,
        estilos: [.flamenco], referencias: [.fernandez2004], lugares: [.region(.andalucia)])
    /// El compás de la petenera: el de la guajira, más lento.
    public static let petenera = RitmoConNombre(
        nombre: "petenera", patron: "xooxooxoxoxo", agrupacion: [3, 3, 2, 2, 2], unidad: 8, familia: .flamenco,
        alias: ["peteneras"], estilos: [.flamenco], referencias: [.fernandez2004], lugares: [.region(.andalucia)])
    /// El compás ternario del fandango, el de Huelva y los demás de su familia.
    public static let fandango = RitmoConNombre(
        nombre: "fandango", patron: "xoo", agrupacion: [1, 1, 1], unidad: 4, familia: .flamenco, alias: ["fandangos"],
        estilos: [.flamenco], referencias: [.fernandez2004], lugares: [.region(.andalucia)])
    // MARK: Tāla de la India

    /// El tāla de dieciséis mātrā en cuatro vibhāg: palmadas en el 1, el 5 y el 13, y la onda (khālī) en el 9.
    public static let tintal = RitmoConNombre(
        nombre: "tīntāl", patron: "xoooxoooooooxooo", agrupacion: [4, 4, 4, 4], unidad: 4, familia: .tala,
        alias: ["tintal", "teentaal", "trital"], referencias: [.clayton2000], tradicion: .india)
    /// Doce mātrā en seis vibhāg de dos, con palmadas en el 1, el 5, el 9 y el 11.
    public static let ektal = RitmoConNombre(
        nombre: "ektāl", patron: "xoooxoooxoxo", agrupacion: [2, 2, 2, 2, 2, 2], unidad: 4, familia: .tala,
        alias: ["ektal", "ektaal"], referencias: [.clayton2000], tradicion: .india)
    /// Diez mātrā en 2 + 3 + 2 + 3, con palmadas en el 1, el 3 y el 8.
    public static let jhaptal = RitmoConNombre(
        nombre: "jhaptāl", patron: "xoxooooxoo", agrupacion: [2, 3, 2, 3], unidad: 4, familia: .tala,
        alias: ["jhaptal", "jhaptaal"], referencias: [.clayton2000], tradicion: .india)
    /// Siete mātrā en 3 + 2 + 2; el único tāla que empieza con la onda, y las palmadas en el 4 y el 6.
    public static let rupak = RitmoConNombre(
        nombre: "rūpak", patron: "oooxoxo", agrupacion: [3, 2, 2], unidad: 4, familia: .tala,
        alias: ["rupak", "rupaktaal"], referencias: [.clayton2000], tradicion: .india)
    /// Seis mātrā en dos vibhāg de tres, el tāla ligero del ghazal y del bhajan.
    public static let dadra = RitmoConNombre(
        nombre: "dādrā", patron: "xooooo", agrupacion: [3, 3], unidad: 4, familia: .tala, alias: ["dadra"],
        referencias: [.clayton2000], tradicion: .india)
    /// Ocho mātrā en dos vibhāg de cuatro, el tāla ligero más común.
    public static let kaharva = RitmoConNombre(
        nombre: "kaharvā", patron: "xooooooo", agrupacion: [4, 4], unidad: 4, familia: .tala,
        alias: ["keharwa", "kaherva"], referencias: [.clayton2000], tradicion: .india)
    /// El tāla carnático de ocho aksara: un laghu de cuatro y dos drutam de dos.
    public static let adi = RitmoConNombre(
        nombre: "ādi tāla", patron: "xoooxoxo", agrupacion: [4, 2, 2], unidad: 4, familia: .tala, alias: ["adi tala"],
        referencias: [.viswanathan2004], tradicion: .india)
    /// El primero de los siete tāla sūlādi carnáticos, en su jāti de cuatro (catusra): laghu, drutam, laghu y laghu,
    /// catorce aksara.
    public static let dhruvaTala = RitmoConNombre(
        nombre: "dhruva tāla", patron: "xoooxoxoooxooo", agrupacion: [4, 2, 4, 4], unidad: 4, familia: .tala,
        alias: ["dhruva tala"], referencias: [.viswanathan2004], tradicion: .india)
    /// Laghu, drutam y laghu, en su jāti de cuatro: diez aksara.
    public static let mathyaTala = RitmoConNombre(
        nombre: "maṭhya tāla", patron: "xoooxoxooo", agrupacion: [4, 2, 4], unidad: 4, familia: .tala,
        alias: ["matya tala", "mathya tala"], referencias: [.viswanathan2004], tradicion: .india)
    /// Drutam y laghu, en su jāti de cuatro: seis aksara. No es el rūpak indostánico.
    public static let rupakaTala = RitmoConNombre(
        nombre: "rūpaka tāla", patron: "xoxooo", agrupacion: [2, 4], unidad: 4, familia: .tala, alias: ["rupaka tala"],
        referencias: [.viswanathan2004], tradicion: .india)
    /// Laghu, anudrutam y drutam, en su jāti de siete (miśra): diez aksara.
    public static let jhampaTala = RitmoConNombre(
        nombre: "jhampa tāla", patron: "xooooooxxo", agrupacion: [7, 1, 2], unidad: 4, familia: .tala,
        alias: ["jhampa tala"], referencias: [.viswanathan2004], tradicion: .india)
    /// Laghu, drutam y drutam, en su jāti de tres (tiśra): siete aksara. En la de cuatro es el ādi tāla.
    public static let triputaTala = RitmoConNombre(
        nombre: "tripuṭa tāla", patron: "xooxoxo", agrupacion: [3, 2, 2], unidad: 4, familia: .tala,
        alias: ["triputa tala"], referencias: [.viswanathan2004], tradicion: .india)
    /// Laghu, laghu, drutam y drutam, en su jāti de cinco (khaṇḍa): catorce aksara.
    public static let ataTala = RitmoConNombre(
        nombre: "aṭa tāla", patron: "xooooxooooxoxo", agrupacion: [5, 5, 2, 2], unidad: 4, familia: .tala,
        alias: ["ata tala"], referencias: [.viswanathan2004], tradicion: .india)
    /// Un solo laghu, en su jāti de cuatro: cuatro aksara.
    public static let ekaTala = RitmoConNombre(
        nombre: "eka tāla", patron: "xooo", unidad: 4, familia: .tala, alias: ["eka tala"],
        referencias: [.viswanathan2004], tradicion: .india)
    // MARK: Iqa'at árabes

    /// El iqa' más común de la música árabe: dum tek · tek dum · tek ·.
    public static let maqsum = RitmoConNombre(
        nombre: "maqsūm", patron: "xo.ox.o.", agrupacion: [2, 2, 2, 2], unidad: 8, familia: .iqa, alias: ["maqsum"],
        referencias: [.touma1996], tradicion: .mundoArabe)
    /// El maqsūm con dos dum al principio: dum dum · tek dum · tek ·.
    public static let baladi = RitmoConNombre(
        nombre: "baladī", patron: "xx.ox.o.", agrupacion: [2, 2, 2, 2], unidad: 8, familia: .iqa, alias: ["baladi"],
        referencias: [.touma1996], tradicion: .mundoArabe, lugares: [.zona(.egipto)])
    /// El iqa' del Alto Egipto, con dos dum seguidos en el centro: dum tek · dum dum · tek ·.
    public static let saidi = RitmoConNombre(
        nombre: "ṣa‘īdī", patron: "xo.xx.o.", agrupacion: [2, 2, 2, 2], unidad: 8, familia: .iqa, alias: ["saidi"],
        referencias: [.touma1996], tradicion: .mundoArabe, lugares: [.zona(.egipto)])
    /// Un dum y dos tek en 3 + 3 + 2: el tresillo de los iqa'at.
    public static let malfuf = RitmoConNombre(
        nombre: "malfūf", patron: "x..o..o.", agrupacion: [2, 2, 2, 2], unidad: 8, familia: .iqa, alias: ["malfuf"],
        referencias: [.touma1996], tradicion: .mundoArabe)
    /// El york-samai árabe de seis pulsos: E(5, 6), girado.
    public static let yorkSamai = RitmoConNombre(
        nombre: "york-samai", patron: "x.xxxx", unidad: 8, familia: .iqa, referencias: [.toussaint2005],
        tradicion: .mundoArabe)
    /// El nawakhat árabe de siete pulsos: E(5, 7).
    public static let nawakhat = RitmoConNombre(
        nombre: "nawakhat", patron: "x.xx.xx", unidad: 8, familia: .iqa, referencias: [.toussaint2005],
        tradicion: .mundoArabe)
    /// El khafif-e-ramal persa del siglo XIII: E(2, 5), dos golpes en cinco pulsos.
    public static let khafifERamal = RitmoConNombre(
        nombre: "khafif-e-ramal", patron: "x.x..", unidad: 8, familia: .iqa, referencias: [.toussaint2005],
        tradicion: .persia)
    // MARK: Aksak y usul

    /// El aksak de cinco pulsos, 2 + 3, de la danza búlgara.
    public static let paidushko = RitmoConNombre(
        nombre: "paidushko", patron: "x.x..", agrupacion: [2, 3], unidad: 8, familia: .aksak,
        estilos: [.folclore], referencias: [.brailoiu1951], tradicion: .europa, lugares: [.pais(.bulgaria)])
    /// El aksak de siete pulsos, 2 + 2 + 3, de la danza búlgara.
    public static let ruchenitsa = RitmoConNombre(
        nombre: "ruchenitsa", patron: "x.x.x..", agrupacion: [2, 2, 3], unidad: 8, familia: .aksak,
        alias: ["račenica", "rachenitsa"], estilos: [.folclore], referencias: [.brailoiu1951], tradicion: .europa,
        lugares: [.pais(.bulgaria)])
    /// El aksak de siete pulsos de Macedonia, 3 + 2 + 2.
    public static let lesnoto = RitmoConNombre(
        nombre: "lesnoto", patron: "x..x.x.", agrupacion: [3, 2, 2], unidad: 8, familia: .aksak, alias: ["lesnoto oro"],
        estilos: [.folclore], referencias: [.brailoiu1951], tradicion: .europa, lugares: [.pais(.macedoniaDelNorte)])
    /// El aksak de nueve pulsos, 2 + 2 + 2 + 3, de Bulgaria; el karşılama turco tiene la misma agrupación.
    public static let daichovo = RitmoConNombre(
        nombre: "daichovo", patron: "x.x.x.x..", agrupacion: [2, 2, 2, 3], unidad: 8, familia: .aksak,
        alias: ["dajchovo", "karşılama"], estilos: [.folclore], referencias: [.brailoiu1951], tradicion: .europa,
        lugares: [.pais(.bulgaria)])
    /// El aksak de once pulsos, 2 + 2 + 3 + 2 + 2, de Bulgaria.
    public static let kopanitsa = RitmoConNombre(
        nombre: "kopanitsa", patron: "x.x.x..x.x.", agrupacion: [2, 2, 3, 2, 2], unidad: 8, familia: .aksak,
        alias: ["gankino"], estilos: [.folclore], referencias: [.brailoiu1951], tradicion: .europa,
        lugares: [.pais(.bulgaria)])
    /// El usul turco de diez pulsos, 3 + 2 + 2 + 3.
    public static let curcuna = RitmoConNombre(
        nombre: "curcuna", patron: "x..x.x.x..", agrupacion: [3, 2, 2, 3], unidad: 8, familia: .aksak,
        alias: ["curcuna usulü"], referencias: [.brailoiu1951], tradicion: .turquia)
    /// El usul turco de ocho pulsos: düm tek · tek düm · tek ·, el mismo dibujo que el maqsūm.
    public static let duyek = RitmoConNombre(
        nombre: "düyek", patron: "xo.ox.o.", agrupacion: [2, 2, 2, 2], unidad: 8, familia: .aksak,
        alias: ["duyek", "düyek usulü"], referencias: [.toussaint2013], tradicion: .turquia)
    /// El agsag-samai árabe de nueve pulsos: E(5, 9), cinco golpes de dos en dos.
    public static let agsagSamai = RitmoConNombre(
        nombre: "agsag-samai", patron: "x.x.x.x.x", unidad: 8, familia: .aksak, referencias: [.toussaint2005],
        tradicion: .mundoArabe)
    // MARK: Modos rítmicos
    //
    // Del año de «De mensurabili musica» de Johannes de Garlandia (hacia 1250), que los describe.

    /// Dos pies del modo de la escuela de Notre Dame. Longa y breve: el troqueo.
    public static let primerModoRitmico = RitmoConNombre(
        nombre: "primer modo rítmico (troqueo)", patron: "x.xx.x", agrupacion: [3, 3], unidad: 8, familia: .modoRitmico,
        estilos: [.clasica], referencias: [.apel1953], anio: 1250, lugares: [.pais(.francia)])
    /// Dos pies del modo de la escuela de Notre Dame. Breve y longa: el yambo.
    public static let segundoModoRitmico = RitmoConNombre(
        nombre: "segundo modo rítmico (yambo)", patron: "xx.xx.", agrupacion: [3, 3], unidad: 8, familia: .modoRitmico,
        estilos: [.clasica], referencias: [.apel1953], anio: 1250, lugares: [.pais(.francia)])
    /// Dos pies del modo de la escuela de Notre Dame. Longa con puntillo, breve y longa: el dáctilo.
    public static let tercerModoRitmico = RitmoConNombre(
        nombre: "tercer modo rítmico (dáctilo)", patron: "x..xx.", agrupacion: [3, 3], unidad: 8, familia: .modoRitmico,
        estilos: [.clasica], referencias: [.apel1953], anio: 1250, lugares: [.pais(.francia)])
    /// Dos pies del modo de la escuela de Notre Dame. Breve, longa y longa con puntillo: el anapesto.
    public static let cuartoModoRitmico = RitmoConNombre(
        nombre: "cuarto modo rítmico (anapesto)", patron: "xx.x..", agrupacion: [3, 3], unidad: 8,
        familia: .modoRitmico, estilos: [.clasica], referencias: [.apel1953], anio: 1250, lugares: [.pais(.francia)])
    /// Dos pies del modo de la escuela de Notre Dame. Dos longas con puntillo: el espondeo.
    public static let quintoModoRitmico = RitmoConNombre(
        nombre: "quinto modo rítmico (espondeo)", patron: "x..x..", agrupacion: [3, 3], unidad: 8,
        familia: .modoRitmico, estilos: [.clasica], referencias: [.apel1953], anio: 1250, lugares: [.pais(.francia)])
    /// Dos pies del modo de la escuela de Notre Dame. Breves seguidas: el tríbraco.
    public static let sextoModoRitmico = RitmoConNombre(
        nombre: "sexto modo rítmico (tríbraco)", patron: "xxxxxx", agrupacion: [3, 3], unidad: 8, familia: .modoRitmico,
        estilos: [.clasica], referencias: [.apel1953], anio: 1250, lugares: [.pais(.francia)])
    // MARK: Danzas

    /// Tres tiempos con el acento en el primero.
    public static let vals = RitmoConNombre(
        nombre: "vals", patron: "xoo", agrupacion: [1, 1, 1], unidad: 4, familia: .danza, estilos: [.clasica],
        referencias: [.toussaint2013], lugares: [.pais(.austria)])
    /// La corchea y las dos semicorcheas del primer tiempo, y las cuatro corcheas de los otros dos.
    public static let polonesa = RitmoConNombre(
        nombre: "polonesa", patron: "x.xxx.x.x.x.", agrupacion: [4, 4, 4], unidad: 16, familia: .danza,
        estilos: [.clasica], referencias: [.toussaint2013], lugares: [.pais(.polonia)])
    /// La corchea con puntillo, la semicorchea y la corchea de cada tiempo de 6/8.
    public static let siciliana = RitmoConNombre(
        nombre: "siciliana", patron: "x..xx.x..xx.", agrupacion: [6, 6], unidad: 16, familia: .danza,
        estilos: [.clasica], referencias: [.toussaint2013], lugares: [.pais(.italia)])
    /// La negra con puntillo y la corchea ligada del charleston de los años veinte: el de James P. Johnson es de 1923.
    public static let charleston = RitmoConNombre(
        nombre: "charleston", patron: "x..x....", agrupacion: [2, 2, 2, 2], unidad: 8, familia: .danza,
        estilos: [.jazz], referencias: [.toussaint2013], anio: 1923, lugares: [.pais(.estadosUnidos)])

    /// Todo el catálogo, en el orden de este fichero.
    public static let catalogo: [RitmoConNombre] = [
        .tresillo, .cinquillo, .habanera, .claveDeSon, .claveDeSonDosTres, .claveDeRumba, .bossaNova, .soukous, .shiko,
        .gahu, .bembe, .palmasVenda, .fumeFume, .samba, .solea, .buleria, .seguiriya, .alegrias, .guajira, .petenera,
        .fandango, .tintal, .ektal, .jhaptal, .rupak, .dadra, .kaharva, .adi, .dhruvaTala, .mathyaTala, .rupakaTala,
        .jhampaTala, .triputaTala, .ataTala, .ekaTala, .maqsum, .baladi, .saidi, .malfuf, .yorkSamai, .nawakhat,
        .khafifERamal, .paidushko, .ruchenitsa, .lesnoto, .daichovo, .kopanitsa, .curcuna, .duyek, .agsagSamai,
        .primerModoRitmico, .segundoModoRitmico, .tercerModoRitmico, .cuartoModoRitmico, .quintoModoRitmico,
        .sextoModoRitmico, .vals, .polonesa, .siciliana, .charleston,
    ]
}
