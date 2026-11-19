*==============================================================================
* COMBOS POR PRODUCTOS SUELTOS (forma Santarossa) para Distribuidora - regfacpub
* 18/11/2026
*
* Metodos para la clase local "oregfacvta" (clases\onegocioslocal.vcx), que en
* regfacpub es thisform.oRegfacvta. Convive con la forma actual de Distribuidora
* (cargar el producto combo -> cargarcombo agrega sus productos con escombo = 1):
*
*   escombo = 1  (renglon agregado por el producto combo) -> NO se toca aca.
*   escombo = 0  (renglon cargado suelto)                 -> lo controla este codigo.
*
* Que hace: despues de cada renglon (y al borrar uno) revisa si los renglones
* sueltos completan algun combo vigente (CabeCombo/CuerCombo con feccorte >= fecha
* de la factura). Si lo completan, a esos renglones les pone:
*     despor      = CuerCombo.bonifica del articulo
*     bondigitada = 1   (para que grid2_control no le recalcule la bonificacion)
*     idprodcombo = CabeCombo.id
*     idcabeunifica = 0
* Si el combo deja de estar completo (cambio de cantidad, renglon borrado), a los
* renglones que habia marcado les DEVUELVE la bonificacion que tenian antes.
*
* Reglas (las mismas de Santarossa, verificarcombo):
*  - Cada renglon entra entero en el combo: su cantidad tiene que ser <= a lo que
*    todavia falta de ese articulo en el combo. Se compara la cantidad tal como se
*    cargo (no se pasa a unidades por bulto), igual que Santarossa.
*  - Si alcanzan para dos o mas combos iguales, se arman todos los que se completen.
*  - Un renglon queda en un solo combo: si un articulo esta en dos combos, gana el
*    combo de id mas bajo.
*  - No cuentan: renglones de cambio (escambio = 1), de promocion (espromocion = 1)
*    ni los que vinieron de un producto combo (escombo = 1).
*
* Parametro: paravario nombre = 'FACPUB_COMBOSUELTOS', estado = 1 -> activado.
* (independiente de Fac_Combo, que sigue manejando la forma de Distribuidora;
*  pueden estar los dos activos).
*
*------------------------------------------------------------------------------
* PROPIEDADES a agregar a oregfacvta (onegocioslocal):
*   combosueltos     = .F.   && FACPUB_COMBOSUELTOS activo
*   combosleidos     = .F.   && ya se leyo el parametro
*   combosfecha      = ""    && DTOS de la fecha con la que se cargo CsrProdCombos
*   combosenproceso  = .F.   && corta la recursividad
*------------------------------------------------------------------------------
* ENGANCHES en regfacpub: ver enganches_regfacpub.txt
*==============================================================================


*------------------------------------------------------------------------------
PROCEDURE combos_leerparametro
*------------------------------------------------------------------------------
LOCAL lcCmd

this.combosueltos = .F.

TEXT TO lcCmd TEXTMERGE NOSHOW
SELECT CsrParaVario.* FROM ParaVario as CsrParaVario
WHERE CsrParaVario.nombre = 'FACPUB_COMBOSUELTOS'
ENDTEXT

IF CrearCursorAdapter('CsrParaCombo',lcCmd)
	IF RECCOUNT('CsrParaCombo')#0
		this.combosueltos = (CsrParaCombo.estado = 1)
	ENDIF
	USE IN CsrParaCombo
ENDIF
this.combosleidos = .T.

RETURN this.combosueltos
ENDPROC


*------------------------------------------------------------------------------
PROCEDURE combos_iniciar
*------------------------------------------------------------------------------
* Opcional: llamarlo al empezar un comprobante nuevo. Limpia las marcas de los
* renglones que se pusieron en combo (igual se validan antes de usarlas).
IF USED('CsrComboMarca')
	SET SAFETY OFF
	ZAP IN CsrComboMarca
	SET SAFETY ON
ENDIF
ENDPROC


*------------------------------------------------------------------------------
PROCEDURE combos_cargar
*------------------------------------------------------------------------------
* Combos vigentes a la fecha de la factura. Se recarga solo si cambia la fecha.
LPARAMETERS ldFecha
LOCAL lcCmd,lcFecha

lcFecha = DTOS(ldFecha)
IF USED('CsrProdCombos') AND this.combosfecha == lcFecha
	RETURN .T.
ENDIF

IF USED('CsrProdCombos')
	USE IN CsrProdCombos
ENDIF

&& El ORDER BY importa: los combos se recorren por idcabecombo.
TEXT TO lcCmd TEXTMERGE NOSHOW
SELECT CsrCuerCombo.idcabecombo, CsrCuerCombo.idarticulo, CsrCuerCombo.cantidad
,CsrCuerCombo.bonifica, CsrCabeCombo.feccorte
FROM CabeCombo as CsrCabeCombo
inner join CuerCombo as CsrCuerCombo on CsrCabeCombo.id = CsrCuerCombo.idcabecombo
inner join Producto as CsrProducto on CsrCabeCombo.idpromocion = CsrProducto.id
where CsrCabeCombo.feccorte >= '<<lcFecha>>'
and CsrProducto.idestado = 1 and CsrProducto.nofactura = 0
order by CsrCuerCombo.idcabecombo, CsrCuerCombo.idarticulo
ENDTEXT

IF NOT CrearCursorAdapter('CsrProdCombos',lcCmd)
	this.combosfecha = ""
	RETURN .F.
ENDIF

this.combosfecha = lcFecha
RETURN .T.
ENDPROC


*------------------------------------------------------------------------------
PROCEDURE combos_controlar
*------------------------------------------------------------------------------
* Llamar al final de grid2_control y en grid2_borrarlinea (ver enganches).
LOCAL lnSelect,lnRecno,llCambio

IF NOT this.combosleidos
	this.combos_leerparametro()
ENDIF
IF NOT this.combosueltos OR this.combosenproceso
	RETURN .T.
ENDIF
IF thisform.accion#'A' OR thisform.hayescape
	RETURN .T.
ENDIF
IF NOT USED('CsrAuxCuerfac') OR NOT USED('CsrAuxCabefac')
	RETURN .T.
ENDIF

lnSelect = SELECT()
lnRecno  = IIF(EOF('CsrAuxCuerfac') OR BOF('CsrAuxCuerfac'),0,RECNO('CsrAuxCuerfac'))
llCambio = .F.
this.combosenproceso = .T.

IF NOT USED('CsrComboMarca')
	&& Renglones que este codigo puso en combo, con la bonificacion que tenian antes
	CREATE CURSOR CsrComboMarca (nrec I, idarticulo I, idcombo I, despor N(11,3) ;
		,desporant N(11,3), bondigant N(2,0))
ENDIF

IF this.combos_cargar(CsrAuxCabefac.fecha) AND RECCOUNT('CsrProdCombos')#0
	SELECT DISTINCT idcabecombo FROM CsrProdCombos ORDER BY 1 INTO CURSOR CsrCombosIds
	SELECT CsrCombosIds
	SCAN
		IF this.combos_verificar(CsrCombosIds.idcabecombo)
			llCambio = .T.
		ENDIF
		SELECT CsrCombosIds
	ENDSCAN
	USE IN CsrCombosIds
ENDIF

IF llCambio
	thisform.totalcomprobante()
	thisform.grid2.Refresh()
ENDIF

IF lnRecno#0 AND lnRecno<=RECCOUNT('CsrAuxCuerfac')
	GO lnRecno IN CsrAuxCuerfac
ENDIF
this.combosenproceso = .F.
SELECT (lnSelect)

RETURN .T.
ENDPROC


*------------------------------------------------------------------------------
PROCEDURE combos_verificar
*------------------------------------------------------------------------------
* Arma (o desarma) el combo nIdCombo con los renglones sueltos.
* Devuelve .T. si cambio algun renglon.
LPARAMETERS nIdCombo
LOCAL llCambio,lnTotalReq,lnGrupo,lnFalta,lnRec,lnBonif,lnSelect

llCambio = .F.
lnSelect = SELECT()

&& Lo que pide el combo, por articulo
SELECT idarticulo, SUM(cantidad) as requerido, SUM(cantidad) as falta, MAX(bonifica) as bonifica ;
	FROM CsrProdCombos WHERE idcabecombo = nIdCombo ;
	GROUP BY idarticulo INTO CURSOR CsrComboReq READWRITE

SELECT CsrComboReq
SUM requerido TO lnTotalReq
IF lnTotalReq <= 0
	USE IN CsrComboReq
	SELECT (lnSelect)
	RETURN .F.
ENDIF

&& Renglones sueltos que pueden entrar en este combo
SELECT RECNO() as nrec, idarticulo, cantidad, 0000 as grupo, 0 as asignado ;
	FROM CsrAuxCuerfac ;
	WHERE NOT DELETED() AND idarticulo#0 AND cantidad>0 ;
	AND escombo=0 AND espromocion#1 AND escambio#1 ;
	AND (idprodcombo=0 OR idprodcombo=nIdCombo) ;
	AND idarticulo IN (SELECT idarticulo FROM CsrComboReq) ;
	ORDER BY 1 INTO CURSOR CsrComboFilas READWRITE

&& Armamos tantos combos completos como se pueda
lnGrupo = 0
DO WHILE .T.
	lnGrupo = lnGrupo + 1

	SELECT CsrComboReq
	REPLACE ALL falta WITH requerido

	SELECT CsrComboFilas
	SCAN FOR asignado = 0 AND grupo = 0
		SELECT CsrComboReq
		LOCATE FOR idarticulo = CsrComboFilas.idarticulo
		IF FOUND() AND CsrComboReq.falta >= CsrComboFilas.cantidad
			REPLACE falta WITH falta - CsrComboFilas.cantidad IN CsrComboReq
			REPLACE grupo WITH lnGrupo IN CsrComboFilas
		ENDIF
		SELECT CsrComboFilas
	ENDSCAN

	SELECT CsrComboReq
	SUM falta TO lnFalta
	IF lnFalta = 0
		&& Combo completo
		REPLACE asignado WITH 1 FOR grupo = lnGrupo IN CsrComboFilas
	ELSE
		&& Incompleto: esos renglones no quedan en combo
		REPLACE grupo WITH 0 FOR grupo = lnGrupo IN CsrComboFilas
		EXIT
	ENDIF
ENDDO

&& 1) Renglones que quedan en el combo
SELECT CsrComboFilas
SCAN FOR asignado = 1
	lnRec = CsrComboFilas.nrec

	SELECT CsrComboReq
	LOCATE FOR idarticulo = CsrComboFilas.idarticulo
	lnBonif = CsrComboReq.bonifica

	GO lnRec IN CsrAuxCuerfac

	&& Marca: guardamos la bonificacion que tenia antes (solo la primera vez)
	SELECT CsrComboMarca
	LOCATE FOR nrec = lnRec
	IF NOT FOUND() OR CsrComboMarca.idarticulo # CsrAuxCuerfac.idarticulo
		IF NOT FOUND()
			APPEND BLANK
		ENDIF
		REPLACE nrec WITH lnRec, idarticulo WITH CsrAuxCuerfac.idarticulo ;
			,desporant WITH CsrAuxCuerfac.despor, bondigant WITH CsrAuxCuerfac.bondigitada IN CsrComboMarca
	ENDIF
	REPLACE idcombo WITH nIdCombo, despor WITH lnBonif IN CsrComboMarca

	IF CsrAuxCuerfac.idprodcombo # nIdCombo OR CsrAuxCuerfac.despor # lnBonif OR CsrAuxCuerfac.bondigitada # 1
		REPLACE despor WITH lnBonif, bondigitada WITH 1, idprodcombo WITH nIdCombo ;
			,idcabeunifica WITH 0 IN CsrAuxCuerfac
		this.combos_recalcularrenglon(lnRec)
		llCambio = .T.
	ENDIF

	SELECT CsrComboFilas
ENDSCAN

&& 2) Renglones que estaban en este combo y ya no: vuelven a su bonificacion anterior.
&&    Solo si el renglon sigue siendo el mismo (articulo y bonificacion del combo),
&&    por si la marca quedo de otro comprobante.
SELECT CsrComboMarca
SCAN FOR idcombo = nIdCombo
	lnRec = CsrComboMarca.nrec

	SELECT CsrComboFilas
	LOCATE FOR nrec = lnRec AND asignado = 1
	IF NOT FOUND()
		IF lnRec <= RECCOUNT('CsrAuxCuerfac')
			GO lnRec IN CsrAuxCuerfac
			IF NOT DELETED('CsrAuxCuerfac') ;
					AND CsrAuxCuerfac.idarticulo = CsrComboMarca.idarticulo ;
					AND CsrAuxCuerfac.escombo = 0 ;
					AND CsrAuxCuerfac.bondigitada = 1 ;
					AND CsrAuxCuerfac.despor = CsrComboMarca.despor ;
					AND INLIST(CsrAuxCuerfac.idprodcombo,0,nIdCombo)
				REPLACE despor WITH CsrComboMarca.desporant, bondigitada WITH CsrComboMarca.bondigant ;
					,idprodcombo WITH 0 IN CsrAuxCuerfac
				this.combos_recalcularrenglon(lnRec)
				llCambio = .T.
			ENDIF
		ENDIF
		DELETE IN CsrComboMarca
	ENDIF

	SELECT CsrComboMarca
ENDSCAN

USE IN CsrComboFilas
USE IN CsrComboReq
SELECT (lnSelect)

RETURN llCambio
ENDPROC


*------------------------------------------------------------------------------
PROCEDURE combos_recalcularrenglon
*------------------------------------------------------------------------------
* Recalcula un renglon con su despor actual, igual que grid2_control de regfacpub.
LPARAMETERS lnRec
LOCAL OscatterCab,Oscatter,lncantidad,lnunibulto,lnpesable,lnkilos,lnSelect

lnSelect = SELECT()

SELECT CsrAuxCabefac
SCATTER NAME OscatterCab

GO lnRec IN CsrAuxCuerfac
SELECT CsrAuxCuerfac
SCATTER NAME Oscatter

lncantidad = Oscatter.cantidad
lnunibulto = IIF(Oscatter.unibulto=0,1,Oscatter.unibulto)
lnunibulto = IIF(Oscatter.univenta=1,1,lnunibulto)
lnpesable  = Oscatter.pesable
lnkilos    = IIF(lnpesable=0,0,Oscatter.cantkilos)

thisform.unitariofac.Calculaimpuesto(Oscatter,OscatterCab,lncantidad,lnunibulto,lnpesable,lnkilos)

Oscatter.total = Red((IIF(thisform.incluyeiva,Oscatter.UniCiva,Oscatter.UniSiva) + Oscatter.internofin),thisform.ndecimaltot)

IF Oscatter.esCambio = 1
	Oscatter.Boniciva  = 0
	Oscatter.Bonisiva  = 0
	Oscatter.totalciva = 0
	Oscatter.totalsiva = 0
	Oscatter.total     = 0
ENDIF

SELECT CsrAuxCuerfac
GO lnRec
GATHER NAME Oscatter

SELECT (lnSelect)
ENDPROC
