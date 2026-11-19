*==============================================================================
* COPIA EN PDF DE CADA COMPROBANTE (parametro FACVTA_PDF) - 18/11/2026
*
* Metodo para la clase local "oregfacvta" (clases\onegocioslocal.vcx), que en
* regfacpub y regfacvta es thisform.oRegfacvta.
*
* Por que no se guardaba:
*  1) El parametro FACVTA_PDF (ruta, "Guardar siempre un PDF", formato) lo graba
*     paravario_facvta, pero NINGUN form ni el impresor lo lee.
*  2) El PDF que se genera hoy es un efecto de imprimir: el impresor
*     (clases\localproyeto, reportfcae) llama a salidapdf en la 1ra copia, pero con
*     loObjVariables.lcfilename = "" -> el archivo sale "<PATHFACPDF>\.pdf"
*     (o ".pdf" en la carpeta del sistema si PATHFACPDF esta vacio): cada factura
*     PISA a la anterior. thisform.Objimpresor.rutadelarchivo queda con ese nombre.
*  3) Solo pasa por reportfcae lo electronico (A/B/C, origen FE). X, remitos, etc.
*     (reportfa / reportremito) no generan PDF.
*
* Que hace este metodo: despues de imprimir, si FACVTA_PDF esta activo (estado = 1)
* y tiene ruta (detalle), copia el PDF recien generado a esa ruta con el nombre del
* comprobante:  <ruta>\<cabrevia> <numcomp>.pdf   (ej. "FAC A 0003-00012345.pdf")
* Si ya existe (reimpresion), la pisa: queda solo la ultima copia.
*
* Limites (no cambian con esto):
*  - Si no se imprime (regfacvta con "Solo grabar", o se contesta "No" a imprimir)
*    no hay PDF que copiar.
*  - Los no electronicos (X, remitos) siguen sin PDF: para eso hay que tocar el
*    impresor (reportfa / reportremito) en localproyeto.
*
*------------------------------------------------------------------------------
* PROPIEDADES a agregar a oregfacvta (onegocioslocal):
*   pdfleido   = .F.
*   pdfguardar = .F.   && FACVTA_PDF estado = 1
*   pdfruta    = ""    && FACVTA_PDF detalle
*------------------------------------------------------------------------------
* ENGANCHES: ver enganches_regfacpub.txt (regfacpub y regfacvta, metodo imprimir)
*==============================================================================


*------------------------------------------------------------------------------
PROCEDURE pdf_leerparametro
*------------------------------------------------------------------------------
LOCAL lcCmd

this.pdfguardar = .F.
this.pdfruta    = ""

TEXT TO lcCmd TEXTMERGE NOSHOW
SELECT CsrParaVario.* FROM ParaVario as CsrParaVario
WHERE CsrParaVario.nombre = 'FACVTA_PDF'
ENDTEXT

IF CrearCursorAdapter('CsrParaPDF',lcCmd)
	IF RECCOUNT('CsrParaPDF')#0
		this.pdfguardar = (CsrParaPDF.estado = 1)
		this.pdfruta    = ALLTRIM(NVL(CsrParaPDF.detalle,''))
	ENDIF
	USE IN CsrParaPDF
ENDIF
this.pdfleido = .T.

RETURN this.pdfguardar
ENDPROC


*------------------------------------------------------------------------------
PROCEDURE pdf_guardarcopia
*------------------------------------------------------------------------------
* Llamar justo despues de thisform.Objimpresor.inicioimpresora(...) en el metodo
* imprimir del form. Antes de inicioimpresora hay que vaciar
* thisform.Objimpresor.rutadelarchivo (ver enganches) para no copiar un PDF viejo.
LOCAL lcOrigen,lcRuta,lcNombre,lcNumComp,lcAbrevia,lcDestino,llOk,loErr

IF NOT this.pdfleido
	this.pdf_leerparametro()
ENDIF
IF NOT this.pdfguardar OR EMPTY(this.pdfruta)
	RETURN .F.
ENDIF

lcOrigen = ALLTRIM(NVL(thisform.Objimpresor.rutadelarchivo,''))
IF EMPTY(lcOrigen) OR NOT FILE(lcOrigen)
	RETURN .F.
ENDIF

lcRuta = ADDBS(this.pdfruta)

&& Nombre: abreviatura del comprobante + numero
lcAbrevia = IIF(USED('CsrComprobante'),ALLTRIM(CsrComprobante.cabrevia),'')
lcNumComp = IIF(USED('CsrAuxMaopera'),ALLTRIM(NVL(CsrAuxMaopera.numcomp,'')),'')
IF EMPTY(lcNumComp)
	&& Sin numero todavia: usamos fecha y hora para no pisar
	lcNumComp = DTOS(DATE()) + "_" + CHRTRAN(TIME(),":","")
ENDIF
lcNombre = ALLTRIM(lcAbrevia + " " + lcNumComp)
lcNombre = CHRTRAN(lcNombre,'\/:*?"<>|','_________')

&& Una sola copia por comprobante: si ya existe (reimpresion), se pisa con la ultima.
lcDestino = lcRuta + lcNombre + ".pdf"

llOk = .T.
TRY
	IF NOT DIRECTORY(lcRuta)
		MKDIR (lcRuta)
	ENDIF
	IF FILE(lcDestino)
		ERASE (lcDestino)
	ENDIF
	COPY FILE (lcOrigen) TO (lcDestino)
CATCH TO loErr
	llOk = .F.
	=Oavisar.usuario("No se pudo guardar la copia en PDF del comprobante" + CHR(13) ;
		+ lcDestino + CHR(13) + loErr.Message,0)
ENDTRY

RETURN llOk
ENDPROC
