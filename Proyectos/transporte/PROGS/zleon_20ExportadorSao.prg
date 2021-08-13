PARAMETERS lcpath
lcpath = IIF(PCOUNT()<2,"",lcpath)

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE 

SET SAFETY OFF

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON
Oavisar.proceso('S','Abriendo archivos') 

llok = .t.
TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrProducto.* 
,CsrCtacte.cnumero as ctacte,CsrRubro.numero  as seccion
,CsrTipofrio.numero as frio,CsrMarca.numero as marca
,Ubicacion.numero as lcubicacion,ISNULL(CsrEnvase.numero,CAST(0 as int)) as envase
FROM Producto as CsrProducto
left join ctacte as CsrCtacte on CsrProducto.idctacte = CsrCtacte.id
left join rubro as CsrRubro on CsrProducto.idrubro = CsrRubro.id
left join tipofrio as CsrTipofrio on CsrProducto.idtipofrio = CsrTipoFrio.id
left join marca as CsrMarca on CsrProducto.idmarca = CsrMarca.id
left join ubicacion as CsrUbicacion on CsrPRoducto.idubicacio = CsrUbicacion.id
left join producto as CsrEnvase on CsrProducto.idenvase = CsrEnvase.id
order by numero
ENDTEXT 
IF !CrearCursorAdapter('CsrProducto',lcCmd)
	RETURN .f.
ENDIF 
TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrSubproducto.* FROM Subproducto as CsrSubproducto
ENDTEXT 
IF !CrearCursorAdapter('CsrSubProducto')
	RETURN .f.
ENDIF 

SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 

USE  ALLTRIM(lcpath )+"\gestion\articulo" in 0 alias CsrArticulo EXCLUSIVE	
USE  ALLTRIM(lcpath )+"\gestion\codbarra" in 0 alias CsrCodBarra EXCLUSIVE	
USE  ALLTRIM(lcpath )+"\gestion\sabor" in 0 alias CsrSabor EXCLUSIVE	

SELECT CsrArticulo.* FROM CsrArticulo WHERE RECNO()<1 INTO CURSOR CsrAuxProducto READWRITE 
SELECT CsrCodBarra.* FROM CsrCodBarra WHERE RECNO()<1 INTO CURSOR CsrAuxCodBarra READWRITE 
SELECT CsrSabor.* FROM CsrSabor WHERE RECNO()<1 INTO CURSOR CsrAuxSabor READWRITE 

Oavisar.proceso('S','Generando tabla de ARTICULOS ') 

SELECT CsrProducto
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
	SELECT CsrAuxArticulo
	APPEND BLANK
	SCATTER NAME Oscatter
	Oscatter.numero		= CsrProducto.numero
	Oscatter.nombre 	= CsrProducto.nombre
	Oscatter.seccion	= CsrProducto.seccion
	Oscatter.marca		= CsrProducto.marca
	Oscatter.articulo	= lnnumero
	Oscatter.cod_prv	= CsrProducto.codartprod
	Oscatter.codigo_emb	= CsrProducto.lcubicacion
	Oscatter.bonif1		= 0
	Oscatter.preventa1	= CsrProducto.prevta1 
	Oscatter.proveedor	= 10000 - CsrCtacte.ctacte
	Oscatter.cambio_pre	= .t.
	Oscatter.fechaulcpr	= TTOD(CsrProducto.feculcpr)
	Oscatter.fraccion 	= IIF(CsrProducto.fraccion=1,'S','N')
	Oscatter.puntope	= 0
	Oscatter.univenta	= ""
	Oscatter.unibulto	= CsrProducto.unibulto
	Oscatter.tablaiva	= IIF(RIGHT(STR(CsrProducto.idiva,10),1)='1',2,1))
	Oscatter.peso		= CsrProducto.peso
	Oscatter.kilos		= IIF(CsrProducto.vtakilos=1,'K','')

	SELECT CsrSubproducto
	LOCATE FOR idarticulo = CsrProducto.id
	Oscatter.sisabor	= IIF(idarticulo = CsrProducto.id,'S','N')
	
	Oscatter.barras		= 0
	Oscatter.interno	= CsrProducto.interno
	Oscatter.debaja		= IIF(CsrProducto,idestado=1,'','S')
	Oscatter.frio		= CsrProducto.frio
	Oscatter.secprv		= 0
	Oscatter.Costo	  	= CsrProducto.costo	
		
   	lnCostoBon			= CsrProducto.costobon
	Oscatter.Flete	  	= ROUND(CsrProducto.flete*100/lnCostoBon,2)	
	Oscatter.Bonifica 	= CsrProducto.bonif1
    Oscatter.utilidad	= CsrProducto.margen1
    Oscatter.util2		= CsrProducto.margen2
    Oscatter.util3		= CsrProducto.margen3
    Oscatter.preve2		= CsrProducto.prevta2 
	Oscatter.preve3		= CsrPRoducto.prevta3
	Oscatter.preve4		= CsrProducto.sugerido
	Oscatter.bonies		= CsrProducto.desc1
	Oscatter.bonies2	= CsrProducto.desc2
	Oscatter.bonies3	= CsrProducto.desc3
	Oscatter.minimo		= CsrProducto.min1
	Oscatter.minimo2	= CsrProducto.min2
	Oscatter.minimo3	= CsrProducto.min3
	Oscatter.Bonif2  	= CsrProducto.bonif2
	Oscatter.Bonif3  	= CsrProducto.bonif3
	Oscatter.Bonif4  	= CsrProducto.bonif4
	Oscatter.fechabon	= TTOD(CsrProducto.fecoferta)	
	Oscatter.fechapre	= TTOD(CsrProducto.fecmodi)
	
	Oscatter.tasa		= 0
	Oscatter.tasapata	= 0
	Oscatter.ibdif		= ''
	Oscatter.unicaja	= 0
	Oscatter.litros		= 0
	Oscatter.bajasto	= 0
	Oscatter.envase		= STR(CsrProducto.envase,4)
	Oscatter.sireparto	= IIF((CsrProducto.sireparto=0),'','S')
	
	GATHER NAME Oscatter
	
	SELECT CsrProducto
ENDSCAN

SELECT CsrSubProducto
GO TOP 
SCAN 
	SELECT CsrAuxSubProducto
	APPEND BLANK
	SCATTER NAME Oscatter
	OScatter.numero		= CsrSubProducto.numero
	Oscatter.CodBarra	= 0
	Oscatter.Sabor		= CsrSubProducto.subnumero
	Oscatter.NomSabor	= CsrSubProducto.nombre
	GATHER NAME Oscatter
	
	SELECT CsrAuxSabor
	LOCATE FOR numero = Oscatter.sabor
	IF numero = Oscatter.sabor
		APPEND BLANK
		SCATTER NAME OscSabor
		OscSabor.numero	= Oscatter.sabor
		OscSabor.nombre	= Oscatter.nombre
		GATHER NAME OscSabor
	ENDIF 
	SELECT CsrSubProducto
ENDSCAN 

SELECT CsrAuxArticulo
COPY TO PUTFILE('',UPPER(lcDestino+"\ARCHIVOS"),'dbf') SDF
SELECT CsrAuxCodBarra
COPY TO PUTFILE('',UPPER(lcDestino"\CODBARRA"),'dbf') SDF
SELECT CsrAuxSabor
COPY TO PUTFILE('',UPPER(lcDestino)"\SABOR",'dbf') SDF

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	
USE  IN  CsrCodBarra
USE IN  CsrArticulo 
USE in CsrSabor 
