// clientes.js
const MIS_CLIENTES_REALES = [
  {
    "id": 1100000001,
    "codigo": "4",
    "nombre": "ACOSTA,JOSE MARIA",
    "cuit": "23-17673513-9",
    "saldo":         0.41
  },
  {
    "id": 1100000002,
    "codigo": "5",
    "nombre": "MARAÑON HERNAN RODRIGO",
    "cuit": "20-22845994-2",
    "saldo":         0.00
  },
  {
    "id": 1100000003,
    "codigo": "6",
    "nombre": "ALMACEN MAYORISTA AUSTRAL",
    "cuit": "30-62836966-2",
    "saldo":         0.00
  },
  {
    "id": 1100000004,
    "codigo": "7",
    "nombre": "ARRIETA,HILDA RAQUEL",
    "cuit": "27-12808051-7",
    "saldo":      -378.00
  },
  {
    "id": 1100000005,
    "codigo": "10",
    "nombre": "ARCURI ANIBAL ROBERTO",
    "cuit": "20-16250056-3",
    "saldo":         0.00
  },
  {
    "id": 1100000006,
    "codigo": "13",
    "nombre": "APPELHANZ MARIA ZULEMA",
    "cuit": "27-05450183-3",
    "saldo":         0.00
  },
  {
    "id": 1100000007,
    "codigo": "14",
    "nombre": "ALVAREZ ALBERTO",
    "cuit": "20-05490183-7",
    "saldo":         0.00
  },
  {
    "id": 1100000008,
    "codigo": "15",
    "nombre": "ARLEO,MIGUEL ANGEL",
    "cuit": "20-18250394-1",
    "saldo":         0.00
  },
  {
    "id": 1100000009,
    "codigo": "17",
    "nombre": "BOSCARDIN,OSCAR ISMAEL",
    "cuit": "20-05483948-1",
    "saldo":         0.00
  },
  {
    "id": 1100000010,
    "codigo": "19",
    "nombre": "BARANDALLA ESTEBAN",
    "cuit": "20-10388768-3",
    "saldo":         0.00
  },
  {
    "id": 1100000011,
    "codigo": "23",
    "nombre": "BALIARDA SA",
    "cuit": "30-52109250-1",
    "saldo":         0.00
  },
  {
    "id": 1100000012,
    "codigo": "24",
    "nombre": "CUTTINI JORGE",
    "cuit": "20-08311191-8",
    "saldo":         0.00
  },
  {
    "id": 1100000013,
    "codigo": "26",
    "nombre": "COOP SOMBRA DE TORO",
    "cuit": "30-53087131-9",
    "saldo":         0.00
  },
  {
    "id": 1100000014,
    "codigo": "27",
    "nombre": "COOP AGR DE BAJO HONDO LTDA",
    "cuit": "30-50678632-0",
    "saldo":         0.00
  },
  {
    "id": 1100000015,
    "codigo": "32",
    "nombre": "DIEZ ANGEL",
    "cuit": "20-05471492-1",
    "saldo":         0.00
  },
  {
    "id": 1100000016,
    "codigo": "35",
    "nombre": "DI LERNIA,OSCAR DOMINGO",
    "cuit": "20-10860038-2",
    "saldo":         0.00
  },
  {
    "id": 1100000017,
    "codigo": "36",
    "nombre": "DE LUCIA,ROBERTO R",
    "cuit": "20-12039760-6",
    "saldo":         0.00
  },
  {
    "id": 1100000018,
    "codigo": "37",
    "nombre": "DOMINGUEZ DIEGO",
    "cuit": "20-22845336-7",
    "saldo":         0.00
  },
  {
    "id": 1100000019,
    "codigo": "38",
    "nombre": "DALHOFF MARIO",
    "cuit": "80-07695910-3",
    "saldo":         0.00
  },
  {
    "id": 1100000020,
    "codigo": "39",
    "nombre": "DOMINGUEZ,HECTOR",
    "cuit": "20-14169414-1",
    "saldo":         0.00
  },
  {
    "id": 1100000021,
    "codigo": "40",
    "nombre": "EL CANDIL SRL",
    "cuit": "30-64525730-4",
    "saldo":         0.00
  },
  {
    "id": 1100000022,
    "codigo": "41",
    "nombre": "EMILIOZZI,PEDRO",
    "cuit": "20-05503703-6",
    "saldo":         0.00
  },
  {
    "id": 1100000023,
    "codigo": "42",
    "nombre": "ETCHEGARAY, ROBERTO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000024,
    "codigo": "45",
    "nombre": "EZPELETA GUILLERMO PABLO",
    "cuit": "20-10737105-3",
    "saldo":         0.00
  },
  {
    "id": 1100000025,
    "codigo": "46",
    "nombre": "EGBA SA",
    "cuit": "30-61541498-7",
    "saldo":         0.00
  },
  {
    "id": 1100000026,
    "codigo": "48",
    "nombre": "FIDALGO, MIGUEL ANGEL",
    "cuit": "23-20043054-9",
    "saldo":         0.00
  },
  {
    "id": 1100000027,
    "codigo": "49",
    "nombre": "FRILAC",
    "cuit": "30-64162898-7",
    "saldo":         0.00
  },
  {
    "id": 1100000028,
    "codigo": "50",
    "nombre": "FERRO  ANGEL JUSTO",
    "cuit": "20-07695811-5",
    "saldo":         0.00
  },
  {
    "id": 1100000029,
    "codigo": "51",
    "nombre": "FERNANDEZ AMILCAR RICARDO",
    "cuit": "20-08213116-8",
    "saldo":         0.00
  },
  {
    "id": 1100000030,
    "codigo": "52",
    "nombre": "FARIAS JORGE",
    "cuit": "20-07848748-9",
    "saldo":         0.00
  },
  {
    "id": 1100000031,
    "codigo": "54",
    "nombre": "GONZALEZ HECTOR - CLEONE",
    "cuit": "20-05495687-9",
    "saldo":         0.00
  },
  {
    "id": 1100000032,
    "codigo": "55",
    "nombre": "GALES FEDERICO",
    "cuit": "20-54600217-0",
    "saldo":         0.00
  },
  {
    "id": 1100000033,
    "codigo": "58",
    "nombre": "GRIMALDI REMO RAFAEL",
    "cuit": "20-15254174-1",
    "saldo":         0.00
  },
  {
    "id": 1100000034,
    "codigo": "60",
    "nombre": "GUANES ANTONIO",
    "cuit": "23-08473000-9",
    "saldo":         0.00
  },
  {
    "id": 1100000035,
    "codigo": "61",
    "nombre": "GALLO MARIA DEL CARMEN",
    "cuit": "27-10524689-2",
    "saldo":         0.00
  },
  {
    "id": 1100000036,
    "codigo": "62",
    "nombre": "HERNANDEZ JUAN CARLOS",
    "cuit": "30-56655636-3",
    "saldo":         0.00
  },
  {
    "id": 1100000037,
    "codigo": "64",
    "nombre": "HIDALGO LUIS",
    "cuit": "20-12425810-5",
    "saldo":         0.00
  },
  {
    "id": 1100000038,
    "codigo": "67",
    "nombre": "ISEPPI MARCELA",
    "cuit": "20-17068877-0",
    "saldo":         0.00
  },
  {
    "id": 1100000039,
    "codigo": "70",
    "nombre": "KUNDT OTTO",
    "cuit": "20-07338304-9",
    "saldo":         0.00
  },
  {
    "id": 1100000040,
    "codigo": "72",
    "nombre": "LOPEZ GASPERINI HNOS",
    "cuit": "30-60472313-9",
    "saldo":         0.00
  },
  {
    "id": 1100000041,
    "codigo": "74",
    "nombre": "LARRABURU JORGE ANTONIO",
    "cuit": "23-05513158-9",
    "saldo":         0.00
  },
  {
    "id": 1100000042,
    "codigo": "75",
    "nombre": "LUNCIO ADOLFO",
    "cuit": "20-05448676-7",
    "saldo":         0.00
  },
  {
    "id": 1100000043,
    "codigo": "76",
    "nombre": "LA MARCA REST",
    "cuit": "20-05383645-4",
    "saldo":         0.00
  },
  {
    "id": 1100000044,
    "codigo": "78",
    "nombre": "LEZZIERI RAQUEL",
    "cuit": "27-00710514-8",
    "saldo":         0.00
  },
  {
    "id": 1100000045,
    "codigo": "81",
    "nombre": "LUCERO ABEL",
    "cuit": "20-07366489-7",
    "saldo":         0.00
  },
  {
    "id": 1100000046,
    "codigo": "82",
    "nombre": "LORRE ALBERTO",
    "cuit": "23-05477116-9",
    "saldo":         0.00
  },
  {
    "id": 1100000047,
    "codigo": "85",
    "nombre": "MEONI JUAN CARLOS",
    "cuit": "20-05492429-2",
    "saldo":         0.00
  },
  {
    "id": 1100000048,
    "codigo": "88",
    "nombre": "MEDORI OSCAR ALBERTO",
    "cuit": "20-11113748-0",
    "saldo":         0.00
  },
  {
    "id": 1100000049,
    "codigo": "89",
    "nombre": "MAZZELLO  PALMIRO",
    "cuit": "20-05460625-8",
    "saldo":         0.00
  },
  {
    "id": 1100000050,
    "codigo": "90",
    "nombre": "MACCARI ORLANDO Y ROBERTO OSCAR",
    "cuit": "30-56350241-6",
    "saldo":         0.00
  },
  {
    "id": 1100000051,
    "codigo": "92",
    "nombre": "MULLER RICARDO",
    "cuit": "20-07848293-2",
    "saldo":         0.00
  },
  {
    "id": 1100000052,
    "codigo": "93",
    "nombre": "MARTINEZ HECTOR",
    "cuit": "20-20903716-6",
    "saldo":         0.00
  },
  {
    "id": 1100000053,
    "codigo": "94",
    "nombre": "MOTRICO HECTOR",
    "cuit": "20-13796151-3",
    "saldo":         0.00
  },
  {
    "id": 1100000054,
    "codigo": "95",
    "nombre": "MARTINEZ ALDO",
    "cuit": "20-07664540-0",
    "saldo":         0.00
  },
  {
    "id": 1100000055,
    "codigo": "100",
    "nombre": "NOIA CATALINA",
    "cuit": "27-04276388-3",
    "saldo":         0.00
  },
  {
    "id": 1100000056,
    "codigo": "102",
    "nombre": "SCARABOTTI FLAVIA LORENA",
    "cuit": "23-25947099-4",
    "saldo":         0.00
  },
  {
    "id": 1100000057,
    "codigo": "103",
    "nombre": "POMPILIO ANA MARIA",
    "cuit": "27-10932991-1",
    "saldo":         0.00
  },
  {
    "id": 1100000058,
    "codigo": "104",
    "nombre": "PHORDOY GUSTAVO RUBEN",
    "cuit": "20-17279962-1",
    "saldo":         0.00
  },
  {
    "id": 1100000059,
    "codigo": "105",
    "nombre": "PETRELLI JOAQUIN",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000060,
    "codigo": "106",
    "nombre": "PHORDOY RUBEN",
    "cuit": "20-05476722-7",
    "saldo":         0.00
  },
  {
    "id": 1100000061,
    "codigo": "108",
    "nombre": "RUESGA DOMINGO",
    "cuit": "20-05169051-7",
    "saldo":         0.00
  },
  {
    "id": 1100000062,
    "codigo": "109",
    "nombre": "RODRIGUEZ GERARDO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000063,
    "codigo": "111",
    "nombre": "RESTAURANT LOS AMIGOS",
    "cuit": "30-64362335-4",
    "saldo":         0.00
  },
  {
    "id": 1100000064,
    "codigo": "112",
    "nombre": "SAVINI JORGE",
    "cuit": "20-78483440-0",
    "saldo":         0.00
  },
  {
    "id": 1100000065,
    "codigo": "113",
    "nombre": "SARIMBALIS JORGE VICTOR",
    "cuit": "27-11177786-7",
    "saldo":         0.00
  },
  {
    "id": 1100000066,
    "codigo": "115",
    "nombre": "SPADAVECCHIA MARIA LUZ",
    "cuit": "27-12775720-0",
    "saldo":         0.00
  },
  {
    "id": 1100000067,
    "codigo": "118",
    "nombre": "TESIDOR CARLOS ALBERTO",
    "cuit": "20-12292752-1",
    "saldo":         0.00
  },
  {
    "id": 1100000068,
    "codigo": "119",
    "nombre": "TEJERA NELSON",
    "cuit": "20-05496176-7",
    "saldo":         0.00
  },
  {
    "id": 1100000069,
    "codigo": "120",
    "nombre": "SABATTINI OSCAR HECTOR",
    "cuit": "30-62836966-2",
    "saldo":         0.00
  },
  {
    "id": 1100000070,
    "codigo": "121",
    "nombre": "SALTARI ENIO",
    "cuit": "27-01441017-7",
    "saldo":         0.00
  },
  {
    "id": 1100000071,
    "codigo": "123",
    "nombre": "SERONE MARIO",
    "cuit": "30-62794310-1",
    "saldo":         0.00
  },
  {
    "id": 1100000072,
    "codigo": "124",
    "nombre": "SPINOSA JOSE",
    "cuit": "20-05431315-3",
    "saldo":         0.00
  },
  {
    "id": 1100000073,
    "codigo": "126",
    "nombre": "ULLOA GRANDON ELINA DEL CARMEN",
    "cuit": "27-92638204-2",
    "saldo":         0.00
  },
  {
    "id": 1100000074,
    "codigo": "127",
    "nombre": "VEROLI JORGE",
    "cuit": "20-13461681-5",
    "saldo":         0.00
  },
  {
    "id": 1100000075,
    "codigo": "128",
    "nombre": "VILLAR Y FERNANDEZ",
    "cuit": "30-58550441-2",
    "saldo":         0.00
  },
  {
    "id": 1100000076,
    "codigo": "129",
    "nombre": "VEGA RAMON CLEMENTE",
    "cuit": "20-05471541-3",
    "saldo":         0.00
  },
  {
    "id": 1100000077,
    "codigo": "131",
    "nombre": "WAIMAN HILARIO",
    "cuit": "20-05504352-4",
    "saldo":         0.00
  },
  {
    "id": 1100000078,
    "codigo": "133",
    "nombre": "ZARZA ERMELINDO",
    "cuit": "20-05422464-9",
    "saldo":         0.00
  },
  {
    "id": 1100000079,
    "codigo": "134",
    "nombre": "ZANASSI ROSA NILDA",
    "cuit": "27-11089897-0",
    "saldo":         0.00
  },
  {
    "id": 1100000080,
    "codigo": "135",
    "nombre": "ZENOBI JORGE HUMBERTO",
    "cuit": "20-11721067-8",
    "saldo":         0.00
  },
  {
    "id": 1100000081,
    "codigo": "136",
    "nombre": "AGRIOLLI",
    "cuit": "20-05440988-6",
    "saldo":         0.00
  },
  {
    "id": 1100000082,
    "codigo": "137",
    "nombre": "BURGOS JUAN JORGE",
    "cuit": "20-05492757-7",
    "saldo":         0.00
  },
  {
    "id": 1100000083,
    "codigo": "149",
    "nombre": "GONZALEZ SUSANA MARGARITA",
    "cuit": "23-12316805-4",
    "saldo":      -158.61
  },
  {
    "id": 1100000084,
    "codigo": "157",
    "nombre": "PANDO JORGE",
    "cuit": "23-13128742-9",
    "saldo":         0.00
  },
  {
    "id": 1100000085,
    "codigo": "162",
    "nombre": "RESTIFO DANIEL MAURICIO",
    "cuit": "20-08435321-4",
    "saldo":         0.00
  },
  {
    "id": 1100000086,
    "codigo": "167",
    "nombre": "STEFANU MARCELO",
    "cuit": "20-16068549-3",
    "saldo":      6868.50
  },
  {
    "id": 1100000087,
    "codigo": "176",
    "nombre": "WALZ PABLO",
    "cuit": "20-21559648-7",
    "saldo":         0.00
  },
  {
    "id": 1100000088,
    "codigo": "186",
    "nombre": "PASCUAL HNOS",
    "cuit": "30-53640060-1",
    "saldo":         0.00
  },
  {
    "id": 1100000089,
    "codigo": "188",
    "nombre": "ESCUELA N 5",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000090,
    "codigo": "190",
    "nombre": "PILOTTI",
    "cuit": "30-58343841-2",
    "saldo":         0.00
  },
  {
    "id": 1100000091,
    "codigo": "195",
    "nombre": "VINUELA Y CIA SCCA",
    "cuit": "30-52917831-6",
    "saldo":         0.00
  },
  {
    "id": 1100000092,
    "codigo": "197",
    "nombre": "MARTINEZ BENITO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000093,
    "codigo": "205",
    "nombre": "ASPREA LUIS",
    "cuit": "20-05490859-9",
    "saldo":         0.00
  },
  {
    "id": 1100000094,
    "codigo": "208",
    "nombre": "CARNDEL FORTIN CECCHINI ROBERTO",
    "cuit": "20-12862584-5",
    "saldo":         0.00
  },
  {
    "id": 1100000095,
    "codigo": "214",
    "nombre": "GIZEH SOC DE HECHO",
    "cuit": "30-65588550-8",
    "saldo":         0.00
  },
  {
    "id": 1100000096,
    "codigo": "215",
    "nombre": "PIZZERIA RIGOLETTO DE RAUL PHOF",
    "cuit": "20-10342710-0",
    "saldo":         0.00
  },
  {
    "id": 1100000097,
    "codigo": "227",
    "nombre": "OLGIATTI JOSE DANIEL",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000098,
    "codigo": "231",
    "nombre": "BUSTAMANTE DANIEL",
    "cuit": "20-04987705-7",
    "saldo":         0.00
  },
  {
    "id": 1100000099,
    "codigo": "249",
    "nombre": "SPINOLO ROBERTO",
    "cuit": "20-05447266-9",
    "saldo":         0.00
  },
  {
    "id": 1100000100,
    "codigo": "250",
    "nombre": "DE DIOS, LAURA",
    "cuit": "27-03498378-5",
    "saldo":         0.00
  },
  {
    "id": 1100000101,
    "codigo": "259",
    "nombre": "LARRASOLO NESTOR",
    "cuit": "20-14935039-0",
    "saldo":        82.14
  },
  {
    "id": 1100000102,
    "codigo": "264",
    "nombre": "MILSTEIN HNOSLOS PAMPERITOS",
    "cuit": "30-59271116-4",
    "saldo":         0.00
  },
  {
    "id": 1100000103,
    "codigo": "269",
    "nombre": "COOPERATIVA AGGANADERA DE CASBAAS LTDA",
    "cuit": "30-55481658-0",
    "saldo":         0.00
  },
  {
    "id": 1100000104,
    "codigo": "270",
    "nombre": "RODRIGUEZ MARDEL",
    "cuit": "23-05280006-4",
    "saldo":         0.00
  },
  {
    "id": 1100000105,
    "codigo": "271",
    "nombre": "LOPEZ RAUL",
    "cuit": "20-10236700-8",
    "saldo":         0.00
  },
  {
    "id": 1100000106,
    "codigo": "274",
    "nombre": "SACKS IRENE",
    "cuit": "27-11177786-7",
    "saldo":         0.00
  },
  {
    "id": 1100000107,
    "codigo": "275",
    "nombre": "CARNELOZ NESTOR",
    "cuit": "20-12474057-7",
    "saldo":         0.00
  },
  {
    "id": 1100000108,
    "codigo": "277",
    "nombre": "KEES OSCAR",
    "cuit": "20-14173111-5",
    "saldo":         0.00
  },
  {
    "id": 1100000109,
    "codigo": "280",
    "nombre": "LA TRANQUERA FAJARDO Y PANEPI",
    "cuit": "33-65899524-9",
    "saldo":         0.00
  },
  {
    "id": 1100000110,
    "codigo": "282",
    "nombre": "SANCHO HUGO OMAR",
    "cuit": "20-08472054-3",
    "saldo":         0.00
  },
  {
    "id": 1100000111,
    "codigo": "283",
    "nombre": "D ACOSTA",
    "cuit": "23-92362895-9",
    "saldo":         0.00
  },
  {
    "id": 1100000112,
    "codigo": "284",
    "nombre": "RIVADEMAR JUAN",
    "cuit": "23-05456248-9",
    "saldo":         0.00
  },
  {
    "id": 1100000113,
    "codigo": "289",
    "nombre": "GENNARI JUAN CARLOS",
    "cuit": "20-10388912-0",
    "saldo":         0.00
  },
  {
    "id": 1100000114,
    "codigo": "290",
    "nombre": "PARLIATORE FELIPE",
    "cuit": "20-06172804-0",
    "saldo":         0.00
  },
  {
    "id": 1100000115,
    "codigo": "291",
    "nombre": "BERTOLINO ANGELICA ESTHER",
    "cuit": "27-12605154-4",
    "saldo":         0.00
  },
  {
    "id": 1100000116,
    "codigo": "292",
    "nombre": "DAY INDUSTRIALSA",
    "cuit": "30-65397837-1",
    "saldo":         0.00
  },
  {
    "id": 1100000117,
    "codigo": "295",
    "nombre": "BERTOLINI",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000118,
    "codigo": "301",
    "nombre": "ARRIETAS ELIDA",
    "cuit": "27-14521107-2",
    "saldo":         0.00
  },
  {
    "id": 1100000119,
    "codigo": "304",
    "nombre": "COOP NUESTRA CASA",
    "cuit": "30-52782532-2",
    "saldo":         0.00
  },
  {
    "id": 1100000120,
    "codigo": "305",
    "nombre": "PRADO OSVALDO DAVID",
    "cuit": "20-16295161-1",
    "saldo":         0.00
  },
  {
    "id": 1100000121,
    "codigo": "307",
    "nombre": "JORGE Y MARIO GARMENDIA",
    "cuit": "30-61249459-4",
    "saldo":         0.00
  },
  {
    "id": 1100000122,
    "codigo": "308",
    "nombre": "COOPAGGANAGRALSAN MARTIN",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000123,
    "codigo": "309",
    "nombre": "CUOMO CZRMEN BEEATRIZ",
    "cuit": "27-03545644-6",
    "saldo":         0.00
  },
  {
    "id": 1100000124,
    "codigo": "310",
    "nombre": "LORENZI JOSE RUBEN",
    "cuit": "20-13227506-9",
    "saldo":         0.00
  },
  {
    "id": 1100000125,
    "codigo": "311",
    "nombre": "OMAR D PRADO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000126,
    "codigo": "312",
    "nombre": "BREGLIA S ALICIA",
    "cuit": "27-10737621-1",
    "saldo":         0.00
  },
  {
    "id": 1100000127,
    "codigo": "314",
    "nombre": "CAMAR5A JUNIORS BBCA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000128,
    "codigo": "315",
    "nombre": "CAMPOS LEIVA ANGEL LIBIO",
    "cuit": "20-92425654-1",
    "saldo":         0.00
  },
  {
    "id": 1100000129,
    "codigo": "318",
    "nombre": "MILUCIANI",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000130,
    "codigo": "320",
    "nombre": "NIETO",
    "cuit": "20-05485156-2",
    "saldo":         0.00
  },
  {
    "id": 1100000131,
    "codigo": "322",
    "nombre": "TEENIAS SERGIO EC",
    "cuit": "20-17837446-0",
    "saldo":         0.00
  },
  {
    "id": 1100000132,
    "codigo": "325",
    "nombre": "LLINARES ANTONIO",
    "cuit": "20-05470797-6",
    "saldo":         0.00
  },
  {
    "id": 1100000133,
    "codigo": "328",
    "nombre": "CARBAJO HUGO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000134,
    "codigo": "329",
    "nombre": "RESCH ENRIQUE RAUL",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000135,
    "codigo": "330",
    "nombre": "SERONE DANIEL",
    "cuit": "20-49875132-0",
    "saldo":         0.00
  },
  {
    "id": 1100000136,
    "codigo": "331",
    "nombre": "SUCRESERO COOP R ESTOMBA",
    "cuit": "30-62853334-9",
    "saldo":         0.00
  },
  {
    "id": 1100000137,
    "codigo": "332",
    "nombre": "CAMINOS MARIA",
    "cuit": "27-01022764-5",
    "saldo":         0.00
  },
  {
    "id": 1100000138,
    "codigo": "335",
    "nombre": "MARTELLO BEATRIZ",
    "cuit": "27-12278522-5",
    "saldo":         0.00
  },
  {
    "id": 1100000139,
    "codigo": "349",
    "nombre": "BENITEZ CESAR HUMBERTO",
    "cuit": "20-25534767-6",
    "saldo":         0.00
  },
  {
    "id": 1100000140,
    "codigo": "354",
    "nombre": "ARISTAN ARNALDO",
    "cuit": "20-05460188-4",
    "saldo":         0.00
  },
  {
    "id": 1100000141,
    "codigo": "355",
    "nombre": "AUT EL INDIO DE RODRIGUEZ NJ",
    "cuit": "20-05445956-5",
    "saldo":         0.00
  },
  {
    "id": 1100000142,
    "codigo": "356",
    "nombre": "COOP RURAL LTDA SUC TRES PICOS",
    "cuit": "30-53420682-4",
    "saldo":         0.00
  },
  {
    "id": 1100000143,
    "codigo": "357",
    "nombre": "FERNANDEZ DOMINGO",
    "cuit": "20-05486018-9",
    "saldo":         0.00
  },
  {
    "id": 1100000144,
    "codigo": "358",
    "nombre": "ALRIC HORACIO",
    "cuit": "20-16606897-6",
    "saldo":         0.00
  },
  {
    "id": 1100000145,
    "codigo": "359",
    "nombre": "LOPEZ DE HARRINSON,NORA",
    "cuit": "27-03496896-4",
    "saldo":         0.00
  },
  {
    "id": 1100000146,
    "codigo": "362",
    "nombre": "SMAEL NORMA ALCIRA",
    "cuit": "20-05110230-4",
    "saldo":         0.00
  },
  {
    "id": 1100000147,
    "codigo": "363",
    "nombre": "OTEIZA OMAR",
    "cuit": "23-18277208-9",
    "saldo":         0.00
  },
  {
    "id": 1100000148,
    "codigo": "366",
    "nombre": "CIOMMO ORESTE",
    "cuit": "20-15257673-1",
    "saldo":         0.00
  },
  {
    "id": 1100000149,
    "codigo": "368",
    "nombre": "BONOTTO SERVICENTRO",
    "cuit": "23-10346426-9",
    "saldo":         0.00
  },
  {
    "id": 1100000150,
    "codigo": "370",
    "nombre": "ANTON JOSE LUIS",
    "cuit": "20-05507921-9",
    "saldo":         0.00
  },
  {
    "id": 1100000151,
    "codigo": "373",
    "nombre": "KITLAN JOSE R",
    "cuit": "20-05462669-0",
    "saldo":         0.00
  },
  {
    "id": 1100000152,
    "codigo": "374",
    "nombre": "FORTUNATTI OMAR Y SUC DE FORTUNATTI HECT",
    "cuit": "30-58272776-3",
    "saldo":         7.58
  },
  {
    "id": 1100000153,
    "codigo": "375",
    "nombre": "MAZZINI GRACIELA ROSA",
    "cuit": "27-10391729-3",
    "saldo":         0.00
  },
  {
    "id": 1100000154,
    "codigo": "380",
    "nombre": "STEIN  CARLOS",
    "cuit": "20-14151417-4",
    "saldo":         0.00
  },
  {
    "id": 1100000155,
    "codigo": "383",
    "nombre": "STRAUB DIREGHPO G",
    "cuit": "20-21797595-7",
    "saldo":         0.00
  },
  {
    "id": 1100000156,
    "codigo": "384",
    "nombre": "GOTHAU  JOSE",
    "cuit": "20-05519961-3",
    "saldo":         0.00
  },
  {
    "id": 1100000157,
    "codigo": "386",
    "nombre": "SAIEG CARLOS R",
    "cuit": "20-11622922-7",
    "saldo":         0.00
  },
  {
    "id": 1100000158,
    "codigo": "388",
    "nombre": "RABIONE  RICARDO  Y CIA",
    "cuit": "30-50990304-9",
    "saldo":         0.00
  },
  {
    "id": 1100000159,
    "codigo": "389",
    "nombre": "CONTISCIANI HAIDEE",
    "cuit": "27-03545715-7",
    "saldo":         0.00
  },
  {
    "id": 1100000160,
    "codigo": "392",
    "nombre": "DI LACIO RAUL",
    "cuit": "20-05440858-8",
    "saldo":         0.00
  },
  {
    "id": 1100000161,
    "codigo": "397",
    "nombre": "VENEGAS JUAN",
    "cuit": "20-92604878-4",
    "saldo":         0.00
  },
  {
    "id": 1100000162,
    "codigo": "399",
    "nombre": "CAMPERI  RAFAEL",
    "cuit": "20-11391964-8",
    "saldo":         0.00
  },
  {
    "id": 1100000163,
    "codigo": "400",
    "nombre": "ARCE  ADRIANA",
    "cuit": "27-17837908-4",
    "saldo":         0.00
  },
  {
    "id": 1100000164,
    "codigo": "401",
    "nombre": "BORELLI",
    "cuit": "23-05472188-9",
    "saldo":     -2916.73
  },
  {
    "id": 1100000165,
    "codigo": "402",
    "nombre": "MARTIN  MABEL",
    "cuit": "27-04259736-3",
    "saldo":         0.00
  },
  {
    "id": 1100000166,
    "codigo": "406",
    "nombre": "PELEGRINO  EDUARDO",
    "cuit": "23-11794857-9",
    "saldo":         0.00
  },
  {
    "id": 1100000167,
    "codigo": "408",
    "nombre": "PETROCAT SRL",
    "cuit": "30-65869422-3",
    "saldo":         0.00
  },
  {
    "id": 1100000168,
    "codigo": "411",
    "nombre": "LA BINCA S A",
    "cuit": "30-50053702-3",
    "saldo":         0.00
  },
  {
    "id": 1100000169,
    "codigo": "412",
    "nombre": "PANELLI JUAN",
    "cuit": "20-05434073-8",
    "saldo":         0.00
  },
  {
    "id": 1100000170,
    "codigo": "413",
    "nombre": "MARCIALI  RUBEN",
    "cuit": "20-10102457-2",
    "saldo":         0.00
  },
  {
    "id": 1100000171,
    "codigo": "417",
    "nombre": "SILMA  JOSE",
    "cuit": "30-05488031-7",
    "saldo":         0.00
  },
  {
    "id": 1100000172,
    "codigo": "419",
    "nombre": "GIOGOTTI DANIEL",
    "cuit": "20-05518357-1",
    "saldo":         0.00
  },
  {
    "id": 1100000173,
    "codigo": "423",
    "nombre": "HOSPITAL MUNICIPAL DE AGUDOS DRLLUCERO",
    "cuit": "30-99927295-5",
    "saldo":    255306.35
  },
  {
    "id": 1100000174,
    "codigo": "426",
    "nombre": "ROSATELLI EDUARDO ALBERTO",
    "cuit": "20-12750930-2",
    "saldo":     56541.60
  },
  {
    "id": 1100000175,
    "codigo": "431",
    "nombre": "PASCUALNI SERGIO",
    "cuit": "20-17403805-9",
    "saldo":         0.00
  },
  {
    "id": 1100000176,
    "codigo": "432",
    "nombre": "LOPEZ  LEUTERIO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000177,
    "codigo": "434",
    "nombre": "GUIMENEZ ALFONSO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000178,
    "codigo": "435",
    "nombre": "FABRI MARIA LUZ",
    "cuit": "23-37984884-2",
    "saldo":         0.79
  },
  {
    "id": 1100000179,
    "codigo": "436",
    "nombre": "ANEROT NESTOR",
    "cuit": "20-12316969-8",
    "saldo":         0.00
  },
  {
    "id": 1100000180,
    "codigo": "438",
    "nombre": "BLANCO DANIEL",
    "cuit": "20-12605768-8",
    "saldo":         0.00
  },
  {
    "id": 1100000181,
    "codigo": "439",
    "nombre": "COOP DE TRABAJO TRANSPORTE DE HACIENDA 1",
    "cuit": "30-56359439-6",
    "saldo":         0.00
  },
  {
    "id": 1100000182,
    "codigo": "442",
    "nombre": "GONZALEZ MARTA",
    "cuit": "23-03798488-4",
    "saldo":         0.00
  },
  {
    "id": 1100000183,
    "codigo": "444",
    "nombre": "DOMINGUEZ HORACIO ABEL",
    "cuit": "30-66413758-1",
    "saldo":         0.00
  },
  {
    "id": 1100000184,
    "codigo": "445",
    "nombre": "HARENGUS SA",
    "cuit": "30-57736497-0",
    "saldo":         0.00
  },
  {
    "id": 1100000185,
    "codigo": "448",
    "nombre": "VINUELA  Y CIA SCA",
    "cuit": "30-52917831-6",
    "saldo":         0.00
  },
  {
    "id": 1100000186,
    "codigo": "450",
    "nombre": "VIVES  ALFREDO",
    "cuit": "20-10534298-6",
    "saldo":         0.00
  },
  {
    "id": 1100000187,
    "codigo": "451",
    "nombre": "RIVERO ROBERTO HECTOR",
    "cuit": "20-05473672-0",
    "saldo":         0.00
  },
  {
    "id": 1100000188,
    "codigo": "452",
    "nombre": "ORTIZ DANIEL",
    "cuit": "20-14949096-6",
    "saldo":         0.00
  },
  {
    "id": 1100000189,
    "codigo": "454",
    "nombre": "ROMAGNELLI NORBERTO ALEM",
    "cuit": "30-55092364-1",
    "saldo":         0.00
  },
  {
    "id": 1100000190,
    "codigo": "459",
    "nombre": "ROSALES HECTOR",
    "cuit": "20-05455790-7",
    "saldo":         0.00
  },
  {
    "id": 1100000191,
    "codigo": "461",
    "nombre": "ORTIZ DANIEL",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000192,
    "codigo": "463",
    "nombre": "ENET N§ 1",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000193,
    "codigo": "467",
    "nombre": "GELATTI BEATRIZ",
    "cuit": "27-17280256-2",
    "saldo":         0.00
  },
  {
    "id": 1100000194,
    "codigo": "468",
    "nombre": "PASCUAL HNOS   SUCVILLARINO",
    "cuit": "30-53640060-1",
    "saldo":         0.00
  },
  {
    "id": 1100000195,
    "codigo": "469",
    "nombre": "DIESER SUSANA MARTA",
    "cuit": "27-04552485-5",
    "saldo":         0.00
  },
  {
    "id": 1100000196,
    "codigo": "470",
    "nombre": "VITA AURELI0",
    "cuit": "27-03842236-1",
    "saldo":         0.00
  },
  {
    "id": 1100000197,
    "codigo": "471",
    "nombre": "GARCIA OMAR",
    "cuit": "20-14148753-2",
    "saldo":         0.00
  },
  {
    "id": 1100000198,
    "codigo": "477",
    "nombre": "GOMEZ FROILAN",
    "cuit": "20-05428133-2",
    "saldo":         0.00
  },
  {
    "id": 1100000199,
    "codigo": "478",
    "nombre": "RESCH ENRIQUE RAUL",
    "cuit": "23-05494613-9",
    "saldo":         0.00
  },
  {
    "id": 1100000200,
    "codigo": "483",
    "nombre": "NOGUES FRANCISCO",
    "cuit": "20-05383645-4",
    "saldo":         0.00
  },
  {
    "id": 1100000201,
    "codigo": "485",
    "nombre": "LAHOZ RUBEN",
    "cuit": "20-73620025-0",
    "saldo":         0.00
  },
  {
    "id": 1100000202,
    "codigo": "486",
    "nombre": "HAIDT MARIO",
    "cuit": "27-04839618-1",
    "saldo":         0.00
  },
  {
    "id": 1100000203,
    "codigo": "496",
    "nombre": "GABRIELLI EMILIO",
    "cuit": "20-03025504-7",
    "saldo":         0.00
  },
  {
    "id": 1100000204,
    "codigo": "501",
    "nombre": "RAFAELI",
    "cuit": "20-05455868-7",
    "saldo":         0.00
  },
  {
    "id": 1100000205,
    "codigo": "510",
    "nombre": "RODRIGO MARY",
    "cuit": "27-01567653-7",
    "saldo":         0.00
  },
  {
    "id": 1100000206,
    "codigo": "521",
    "nombre": "CARMINO NESTOR OSVALDO",
    "cuit": "20-05517928-0",
    "saldo":         0.00
  },
  {
    "id": 1100000207,
    "codigo": "522",
    "nombre": "CRUCIANELLI ELSA",
    "cuit": "27-04481467-1",
    "saldo":         0.00
  },
  {
    "id": 1100000208,
    "codigo": "523",
    "nombre": "MACHADO LIDIA DE",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000209,
    "codigo": "524",
    "nombre": "RECARTE BLANCA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000210,
    "codigo": "538",
    "nombre": "ADRIANA LOY",
    "cuit": "27-14935225-8",
    "saldo":         0.00
  },
  {
    "id": 1100000211,
    "codigo": "539",
    "nombre": "CORVALAN MIGUEL ANGEL",
    "cuit": "20-12663506-1",
    "saldo":         0.00
  },
  {
    "id": 1100000212,
    "codigo": "548",
    "nombre": "SANCHEZ",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000213,
    "codigo": "552",
    "nombre": "RAFAELLI",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000214,
    "codigo": "556",
    "nombre": "TOMASSETTI  ROBERTO HUGO",
    "cuit": "20-05464274-2",
    "saldo":         0.00
  },
  {
    "id": 1100000215,
    "codigo": "560",
    "nombre": "PEREYRA A",
    "cuit": "27-05018182-6",
    "saldo":         0.00
  },
  {
    "id": 1100000216,
    "codigo": "564",
    "nombre": "TRAVI NOEMI ESTER",
    "cuit": "27-49357187-0",
    "saldo":         0.00
  },
  {
    "id": 1100000217,
    "codigo": "565",
    "nombre": "GIACOMOZZI MARTA",
    "cuit": "27-03879628-9",
    "saldo":         0.00
  },
  {
    "id": 1100000218,
    "codigo": "566",
    "nombre": "SCHRU JOSE",
    "cuit": "20-03569364-9",
    "saldo":         0.00
  },
  {
    "id": 1100000219,
    "codigo": "574",
    "nombre": "COPITA JORGE",
    "cuit": "20-11913329-8",
    "saldo":         0.00
  },
  {
    "id": 1100000220,
    "codigo": "576",
    "nombre": "BODANZA PABLO",
    "cuit": "20-20485068-3",
    "saldo":         0.00
  },
  {
    "id": 1100000221,
    "codigo": "577",
    "nombre": "LA CASA DEL QUESO SRL",
    "cuit": "30-62743107-6",
    "saldo":         0.00
  },
  {
    "id": 1100000222,
    "codigo": "579",
    "nombre": "ASOCIACION CIVIL MARIA AUXILIADORA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000223,
    "codigo": "581",
    "nombre": "UGARTE VELMA",
    "cuit": "23-13650086-4",
    "saldo":         0.00
  },
  {
    "id": 1100000224,
    "codigo": "582",
    "nombre": "ROSSI OSVALDO",
    "cuit": "23-05516447-0",
    "saldo":         0.00
  },
  {
    "id": 1100000225,
    "codigo": "583",
    "nombre": "EMILIO AGROPECUARIA SH",
    "cuit": "30-66416115-5",
    "saldo":         0.00
  },
  {
    "id": 1100000226,
    "codigo": "586",
    "nombre": "DONGUI HECTOR",
    "cuit": "20-13227386-4",
    "saldo":         0.00
  },
  {
    "id": 1100000227,
    "codigo": "588",
    "nombre": "TERUEL EY GUERRERO TERUEL T",
    "cuit": "30-63158711-5",
    "saldo":         0.00
  },
  {
    "id": 1100000228,
    "codigo": "589",
    "nombre": "VINA CAMOS",
    "cuit": "23-92345901-4",
    "saldo":         0.00
  },
  {
    "id": 1100000229,
    "codigo": "590",
    "nombre": "MARESCO DANIEL",
    "cuit": "20-14453842-1",
    "saldo":         0.00
  },
  {
    "id": 1100000230,
    "codigo": "591",
    "nombre": "INDUPASTAS",
    "cuit": "30-63819795-9",
    "saldo":         0.00
  },
  {
    "id": 1100000231,
    "codigo": "595",
    "nombre": "LOUJAN ALFREDO",
    "cuit": "20-03024719-2",
    "saldo":         0.00
  },
  {
    "id": 1100000232,
    "codigo": "596",
    "nombre": "BARRIO OSCAR GELIO",
    "cuit": "20-05448720-8",
    "saldo":         0.00
  },
  {
    "id": 1100000233,
    "codigo": "602",
    "nombre": "MARAÑOS JORGE",
    "cuit": "23-16206268-9",
    "saldo":         0.00
  },
  {
    "id": 1100000234,
    "codigo": "604",
    "nombre": "LAHOS BERRISTEGUI",
    "cuit": "30-52259153-6",
    "saldo":         0.00
  },
  {
    "id": 1100000235,
    "codigo": "606",
    "nombre": "GRUPO RESTO COSTA HNOS SRL (EF)",
    "cuit": "30-71123307-1",
    "saldo":     86493.26
  },
  {
    "id": 1100000236,
    "codigo": "608",
    "nombre": "MABE GUILLERMO",
    "cuit": "20-04525955-3",
    "saldo":         0.00
  },
  {
    "id": 1100000237,
    "codigo": "609",
    "nombre": "MERCOTE CARLOS",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000238,
    "codigo": "610",
    "nombre": "BOTINI EDGARDO",
    "cuit": "20-06077827-3",
    "saldo":         0.00
  },
  {
    "id": 1100000239,
    "codigo": "611",
    "nombre": "MERCERES AGUSTIN",
    "cuit": "20-22523604-7",
    "saldo":         0.00
  },
  {
    "id": 1100000240,
    "codigo": "612",
    "nombre": "AUMAR URIEL",
    "cuit": "20-06300711-1",
    "saldo":         0.00
  },
  {
    "id": 1100000241,
    "codigo": "614",
    "nombre": "KARTOVIC NELIDA",
    "cuit": "27-05171712-6",
    "saldo":         0.00
  },
  {
    "id": 1100000242,
    "codigo": "616",
    "nombre": "MAURI ENRIQUE",
    "cuit": "20-05497007-3",
    "saldo":         0.00
  },
  {
    "id": 1100000243,
    "codigo": "618",
    "nombre": "ARTAZCO OSVALDO O",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000244,
    "codigo": "619",
    "nombre": "ZANASCI ROSA",
    "cuit": "27-11089897-1",
    "saldo":         0.00
  },
  {
    "id": 1100000245,
    "codigo": "620",
    "nombre": "BERTINELLI ADELA MARCELINA",
    "cuit": "27-05198033-1",
    "saldo":         0.09
  },
  {
    "id": 1100000246,
    "codigo": "625",
    "nombre": "STEPANSICH LA - VIEJA ESQUINA",
    "cuit": "24-05439715-8",
    "saldo":         0.00
  },
  {
    "id": 1100000247,
    "codigo": "629",
    "nombre": "GUNGOLO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000248,
    "codigo": "630",
    "nombre": "PASTORE PABLO MARCELO",
    "cuit": "20-20044669-1",
    "saldo":         0.00
  },
  {
    "id": 1100000249,
    "codigo": "632",
    "nombre": "MONTIEL JOSE LUIS TESTA NORBERTO OSCAR",
    "cuit": "30-66422220-1",
    "saldo":         0.00
  },
  {
    "id": 1100000250,
    "codigo": "633",
    "nombre": "ALBARRACIN JULIO CARNC AVENIDA",
    "cuit": "20-13227519-0",
    "saldo":         0.00
  },
  {
    "id": 1100000251,
    "codigo": "638",
    "nombre": "ESCUDERO MARIA",
    "cuit": "27-06097161-0",
    "saldo":         0.00
  },
  {
    "id": 1100000252,
    "codigo": "640",
    "nombre": "MERCADITO CIBABIZ DE JC DONARI",
    "cuit": "20-05505686-3",
    "saldo":         0.00
  },
  {
    "id": 1100000253,
    "codigo": "641",
    "nombre": "JB MARITIMA",
    "cuit": "30-50699140-0",
    "saldo":         0.00
  },
  {
    "id": 1100000254,
    "codigo": "642",
    "nombre": "NEYRA PEDRO",
    "cuit": "20-92623025-0",
    "saldo":         0.00
  },
  {
    "id": 1100000255,
    "codigo": "646",
    "nombre": "MARAI SRL",
    "cuit": "30-66101224-9",
    "saldo":         0.00
  },
  {
    "id": 1100000256,
    "codigo": "648",
    "nombre": "GIMENEZ MIRTA",
    "cuit": "27-11314124-2",
    "saldo":         0.00
  },
  {
    "id": 1100000257,
    "codigo": "652",
    "nombre": "URVINA JUANA",
    "cuit": "23-12221113-4",
    "saldo":         0.00
  },
  {
    "id": 1100000258,
    "codigo": "653",
    "nombre": "PASTAS PAULINA SRL",
    "cuit": "30-57290100-5",
    "saldo":        -0.47
  },
  {
    "id": 1100000259,
    "codigo": "658",
    "nombre": "MORESCO",
    "cuit": "20-14453842-1",
    "saldo":         0.00
  },
  {
    "id": 1100000260,
    "codigo": "659",
    "nombre": "CATER SERVI",
    "cuit": "30-82031825-7",
    "saldo":         0.00
  },
  {
    "id": 1100000261,
    "codigo": "660",
    "nombre": "VANUCCI HUBER MARCELO",
    "cuit": "20-05444554-8",
    "saldo":         0.00
  },
  {
    "id": 1100000262,
    "codigo": "664",
    "nombre": "SCHMIDT JUAN CARLOS",
    "cuit": "23-13324086-9",
    "saldo":         0.00
  },
  {
    "id": 1100000263,
    "codigo": "666",
    "nombre": "MONTENEGRO ERNA DEL CARMEN",
    "cuit": "27-11341955-0",
    "saldo":         0.00
  },
  {
    "id": 1100000264,
    "codigo": "668",
    "nombre": "ROSAS LUIS ADRIAN",
    "cuit": "20-20851779-2",
    "saldo":         0.00
  },
  {
    "id": 1100000265,
    "codigo": "672",
    "nombre": "MARIA JUANA",
    "cuit": "23-04135405-4",
    "saldo":         0.00
  },
  {
    "id": 1100000266,
    "codigo": "674",
    "nombre": "PISTONE ROBERTO JOSE",
    "cuit": "20-05455840-3",
    "saldo":         0.00
  },
  {
    "id": 1100000267,
    "codigo": "676",
    "nombre": "BALERDI LILIANA CRISTINA",
    "cuit": "27-13796148-8",
    "saldo":         0.00
  },
  {
    "id": 1100000268,
    "codigo": "677",
    "nombre": "HU KING CHUNG",
    "cuit": "27-92887681-6",
    "saldo":         0.00
  },
  {
    "id": 1100000269,
    "codigo": "680",
    "nombre": "SUCDE MENDEZ JOSE ANTONIO",
    "cuit": "20-01138817-6",
    "saldo":         0.00
  },
  {
    "id": 1100000270,
    "codigo": "681",
    "nombre": "MAGARIÑOS ROVERTO",
    "cuit": "23-01991566-8",
    "saldo":         0.00
  },
  {
    "id": 1100000271,
    "codigo": "682",
    "nombre": "DINDART HNOS SRL",
    "cuit": "33-66419626-9",
    "saldo":         0.00
  },
  {
    "id": 1100000272,
    "codigo": "685",
    "nombre": "LA PREFERIDA",
    "cuit": "27-06255953-0",
    "saldo":         0.00
  },
  {
    "id": 1100000273,
    "codigo": "687",
    "nombre": "ZAPERI DANIEL",
    "cuit": "23-10228277-9",
    "saldo":         0.00
  },
  {
    "id": 1100000274,
    "codigo": "688",
    "nombre": "ORTIZ CLEMENTINA ISABEL",
    "cuit": "27-04412712-7",
    "saldo":         0.00
  },
  {
    "id": 1100000275,
    "codigo": "690",
    "nombre": "MUÑOS EDITH IRENE",
    "cuit": "24-04015559-3",
    "saldo":         0.00
  },
  {
    "id": 1100000276,
    "codigo": "691",
    "nombre": "MARIÑAS ARMANDO JOSE",
    "cuit": "20-05482200-7",
    "saldo":         0.00
  },
  {
    "id": 1100000277,
    "codigo": "700",
    "nombre": "FRIGORIFICO VILLA OLGA SA",
    "cuit": "30-60605463-3",
    "saldo":         0.00
  },
  {
    "id": 1100000278,
    "codigo": "703",
    "nombre": "ACTIS Y PLAZA",
    "cuit": "30-57067814-7",
    "saldo":         0.00
  },
  {
    "id": 1100000279,
    "codigo": "704",
    "nombre": "PAOLA CARLA SMIRAGLIA",
    "cuit": "27-20691130-7",
    "saldo":         0.00
  },
  {
    "id": 1100000280,
    "codigo": "706",
    "nombre": "ULLUA MIRTA IRMA",
    "cuit": "27-04552740-4",
    "saldo":         0.00
  },
  {
    "id": 1100000281,
    "codigo": "707",
    "nombre": "BOCCI MAXIMO JORGE",
    "cuit": "20-07650205-7",
    "saldo":         0.00
  },
  {
    "id": 1100000282,
    "codigo": "708",
    "nombre": "BOERO CARLOS OSCAR",
    "cuit": "20-10644048-5",
    "saldo":         0.00
  },
  {
    "id": 1100000283,
    "codigo": "709",
    "nombre": "COSTILLA ANABELA BEATRIZ",
    "cuit": "27-27429557-6",
    "saldo":         0.00
  },
  {
    "id": 1100000284,
    "codigo": "712",
    "nombre": "PICK-UP`S  BAHIA SA",
    "cuit": "30-63819719-3",
    "saldo":         0.00
  },
  {
    "id": 1100000285,
    "codigo": "716",
    "nombre": "RESTAURANT Y PARRILA LYON DOR",
    "cuit": "23-05454772-8",
    "saldo":         0.00
  },
  {
    "id": 1100000286,
    "codigo": "717",
    "nombre": "LAFFITE ALBERTO ALDO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000287,
    "codigo": "718",
    "nombre": "ABELLEIRA ROBERTO HUGO",
    "cuit": "20-05445354-0",
    "saldo":         0.00
  },
  {
    "id": 1100000288,
    "codigo": "719",
    "nombre": "PEREZ RUP",
    "cuit": "27-17235252-4",
    "saldo":         0.00
  },
  {
    "id": 1100000289,
    "codigo": "720",
    "nombre": "BERAMENDI VIVIANA",
    "cuit": "27-17429367-3",
    "saldo":         0.00
  },
  {
    "id": 1100000290,
    "codigo": "721",
    "nombre": "TERUEL EMILCE MIRTA",
    "cuit": "23-13227511-4",
    "saldo":         0.00
  },
  {
    "id": 1100000291,
    "codigo": "724",
    "nombre": "PEREZ JORGE HAROLDO",
    "cuit": "20-12057094-4",
    "saldo":         0.00
  },
  {
    "id": 1100000292,
    "codigo": "725",
    "nombre": "GIZEH SOC DE HECHO DE JULIO C",
    "cuit": "30-65588550-8",
    "saldo":         0.00
  },
  {
    "id": 1100000293,
    "codigo": "727",
    "nombre": "DOMINGUEZ HECTOR",
    "cuit": "20-14169414-7",
    "saldo":        -0.07
  },
  {
    "id": 1100000294,
    "codigo": "729",
    "nombre": "RIGUERO NESTOR OSCAR",
    "cuit": "20-11544646-1",
    "saldo":     59360.95
  },
  {
    "id": 1100000295,
    "codigo": "730",
    "nombre": "PIATTONI HECTOR",
    "cuit": "20-05509874-4",
    "saldo":         0.00
  },
  {
    "id": 1100000296,
    "codigo": "731",
    "nombre": "KLEIN MARCELA ROSANA",
    "cuit": "27-18041742-2",
    "saldo":        -0.01
  },
  {
    "id": 1100000297,
    "codigo": "733",
    "nombre": "GARCIA ALBERTO",
    "cuit": "20-05439589-3",
    "saldo":         0.00
  },
  {
    "id": 1100000298,
    "codigo": "738",
    "nombre": "STICKAR ALEXIS",
    "cuit": "20-22215769-3",
    "saldo":         0.51
  },
  {
    "id": 1100000299,
    "codigo": "739",
    "nombre": "FELIKS SZUSTER",
    "cuit": "20-15283972-4",
    "saldo":         0.00
  },
  {
    "id": 1100000300,
    "codigo": "740",
    "nombre": "FRIGORIFICO  A Y F",
    "cuit": "30-64314039-6",
    "saldo":         0.00
  },
  {
    "id": 1100000301,
    "codigo": "741",
    "nombre": "OLEODUCTO DEL VALLE SA",
    "cuit": "30-65884016-5",
    "saldo":         0.00
  },
  {
    "id": 1100000302,
    "codigo": "744",
    "nombre": "FERRARIS JUAN CARLOS",
    "cuit": "20-08029270-9",
    "saldo":         0.00
  },
  {
    "id": 1100000303,
    "codigo": "745",
    "nombre": "GONZALES WENDY MARIANA",
    "cuit": "27-22505447-4",
    "saldo":         0.00
  },
  {
    "id": 1100000304,
    "codigo": "746",
    "nombre": "CALCAGNI Y CIA",
    "cuit": "30-54065248-8",
    "saldo":         0.00
  },
  {
    "id": 1100000305,
    "codigo": "752",
    "nombre": "EL RODEO DE DANIEL SOULE - FIAMBRERIA -",
    "cuit": "30-10737602-0",
    "saldo":         0.00
  },
  {
    "id": 1100000306,
    "codigo": "753",
    "nombre": "ANTONELII ANGEL",
    "cuit": "20-05478642-6",
    "saldo":         0.00
  },
  {
    "id": 1100000307,
    "codigo": "755",
    "nombre": "GONZALES HUGO DANIEL",
    "cuit": "20-12904702-0",
    "saldo":        -2.22
  },
  {
    "id": 1100000308,
    "codigo": "757",
    "nombre": "NATALINI NOEMI CARMEN",
    "cuit": "27-12605655-4",
    "saldo":         0.00
  },
  {
    "id": 1100000309,
    "codigo": "759",
    "nombre": "DERIMAIS SILVIA RAQUEL",
    "cuit": "27-12458122-8",
    "saldo":         0.00
  },
  {
    "id": 1100000310,
    "codigo": "766",
    "nombre": "LAZARO MIGUEL ORLANDO",
    "cuit": "20-13471053-6",
    "saldo":         0.00
  },
  {
    "id": 1100000311,
    "codigo": "767",
    "nombre": "DAMICO JOSE PASCUAL",
    "cuit": "20-05474806-0",
    "saldo":         0.00
  },
  {
    "id": 1100000312,
    "codigo": "771",
    "nombre": "DE ARRIBA DANIEL ADRIAN",
    "cuit": "20-20989408-5",
    "saldo":        -0.01
  },
  {
    "id": 1100000313,
    "codigo": "772",
    "nombre": "POLLO,POLLO Y COMPANIA",
    "cuit": "27-04062127-5",
    "saldo":         0.00
  },
  {
    "id": 1100000314,
    "codigo": "773",
    "nombre": "IPARAGUIRRE BENITO EDGARDO",
    "cuit": "20-05497100-2",
    "saldo":         0.00
  },
  {
    "id": 1100000315,
    "codigo": "775",
    "nombre": "PRIETO MAGDALENA",
    "cuit": "27-01443277-4",
    "saldo":         0.00
  },
  {
    "id": 1100000316,
    "codigo": "776",
    "nombre": "NICOLOFF HECTOR",
    "cuit": "30-70737557-0",
    "saldo":         0.00
  },
  {
    "id": 1100000317,
    "codigo": "780",
    "nombre": "ORESTE OLGA ARLACERIS",
    "cuit": "27-02636648-3",
    "saldo":         0.00
  },
  {
    "id": 1100000318,
    "codigo": "782",
    "nombre": "GONZALES RAMON",
    "cuit": "20-07919259-8",
    "saldo":      1806.44
  },
  {
    "id": 1100000319,
    "codigo": "783",
    "nombre": "BAL PABLO OSVALDO",
    "cuit": "20-11089576-4",
    "saldo":         0.00
  },
  {
    "id": 1100000320,
    "codigo": "786",
    "nombre": "SERVICIOS INTEGRADOS SRL",
    "cuit": "30-58368299-2",
    "saldo":         0.00
  },
  {
    "id": 1100000321,
    "codigo": "789",
    "nombre": "DELLO RUSO RAFAEL HUGO Y GOMEZ ALBERTO D",
    "cuit": "30-66421319-9",
    "saldo":         0.00
  },
  {
    "id": 1100000322,
    "codigo": "792",
    "nombre": "TERUEL EMILCE",
    "cuit": "23-13227511-4",
    "saldo":         0.00
  },
  {
    "id": 1100000323,
    "codigo": "793",
    "nombre": "GUERREÑO LEANDRO",
    "cuit": "20-24095375-8",
    "saldo":         0.00
  },
  {
    "id": 1100000324,
    "codigo": "814",
    "nombre": "BUSINSKAS CARLOS A",
    "cuit": "20-16305874-0",
    "saldo":         0.00
  },
  {
    "id": 1100000325,
    "codigo": "816",
    "nombre": "VECCHIOTI DANIEL",
    "cuit": "20-18458500-7",
    "saldo":         0.00
  },
  {
    "id": 1100000326,
    "codigo": "821",
    "nombre": "LEON ABDELINA",
    "cuit": "27-14780394-5",
    "saldo":         0.00
  },
  {
    "id": 1100000327,
    "codigo": "823",
    "nombre": "MUNICIPALIDAD DE BAHIA BLANCA(CASA DEL C",
    "cuit": "30-99900209-5",
    "saldo":         0.00
  },
  {
    "id": 1100000328,
    "codigo": "824",
    "nombre": "DONGHI LILIANA ESTHER",
    "cuit": "27-12605563-9",
    "saldo":         0.00
  },
  {
    "id": 1100000329,
    "codigo": "827",
    "nombre": "MORENO ALBERTO",
    "cuit": "20-12862600-0",
    "saldo":         0.00
  },
  {
    "id": 1100000330,
    "codigo": "828",
    "nombre": "FUNDACION LA INMACULADA",
    "cuit": "34-64325033-2",
    "saldo":         0.00
  },
  {
    "id": 1100000331,
    "codigo": "831",
    "nombre": "CHIESA CARLOS",
    "cuit": "20-05514090-2",
    "saldo":         0.00
  },
  {
    "id": 1100000332,
    "codigo": "834",
    "nombre": "RAMIREZ ALICIA",
    "cuit": "23-04638870-4",
    "saldo":         0.00
  },
  {
    "id": 1100000333,
    "codigo": "837",
    "nombre": "OBERTI ANGEL LUIS",
    "cuit": "20-07650745-8",
    "saldo":         0.00
  },
  {
    "id": 1100000334,
    "codigo": "845",
    "nombre": "OJEDA MARGARITA",
    "cuit": "27-14892796-4",
    "saldo":         0.00
  },
  {
    "id": 1100000335,
    "codigo": "850",
    "nombre": "MENDEZ (PA)",
    "cuit": "20-05481086-6",
    "saldo":         0.00
  },
  {
    "id": 1100000336,
    "codigo": "859",
    "nombre": "SANSONI ROBERTO",
    "cuit": "20-21974921-0",
    "saldo":         0.00
  },
  {
    "id": 1100000337,
    "codigo": "862",
    "nombre": "ZARATE ANGELICA",
    "cuit": "27-05280181-3",
    "saldo":         0.00
  },
  {
    "id": 1100000338,
    "codigo": "868",
    "nombre": "VICTOR N CONTRERAS",
    "cuit": "33-50624902-9",
    "saldo":         0.00
  },
  {
    "id": 1100000339,
    "codigo": "875",
    "nombre": "SANCHEZ MARISA",
    "cuit": "23-21559473-4",
    "saldo":         0.00
  },
  {
    "id": 1100000340,
    "codigo": "878",
    "nombre": "GOMEZ MIRTA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000341,
    "codigo": "885",
    "nombre": "CECCHINI MARTA TERESA",
    "cuit": "23-10847263-9",
    "saldo":         0.00
  },
  {
    "id": 1100000342,
    "codigo": "891",
    "nombre": "MORENO FERNANDO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000343,
    "codigo": "892",
    "nombre": "TORREZ JORGE",
    "cuit": "20-20928268-3",
    "saldo":         0.00
  },
  {
    "id": 1100000344,
    "codigo": "894",
    "nombre": "SCHEER CARLOS ALBERTO",
    "cuit": "20-07664375-0",
    "saldo":         0.00
  },
  {
    "id": 1100000345,
    "codigo": "896",
    "nombre": "ECHEPARRE, EDUARDO",
    "cuit": "20-12836027-2",
    "saldo":         0.00
  },
  {
    "id": 1100000346,
    "codigo": "897",
    "nombre": "ASIAIN GABRIEL PABLO",
    "cuit": "23-04368267-9",
    "saldo":         0.00
  },
  {
    "id": 1100000347,
    "codigo": "899",
    "nombre": "UNION INDUSTRIAL BAHIA BLANCA",
    "cuit": "30-66419756-8",
    "saldo":      -292.76
  },
  {
    "id": 1100000348,
    "codigo": "905",
    "nombre": "SANCHEZ MARISA",
    "cuit": "23-21589473-4",
    "saldo":         0.00
  },
  {
    "id": 1100000349,
    "codigo": "906",
    "nombre": "PESCARGEN SOCIEDADD ANONIMA",
    "cuit": "30-57596116-5",
    "saldo":         0.00
  },
  {
    "id": 1100000350,
    "codigo": "907",
    "nombre": "ORTIZ SANDRO",
    "cuit": "20-14780406-8",
    "saldo":         0.00
  },
  {
    "id": 1100000351,
    "codigo": "909",
    "nombre": "VARELA LIA FANNY",
    "cuit": "27-01722065-4",
    "saldo":         0.00
  },
  {
    "id": 1100000352,
    "codigo": "910",
    "nombre": "UNAMUNO RUBEN",
    "cuit": "20-05109878-0",
    "saldo":         0.00
  },
  {
    "id": 1100000353,
    "codigo": "911",
    "nombre": "TIBURSI MARIO",
    "cuit": "20-16060389-6",
    "saldo":       276.86
  },
  {
    "id": 1100000354,
    "codigo": "915",
    "nombre": "MONTIEL JOSE LUIS",
    "cuit": "20-20025399-5",
    "saldo":         0.00
  },
  {
    "id": 1100000355,
    "codigo": "916",
    "nombre": "SPINOSO LUIS",
    "cuit": "20-17194777-5",
    "saldo":         0.00
  },
  {
    "id": 1100000356,
    "codigo": "917",
    "nombre": "ZUBINI NORMA LIDIA",
    "cuit": "23-04999516-4",
    "saldo":         0.00
  },
  {
    "id": 1100000357,
    "codigo": "926",
    "nombre": "MERINGER PEDRO DANIEL",
    "cuit": "20-12135803-5",
    "saldo":         0.00
  },
  {
    "id": 1100000358,
    "codigo": "927",
    "nombre": "DETZEL MARIA",
    "cuit": "27-04087977-9",
    "saldo":         0.00
  },
  {
    "id": 1100000359,
    "codigo": "938",
    "nombre": "VIOZZI OSVALDO",
    "cuit": "20-14148081-3",
    "saldo":         0.00
  },
  {
    "id": 1100000360,
    "codigo": "944",
    "nombre": "VILLARREAL DANIEL",
    "cuit": "20-11794161-3",
    "saldo":         0.00
  },
  {
    "id": 1100000361,
    "codigo": "945",
    "nombre": "PERA ACEBAL",
    "cuit": "30-56359804-9",
    "saldo":         0.00
  },
  {
    "id": 1100000362,
    "codigo": "946",
    "nombre": "VILLARREAL ELENA",
    "cuit": "27-05790905-1",
    "saldo":         0.00
  },
  {
    "id": 1100000363,
    "codigo": "952",
    "nombre": "ENRIQUE FRANZINO   (MERCADO)",
    "cuit": "20-08311107-1",
    "saldo":         0.00
  },
  {
    "id": 1100000364,
    "codigo": "954",
    "nombre": "GENDARMERIA NACIONAL",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000365,
    "codigo": "955",
    "nombre": "PUCCI JOSEFINA",
    "cuit": "23-01442237-4",
    "saldo":         0.00
  },
  {
    "id": 1100000366,
    "codigo": "956",
    "nombre": "LECOMTE CARLOS PEDRO",
    "cuit": "20-25493998-2",
    "saldo":         0.00
  },
  {
    "id": 1100000367,
    "codigo": "958",
    "nombre": "WENER ELLI",
    "cuit": "20-09445131-9",
    "saldo":         0.00
  },
  {
    "id": 1100000368,
    "codigo": "961",
    "nombre": "FABIAN MEDORI",
    "cuit": "23-17673320-9",
    "saldo":         0.00
  },
  {
    "id": 1100000369,
    "codigo": "963",
    "nombre": "FARIAS NICACIO",
    "cuit": "20-04143223-4",
    "saldo":         0.00
  },
  {
    "id": 1100000370,
    "codigo": "964",
    "nombre": "CASA DE ESPAÑA",
    "cuit": "33-65238141-9",
    "saldo":         0.00
  },
  {
    "id": 1100000371,
    "codigo": "966",
    "nombre": "CALVO ALFREDO",
    "cuit": "20-05451165-6",
    "saldo":         0.00
  },
  {
    "id": 1100000372,
    "codigo": "968",
    "nombre": "DINDART HNOS SRL",
    "cuit": "33-66419626-9",
    "saldo":         0.00
  },
  {
    "id": 1100000373,
    "codigo": "973",
    "nombre": "MUÑOZ GUILARDI HECTOR DEL ROSA",
    "cuit": "20-92401571-4",
    "saldo":         0.00
  },
  {
    "id": 1100000374,
    "codigo": "975",
    "nombre": "REYES ROSA",
    "cuit": "27-16072538-4",
    "saldo":         0.00
  },
  {
    "id": 1100000375,
    "codigo": "978",
    "nombre": "ORTEGA Y CIA SRL",
    "cuit": "30-53519616-4",
    "saldo":      8232.10
  },
  {
    "id": 1100000376,
    "codigo": "979",
    "nombre": "SANTIN ANTONIO",
    "cuit": "20-05487184-9",
    "saldo":         0.00
  },
  {
    "id": 1100000377,
    "codigo": "982",
    "nombre": "OBERST FELICIANO",
    "cuit": "20-16739050-2",
    "saldo":         0.00
  },
  {
    "id": 1100000378,
    "codigo": "986",
    "nombre": "EDUARDO FEDERICO BIANCO",
    "cuit": "20-10102981-7",
    "saldo":         0.00
  },
  {
    "id": 1100000379,
    "codigo": "1000",
    "nombre": "TAMALET NELI ESTHER",
    "cuit": "27-04090631-8",
    "saldo":         0.00
  },
  {
    "id": 1100000380,
    "codigo": "1002",
    "nombre": "LABINCA SA",
    "cuit": "30-50053702-3",
    "saldo":         0.00
  },
  {
    "id": 1100000381,
    "codigo": "1013",
    "nombre": "SERVICIOS HLB SA",
    "cuit": "30-70798086-5",
    "saldo":         0.00
  },
  {
    "id": 1100000382,
    "codigo": "1015",
    "nombre": "BERTI IRMA NOEMI",
    "cuit": "23-06229295-4",
    "saldo":         0.00
  },
  {
    "id": 1100000383,
    "codigo": "1018",
    "nombre": "CARLOS RONDA",
    "cuit": "20-05493943-7",
    "saldo":         0.00
  },
  {
    "id": 1100000384,
    "codigo": "1019",
    "nombre": "PUNTA PALIHUE SA",
    "cuit": "30-66417286-7",
    "saldo":         0.00
  },
  {
    "id": 1100000385,
    "codigo": "1021",
    "nombre": "CASTILLO P - VACCANI M",
    "cuit": "33-66422039-9",
    "saldo":         0.00
  },
  {
    "id": 1100000386,
    "codigo": "1027",
    "nombre": "RODRIGUEZ RAIMUNDO",
    "cuit": "20-05508761-0",
    "saldo":         0.00
  },
  {
    "id": 1100000387,
    "codigo": "1032",
    "nombre": "ASOCIACION DE LOS TESTIGOS DE JEHOVA",
    "cuit": "30-62671206-8",
    "saldo":         0.00
  },
  {
    "id": 1100000388,
    "codigo": "1033",
    "nombre": "MOLINERO GERARDO JAVIER",
    "cuit": "20-20030915-5",
    "saldo":         0.00
  },
  {
    "id": 1100000389,
    "codigo": "1034",
    "nombre": "LA MORA",
    "cuit": "30-64285709-0",
    "saldo":         0.00
  },
  {
    "id": 1100000390,
    "codigo": "1040",
    "nombre": "RODRIGUES GERARDO",
    "cuit": "20-04891982-1",
    "saldo":         0.00
  },
  {
    "id": 1100000391,
    "codigo": "1042",
    "nombre": "RANCHO JR SRL",
    "cuit": "30-68113755-2",
    "saldo":         0.00
  },
  {
    "id": 1100000392,
    "codigo": "1046",
    "nombre": "FLOTA DE MAR",
    "cuit": "30-54669501-4",
    "saldo":        -0.04
  },
  {
    "id": 1100000393,
    "codigo": "1047",
    "nombre": "PASCUAL HNOS (SUC NVA)",
    "cuit": "30-53640060-1",
    "saldo":         0.00
  },
  {
    "id": 1100000394,
    "codigo": "1048",
    "nombre": "ESTER RITA CRUCEÑO",
    "cuit": "20-06295828-1",
    "saldo":         0.00
  },
  {
    "id": 1100000395,
    "codigo": "1051",
    "nombre": "COLEGIO DON BOSCO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000396,
    "codigo": "1053",
    "nombre": "BIONDO ANGEL",
    "cuit": "20-10106028-5",
    "saldo":         0.00
  },
  {
    "id": 1100000397,
    "codigo": "1055",
    "nombre": "ORTIZ BETANCOUR SANDRO",
    "cuit": "20-14780406-8",
    "saldo":         0.00
  },
  {
    "id": 1100000398,
    "codigo": "1056",
    "nombre": "OCA",
    "cuit": "30-53625919-4",
    "saldo":         0.00
  },
  {
    "id": 1100000399,
    "codigo": "1070",
    "nombre": "FANTAGUZZI BLANCA",
    "cuit": "27-04065463-7",
    "saldo":         0.00
  },
  {
    "id": 1100000400,
    "codigo": "1073",
    "nombre": "COMBUSTIBLES EL FORTIN SRL",
    "cuit": "30-51774224-0",
    "saldo":         0.00
  },
  {
    "id": 1100000401,
    "codigo": "1080",
    "nombre": "GATTI MARCELA EDITH",
    "cuit": "27-18454771-1",
    "saldo":         0.00
  },
  {
    "id": 1100000402,
    "codigo": "1082",
    "nombre": "ATILIO MARTIN",
    "cuit": "23-05450871-9",
    "saldo":         0.00
  },
  {
    "id": 1100000403,
    "codigo": "1084",
    "nombre": "COLEGIO MARIA AUXILIADORA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000404,
    "codigo": "1089",
    "nombre": "GONZALES IRAM",
    "cuit": "20-12836266-6",
    "saldo":         0.00
  },
  {
    "id": 1100000405,
    "codigo": "1090",
    "nombre": "LAMBICCHI HECTOR O",
    "cuit": "20-05501547-4",
    "saldo":     11921.39
  },
  {
    "id": 1100000406,
    "codigo": "1105",
    "nombre": "MASSETTI ENRIQUE EDGARDO COSM",
    "cuit": "20-05513610-7",
    "saldo":         0.00
  },
  {
    "id": 1100000407,
    "codigo": "1106",
    "nombre": "GAROFOLI ROBERTO EMILIO",
    "cuit": "20-13836645-7",
    "saldo":         0.00
  },
  {
    "id": 1100000408,
    "codigo": "1108",
    "nombre": "LAZARO BRESLER",
    "cuit": "20-17403610-2",
    "saldo":         0.00
  },
  {
    "id": 1100000409,
    "codigo": "1116",
    "nombre": "OLIVERA ANIBAL",
    "cuit": "20-05507267-2",
    "saldo":         0.00
  },
  {
    "id": 1100000410,
    "codigo": "1117",
    "nombre": "GASTRONOMICA BELGRANO (MTEHSO)",
    "cuit": "30-65976322-9",
    "saldo":         0.00
  },
  {
    "id": 1100000411,
    "codigo": "1126",
    "nombre": "MONTIEL JOSE LUIS - SUC CORDOBA",
    "cuit": "20-20025399-5",
    "saldo":         0.00
  },
  {
    "id": 1100000412,
    "codigo": "1129",
    "nombre": "ROSAS LUIS ADRIAN (BROWN)",
    "cuit": "20-20851779-2",
    "saldo":         0.00
  },
  {
    "id": 1100000413,
    "codigo": "1130",
    "nombre": "ROSAS LUIS ADRIAN (S Y L)",
    "cuit": "20-20851779-2",
    "saldo":         0.00
  },
  {
    "id": 1100000414,
    "codigo": "1131",
    "nombre": "ROSAS LUIS ADRIAN (C E I)",
    "cuit": "20-20851779-2",
    "saldo":         0.00
  },
  {
    "id": 1100000415,
    "codigo": "1138",
    "nombre": "ESTEBE MARIA E - ROTISERIA PLAZA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000416,
    "codigo": "1139",
    "nombre": "SARNETI ROSA",
    "cuit": "27-02759148-0",
    "saldo":         0.00
  },
  {
    "id": 1100000417,
    "codigo": "1144",
    "nombre": "MARTIN, NANCY ETHEL GOMEZ DE",
    "cuit": "23-04088277-4",
    "saldo":         0.00
  },
  {
    "id": 1100000418,
    "codigo": "1145",
    "nombre": "BARRERA",
    "cuit": "20-07848218-5",
    "saldo":         0.00
  },
  {
    "id": 1100000419,
    "codigo": "1146",
    "nombre": "CORREA SILVIA",
    "cuit": "27-06284709-9",
    "saldo":         0.00
  },
  {
    "id": 1100000420,
    "codigo": "1147",
    "nombre": "LA SIRENA SA",
    "cuit": "30-64209135-9",
    "saldo":        -0.45
  },
  {
    "id": 1100000421,
    "codigo": "1150",
    "nombre": "BULLA JUAN CARLOS",
    "cuit": "20-12795573-6",
    "saldo":         0.00
  },
  {
    "id": 1100000422,
    "codigo": "1151",
    "nombre": "RESTIFFO DANIEL MAURICIO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000423,
    "codigo": "1153",
    "nombre": "ESCUELA N§ 47 COOPERATIVA",
    "cuit": "30-65733431-2",
    "saldo":         0.00
  },
  {
    "id": 1100000424,
    "codigo": "1154",
    "nombre": "MUNICH III",
    "cuit": "20-17749086-6",
    "saldo":         0.00
  },
  {
    "id": 1100000425,
    "codigo": "1157",
    "nombre": "LOS PAMPEANITOS",
    "cuit": "30-59271116-4",
    "saldo":         0.00
  },
  {
    "id": 1100000426,
    "codigo": "1160",
    "nombre": "CANALIS ELENA",
    "cuit": "27-02790328-8",
    "saldo":         0.00
  },
  {
    "id": 1100000427,
    "codigo": "1162",
    "nombre": "SCHNEIDER HILDA ROSA",
    "cuit": "27-06151459-2",
    "saldo":         0.00
  },
  {
    "id": 1100000428,
    "codigo": "1164",
    "nombre": "RABIONE RICARDO Y CIA",
    "cuit": "30-50990304-9",
    "saldo":         0.00
  },
  {
    "id": 1100000429,
    "codigo": "1165",
    "nombre": "BARONA NESTOR",
    "cuit": "30-66422237-6",
    "saldo":         0.00
  },
  {
    "id": 1100000430,
    "codigo": "1166",
    "nombre": "STREITENBERGER ANA DELVECIA",
    "cuit": "23-03938118-4",
    "saldo":         0.00
  },
  {
    "id": 1100000431,
    "codigo": "1171",
    "nombre": "FIERRO MIRTA",
    "cuit": "27-04552740-4",
    "saldo":         0.00
  },
  {
    "id": 1100000432,
    "codigo": "1173",
    "nombre": "ALBERTOLI ROBERTO CESAR",
    "cuit": "20-08397552-1",
    "saldo":         0.00
  },
  {
    "id": 1100000433,
    "codigo": "1179",
    "nombre": "QUIÑENAO JULIA",
    "cuit": "27-02297292-3",
    "saldo":         0.00
  },
  {
    "id": 1100000434,
    "codigo": "1181",
    "nombre": "LONGAS",
    "cuit": "20-05428046-8",
    "saldo":         0.00
  },
  {
    "id": 1100000435,
    "codigo": "1191",
    "nombre": "RODRIGUEZ AMANDA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000436,
    "codigo": "1194",
    "nombre": "ESPIZUA RICARDO PAULINO",
    "cuit": "20-26958640-1",
    "saldo":         0.00
  },
  {
    "id": 1100000437,
    "codigo": "1197",
    "nombre": "EL RODEO DE DANIEL SOULE (2)",
    "cuit": "30-10737602-0",
    "saldo":         0.00
  },
  {
    "id": 1100000438,
    "codigo": "1202",
    "nombre": "GOMEZ GUASTAVO ANIBAL",
    "cuit": "20-14780192-1",
    "saldo":         0.00
  },
  {
    "id": 1100000439,
    "codigo": "1210",
    "nombre": "ZACCARIN ENRIQUE DANIEL - DESPENSA SAN C",
    "cuit": "23-10598306-9",
    "saldo":        -1.74
  },
  {
    "id": 1100000440,
    "codigo": "1211",
    "nombre": "VIVES ANTONIO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000441,
    "codigo": "1215",
    "nombre": "EL TRIANGULO SA",
    "cuit": "33-56100334-9",
    "saldo":         0.00
  },
  {
    "id": 1100000442,
    "codigo": "1220",
    "nombre": "PEREZ RUTH",
    "cuit": "27-17235252-4",
    "saldo":         0.00
  },
  {
    "id": 1100000443,
    "codigo": "1222",
    "nombre": "MITILLI SRL",
    "cuit": "30-70962477-2",
    "saldo":     16315.31
  },
  {
    "id": 1100000444,
    "codigo": "1224",
    "nombre": "MANOSALVA SILVIA",
    "cuit": "27-92453768-5",
    "saldo":         0.00
  },
  {
    "id": 1100000445,
    "codigo": "1231",
    "nombre": "ASSI JULIO",
    "cuit": "20-13564454-5",
    "saldo":         0.00
  },
  {
    "id": 1100000446,
    "codigo": "1232",
    "nombre": "ORDIALES NELIDA",
    "cuit": "27-05121917-6",
    "saldo":         0.00
  },
  {
    "id": 1100000447,
    "codigo": "1234",
    "nombre": "CIMBA COMPA LA INT DE BEBIDAS Y ALIM SOC",
    "cuit": "30-50370362-5",
    "saldo":         0.00
  },
  {
    "id": 1100000448,
    "codigo": "1242",
    "nombre": "ESTRADA VICENTE",
    "cuit": "20-14533964-3",
    "saldo":      1156.95
  },
  {
    "id": 1100000449,
    "codigo": "1245",
    "nombre": "SEIBEL JUAN",
    "cuit": "20-11787028-7",
    "saldo":         0.00
  },
  {
    "id": 1100000450,
    "codigo": "1250",
    "nombre": "DELLA NONA",
    "cuit": "30-65960934-3",
    "saldo":         0.00
  },
  {
    "id": 1100000451,
    "codigo": "1251",
    "nombre": "CECCHI LILIANA MABEL",
    "cuit": "27-13836555-2",
    "saldo":         0.00
  },
  {
    "id": 1100000452,
    "codigo": "1253",
    "nombre": "CERDEIRA JUAN CARLOS",
    "cuit": "20-05491147-6",
    "saldo":         0.00
  },
  {
    "id": 1100000453,
    "codigo": "1257",
    "nombre": "BELTRAN MARIA GUADALUPE",
    "cuit": "27-27131450-2",
    "saldo":         0.00
  },
  {
    "id": 1100000454,
    "codigo": "1259",
    "nombre": "STORTINI NORMA",
    "cuit": "23-01440956-4",
    "saldo":         0.00
  },
  {
    "id": 1100000455,
    "codigo": "1260",
    "nombre": "LA POSTA SRL",
    "cuit": "33-66416337-9",
    "saldo":         0.00
  },
  {
    "id": 1100000456,
    "codigo": "1261",
    "nombre": "CRESPO CHRISTIAN",
    "cuit": "20-23776366-2",
    "saldo":         0.00
  },
  {
    "id": 1100000457,
    "codigo": "1264",
    "nombre": "AUTOSERVICIO LAINEZ",
    "cuit": "27-01443544-7",
    "saldo":         0.00
  },
  {
    "id": 1100000458,
    "codigo": "1271",
    "nombre": "ZAPACOSTA CARLOS Y GUILLERMEC C",
    "cuit": "30-56132241-0",
    "saldo":         0.00
  },
  {
    "id": 1100000459,
    "codigo": "1272",
    "nombre": "FRANCESCHI RICARDO OSCAR",
    "cuit": "20-04924081-4",
    "saldo":         0.00
  },
  {
    "id": 1100000460,
    "codigo": "1273",
    "nombre": "SCHAFER ROSA",
    "cuit": "27-11913698-4",
    "saldo":         0.00
  },
  {
    "id": 1100000461,
    "codigo": "1276",
    "nombre": "MANDATORI DANIEL",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000462,
    "codigo": "1277",
    "nombre": "LAR SA (BROWN42)",
    "cuit": "30-66421975-8",
    "saldo":         0.00
  },
  {
    "id": 1100000463,
    "codigo": "1278",
    "nombre": "SUAREZ CELESTINO",
    "cuit": "20-04873285-3",
    "saldo":         0.00
  },
  {
    "id": 1100000464,
    "codigo": "1282",
    "nombre": "FRANCANO JUAN CARLOS",
    "cuit": "20-10216802-0",
    "saldo":         0.00
  },
  {
    "id": 1100000465,
    "codigo": "1284",
    "nombre": "NARETO OSVALSO",
    "cuit": "20-07390484-7",
    "saldo":         0.00
  },
  {
    "id": 1100000466,
    "codigo": "1287",
    "nombre": "PREV DEL TRAUMA PEDIATRICO ASOC CIVIL",
    "cuit": "30-70887121-0",
    "saldo":         0.00
  },
  {
    "id": 1100000467,
    "codigo": "1288",
    "nombre": "BAUER NELIDA",
    "cuit": "27-04135537-4",
    "saldo":         0.00
  },
  {
    "id": 1100000468,
    "codigo": "1293",
    "nombre": "SARRACHAGA ISABEL",
    "cuit": "27-04748787-6",
    "saldo":         0.00
  },
  {
    "id": 1100000469,
    "codigo": "1294",
    "nombre": "COPO DE NIEVE",
    "cuit": "20-05514978-0",
    "saldo":         0.00
  },
  {
    "id": 1100000470,
    "codigo": "1301",
    "nombre": "CHADER (CF)",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000471,
    "codigo": "1303",
    "nombre": "SANDRONI 1847",
    "cuit": "20-11775450-3",
    "saldo":         0.00
  },
  {
    "id": 1100000472,
    "codigo": "1308",
    "nombre": "MARTELLINI HUGO",
    "cuit": "30-64436928-1",
    "saldo":         0.00
  },
  {
    "id": 1100000473,
    "codigo": "1314",
    "nombre": "SCHMIDT MARIA ELIDA",
    "cuit": "27-02759275-4",
    "saldo":        -0.01
  },
  {
    "id": 1100000474,
    "codigo": "1315",
    "nombre": "GASPARRI MURGOITIA Y COPRENI",
    "cuit": "33-61348631-9",
    "saldo":         0.00
  },
  {
    "id": 1100000475,
    "codigo": "1320",
    "nombre": "BAROU BEATRIZ",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000476,
    "codigo": "1321",
    "nombre": "GARCIA GRACIELA",
    "cuit": "27-12725889-4",
    "saldo":         0.00
  },
  {
    "id": 1100000477,
    "codigo": "1322",
    "nombre": "FUICA MIGUEL ANGEL",
    "cuit": "20-10388084-0",
    "saldo":         0.00
  },
  {
    "id": 1100000478,
    "codigo": "1324",
    "nombre": "SAREDI CARLOS ALEJANDRO (CLUB DE GOLF)",
    "cuit": "20-10133189-0",
    "saldo":         0.00
  },
  {
    "id": 1100000479,
    "codigo": "1328",
    "nombre": "NASS SCHELL",
    "cuit": "20-20045651-4",
    "saldo":         0.00
  },
  {
    "id": 1100000480,
    "codigo": "1329",
    "nombre": "RENSI NESTOR",
    "cuit": "23-05512155-9",
    "saldo":         0.00
  },
  {
    "id": 1100000481,
    "codigo": "1332",
    "nombre": "MARTINEZ GUSTAVO - PIZZANGELO",
    "cuit": "30-66418350-3",
    "saldo":         0.00
  },
  {
    "id": 1100000482,
    "codigo": "1333",
    "nombre": "SILVEYRA PABLO",
    "cuit": "23-22845259-9",
    "saldo":         0.00
  },
  {
    "id": 1100000483,
    "codigo": "1337",
    "nombre": "PIPKIN MANUEL SA",
    "cuit": "30-52983867-7",
    "saldo":         0.00
  },
  {
    "id": 1100000484,
    "codigo": "1340",
    "nombre": "MERCADO MARIA",
    "cuit": "27-10572333-3",
    "saldo":         0.00
  },
  {
    "id": 1100000485,
    "codigo": "1341",
    "nombre": "AVERSANO ALEJANDRO",
    "cuit": "20-16068619-8",
    "saldo":         0.00
  },
  {
    "id": 1100000486,
    "codigo": "1346",
    "nombre": "DIETRICH JOSE LUIS",
    "cuit": "20-16968849-5",
    "saldo":         0.00
  },
  {
    "id": 1100000487,
    "codigo": "1348",
    "nombre": "GALVAN DORA",
    "cuit": "27-10618939-6",
    "saldo":         0.00
  },
  {
    "id": 1100000488,
    "codigo": "1349",
    "nombre": "KOLLER JOSE",
    "cuit": "20-05484810-5",
    "saldo":         0.00
  },
  {
    "id": 1100000489,
    "codigo": "1355",
    "nombre": "GOMEZ RAUL",
    "cuit": "20-54588861-0",
    "saldo":         0.00
  },
  {
    "id": 1100000490,
    "codigo": "1357",
    "nombre": "ALARCON FEBE",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000491,
    "codigo": "1358",
    "nombre": "OVIEDO HECTOR SANTOS",
    "cuit": "20-05515602-7",
    "saldo":         0.00
  },
  {
    "id": 1100000492,
    "codigo": "1364",
    "nombre": "AIMAR MELVA",
    "cuit": "27-11913496-5",
    "saldo":         0.00
  },
  {
    "id": 1100000493,
    "codigo": "1366",
    "nombre": "FABOZZI OSVALDO ANTONIO",
    "cuit": "20-22277178-2",
    "saldo":         0.00
  },
  {
    "id": 1100000494,
    "codigo": "1369",
    "nombre": "LA COSTANERA SA",
    "cuit": "30-61319556-0",
    "saldo":         0.00
  },
  {
    "id": 1100000495,
    "codigo": "1370",
    "nombre": "GANDINI RUBEN",
    "cuit": "20-05495984-9",
    "saldo":         0.00
  },
  {
    "id": 1100000496,
    "codigo": "1373",
    "nombre": "APRAIZ MIRIAM SUSANA",
    "cuit": "27-12963675-6",
    "saldo":         0.00
  },
  {
    "id": 1100000497,
    "codigo": "1374",
    "nombre": "GUTIERRES GUILLERMO ANIBAL Y G",
    "cuit": "30-67165450-8",
    "saldo":         0.00
  },
  {
    "id": 1100000498,
    "codigo": "1378",
    "nombre": "CARRICA VICTOR AGUSTIN",
    "cuit": "23-13836456-9",
    "saldo":         0.00
  },
  {
    "id": 1100000499,
    "codigo": "1381",
    "nombre": "DONATI NORBERTO",
    "cuit": "20-05512371-4",
    "saldo":         0.00
  },
  {
    "id": 1100000500,
    "codigo": "1382",
    "nombre": "RODRIGUEZ NELIDA (CARN)",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000501,
    "codigo": "1383",
    "nombre": "GRAFF HNOS",
    "cuit": "30-62455455-4",
    "saldo":         0.00
  },
  {
    "id": 1100000502,
    "codigo": "1385",
    "nombre": "GIMENEZ VICTOR LUJAN",
    "cuit": "20-05536728-1",
    "saldo":         0.00
  },
  {
    "id": 1100000503,
    "codigo": "1389",
    "nombre": "SACK CARINA SOLEDAD",
    "cuit": "27-24017758-2",
    "saldo":         0.00
  },
  {
    "id": 1100000504,
    "codigo": "1390",
    "nombre": "CENTRO AMBRUSECE",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000505,
    "codigo": "1393",
    "nombre": "VAZQUEZ MOYA",
    "cuit": "27-92030733-2",
    "saldo":         0.00
  },
  {
    "id": 1100000506,
    "codigo": "1400",
    "nombre": "CORONEL CATALINA",
    "cuit": "27-92122226-8",
    "saldo":         0.00
  },
  {
    "id": 1100000507,
    "codigo": "1402",
    "nombre": "ADESCKY MARCOS",
    "cuit": "20-04243992-5",
    "saldo":         0.00
  },
  {
    "id": 1100000508,
    "codigo": "1408",
    "nombre": "BOCCI MAXIMO",
    "cuit": "20-07650205-7",
    "saldo":         0.00
  },
  {
    "id": 1100000509,
    "codigo": "1412",
    "nombre": "CASTELLANO MARIA",
    "cuit": "23-10388140-4",
    "saldo":      1053.45
  },
  {
    "id": 1100000510,
    "codigo": "1413",
    "nombre": "SMIDT MONICA",
    "cuit": "27-12963511-3",
    "saldo":        -0.04
  },
  {
    "id": 1100000511,
    "codigo": "1415",
    "nombre": "IBAÑEZ ALICIA",
    "cuit": "27-01191403-4",
    "saldo":         0.00
  },
  {
    "id": 1100000512,
    "codigo": "1417",
    "nombre": "GARCIA RICARDO",
    "cuit": "20-12278551-4",
    "saldo":         0.00
  },
  {
    "id": 1100000513,
    "codigo": "1418",
    "nombre": "MARCHESSE ERNESTO",
    "cuit": "20-05488050-3",
    "saldo":         0.00
  },
  {
    "id": 1100000514,
    "codigo": "1419",
    "nombre": "DELVIEUX GUSTAVO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000515,
    "codigo": "1420",
    "nombre": "LEAL MATILDE",
    "cuit": "27-17647219-2",
    "saldo":         0.00
  },
  {
    "id": 1100000516,
    "codigo": "1423",
    "nombre": "CADENAS LUIS",
    "cuit": "20-14533698-9",
    "saldo":         8.27
  },
  {
    "id": 1100000517,
    "codigo": "1430",
    "nombre": "VITA AURELIO",
    "cuit": "27-03542236-9",
    "saldo":         0.00
  },
  {
    "id": 1100000518,
    "codigo": "1432",
    "nombre": "LAR SA (BRIKMAN Y 25 DE MAYO)",
    "cuit": "30-66421975-8",
    "saldo":         0.00
  },
  {
    "id": 1100000519,
    "codigo": "1433",
    "nombre": "FERNANDEZ OSVALDO",
    "cuit": "23-05460672-9",
    "saldo":         0.00
  },
  {
    "id": 1100000520,
    "codigo": "1434",
    "nombre": "LARRINA ANTONIO",
    "cuit": "20-15302223-3",
    "saldo":         0.00
  },
  {
    "id": 1100000521,
    "codigo": "1435",
    "nombre": "SCHILL JAKOBO",
    "cuit": "20-05500480-4",
    "saldo":         0.00
  },
  {
    "id": 1100000522,
    "codigo": "1436",
    "nombre": "VEGA  ARIAS ARNOLDO",
    "cuit": "20-18687654-8",
    "saldo":     10368.73
  },
  {
    "id": 1100000523,
    "codigo": "1438",
    "nombre": "DIAZ LUIS",
    "cuit": "20-11981489-5",
    "saldo":         0.00
  },
  {
    "id": 1100000524,
    "codigo": "1440",
    "nombre": "CADENAS ROBERTO",
    "cuit": "20-24924985-9",
    "saldo":      2521.04
  },
  {
    "id": 1100000525,
    "codigo": "1441",
    "nombre": "ALMIRON PIO FIDEL",
    "cuit": "20-05490818-1",
    "saldo":         0.00
  },
  {
    "id": 1100000526,
    "codigo": "1443",
    "nombre": "GAUNA FABIAN EDUARDO Y MONTECINO SANTIAG",
    "cuit": "30-71091476-8",
    "saldo":         0.00
  },
  {
    "id": 1100000527,
    "codigo": "1445",
    "nombre": "URRUTI DANIEL",
    "cuit": "20-08435258-7",
    "saldo":         0.00
  },
  {
    "id": 1100000528,
    "codigo": "1446",
    "nombre": "JESSER ALFREDO",
    "cuit": "20-14595347-3",
    "saldo":         0.00
  },
  {
    "id": 1100000529,
    "codigo": "1449",
    "nombre": "SANCHEZ A NESTOR",
    "cuit": "20-05497798-1",
    "saldo":         0.00
  },
  {
    "id": 1100000530,
    "codigo": "1455",
    "nombre": "LISCHESKE GERMAN",
    "cuit": "20-14688605-2",
    "saldo":         0.00
  },
  {
    "id": 1100000531,
    "codigo": "1456",
    "nombre": "VITALE SANDRA",
    "cuit": "27-18565620-4",
    "saldo":         0.00
  },
  {
    "id": 1100000532,
    "codigo": "1464",
    "nombre": "AIMAR MELBA",
    "cuit": "27-11913496-5",
    "saldo":         0.00
  },
  {
    "id": 1100000533,
    "codigo": "1467",
    "nombre": "SCOZZAFAVA FRANCISCO",
    "cuit": "20-11674955-7",
    "saldo":         0.00
  },
  {
    "id": 1100000534,
    "codigo": "1470",
    "nombre": "HERBALEJO CLARA EDELMA",
    "cuit": "27-03951419-8",
    "saldo":         0.00
  },
  {
    "id": 1100000535,
    "codigo": "1472",
    "nombre": "GIAMBARTOLOMEI LUIS",
    "cuit": "20-11010871-1",
    "saldo":         0.00
  },
  {
    "id": 1100000536,
    "codigo": "1477",
    "nombre": "BORDENABE JULIO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000537,
    "codigo": "1478",
    "nombre": "CACHEIRO MARIO OSCAR",
    "cuit": "20-08312328-2",
    "saldo":         0.00
  },
  {
    "id": 1100000538,
    "codigo": "1481",
    "nombre": "COFRE CARRASCO MARIA ISABEL",
    "cuit": "27-18668996-3",
    "saldo":         0.00
  },
  {
    "id": 1100000539,
    "codigo": "1484",
    "nombre": "ACEITUNO ADRIAN",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000540,
    "codigo": "1497",
    "nombre": "DEL REUX JORGE",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000541,
    "codigo": "1498",
    "nombre": "MAURI NILDA ESTER",
    "cuit": "27-05792083-7",
    "saldo":         0.00
  },
  {
    "id": 1100000542,
    "codigo": "1500",
    "nombre": "LA CABAÑA DE PEDRO RAYEB",
    "cuit": "30-58431964-6",
    "saldo":         0.00
  },
  {
    "id": 1100000543,
    "codigo": "1508",
    "nombre": "COMBUSTIBLES EL FORTIN",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000544,
    "codigo": "1520",
    "nombre": "DELLO RUSO (LA MORENITA)",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000545,
    "codigo": "1523",
    "nombre": "RUPEL HECTOR ALBERTO",
    "cuit": "20-12278949-8",
    "saldo":         0.00
  },
  {
    "id": 1100000546,
    "codigo": "1526",
    "nombre": "SPAGLIARI LUIS ROBERTO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000547,
    "codigo": "1527",
    "nombre": "GONZALEZ ENRIQUE",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000548,
    "codigo": "1549",
    "nombre": "COLOMBO JUAN",
    "cuit": "23-15311507-9",
    "saldo":         0.00
  },
  {
    "id": 1100000549,
    "codigo": "1554",
    "nombre": "OTTONE MONICA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000550,
    "codigo": "1556",
    "nombre": "MENDIONE GABRIELA",
    "cuit": "27-01764700-9",
    "saldo":         0.00
  },
  {
    "id": 1100000551,
    "codigo": "1561",
    "nombre": "JOSEFINA PUCCI",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000552,
    "codigo": "1563",
    "nombre": "CARLOS DI MARCO",
    "cuit": "20-08435302-8",
    "saldo":         0.00
  },
  {
    "id": 1100000553,
    "codigo": "1565",
    "nombre": "FABRIQUE NORMA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000554,
    "codigo": "1567",
    "nombre": "PUEBLAS ADRIAN",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000555,
    "codigo": "1571",
    "nombre": "PASI MARINA",
    "cuit": "27-02452868-0",
    "saldo":         0.00
  },
  {
    "id": 1100000556,
    "codigo": "1572",
    "nombre": "GIL NORBERTO",
    "cuit": "20-05514883-0",
    "saldo":         0.00
  },
  {
    "id": 1100000557,
    "codigo": "1586",
    "nombre": "LA HERRADURA - DIB ELIAS",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000558,
    "codigo": "1594",
    "nombre": "RUPPEL MARTIN",
    "cuit": "20-22507265-6",
    "saldo":         2.10
  },
  {
    "id": 1100000559,
    "codigo": "1600",
    "nombre": "KASZA BOGUSTAW JOZEL",
    "cuit": "20-93322160-2",
    "saldo":         0.00
  },
  {
    "id": 1100000560,
    "codigo": "1601",
    "nombre": "ROSENDO JUAN CARLOS",
    "cuit": "20-10480987-2",
    "saldo":         0.00
  },
  {
    "id": 1100000561,
    "codigo": "1603",
    "nombre": "CRUCIANELLI EDUARDO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000562,
    "codigo": "1616",
    "nombre": "GONZALEZ GABRIEL",
    "cuit": "20-14780061-5",
    "saldo":         0.00
  },
  {
    "id": 1100000563,
    "codigo": "1618",
    "nombre": "VELASCO RUBEN DARIO",
    "cuit": "20-14085514-7",
    "saldo":         0.00
  },
  {
    "id": 1100000564,
    "codigo": "1624",
    "nombre": "ACEITUNO GRACIELA",
    "cuit": "27-12038779-6",
    "saldo":         0.00
  },
  {
    "id": 1100000565,
    "codigo": "1627",
    "nombre": "POSTAY SILVIA",
    "cuit": "27-22121643-7",
    "saldo":         0.00
  },
  {
    "id": 1100000566,
    "codigo": "1628",
    "nombre": "ARAQUE JULIO",
    "cuit": "20-05536619-6",
    "saldo":         0.00
  },
  {
    "id": 1100000567,
    "codigo": "1631",
    "nombre": "QUE POLLO - MARCIALETI",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000568,
    "codigo": "1641",
    "nombre": "CORONEL CATALINA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000569,
    "codigo": "1644",
    "nombre": "MORENO SILVIA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000570,
    "codigo": "1645",
    "nombre": "ASISTENCIA TECNICA",
    "cuit": "30-65894895-0",
    "saldo":         0.00
  },
  {
    "id": 1100000571,
    "codigo": "1646",
    "nombre": "GARRIDO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000572,
    "codigo": "1647",
    "nombre": "PALMIERI PUBLICIDAD SRL",
    "cuit": "30-66422626-6",
    "saldo":         0.00
  },
  {
    "id": 1100000573,
    "codigo": "1663",
    "nombre": "FARIAS ALICIA",
    "cuit": "27-03561698-0",
    "saldo":         0.00
  },
  {
    "id": 1100000574,
    "codigo": "1664",
    "nombre": "FERNANDEZ ELSA",
    "cuit": "27-14057521-1",
    "saldo":         0.00
  },
  {
    "id": 1100000575,
    "codigo": "1669",
    "nombre": "NUNGESER ERNESTO",
    "cuit": "20-05494629-6",
    "saldo":         0.00
  },
  {
    "id": 1100000576,
    "codigo": "1671",
    "nombre": "FABRI OMAR",
    "cuit": "20-07371756-7",
    "saldo":         0.00
  },
  {
    "id": 1100000577,
    "codigo": "1674",
    "nombre": "SEQUEIRA Y DEL MORO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000578,
    "codigo": "1679",
    "nombre": "OSCAR DIESER",
    "cuit": "20-08002207-8",
    "saldo":         0.00
  },
  {
    "id": 1100000579,
    "codigo": "1682",
    "nombre": "MARCONATO HECTOR",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000580,
    "codigo": "1683",
    "nombre": "FRUTERIA Y VERDUERIA MAXI",
    "cuit": "20-20561562-0",
    "saldo":         0.00
  },
  {
    "id": 1100000581,
    "codigo": "1685",
    "nombre": "CASTILLO PALACIOS  HELIA ELISA",
    "cuit": "27-92490199-9",
    "saldo":         0.00
  },
  {
    "id": 1100000582,
    "codigo": "1688",
    "nombre": "BOCA HORACIO",
    "cuit": "20-05536710-9",
    "saldo":         0.00
  },
  {
    "id": 1100000583,
    "codigo": "1689",
    "nombre": "GASTRONOMICA BELGRANO",
    "cuit": "30-65976322-9",
    "saldo":         0.00
  },
  {
    "id": 1100000584,
    "codigo": "1691",
    "nombre": "CARNES DEL SUR SOC DE HECHO DE ABEL A Y",
    "cuit": "30-68113892-3",
    "saldo":         0.00
  },
  {
    "id": 1100000585,
    "codigo": "1697",
    "nombre": "VOLPINESTA FRANCISCO",
    "cuit": "20-15249191-4",
    "saldo":         0.00
  },
  {
    "id": 1100000586,
    "codigo": "1698",
    "nombre": "PRIETO SERGIO",
    "cuit": "20-05021658-7",
    "saldo":         0.00
  },
  {
    "id": 1100000587,
    "codigo": "1700",
    "nombre": "ROTH SILVANA",
    "cuit": "27-11358012-2",
    "saldo":         0.00
  },
  {
    "id": 1100000588,
    "codigo": "1702",
    "nombre": "ORTIZ RAMONA EDITH",
    "cuit": "27-10631267-8",
    "saldo":         0.00
  },
  {
    "id": 1100000589,
    "codigo": "1705",
    "nombre": "BELTRAN JOSE",
    "cuit": "20-14617890-2",
    "saldo":         0.00
  },
  {
    "id": 1100000590,
    "codigo": "1709",
    "nombre": "PROVISIONES ELEGIDAS DE ALFY JSALDUNGARA",
    "cuit": "30-66422749-1",
    "saldo":         0.00
  },
  {
    "id": 1100000591,
    "codigo": "1711",
    "nombre": "SCHAFER GUSTAVO",
    "cuit": "23-22970479-9",
    "saldo":         0.00
  },
  {
    "id": 1100000592,
    "codigo": "1714",
    "nombre": "PAL PEDRO JUAN",
    "cuit": "20-14934054-9",
    "saldo":      7915.30
  },
  {
    "id": 1100000593,
    "codigo": "1715",
    "nombre": "ZURITA",
    "cuit": "23-17673278-4",
    "saldo":         0.00
  },
  {
    "id": 1100000594,
    "codigo": "1717",
    "nombre": "BERAMENDI CLAUDIO",
    "cuit": "20-22053728-6",
    "saldo":         0.00
  },
  {
    "id": 1100000595,
    "codigo": "1718",
    "nombre": "PHORDOY MARIA CRISTINA",
    "cuit": "27-10228294-4",
    "saldo":         0.00
  },
  {
    "id": 1100000596,
    "codigo": "1732",
    "nombre": "PAUL ARACELI FERMINA",
    "cuit": "27-01022952-4",
    "saldo":         0.00
  },
  {
    "id": 1100000597,
    "codigo": "1736",
    "nombre": "MISTRAL",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000598,
    "codigo": "1737",
    "nombre": "VERGARA JOSE ALBERTO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000599,
    "codigo": "1739",
    "nombre": "KIOSCO LIB",
    "cuit": "20-06737022-9",
    "saldo":         0.00
  },
  {
    "id": 1100000600,
    "codigo": "1740",
    "nombre": "TELLO MARIA ALCIRA",
    "cuit": "27-06635114-4",
    "saldo":        -0.02
  },
  {
    "id": 1100000601,
    "codigo": "1741",
    "nombre": "MANNELLA CARLOS ALBERTO",
    "cuit": "20-20561991-8",
    "saldo":         0.00
  },
  {
    "id": 1100000602,
    "codigo": "1749",
    "nombre": "GONET ELIDA",
    "cuit": "27-10976005-1",
    "saldo":         0.00
  },
  {
    "id": 1100000603,
    "codigo": "1753",
    "nombre": "GAROFOLI GILBERTO",
    "cuit": "20-03029002-0",
    "saldo":         0.00
  },
  {
    "id": 1100000604,
    "codigo": "1757",
    "nombre": "ESTACION DE SERVICIO DE PAZ PABLO N Y PA",
    "cuit": "30-68115317-5",
    "saldo":         0.00
  },
  {
    "id": 1100000605,
    "codigo": "1761",
    "nombre": "CLUB SOCIAL MONTE HERMOSO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000606,
    "codigo": "1771",
    "nombre": "RABBIONE RICARDO ESTEBAN",
    "cuit": "20-11314300-3",
    "saldo":         0.00
  },
  {
    "id": 1100000607,
    "codigo": "1773",
    "nombre": "VALLEJOS MARIA DEL CARMEN",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000608,
    "codigo": "1774",
    "nombre": "CARNICERIA DON JAIME",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000609,
    "codigo": "1775",
    "nombre": "RIFFO IDA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000610,
    "codigo": "1778",
    "nombre": "SUCESORES DE JUAN RIPOL SOC DE HECHO",
    "cuit": "30-64754390-8",
    "saldo":         0.00
  },
  {
    "id": 1100000611,
    "codigo": "1781",
    "nombre": "PLAQUIN CLAUDIA",
    "cuit": "27-07280152-5",
    "saldo":         0.00
  },
  {
    "id": 1100000612,
    "codigo": "1783",
    "nombre": "GONZALEZ MANUELA MARCELINA",
    "cuit": "27-10631016-0",
    "saldo":         0.00
  },
  {
    "id": 1100000613,
    "codigo": "1784",
    "nombre": "TORSANI OSCAR",
    "cuit": "20-07650489-0",
    "saldo":       687.77
  },
  {
    "id": 1100000614,
    "codigo": "1785",
    "nombre": "PRIETO EDGARDO OSCAR",
    "cuit": "20-10388654-7",
    "saldo":         0.00
  },
  {
    "id": 1100000615,
    "codigo": "1797",
    "nombre": "RESTAURANT DANY",
    "cuit": "20-22539011-9",
    "saldo":         0.00
  },
  {
    "id": 1100000616,
    "codigo": "1800",
    "nombre": "SOTO MARIA",
    "cuit": "27-06059770-6",
    "saldo":         0.00
  },
  {
    "id": 1100000617,
    "codigo": "1804",
    "nombre": "STEFFENS LUIS",
    "cuit": "20-05474790-0",
    "saldo":         0.00
  },
  {
    "id": 1100000618,
    "codigo": "1809",
    "nombre": "ESTACION DE SERVICIO DON ANTONIO DE GILI",
    "cuit": "30-66416474-0",
    "saldo":         0.00
  },
  {
    "id": 1100000619,
    "codigo": "1810",
    "nombre": "FERNANDEZ SERGIO ARIEL",
    "cuit": "20-23574545-4",
    "saldo":         0.00
  },
  {
    "id": 1100000620,
    "codigo": "1811",
    "nombre": "TSAI",
    "cuit": "20-92762722-2",
    "saldo":         0.00
  },
  {
    "id": 1100000621,
    "codigo": "1812",
    "nombre": "GONZALEZ MATILDE",
    "cuit": "27-60159601-6",
    "saldo":         0.00
  },
  {
    "id": 1100000622,
    "codigo": "1817",
    "nombre": "AGROPECUARIA LA LUCILA SRL",
    "cuit": "30-68121033-0",
    "saldo":         0.00
  },
  {
    "id": 1100000623,
    "codigo": "1825",
    "nombre": "CHICAS",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000624,
    "codigo": "1826",
    "nombre": "PREO MARTA",
    "cuit": "27-01197182-5",
    "saldo":         0.00
  },
  {
    "id": 1100000625,
    "codigo": "1828",
    "nombre": "MEDORI ANTONIO",
    "cuit": "20-54742534-0",
    "saldo":         0.00
  },
  {
    "id": 1100000626,
    "codigo": "1829",
    "nombre": "COMEDOR UNIVERSITARIO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000627,
    "codigo": "1830",
    "nombre": "SAMPOGLIONI ROBERTO",
    "cuit": "20-02978515-6",
    "saldo":         0.00
  },
  {
    "id": 1100000628,
    "codigo": "1833",
    "nombre": "HOTEL BELGRANO",
    "cuit": "33-59279325-9",
    "saldo":         0.00
  },
  {
    "id": 1100000629,
    "codigo": "1839",
    "nombre": "FRIGORIFICO BAHIENSE SA",
    "cuit": "30-50383027-9",
    "saldo":         0.00
  },
  {
    "id": 1100000630,
    "codigo": "1840",
    "nombre": "ITURBIDE",
    "cuit": "20-23619730-2",
    "saldo":         0.00
  },
  {
    "id": 1100000631,
    "codigo": "1846",
    "nombre": "ORTIZ OSVALDO",
    "cuit": "20-05509308-4",
    "saldo":         0.00
  },
  {
    "id": 1100000632,
    "codigo": "1847",
    "nombre": "FRIGORIFICO BAHIENSE",
    "cuit": "30-50383027-9",
    "saldo":         0.00
  },
  {
    "id": 1100000633,
    "codigo": "1848",
    "nombre": "DURANTE SUSANA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000634,
    "codigo": "1855",
    "nombre": "ULLUA OSVALDO",
    "cuit": "20-07848264-9",
    "saldo":      2199.99
  },
  {
    "id": 1100000635,
    "codigo": "1856",
    "nombre": "NINO PASTAS",
    "cuit": "20-23130439-9",
    "saldo":         0.00
  },
  {
    "id": 1100000636,
    "codigo": "1858",
    "nombre": "ZENGARINI ALICIA BEATRIZ B DE",
    "cuit": "27-04897945-4",
    "saldo":        -2.54
  },
  {
    "id": 1100000637,
    "codigo": "1867",
    "nombre": "FIGUEROA OSCAR SEGUNDO",
    "cuit": "20-16922333-6",
    "saldo":         0.00
  },
  {
    "id": 1100000638,
    "codigo": "1874",
    "nombre": "LASTRA VICTOR",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000639,
    "codigo": "1883",
    "nombre": "BOTAI RANIERI",
    "cuit": "27-01686455-8",
    "saldo":         0.00
  },
  {
    "id": 1100000640,
    "codigo": "1886",
    "nombre": "ALVAREZ AMELIA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000641,
    "codigo": "1893",
    "nombre": "SOTO ANTONIO SALVADOR",
    "cuit": "20-12786550-8",
    "saldo":         0.00
  },
  {
    "id": 1100000642,
    "codigo": "1900",
    "nombre": "ADRI MARIA TERESA",
    "cuit": "27-06172973-4",
    "saldo":         0.00
  },
  {
    "id": 1100000643,
    "codigo": "1911",
    "nombre": "LORENZO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000644,
    "codigo": "1912",
    "nombre": "SOLA LUIS OMAR",
    "cuit": "20-10598350-7",
    "saldo":         0.00
  },
  {
    "id": 1100000645,
    "codigo": "1913",
    "nombre": "CARRITO NEGRO EL 11",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000646,
    "codigo": "1914",
    "nombre": "ASOCIACION EMPLEADOS DE COMERCIO BAHIA B",
    "cuit": "30-52635805-4",
    "saldo":         0.00
  },
  {
    "id": 1100000647,
    "codigo": "1917",
    "nombre": "RODRIGUEZ EDUARDO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000648,
    "codigo": "1924",
    "nombre": "ORRIETA ELIDA",
    "cuit": "27-14521107-2",
    "saldo":         0.00
  },
  {
    "id": 1100000649,
    "codigo": "1926",
    "nombre": "HOTEL BASE NAVAL PUERTO BELGRANO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000650,
    "codigo": "1927",
    "nombre": "COTTA HECTOR",
    "cuit": "20-04602451-7",
    "saldo":         0.00
  },
  {
    "id": 1100000651,
    "codigo": "1928",
    "nombre": "CHIN-TSAI",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000652,
    "codigo": "1932",
    "nombre": "GIL Y FRANZINO SA",
    "cuit": "30-57922627-3",
    "saldo":         0.00
  },
  {
    "id": 1100000653,
    "codigo": "1942",
    "nombre": "FERNANDEZ CARLOS",
    "cuit": "20-05516774-6",
    "saldo":         0.00
  },
  {
    "id": 1100000654,
    "codigo": "1949",
    "nombre": "MONTAGNER HUGO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000655,
    "codigo": "1953",
    "nombre": "ZEBALLOS MIGUEL",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000656,
    "codigo": "1955",
    "nombre": "PUGLISI JOSE ANTONIO",
    "cuit": "20-05518813-1",
    "saldo":         0.00
  },
  {
    "id": 1100000657,
    "codigo": "1961",
    "nombre": "FABRIZZI SUSANA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000658,
    "codigo": "1965",
    "nombre": "LOPEZ EDUARDO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000659,
    "codigo": "1968",
    "nombre": "MANSILLA DANIEL ROQUE",
    "cuit": "20-10187800-8",
    "saldo":         0.00
  },
  {
    "id": 1100000660,
    "codigo": "1969",
    "nombre": "AYUDALE",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000661,
    "codigo": "1970",
    "nombre": "PONS",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000662,
    "codigo": "1971",
    "nombre": "TONIN ARGENTINO ARTENIO",
    "cuit": "20-10631939-2",
    "saldo":         0.00
  },
  {
    "id": 1100000663,
    "codigo": "1974",
    "nombre": "BATTELLI ANIBAL",
    "cuit": "20-05427461-1",
    "saldo":         0.00
  },
  {
    "id": 1100000664,
    "codigo": "1983",
    "nombre": "GRITTEN FEDERICO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000665,
    "codigo": "1984",
    "nombre": "ANTONGNOLI BETY",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000666,
    "codigo": "1994",
    "nombre": "CANALES DIAZ MARIA",
    "cuit": "27-18688091-4",
    "saldo":         0.00
  },
  {
    "id": 1100000667,
    "codigo": "1996",
    "nombre": "STREMEL CARLOS OMAR",
    "cuit": "20-11932295-3",
    "saldo":         0.00
  },
  {
    "id": 1100000668,
    "codigo": "2001",
    "nombre": "AUTO REPUESTO DEL OESTE SH",
    "cuit": "30-64673859-4",
    "saldo":         0.00
  },
  {
    "id": 1100000669,
    "codigo": "2003",
    "nombre": "KOENIG J CARLOS",
    "cuit": "20-08623212-0",
    "saldo":         0.00
  },
  {
    "id": 1100000670,
    "codigo": "2005",
    "nombre": "DIMARCO CARLOS",
    "cuit": "20-08435302-8",
    "saldo":         0.00
  },
  {
    "id": 1100000671,
    "codigo": "2007",
    "nombre": "AISTER SRL",
    "cuit": "30-63962660-8",
    "saldo":         0.00
  },
  {
    "id": 1100000672,
    "codigo": "2013",
    "nombre": "GAMBINI ALFREDO",
    "cuit": "20-03431670-9",
    "saldo":         0.00
  },
  {
    "id": 1100000673,
    "codigo": "2015",
    "nombre": "ASPUD ALBERTO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000674,
    "codigo": "2016",
    "nombre": "PENNACCHIOTTI ROBERTO QUINTO",
    "cuit": "20-05464805-8",
    "saldo":         0.00
  },
  {
    "id": 1100000675,
    "codigo": "2020",
    "nombre": "LAR SA (BROWN 123)",
    "cuit": "30-66421975-8",
    "saldo":         0.00
  },
  {
    "id": 1100000676,
    "codigo": "2023",
    "nombre": "BONJOUR SERGIO",
    "cuit": "20-14748269-9",
    "saldo":         0.00
  },
  {
    "id": 1100000677,
    "codigo": "2024",
    "nombre": "PIZZA JET DE FIORAMONTI CORCHETTI",
    "cuit": "20-11232769-0",
    "saldo":         0.00
  },
  {
    "id": 1100000678,
    "codigo": "2026",
    "nombre": "FRIGOLOMAS SAGI Y C",
    "cuit": "33-56579404-9",
    "saldo":         0.00
  },
  {
    "id": 1100000679,
    "codigo": "2030",
    "nombre": "CAMPING AMERICANO DE GUTIERRES ROSANA",
    "cuit": "27-13179076-5",
    "saldo":         0.00
  },
  {
    "id": 1100000680,
    "codigo": "2031",
    "nombre": "CAMPING SUR",
    "cuit": "20-05886371-9",
    "saldo":         0.00
  },
  {
    "id": 1100000681,
    "codigo": "2033",
    "nombre": "ASOCIACION JUDICIAL BONAERENSE",
    "cuit": "30-57416579-9",
    "saldo":         0.00
  },
  {
    "id": 1100000682,
    "codigo": "2040",
    "nombre": "ORTEGA SUSANA EDITH",
    "cuit": "27-10103147-6",
    "saldo":         0.00
  },
  {
    "id": 1100000683,
    "codigo": "2044",
    "nombre": "RUPPEL MARIA",
    "cuit": "27-14320119-3",
    "saldo":         0.00
  },
  {
    "id": 1100000684,
    "codigo": "2045",
    "nombre": "BARZAGHI IVAN PABLO",
    "cuit": "23-22575580-9",
    "saldo":         0.00
  },
  {
    "id": 1100000685,
    "codigo": "2053",
    "nombre": "MACHADO ANTONIO",
    "cuit": "20-11010861-4",
    "saldo":         0.00
  },
  {
    "id": 1100000686,
    "codigo": "2063",
    "nombre": "FANONI OSCAR PEDRO",
    "cuit": "20-05437159-5",
    "saldo":         0.00
  },
  {
    "id": 1100000687,
    "codigo": "2065",
    "nombre": "REPETTI ERMINIO  LA ESTRELLA",
    "cuit": "20-05493303-4",
    "saldo":         0.00
  },
  {
    "id": 1100000688,
    "codigo": "2066",
    "nombre": "ROLDAN RAMON",
    "cuit": "20-08437444-0",
    "saldo":         0.00
  },
  {
    "id": 1100000689,
    "codigo": "2068",
    "nombre": "ELENA VILLARREAL",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000690,
    "codigo": "2069",
    "nombre": "GIULIANO ALICIA",
    "cuit": "27-10105597-9",
    "saldo":         0.00
  },
  {
    "id": 1100000691,
    "codigo": "2071",
    "nombre": "FCO EMBA SOCDE HECHO,DE BERNAT N Y DEVED",
    "cuit": "30-68119814-4",
    "saldo":         0.00
  },
  {
    "id": 1100000692,
    "codigo": "2073",
    "nombre": "NAFTILUS ARGENTINA SA",
    "cuit": "30-58328424-5",
    "saldo":         0.00
  },
  {
    "id": 1100000693,
    "codigo": "2074",
    "nombre": "MARTINEZ CLAUDIO",
    "cuit": "23-17647333-9",
    "saldo":         0.00
  },
  {
    "id": 1100000694,
    "codigo": "2079",
    "nombre": "REPETTI ENRIQUE ALBERTO",
    "cuit": "20-05474663-7",
    "saldo":         0.00
  },
  {
    "id": 1100000695,
    "codigo": "2081",
    "nombre": "SERIGRAFIA GOMEZ DE DANIEL Y FERNANDO GO",
    "cuit": "30-64006200-9",
    "saldo":         0.00
  },
  {
    "id": 1100000696,
    "codigo": "2086",
    "nombre": "FELIX CARLOS Y DANIEL",
    "cuit": "30-62525215-6",
    "saldo":         0.00
  },
  {
    "id": 1100000697,
    "codigo": "2088",
    "nombre": "DARINO Y CIA  SCA",
    "cuit": "30-50610992-9",
    "saldo":         0.00
  },
  {
    "id": 1100000698,
    "codigo": "2091",
    "nombre": "LAVIOS RUBEN",
    "cuit": "20-54355417-0",
    "saldo":         0.00
  },
  {
    "id": 1100000699,
    "codigo": "2093",
    "nombre": "SANCHEZ N ADOLFO",
    "cuit": "20-05197798-4",
    "saldo":         0.00
  },
  {
    "id": 1100000700,
    "codigo": "2094",
    "nombre": "LA BALSA DE MIGUEL ANGEL CORVALAN",
    "cuit": "20-12663506-1",
    "saldo":         0.00
  },
  {
    "id": 1100000701,
    "codigo": "2102",
    "nombre": "LAS PALMERAS PADDLE DE L A VEROLI Y F DO",
    "cuit": "30-68119036-4",
    "saldo":         0.00
  },
  {
    "id": 1100000702,
    "codigo": "2116",
    "nombre": "PARROTA LILIANA",
    "cuit": "27-11314717-8",
    "saldo":         0.00
  },
  {
    "id": 1100000703,
    "codigo": "2117",
    "nombre": "BERZAGHI IVAN PABLO",
    "cuit": "23-22575580-9",
    "saldo":         0.00
  },
  {
    "id": 1100000704,
    "codigo": "2118",
    "nombre": "TAÑO FERNANADO, TAÑO MARIANO Y COMISSO M",
    "cuit": "30-71010210-0",
    "saldo":         0.00
  },
  {
    "id": 1100000705,
    "codigo": "2121",
    "nombre": "PRILLER VICTOR",
    "cuit": "20-54636394-0",
    "saldo":         0.00
  },
  {
    "id": 1100000706,
    "codigo": "2123",
    "nombre": "ARIEL PALAZANI",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000707,
    "codigo": "2124",
    "nombre": "LAFRANCONI GUILLERMO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000708,
    "codigo": "2128",
    "nombre": "MOSTAZA PUB DE RODRIGUEZ JORGE",
    "cuit": "20-11314015-2",
    "saldo":         0.00
  },
  {
    "id": 1100000709,
    "codigo": "2129",
    "nombre": "RICCI MARIA VIVIANA",
    "cuit": "27-01222169-5",
    "saldo":         0.00
  },
  {
    "id": 1100000710,
    "codigo": "2130",
    "nombre": "ZIEGENRMAN FERNANDO",
    "cuit": "20-12663577-0",
    "saldo":         0.00
  },
  {
    "id": 1100000711,
    "codigo": "2136",
    "nombre": "DATO MARIA A",
    "cuit": "27-05015917-0",
    "saldo":         0.00
  },
  {
    "id": 1100000712,
    "codigo": "2141",
    "nombre": "CORREA ADRIANA INES",
    "cuit": "27-14556084-0",
    "saldo":         0.00
  },
  {
    "id": 1100000713,
    "codigo": "2145",
    "nombre": "MATTINA HNOS SACIAN",
    "cuit": "30-54158342-0",
    "saldo":        53.43
  },
  {
    "id": 1100000714,
    "codigo": "2146",
    "nombre": "LAVIOS FRANCISCO RUBENS Y RUBEN EDUARDO",
    "cuit": "30-64814126-9",
    "saldo":         0.00
  },
  {
    "id": 1100000715,
    "codigo": "2155",
    "nombre": "GOMEZ NORMA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000716,
    "codigo": "2156",
    "nombre": "LUCHETI HNOS",
    "cuit": "30-52498324-3",
    "saldo":         0.00
  },
  {
    "id": 1100000717,
    "codigo": "2166",
    "nombre": "GRIMALT ALICIA ANA",
    "cuit": "27-12278411-3",
    "saldo":         0.00
  },
  {
    "id": 1100000718,
    "codigo": "2180",
    "nombre": "MASSACCESI NORBERTO",
    "cuit": "23-10502707-9",
    "saldo":         0.00
  },
  {
    "id": 1100000719,
    "codigo": "2181",
    "nombre": "MAIPACH SA",
    "cuit": "33-68114222-9",
    "saldo":         0.20
  },
  {
    "id": 1100000720,
    "codigo": "2191",
    "nombre": "PERFILES SRL",
    "cuit": "30-68120849-2",
    "saldo":         0.00
  },
  {
    "id": 1100000721,
    "codigo": "2195",
    "nombre": "GAUCCI MARTA ADELA",
    "cuit": "27-05110089-7",
    "saldo":         0.00
  },
  {
    "id": 1100000722,
    "codigo": "2202",
    "nombre": "LOPEZ JUAN HORACIO",
    "cuit": "20-16094607-6",
    "saldo":         0.00
  },
  {
    "id": 1100000723,
    "codigo": "2204",
    "nombre": "MASSIMILIANI ANA MARIA",
    "cuit": "27-12278422-9",
    "saldo":         0.00
  },
  {
    "id": 1100000724,
    "codigo": "2208",
    "nombre": "RECALDE JOSE",
    "cuit": "20-14189700-5",
    "saldo":         0.00
  },
  {
    "id": 1100000725,
    "codigo": "2211",
    "nombre": "PANIF Y AUT PAMPA  SH DE C ECHEGA",
    "cuit": "30-68119142-5",
    "saldo":         0.00
  },
  {
    "id": 1100000726,
    "codigo": "2215",
    "nombre": "ULLUA OSVALDO",
    "cuit": "20-07848264-9",
    "saldo":         0.00
  },
  {
    "id": 1100000727,
    "codigo": "2216",
    "nombre": "CENIZO NORMA BEATRIZ",
    "cuit": "27-20235878-6",
    "saldo":         0.00
  },
  {
    "id": 1100000728,
    "codigo": "2217",
    "nombre": "SUAREZ ANGEL MARTIN",
    "cuit": "20-11089657-4",
    "saldo":         0.00
  },
  {
    "id": 1100000729,
    "codigo": "2221",
    "nombre": "BURGOS GLADYS RAQUEL",
    "cuit": "27-11913595-3",
    "saldo":         0.00
  },
  {
    "id": 1100000730,
    "codigo": "2228",
    "nombre": "ANNA MARIA LUJAN",
    "cuit": "27-06703211-5",
    "saldo":         0.00
  },
  {
    "id": 1100000731,
    "codigo": "2232",
    "nombre": "SEQUEIRA GUSTAVO",
    "cuit": "20-23084744-5",
    "saldo":         0.00
  },
  {
    "id": 1100000732,
    "codigo": "2234",
    "nombre": "CAFE BOSTON-HERRO JUAN",
    "cuit": "23-13227657-9",
    "saldo":        -0.08
  },
  {
    "id": 1100000733,
    "codigo": "2235",
    "nombre": "CLINICA DEL SOL DE BAHIA BLANCA SA",
    "cuit": "30-68120757-7",
    "saldo":         0.00
  },
  {
    "id": 1100000734,
    "codigo": "2237",
    "nombre": "HORACIO J AGUIRRE SRL",
    "cuit": "30-68805032-0",
    "saldo":         0.00
  },
  {
    "id": 1100000735,
    "codigo": "2240",
    "nombre": "EL MUNDO SC",
    "cuit": "30-59323862-4",
    "saldo":         0.00
  },
  {
    "id": 1100000736,
    "codigo": "2245",
    "nombre": "MORETTO CARINA",
    "cuit": "27-20903371-8",
    "saldo":         0.00
  },
  {
    "id": 1100000737,
    "codigo": "2246",
    "nombre": "ROCHEN ELIDA (TIA PELU)",
    "cuit": "27-57784003-0",
    "saldo":         0.00
  },
  {
    "id": 1100000738,
    "codigo": "2249",
    "nombre": "GRASULITO -PERA JOSE",
    "cuit": "30-56359804-9",
    "saldo":         0.00
  },
  {
    "id": 1100000739,
    "codigo": "2251",
    "nombre": "ROMA SRL",
    "cuit": "30-62914972-0",
    "saldo":         0.00
  },
  {
    "id": 1100000740,
    "codigo": "2261",
    "nombre": "MELINGER ROBERTO",
    "cuit": "20-05518925-1",
    "saldo":         0.00
  },
  {
    "id": 1100000741,
    "codigo": "2263",
    "nombre": "DIGNEF HECTOR OSCAR",
    "cuit": "20-11794531-7",
    "saldo":         0.00
  },
  {
    "id": 1100000742,
    "codigo": "2264",
    "nombre": "EL RESERO",
    "cuit": "27-05110172-9",
    "saldo":         0.00
  },
  {
    "id": 1100000743,
    "codigo": "2272",
    "nombre": "DAMBOLENA JUAN",
    "cuit": "33-68119050-9",
    "saldo":         0.00
  },
  {
    "id": 1100000744,
    "codigo": "2274",
    "nombre": "PERERA NORMA",
    "cuit": "27-13941447-6",
    "saldo":         0.00
  },
  {
    "id": 1100000745,
    "codigo": "2275",
    "nombre": "MUÑOZ RIOS ROXANA DEL PILAR",
    "cuit": "27-92401570-0",
    "saldo":         0.00
  },
  {
    "id": 1100000746,
    "codigo": "2280",
    "nombre": "ONORATO ROXANA PAOLA",
    "cuit": "27-20437940-3",
    "saldo":         0.00
  },
  {
    "id": 1100000747,
    "codigo": "2282",
    "nombre": "ANEROT JUAN",
    "cuit": "20-05482323-2",
    "saldo":         0.00
  },
  {
    "id": 1100000748,
    "codigo": "2284",
    "nombre": "VEGA ROLANDO",
    "cuit": "20-12904703-9",
    "saldo":         0.18
  },
  {
    "id": 1100000749,
    "codigo": "2285",
    "nombre": "MOLINARI DELIA",
    "cuit": "27-04065539-0",
    "saldo":         0.00
  },
  {
    "id": 1100000750,
    "codigo": "2286",
    "nombre": "PAEZ GREGORIO ANTONIO",
    "cuit": "20-10103094-7",
    "saldo":         0.00
  },
  {
    "id": 1100000751,
    "codigo": "2287",
    "nombre": "LONGSTAFF GRACILA M",
    "cuit": "27-11113354-4",
    "saldo":         0.00
  },
  {
    "id": 1100000752,
    "codigo": "2290",
    "nombre": "COTTA HECTOR EDUARDO",
    "cuit": "20-04602451-7",
    "saldo":         0.00
  },
  {
    "id": 1100000753,
    "codigo": "2294",
    "nombre": "CASALLI SA",
    "cuit": "30-50980594-3",
    "saldo":         0.00
  },
  {
    "id": 1100000754,
    "codigo": "2297",
    "nombre": "ALICIA VAZQUEZ",
    "cuit": "27-06046134-7",
    "saldo":         0.00
  },
  {
    "id": 1100000755,
    "codigo": "2303",
    "nombre": "FIAMBRERIA CABILDO {BERAZATEGUI}",
    "cuit": "27-20513631-8",
    "saldo":         0.00
  },
  {
    "id": 1100000756,
    "codigo": "2308",
    "nombre": "AGUILAR JORGE",
    "cuit": "20-08312371-1",
    "saldo":         0.00
  },
  {
    "id": 1100000757,
    "codigo": "2317",
    "nombre": "SAN MARTIN RICARDO OSVALDO",
    "cuit": "20-08188780-3",
    "saldo":         0.00
  },
  {
    "id": 1100000758,
    "codigo": "2324",
    "nombre": "FRAGAPANE DOMINGO",
    "cuit": "20-05123023-0",
    "saldo":         0.00
  },
  {
    "id": 1100000759,
    "codigo": "2325",
    "nombre": "CANIS CARLOS",
    "cuit": "20-23387119-2",
    "saldo":         0.00
  },
  {
    "id": 1100000760,
    "codigo": "2326",
    "nombre": "REYES JOSE",
    "cuit": "20-13227364-3",
    "saldo":         0.00
  },
  {
    "id": 1100000761,
    "codigo": "2329",
    "nombre": "NHNEILSON Y CIA  SRL",
    "cuit": "30-50673195-6",
    "saldo":         0.00
  },
  {
    "id": 1100000762,
    "codigo": "2334",
    "nombre": "DULSAN DORA DOSOLINA",
    "cuit": "27-04015239-9",
    "saldo":         0.00
  },
  {
    "id": 1100000763,
    "codigo": "2336",
    "nombre": "COMISION ASAMBLEA DEL PUEBLO DE DIOS",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000764,
    "codigo": "2339",
    "nombre": "IGLESIAS ADRIANA",
    "cuit": "30-67172193-0",
    "saldo":         0.00
  },
  {
    "id": 1100000765,
    "codigo": "2340",
    "nombre": "PAUL PEDRO",
    "cuit": "20-05488604-4",
    "saldo":         0.00
  },
  {
    "id": 1100000766,
    "codigo": "2341",
    "nombre": "DEJTER SIMON LEON",
    "cuit": "20-03035059-7",
    "saldo":         0.00
  },
  {
    "id": 1100000767,
    "codigo": "2342",
    "nombre": "CANGELOSI",
    "cuit": "20-05515958-0",
    "saldo":         0.00
  },
  {
    "id": 1100000768,
    "codigo": "2343",
    "nombre": "AMILLANO GLADIS",
    "cuit": "27-03757539-4",
    "saldo":         0.00
  },
  {
    "id": 1100000769,
    "codigo": "2345",
    "nombre": "DUNRAUF ANGELA",
    "cuit": "27-04445461-6",
    "saldo":         0.00
  },
  {
    "id": 1100000770,
    "codigo": "2346",
    "nombre": "BARROSO MARIA JOSE",
    "cuit": "23-23130203-4",
    "saldo":         0.00
  },
  {
    "id": 1100000771,
    "codigo": "2347",
    "nombre": "MAS OSCAR HORACIO",
    "cuit": "20-10359416-3",
    "saldo":         0.00
  },
  {
    "id": 1100000772,
    "codigo": "2349",
    "nombre": "SAIPP SRL",
    "cuit": "30-63461835-6",
    "saldo":         0.00
  },
  {
    "id": 1100000773,
    "codigo": "2356",
    "nombre": "CAMINITI MORETTI SRL",
    "cuit": "30-60622725-2",
    "saldo":         0.00
  },
  {
    "id": 1100000774,
    "codigo": "2360",
    "nombre": "MARTINEZ JUAN CARLOS",
    "cuit": "20-04914935-3",
    "saldo":      7913.30
  },
  {
    "id": 1100000775,
    "codigo": "2366",
    "nombre": "CATALINI EMILIO",
    "cuit": "20-15291741-5",
    "saldo":         0.00
  },
  {
    "id": 1100000776,
    "codigo": "2371",
    "nombre": "REDONDAS HUGO RICARDO",
    "cuit": "20-05449528-6",
    "saldo":         0.00
  },
  {
    "id": 1100000777,
    "codigo": "2374",
    "nombre": "BIOMA ARGENTINA SRL",
    "cuit": "33-68803869-9",
    "saldo":         0.00
  },
  {
    "id": 1100000778,
    "codigo": "2375",
    "nombre": "ACUÑA ANGELA NATALIA",
    "cuit": "27-27385972-7",
    "saldo":         0.00
  },
  {
    "id": 1100000779,
    "codigo": "2376",
    "nombre": "SAN MARTIN",
    "cuit": "20-11061337-8",
    "saldo":         0.00
  },
  {
    "id": 1100000780,
    "codigo": "2379",
    "nombre": "ALIBA SA",
    "cuit": "30-61111237-4",
    "saldo":         0.00
  },
  {
    "id": 1100000781,
    "codigo": "2380",
    "nombre": "GODINO ROSA",
    "cuit": "23-11113754-4",
    "saldo":         0.00
  },
  {
    "id": 1100000782,
    "codigo": "2381",
    "nombre": "STRADIVARIUS SRL",
    "cuit": "30-68806196-9",
    "saldo":         0.00
  },
  {
    "id": 1100000783,
    "codigo": "2387",
    "nombre": "AISA SOCIEDAD ANONIMA",
    "cuit": "30-58638235-3",
    "saldo":         0.00
  },
  {
    "id": 1100000784,
    "codigo": "2390",
    "nombre": "REPALLETS SA",
    "cuit": "30-64718220-4",
    "saldo":         0.00
  },
  {
    "id": 1100000785,
    "codigo": "2391",
    "nombre": "FERLETIC CAROLINA",
    "cuit": "27-93538092-3",
    "saldo":         0.00
  },
  {
    "id": 1100000786,
    "codigo": "2396",
    "nombre": "BERAMENDI DIEHL VIVIANA NORMA",
    "cuit": "27-17429367-3",
    "saldo":         0.00
  },
  {
    "id": 1100000787,
    "codigo": "2399",
    "nombre": "PANIFICADORA SRL",
    "cuit": "30-68805179-3",
    "saldo":         0.00
  },
  {
    "id": 1100000788,
    "codigo": "2400",
    "nombre": "SCHWAMM SERGIO DANIEL",
    "cuit": "20-18041704-5",
    "saldo":         0.00
  },
  {
    "id": 1100000789,
    "codigo": "2404",
    "nombre": "LOPEZ HECTOR FABIAN",
    "cuit": "20-17693892-8",
    "saldo":        -0.02
  },
  {
    "id": 1100000790,
    "codigo": "2406",
    "nombre": "NOBLEZA PICCARDO SAICYF",
    "cuit": "30-50111266-2",
    "saldo":         0.00
  },
  {
    "id": 1100000791,
    "codigo": "2412",
    "nombre": "OLAVARRIA IRMA CLARA",
    "cuit": "27-13227162-9",
    "saldo":         0.00
  },
  {
    "id": 1100000792,
    "codigo": "2413",
    "nombre": "PRAUSSELLO ALDO",
    "cuit": "20-55094617-4",
    "saldo":         0.00
  },
  {
    "id": 1100000793,
    "codigo": "2414",
    "nombre": "ASOCIACION MUTUAL DE EMPLEADOS",
    "cuit": "30-61771297-7",
    "saldo":         0.00
  },
  {
    "id": 1100000794,
    "codigo": "2416",
    "nombre": "FERRETI INES",
    "cuit": "27-03582178-9",
    "saldo":         0.00
  },
  {
    "id": 1100000795,
    "codigo": "2418",
    "nombre": "VAQUERO DARDO O",
    "cuit": "23-20687086-9",
    "saldo":         0.00
  },
  {
    "id": 1100000796,
    "codigo": "2424",
    "nombre": "SALABERRY RAUL FLORENTINO",
    "cuit": "20-05502916-5",
    "saldo":         0.00
  },
  {
    "id": 1100000797,
    "codigo": "2428",
    "nombre": "COVATI NORMA BEATRIZ",
    "cuit": "27-05606049-4",
    "saldo":         0.00
  },
  {
    "id": 1100000798,
    "codigo": "2431",
    "nombre": "VICENTE DANIEL Y JOSE(YPF)",
    "cuit": "30-62726203-1",
    "saldo":         0.00
  },
  {
    "id": 1100000799,
    "codigo": "2433",
    "nombre": "NUÑEZ CRISTINA",
    "cuit": "27-11794341-6",
    "saldo":         0.00
  },
  {
    "id": 1100000800,
    "codigo": "2434",
    "nombre": "GONZALES NESTOR",
    "cuit": "20-12725878-4",
    "saldo":         0.00
  },
  {
    "id": 1100000801,
    "codigo": "2437",
    "nombre": "ASENSCIO LUCRECIA",
    "cuit": "23-14717039-4",
    "saldo":         0.00
  },
  {
    "id": 1100000802,
    "codigo": "2439",
    "nombre": "SERVICIO DE ENSEÑANZA S A (GOYENA)",
    "cuit": "30-61792773-6",
    "saldo":         0.00
  },
  {
    "id": 1100000803,
    "codigo": "2440",
    "nombre": "MATEO JORGE DANIEL",
    "cuit": "20-14198326-2",
    "saldo":         0.00
  },
  {
    "id": 1100000804,
    "codigo": "2441",
    "nombre": "FORTUNATTI ARIEL",
    "cuit": "20-24508285-2",
    "saldo":         0.00
  },
  {
    "id": 1100000805,
    "codigo": "2444",
    "nombre": "OLIVERA HECTOR",
    "cuit": "20-10216941-8",
    "saldo":         0.00
  },
  {
    "id": 1100000806,
    "codigo": "2445",
    "nombre": "BRUNET CAROLINA",
    "cuit": "27-26172050-2",
    "saldo":         0.00
  },
  {
    "id": 1100000807,
    "codigo": "2449",
    "nombre": "YOCCO HECTOR ANTONIO",
    "cuit": "20-06445780-3",
    "saldo":         0.00
  },
  {
    "id": 1100000808,
    "codigo": "2454",
    "nombre": "GALVAN AGUSTIN CELESTINO",
    "cuit": "23-01767378-5",
    "saldo":         0.00
  },
  {
    "id": 1100000809,
    "codigo": "2455",
    "nombre": "COLEGIOS DEL SOLAR",
    "cuit": "30-68810922-8",
    "saldo":     36488.76
  },
  {
    "id": 1100000810,
    "codigo": "2456",
    "nombre": "ORTIZ ISABEL",
    "cuit": "27-04412712-7",
    "saldo":         0.00
  },
  {
    "id": 1100000811,
    "codigo": "2458",
    "nombre": "LA CADENA PACK SA",
    "cuit": "30-68810809-4",
    "saldo":         0.00
  },
  {
    "id": 1100000812,
    "codigo": "2460",
    "nombre": "MASSON SILVIA ANDREA Z DE (COLSAN MARTIN",
    "cuit": "27-20467601-7",
    "saldo":         0.00
  },
  {
    "id": 1100000813,
    "codigo": "2461",
    "nombre": "FERNANDEZ JCARLOS",
    "cuit": "20-05516774-6",
    "saldo":         0.00
  },
  {
    "id": 1100000814,
    "codigo": "2477",
    "nombre": "PAUL MARCELA (MISTER SANDWICH )",
    "cuit": "27-20046162-8",
    "saldo":         0.00
  },
  {
    "id": 1100000815,
    "codigo": "2478",
    "nombre": "GARCIA JUAN CARLOS",
    "cuit": "20-05468099-7",
    "saldo":         0.00
  },
  {
    "id": 1100000816,
    "codigo": "2483",
    "nombre": "AGROPECUARIA VILLA SAUCE S R L",
    "cuit": "30-65783184-7",
    "saldo":         0.00
  },
  {
    "id": 1100000817,
    "codigo": "2484",
    "nombre": "STAMATIOU JORGE",
    "cuit": "20-15254326-4",
    "saldo":         0.00
  },
  {
    "id": 1100000818,
    "codigo": "2485",
    "nombre": "MITILLI ALEJANDRO  A  (VILLA Y D BOSCO)",
    "cuit": "20-05515911-5",
    "saldo":     20025.15
  },
  {
    "id": 1100000819,
    "codigo": "2487",
    "nombre": "BECKER NORA ELSA",
    "cuit": "27-04214001-0",
    "saldo":         0.00
  },
  {
    "id": 1100000820,
    "codigo": "2490",
    "nombre": "OLAYA ARIEL ALEJANDRO",
    "cuit": "20-22845978-0",
    "saldo":         0.00
  },
  {
    "id": 1100000821,
    "codigo": "2493",
    "nombre": "IRIARTE HORACIO ESTEBAN",
    "cuit": "20-04987642-5",
    "saldo":         0.00
  },
  {
    "id": 1100000822,
    "codigo": "2495",
    "nombre": "CAMPA",
    "cuit": "30-53939395-9",
    "saldo":         0.00
  },
  {
    "id": 1100000823,
    "codigo": "2497",
    "nombre": "DE SENSI ROBERTO",
    "cuit": "20-07753335-5",
    "saldo":         0.00
  },
  {
    "id": 1100000824,
    "codigo": "2501",
    "nombre": "MITILLI Y PACHECO SOC DE HECHO",
    "cuit": "30-68812423-5",
    "saldo":         0.00
  },
  {
    "id": 1100000825,
    "codigo": "2503",
    "nombre": "GARCIA JUAN",
    "cuit": "23-10480983-9",
    "saldo":        -0.03
  },
  {
    "id": 1100000826,
    "codigo": "2506",
    "nombre": "LEMOS HECTOR",
    "cuit": "20-05487193-8",
    "saldo":         0.00
  },
  {
    "id": 1100000827,
    "codigo": "2511",
    "nombre": "MEIER JUAN FRANCISCO",
    "cuit": "20-07650222-7",
    "saldo":       193.50
  },
  {
    "id": 1100000828,
    "codigo": "2514",
    "nombre": "ROSALES HECTOR",
    "cuit": "20-05455790-7",
    "saldo":         0.00
  },
  {
    "id": 1100000829,
    "codigo": "2515",
    "nombre": "CIRIACO CATALINA { ESTANCIA M }",
    "cuit": "27-01024645-3",
    "saldo":         0.00
  },
  {
    "id": 1100000830,
    "codigo": "2518",
    "nombre": "MENDIOROZ AGUSTIN MARIO",
    "cuit": "23-05509966-9",
    "saldo":         0.00
  },
  {
    "id": 1100000831,
    "codigo": "2520",
    "nombre": "FRIGORIFICO IFCA DE PJQUIRUELAS",
    "cuit": "20-05454201-2",
    "saldo":         0.00
  },
  {
    "id": 1100000832,
    "codigo": "2524",
    "nombre": "DECASO ROBERTO CESARIO",
    "cuit": "20-05430957-1",
    "saldo":         0.00
  },
  {
    "id": 1100000833,
    "codigo": "2525",
    "nombre": "DOMENICALE HUGO P",
    "cuit": "20-05479471-0",
    "saldo":         0.00
  },
  {
    "id": 1100000834,
    "codigo": "2526",
    "nombre": "CHACINADOS LITRE DE CLITRE",
    "cuit": "20-05487957-2",
    "saldo":         0.00
  },
  {
    "id": 1100000835,
    "codigo": "2527",
    "nombre": "TIGRE ARGENTINA SA",
    "cuit": "30-64970578-6",
    "saldo":         0.00
  },
  {
    "id": 1100000836,
    "codigo": "2528",
    "nombre": "CHAMAN DE CARLOVICH CY RANDAZZO D SH",
    "cuit": "30-68813266-1",
    "saldo":         0.00
  },
  {
    "id": 1100000837,
    "codigo": "2529",
    "nombre": "CRUCIANELLI ADRIAN EDUARDO",
    "cuit": "20-18488631-7",
    "saldo":         0.00
  },
  {
    "id": 1100000838,
    "codigo": "2531",
    "nombre": "BARRAL, HECTOR Y SURIANO, SANDRA",
    "cuit": "30-68812935-0",
    "saldo":         0.00
  },
  {
    "id": 1100000839,
    "codigo": "2533",
    "nombre": "DELGADO FY RABBIONE F  FISA",
    "cuit": "30-68811024-2",
    "saldo":         0.00
  },
  {
    "id": 1100000840,
    "codigo": "2537",
    "nombre": "LARRERE  CARLOS",
    "cuit": "20-17673264-5",
    "saldo":         0.00
  },
  {
    "id": 1100000841,
    "codigo": "2541",
    "nombre": "SARIMBALIS JORGE VICTOR",
    "cuit": "20-05473661-5",
    "saldo":         0.00
  },
  {
    "id": 1100000842,
    "codigo": "2542",
    "nombre": "METROPOLITAN SRL BBCA",
    "cuit": "30-61319648-6",
    "saldo":         0.00
  },
  {
    "id": 1100000843,
    "codigo": "2547",
    "nombre": "NIZZARI NUNZIO",
    "cuit": "20-15253109-6",
    "saldo":         0.00
  },
  {
    "id": 1100000844,
    "codigo": "2549",
    "nombre": "HOLZMANN SILVANA",
    "cuit": "27-22418713-6",
    "saldo":         0.00
  },
  {
    "id": 1100000845,
    "codigo": "2550",
    "nombre": "VITA Y CIA SCPACCIONES",
    "cuit": "33-52082052-9",
    "saldo":         0.00
  },
  {
    "id": 1100000846,
    "codigo": "2551",
    "nombre": "LEGINI LUIS",
    "cuit": "20-08311598-0",
    "saldo":         0.00
  },
  {
    "id": 1100000847,
    "codigo": "2552",
    "nombre": "GODINO ROSA",
    "cuit": "23-11113754-4",
    "saldo":         0.00
  },
  {
    "id": 1100000848,
    "codigo": "2557",
    "nombre": "ROCCA NANCY",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000849,
    "codigo": "2559",
    "nombre": "ROSTAN MARIO",
    "cuit": "23-11089830-4",
    "saldo":         0.00
  },
  {
    "id": 1100000850,
    "codigo": "2560",
    "nombre": "PEZZUTTI GILBERTO ADOLFO",
    "cuit": "20-05442341-2",
    "saldo":         0.00
  },
  {
    "id": 1100000851,
    "codigo": "2565",
    "nombre": "REALE ALICIA ESTER",
    "cuit": "27-04552786-2",
    "saldo":         0.00
  },
  {
    "id": 1100000852,
    "codigo": "2566",
    "nombre": "BILBAO DORA A",
    "cuit": "27-04984686-5",
    "saldo":         0.00
  },
  {
    "id": 1100000853,
    "codigo": "2570",
    "nombre": "PORTILLO ANGELICA",
    "cuit": "27-12073940-4",
    "saldo":         0.00
  },
  {
    "id": 1100000854,
    "codigo": "2572",
    "nombre": "DIAZ SILVIA",
    "cuit": "27-05147954-3",
    "saldo":         0.00
  },
  {
    "id": 1100000855,
    "codigo": "2573",
    "nombre": "USULDINGER CARLOS GUSTAVO",
    "cuit": "20-21556672-3",
    "saldo":         0.00
  },
  {
    "id": 1100000856,
    "codigo": "2576",
    "nombre": "STEINBACH PATRICIA",
    "cuit": "27-20485500-0",
    "saldo":         0.00
  },
  {
    "id": 1100000857,
    "codigo": "2577",
    "nombre": "KOPP ISABEL",
    "cuit": "27-12491056-6",
    "saldo":         0.00
  },
  {
    "id": 1100000858,
    "codigo": "2578",
    "nombre": "STADLER DELIA CATALINA",
    "cuit": "27-16529274-5",
    "saldo":         0.00
  },
  {
    "id": 1100000859,
    "codigo": "2579",
    "nombre": "ACEITUNO ADRIAN A",
    "cuit": "23-17235316-9",
    "saldo":        -1.92
  },
  {
    "id": 1100000860,
    "codigo": "2580",
    "nombre": "WAL-MART ARGENTINA SRL",
    "cuit": "30-67813830-0",
    "saldo":    -25613.82
  },
  {
    "id": 1100000861,
    "codigo": "2582",
    "nombre": "FORNASIER CARMEN M DE",
    "cuit": "27-05121980-0",
    "saldo":         0.00
  },
  {
    "id": 1100000862,
    "codigo": "2583",
    "nombre": "SENSINI RENE",
    "cuit": "20-05484460-4",
    "saldo":         0.00
  },
  {
    "id": 1100000863,
    "codigo": "2584",
    "nombre": "VICTORIA CELIA DIAZ DE",
    "cuit": "27-04580837-3",
    "saldo":         0.00
  },
  {
    "id": 1100000864,
    "codigo": "2586",
    "nombre": "YATZKY AROLDO OSCAR",
    "cuit": "20-05483989-9",
    "saldo":         0.00
  },
  {
    "id": 1100000865,
    "codigo": "2587",
    "nombre": "FITTERER ISABEL CATALINA",
    "cuit": "27-05121925-8",
    "saldo":         0.00
  },
  {
    "id": 1100000866,
    "codigo": "2591",
    "nombre": "LATTANZI CARLOS",
    "cuit": "20-05516800-9",
    "saldo":         0.00
  },
  {
    "id": 1100000867,
    "codigo": "2593",
    "nombre": "ROMERO CRISTINA",
    "cuit": "27-11404446-1",
    "saldo":        -0.42
  },
  {
    "id": 1100000868,
    "codigo": "2594",
    "nombre": "ARCUCCI ALEJANDRO OSCAR",
    "cuit": "20-26922224-8",
    "saldo":         0.00
  },
  {
    "id": 1100000869,
    "codigo": "2595",
    "nombre": "MAESTRI NESTOR RYWITUSKI",
    "cuit": "30-66489203-7",
    "saldo":         0.00
  },
  {
    "id": 1100000870,
    "codigo": "2596",
    "nombre": "BIDEGAIN JOSE MIGUEL",
    "cuit": "23-14955672-9",
    "saldo":         0.00
  },
  {
    "id": 1100000871,
    "codigo": "2597",
    "nombre": "LEGUIZAMON MARCELO ADRIAN",
    "cuit": "20-12221385-5",
    "saldo":        -7.16
  },
  {
    "id": 1100000872,
    "codigo": "2601",
    "nombre": "ACUA DEI SA",
    "cuit": "30-68746667-1",
    "saldo":         0.00
  },
  {
    "id": 1100000873,
    "codigo": "2603",
    "nombre": "KOPP JUANA JOSEFA",
    "cuit": "27-05147878-4",
    "saldo":         0.00
  },
  {
    "id": 1100000874,
    "codigo": "2604",
    "nombre": "DIAZ DE PEREZ RENE",
    "cuit": "27-02764802-4",
    "saldo":      2382.04
  },
  {
    "id": 1100000875,
    "codigo": "2605",
    "nombre": "VERON SERGIO ALEJANDRO",
    "cuit": "23-13057946-9",
    "saldo":         0.00
  },
  {
    "id": 1100000876,
    "codigo": "2606",
    "nombre": "PERALTA ALBERTO",
    "cuit": "20-08472109-4",
    "saldo":         0.00
  },
  {
    "id": 1100000877,
    "codigo": "2611",
    "nombre": "COLIHUEQUE COLLINAO L M DE NAVARRO",
    "cuit": "27-92392304-2",
    "saldo":         0.00
  },
  {
    "id": 1100000878,
    "codigo": "2614",
    "nombre": "GANDUGLIA OSCAR ALBERTO",
    "cuit": "20-05509510-9",
    "saldo":         0.00
  },
  {
    "id": 1100000879,
    "codigo": "2615",
    "nombre": "SCOROLLI HUGO",
    "cuit": "20-11800831-7",
    "saldo":         0.00
  },
  {
    "id": 1100000880,
    "codigo": "2622",
    "nombre": "IL PIRATA BERDINI ADALBERTO",
    "cuit": "20-10737857-0",
    "saldo":         0.00
  },
  {
    "id": 1100000881,
    "codigo": "2623",
    "nombre": "MAZZONI HNOS SRL",
    "cuit": "30-62854733-1",
    "saldo":         0.00
  },
  {
    "id": 1100000882,
    "codigo": "2629",
    "nombre": "DI MEGLIO ALBERTO MARGELO",
    "cuit": "20-11825485-7",
    "saldo":         0.00
  },
  {
    "id": 1100000883,
    "codigo": "2632",
    "nombre": "SIDEX SA",
    "cuit": "30-61622021-3",
    "saldo":         0.00
  },
  {
    "id": 1100000884,
    "codigo": "2634",
    "nombre": "ARRIBA LUIS ALBERTO",
    "cuit": "20-10356701-8",
    "saldo":         0.00
  },
  {
    "id": 1100000885,
    "codigo": "2636",
    "nombre": "RENTERIA ELINA",
    "cuit": "27-05737886-2",
    "saldo":         0.00
  },
  {
    "id": 1100000886,
    "codigo": "2637",
    "nombre": "DELUSTER RICARDO",
    "cuit": "20-12039607-3",
    "saldo":         0.00
  },
  {
    "id": 1100000887,
    "codigo": "2638",
    "nombre": "CURA MARIO",
    "cuit": "20-05390219-3",
    "saldo":         0.00
  },
  {
    "id": 1100000888,
    "codigo": "2639",
    "nombre": "ITURRALDE HECTOR OSCAR",
    "cuit": "20-11253898-5",
    "saldo":         0.00
  },
  {
    "id": 1100000889,
    "codigo": "2640",
    "nombre": "ISMAEL DANIEL",
    "cuit": "20-14499196-7",
    "saldo":         0.00
  },
  {
    "id": 1100000890,
    "codigo": "2641",
    "nombre": "FORCHETTI FIORAVANTE",
    "cuit": "20-11232769-0",
    "saldo":         0.00
  },
  {
    "id": 1100000891,
    "codigo": "2642",
    "nombre": "TORRES JULIO ALBERTO PAST SANTINO",
    "cuit": "23-05499651-9",
    "saldo":        13.87
  },
  {
    "id": 1100000892,
    "codigo": "2644",
    "nombre": "NUNGESER JOSE LUIS",
    "cuit": "20-21603391-5",
    "saldo":         0.00
  },
  {
    "id": 1100000893,
    "codigo": "2646",
    "nombre": "BURCHIL SA",
    "cuit": "30-62707730-7",
    "saldo":         0.00
  },
  {
    "id": 1100000894,
    "codigo": "2647",
    "nombre": "VALDEBENITO JUAN",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000895,
    "codigo": "2649",
    "nombre": "CAVALLI ARIEL CARLOS",
    "cuit": "20-25576227-4",
    "saldo":         0.00
  },
  {
    "id": 1100000896,
    "codigo": "2650",
    "nombre": "GALE WALTER CESAR",
    "cuit": "20-16521519-3",
    "saldo":         0.00
  },
  {
    "id": 1100000897,
    "codigo": "2651",
    "nombre": "VITA OSCAR",
    "cuit": "20-10536893-4",
    "saldo":         0.00
  },
  {
    "id": 1100000898,
    "codigo": "2652",
    "nombre": "SOLER OLGA GUIDA DE",
    "cuit": "27-01433379-2",
    "saldo":         0.00
  },
  {
    "id": 1100000899,
    "codigo": "2653",
    "nombre": "CAMPING AMERICANO",
    "cuit": "30-58428549-2",
    "saldo":         0.00
  },
  {
    "id": 1100000900,
    "codigo": "2654",
    "nombre": "VOGT JUAN CARLOS N2",
    "cuit": "20-17828969-2",
    "saldo":         0.00
  },
  {
    "id": 1100000901,
    "codigo": "2656",
    "nombre": "PIZARRO KARINA",
    "cuit": "27-22307565-2",
    "saldo":         0.00
  },
  {
    "id": 1100000902,
    "codigo": "2658",
    "nombre": "VALLEJOS PEDRO",
    "cuit": "20-13894346-2",
    "saldo":         0.00
  },
  {
    "id": 1100000903,
    "codigo": "2659",
    "nombre": "KRIEGER MARIA",
    "cuit": "27-05073937-1",
    "saldo":         0.00
  },
  {
    "id": 1100000904,
    "codigo": "2660",
    "nombre": "FARIAS GABRIEL",
    "cuit": "20-22976582-6",
    "saldo":         0.00
  },
  {
    "id": 1100000905,
    "codigo": "2663",
    "nombre": "ZAZZETA RICARDO",
    "cuit": "20-13946108-9",
    "saldo":         0.00
  },
  {
    "id": 1100000906,
    "codigo": "2665",
    "nombre": "ESTRADA CECILIA",
    "cuit": "27-04743940-5",
    "saldo":         0.00
  },
  {
    "id": 1100000907,
    "codigo": "2666",
    "nombre": "TETILLA JUAN CARLOS",
    "cuit": "20-08472068-3",
    "saldo":         0.00
  },
  {
    "id": 1100000908,
    "codigo": "2667",
    "nombre": "CHAMATROPULOS CLELIA J",
    "cuit": "27-21584948-7",
    "saldo":         0.00
  },
  {
    "id": 1100000909,
    "codigo": "2668",
    "nombre": "BARES RUBEN",
    "cuit": "20-05505923-4",
    "saldo":         0.00
  },
  {
    "id": 1100000910,
    "codigo": "2671",
    "nombre": "ZUKERMAN WMAURICIO",
    "cuit": "20-16068601-5",
    "saldo":         0.00
  },
  {
    "id": 1100000911,
    "codigo": "2675",
    "nombre": "RODRIGUEZ OSVALDO FELIX",
    "cuit": "20-05536919-5",
    "saldo":         0.00
  },
  {
    "id": 1100000912,
    "codigo": "2676",
    "nombre": "ISABEL ORTIZ",
    "cuit": "27-04412712-7",
    "saldo":         0.00
  },
  {
    "id": 1100000913,
    "codigo": "2677",
    "nombre": "LABEYRIE ML CLUB DE GOLF",
    "cuit": "27-21107108-2",
    "saldo":         0.00
  },
  {
    "id": 1100000914,
    "codigo": "2678",
    "nombre": "POGGIO OSCAR",
    "cuit": "23-05498385-9",
    "saldo":         0.00
  },
  {
    "id": 1100000915,
    "codigo": "2681",
    "nombre": "MANGUELLO OSCAR ALFREDO",
    "cuit": "20-10631581-8",
    "saldo":         0.00
  },
  {
    "id": 1100000916,
    "codigo": "2685",
    "nombre": "MONTERO OSCAR",
    "cuit": "20-10217054-8",
    "saldo":         0.00
  },
  {
    "id": 1100000917,
    "codigo": "2687",
    "nombre": "LA CALESITA SOCRESPLTDA",
    "cuit": "30-56050097-8",
    "saldo":         0.00
  },
  {
    "id": 1100000918,
    "codigo": "2688",
    "nombre": "ALVAREZ JORGE",
    "cuit": "20-05518252-4",
    "saldo":         0.00
  },
  {
    "id": 1100000919,
    "codigo": "2690",
    "nombre": "DEL PORT NORMA HAYDEE",
    "cuit": "27-06226408-5",
    "saldo":         0.00
  },
  {
    "id": 1100000920,
    "codigo": "2696",
    "nombre": "HIRAN BLAS GONZALEZ",
    "cuit": "20-12836266-6",
    "saldo":         0.00
  },
  {
    "id": 1100000921,
    "codigo": "2697",
    "nombre": "SIERRA ESTELA MARIS",
    "cuit": "27-17673336-0",
    "saldo":         0.00
  },
  {
    "id": 1100000922,
    "codigo": "2698",
    "nombre": "DELMAU PAOLA CAROLINA",
    "cuit": "27-25442419-1",
    "saldo":         0.00
  },
  {
    "id": 1100000923,
    "codigo": "2699",
    "nombre": "BENEGAS MIRTA",
    "cuit": "27-05297796-2",
    "saldo":         0.00
  },
  {
    "id": 1100000924,
    "codigo": "2700",
    "nombre": "VILLAR Y FERNANDEZ",
    "cuit": "30-58550441-2",
    "saldo":        -0.30
  },
  {
    "id": 1100000925,
    "codigo": "2703",
    "nombre": "UPF COLEGIO CLARET BBCA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000926,
    "codigo": "2704",
    "nombre": "SANABRIA RICARDO ALBINO",
    "cuit": "20-13946125-9",
    "saldo":         0.00
  },
  {
    "id": 1100000927,
    "codigo": "2706",
    "nombre": "AREVALO LIDIA",
    "cuit": "27-06665147-4",
    "saldo":         0.00
  },
  {
    "id": 1100000928,
    "codigo": "2707",
    "nombre": "CONTE-GRAND Y CIA SA",
    "cuit": "30-52839597-6",
    "saldo":         0.00
  },
  {
    "id": 1100000929,
    "codigo": "2709",
    "nombre": "D AGNINO NORBERTO",
    "cuit": "23-05510485-9",
    "saldo":         0.00
  },
  {
    "id": 1100000930,
    "codigo": "2711",
    "nombre": "BERTIN Y CIA SCA",
    "cuit": "33-51816870-9",
    "saldo":         0.00
  },
  {
    "id": 1100000931,
    "codigo": "2712",
    "nombre": "TRANSPORTE SA",
    "cuit": "30-68119425-4",
    "saldo":         0.00
  },
  {
    "id": 1100000932,
    "codigo": "2713",
    "nombre": "COMUNICACIONES DEL ATLANTICO SRL",
    "cuit": "30-68813280-7",
    "saldo":         0.00
  },
  {
    "id": 1100000933,
    "codigo": "2715",
    "nombre": "GARCIA CARMEN RAQUEL",
    "cuit": "20-20317102-2",
    "saldo":         0.00
  },
  {
    "id": 1100000934,
    "codigo": "2717",
    "nombre": "RAMOS MARCELA ALEJANDRA",
    "cuit": "27-17837906-8",
    "saldo":         0.00
  },
  {
    "id": 1100000935,
    "codigo": "2719",
    "nombre": "PEZAE ESTER",
    "cuit": "27-06666744-0",
    "saldo":         0.00
  },
  {
    "id": 1100000936,
    "codigo": "2721",
    "nombre": "GRUNDNIG CARLOS Y GRUNDNIG DANIEL",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000937,
    "codigo": "2724",
    "nombre": "GOMEZ RAUL",
    "cuit": "20-05514866-0",
    "saldo":         0.00
  },
  {
    "id": 1100000938,
    "codigo": "2727",
    "nombre": "MORMANDO LORENZO",
    "cuit": "20-12368152-6",
    "saldo":         0.15
  },
  {
    "id": 1100000939,
    "codigo": "2728",
    "nombre": "EL MUNDO",
    "cuit": "30-59323862-4",
    "saldo":        -0.10
  },
  {
    "id": 1100000940,
    "codigo": "2731",
    "nombre": "LAS TRES EFES SRL",
    "cuit": "30-68811024-2",
    "saldo":         0.00
  },
  {
    "id": 1100000941,
    "codigo": "2732",
    "nombre": "ZAZZALI  AYELEN VERONICA",
    "cuit": "27-22539103-9",
    "saldo":         0.00
  },
  {
    "id": 1100000942,
    "codigo": "2736",
    "nombre": "FERNANADEZ JORGE HORACIO",
    "cuit": "20-10346531-2",
    "saldo":         0.00
  },
  {
    "id": 1100000943,
    "codigo": "2737",
    "nombre": "FURCH ANSELMO",
    "cuit": "20-05481643-0",
    "saldo":         0.00
  },
  {
    "id": 1100000944,
    "codigo": "2739",
    "nombre": "POLI MARIA ISABEL",
    "cuit": "27-16521402-7",
    "saldo":         0.00
  },
  {
    "id": 1100000945,
    "codigo": "2740",
    "nombre": "CONTENTO ESTEBAN ANTONIO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000946,
    "codigo": "2742",
    "nombre": "PAGELLA ALBERTO",
    "cuit": "30-68123039-0",
    "saldo":         0.00
  },
  {
    "id": 1100000947,
    "codigo": "2745",
    "nombre": "SAN SEBASTIAN NESTOR",
    "cuit": "20-17568967-3",
    "saldo":         0.00
  },
  {
    "id": 1100000948,
    "codigo": "2746",
    "nombre": "MILENI EDUARDO FLORINDO",
    "cuit": "20-05511386-7",
    "saldo":         0.00
  },
  {
    "id": 1100000949,
    "codigo": "2747",
    "nombre": "TRANSPORTE DON GREGORIO SRL",
    "cuit": "30-59813637-4",
    "saldo":         0.00
  },
  {
    "id": 1100000950,
    "codigo": "2749",
    "nombre": "KESSLER GUILLERMO H",
    "cuit": "20-13836841-7",
    "saldo":         0.00
  },
  {
    "id": 1100000951,
    "codigo": "2750",
    "nombre": "ZIEGERMAN FERNANDO HORACIO",
    "cuit": "20-12663577-0",
    "saldo":      6489.90
  },
  {
    "id": 1100000952,
    "codigo": "2751",
    "nombre": "PATRIARCA ROBERTO",
    "cuit": "20-11113505-4",
    "saldo":         0.00
  },
  {
    "id": 1100000953,
    "codigo": "2753",
    "nombre": "DAUPHIN ARNALDO Y OSCAR",
    "cuit": "30-59063445-6",
    "saldo":         0.00
  },
  {
    "id": 1100000954,
    "codigo": "2754",
    "nombre": "LERA RAUL",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000955,
    "codigo": "2755",
    "nombre": "APRAIZ CARLOS",
    "cuit": "23-05516366-9",
    "saldo":        -0.04
  },
  {
    "id": 1100000956,
    "codigo": "2756",
    "nombre": "BURGOS SUAREZ GLADYS NOEMI",
    "cuit": "27-11913595-3",
    "saldo":         0.00
  },
  {
    "id": 1100000957,
    "codigo": "2765",
    "nombre": "SCHACHTEL GERARDO",
    "cuit": "20-05488353-7",
    "saldo":         0.00
  },
  {
    "id": 1100000958,
    "codigo": "2766",
    "nombre": "JUAREZ GABRIELA SUSANA (PIZZICOSA)",
    "cuit": "27-18037662-9",
    "saldo":         0.00
  },
  {
    "id": 1100000959,
    "codigo": "2767",
    "nombre": "DIEZ DANIEL",
    "cuit": "20-21152078-8",
    "saldo":         0.00
  },
  {
    "id": 1100000960,
    "codigo": "2769",
    "nombre": "CORNEJO ELOY",
    "cuit": "20-54916656-4",
    "saldo":         0.00
  },
  {
    "id": 1100000961,
    "codigo": "2770",
    "nombre": "GIANOVICH MAURICIO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000962,
    "codigo": "2776",
    "nombre": "FRANCISCO FERNANDO",
    "cuit": "20-16455192-0",
    "saldo":         0.00
  },
  {
    "id": 1100000963,
    "codigo": "2777",
    "nombre": "MADARIETA ANTONIO Y PAGLIALUNGA ESTEBAN",
    "cuit": "33-64110774-9",
    "saldo":         0.00
  },
  {
    "id": 1100000964,
    "codigo": "2780",
    "nombre": "GALLINJER ALEJANDRO",
    "cuit": "20-05455610-2",
    "saldo":         0.00
  },
  {
    "id": 1100000965,
    "codigo": "2781",
    "nombre": "VEGA MARIA MERCEDES",
    "cuit": "27-16305642-4",
    "saldo":         0.00
  },
  {
    "id": 1100000966,
    "codigo": "2784",
    "nombre": "PALAU RH -PARRILLA-",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000967,
    "codigo": "2786",
    "nombre": "QUINTANA DAVID",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000968,
    "codigo": "2787",
    "nombre": "DONAIRE ERNESTO NERI",
    "cuit": "20-13467308-8",
    "saldo":         0.00
  },
  {
    "id": 1100000969,
    "codigo": "2788",
    "nombre": "PEREZ MIGUEL ANGEL",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000970,
    "codigo": "2789",
    "nombre": "VLEK ADRIAN EDGARDO",
    "cuit": "20-16681253-5",
    "saldo":         0.00
  },
  {
    "id": 1100000971,
    "codigo": "2790",
    "nombre": "DE LARENA MARIA SANDRA",
    "cuit": "27-14556099-9",
    "saldo":         0.00
  },
  {
    "id": 1100000972,
    "codigo": "2792",
    "nombre": "VOGT JUAN CARLOS N1",
    "cuit": "20-17828969-2",
    "saldo":         0.00
  },
  {
    "id": 1100000973,
    "codigo": "2793",
    "nombre": "FABRIZZI RAUL MARINO",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000974,
    "codigo": "2794",
    "nombre": "CHAMAN DE CARLOVICH C Y RANDAZZO,D SH",
    "cuit": "30-68813266-1",
    "saldo":         0.00
  },
  {
    "id": 1100000975,
    "codigo": "2796",
    "nombre": "FAST COOK SRL",
    "cuit": "30-69802162-0",
    "saldo":         0.00
  },
  {
    "id": 1100000976,
    "codigo": "2797",
    "nombre": "FLORES DALMIRO JESUS",
    "cuit": "20-04553654-9",
    "saldo":         0.00
  },
  {
    "id": 1100000977,
    "codigo": "2798",
    "nombre": "DE CASCO CLOS",
    "cuit": "20-20691156-6",
    "saldo":         0.00
  },
  {
    "id": 1100000978,
    "codigo": "2799",
    "nombre": "CLUB UNIVERSITARIO",
    "cuit": "30-54518531-4",
    "saldo":         0.00
  },
  {
    "id": 1100000979,
    "codigo": "2801",
    "nombre": "COOPERATIVA AGROPECUARIA DOBLAS LTD",
    "cuit": "30-54090406-1",
    "saldo":         0.00
  },
  {
    "id": 1100000980,
    "codigo": "2803",
    "nombre": "MONTIEL RUBEN OMAR Y MONTIEL SERGIO RONA",
    "cuit": "33-67171800-9",
    "saldo":         0.00
  },
  {
    "id": 1100000981,
    "codigo": "2804",
    "nombre": "ROBERTINO DEL SHOPPING SRL",
    "cuit": "30-69588570-5",
    "saldo":         0.00
  },
  {
    "id": 1100000982,
    "codigo": "2805",
    "nombre": "FERULLO GERARDO",
    "cuit": "20-14595599-9",
    "saldo":         0.00
  },
  {
    "id": 1100000983,
    "codigo": "2806",
    "nombre": "VICENTE HILARIO RENE",
    "cuit": "20-05514127-5",
    "saldo":         0.00
  },
  {
    "id": 1100000984,
    "codigo": "2807",
    "nombre": "LOPEZ ADRIAN LUIS",
    "cuit": "23-14748571-9",
    "saldo":         0.00
  },
  {
    "id": 1100000985,
    "codigo": "2809",
    "nombre": "EEGONZALEZ Y SFZAMORA SH",
    "cuit": "30-69590478-5",
    "saldo":         0.00
  },
  {
    "id": 1100000986,
    "codigo": "2810",
    "nombre": "LANZAVECCHIA ALEJANDRO ROQUE",
    "cuit": "20-13979772-9",
    "saldo":         0.00
  },
  {
    "id": 1100000987,
    "codigo": "2811",
    "nombre": "PERERA NORMA EDITH MH",
    "cuit": "27-13941447-6",
    "saldo":         0.00
  },
  {
    "id": 1100000988,
    "codigo": "2812",
    "nombre": "OVIDE ELENA",
    "cuit": "27-93204058-7",
    "saldo":         0.00
  },
  {
    "id": 1100000989,
    "codigo": "2815",
    "nombre": "COOP PRE-NA-MAR CONSUMO PROV Y VIVIENDA",
    "cuit": "",
    "saldo":         0.00
  },
  {
    "id": 1100000990,
    "codigo": "2816",
    "nombre": "INAR SA",
    "cuit": "30-68804930-6",
    "saldo":         0.00
  },
  {
    "id": 1100000991,
    "codigo": "2817",
    "nombre": "VISSANI HNOS",
    "cuit": "30-68118019-9",
    "saldo":         0.00
  },
  {
    "id": 1100000992,
    "codigo": "2822",
    "nombre": "RODRIGO OMAR EDGARDO",
    "cuit": "23-05367697-9",
    "saldo":         0.00
  },
  {
    "id": 1100000993,
    "codigo": "2823",
    "nombre": "MANDINO",
    "cuit": "20-05494226-6",
    "saldo":         0.00
  },
  {
    "id": 1100000994,
    "codigo": "2824",
    "nombre": "ESCOBIO ELIDA",
    "cuit": "23-06627283-4",
    "saldo":         0.00
  },
  {
    "id": 1100000995,
    "codigo": "2825",
    "nombre": "BLANCO INGENIERIA SA",
    "cuit": "30-60414221-7",
    "saldo":         0.00
  },
  {
    "id": 1100000996,
    "codigo": "2827",
    "nombre": "BACHMEIR ANA M B DE",
    "cuit": "27-06729052-1",
    "saldo":         0.00
  },
  {
    "id": 1100000997,
    "codigo": "2832",
    "nombre": "CAPELLA J Y ALMANSA A SH",
    "cuit": "30-67880712-0",
    "saldo":         0.00
  },
  {
    "id": 1100000998,
    "codigo": "2833",
    "nombre": "SIROCCHI FRANCISCO",
    "cuit": "30-56711224-8",
    "saldo":         0.00
  },
  {
    "id": 1100000999,
    "codigo": "2834",
    "nombre": "BYK ARGENTINA SA",
    "cuit": "30-50160299-6",
    "saldo":         0.00
  },
  {
    "id": 1100001000,
    "codigo": "2835",
    "nombre": "SECE SRL",
    "cuit": "33-69590324-9",
    "saldo":         0.00
  }
 ]