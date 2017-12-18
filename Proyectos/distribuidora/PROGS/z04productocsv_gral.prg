PARAMETERS ldvacio,lcpath,lcBase
LOCAL lcData,lnid,lcfecha
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE 

SET SAFETY OFF


SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON
Oavisar.proceso('S','Abriendo archivos') 
llok = .t.
llok = CargarTabla(lcData,'Producto',.t.)
llok = CargarTabla(lcData,'Variedad',.t.)
llok = CargarTabla(lcData,'Rubro',.t.)
llok = CargarTabla(lcData,'Marca',.t.)
llok = CargarTabla(lcData,'SubProducto',.t.)
llok = CargarTabla(lcData,'BloqueoProd',.t.)
llok = CargarTabla(lcData,'GamaBase',.t.)
llok = CargarTabla(lcData,'Deposito',.t.)
llok = CargarTabla(lcData,'Ubicacion',.t.)
llok = CargarTabla(lcData,'FuerzaVta')
llok = CargarTabla(lcData,'Ctacte')


SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

IF USED('CsrLista')
	USE IN CsrLista
ENDIF 

SELECT CsrFuerzaVta
GO TOP 
lnidfuerzavta = CsrFuerzavta.id

&&&&UBICACIONES
lnid = RecuperarID('CsrUbicacion',Goapp.sucursal10)

INSERT INTO CsrUbicacion (id,numero,nombre)	VALUES (lnid,'1','GENERAL')


CREATE CURSOR CsrLista (deta c(254))
		
Oavisar.proceso('S','Abriendo archivos') 

local lnidrubro, lnidmarca, lncodrubro
store 0 to lnidrubro, lnidmarca ,lncodrubro

SELECT CsrLista
cArhivo = ALLTRIM(lcpath )+"\articulos.csv"
APPEND FROM  &cArhivo SDF


SELECT CsrLista
GO TOP 
vista()
i	= 1
SCAN 
	cRegistro	= ALLTRIM(CsrLista.deta)
	nPos		= AT(';',cRegistro,i)
	cCodigo		= LEFT(cRegistro,nPos-1)
	i = i + 1
	nPos		= AT(';',cRegistro,i)
	cRubro	= SUBSTR(cRegistro,AT(';',cRegistro,i-1)+1,nPos-1)
	i = i + 1 
	nPos		= AT(';',cRegistro,i)
	cNombre		= SUBSTR(cRegistro,AT(';',cRegistro,i-1)+1,nPos-1)
	i = i + 1 
	nPos		= AT(';',cRegistro,i)
	cCodProv	= SUBSTR(cRegistro,AT(';',cRegistro,i-1)+1,nPos-1) + " PROVEEDOR"
	i = i + 2
	nPos		= AT(';',cRegistro,i)
	cCossiva	= SUBSTR(cRegistro,AT(';',cRegistro,i-1)+1,nPos-1)
	i = i + 1
	nPos		= AT(';',cRegistro,i)
	cCosCiva	= SUBSTR(cRegistro,AT(';',cRegistro,i-1)+1,nPos-1)
	i = i + 2
	nPos		= AT(';',cRegistro,i)
	cPref1Siva	= SUBSTR(cRegistro,AT(';',cRegistro,i-1)+1,nPos-1)
	i = i + 1
	nPos		= AT(';',cRegistro,i)
	cPref1Civa	= SUBSTR(cRegistro,AT(';',cRegistro,i-1)+1,nPos-1)
	i = i + 3
	nPos		= AT(';',cRegistro,i)
	cPref2Siva	= SUBSTR(cRegistro,AT(';',cRegistro,i-1)+1,nPos-1)
	i = i + 1
	nPos		= AT(';',cRegistro,i)
	cPref2Civa	= SUBSTR(cRegistro,AT(';',cRegistro,i-1)+1,nPos-1)
	i = i + 3
	nPos		= AT(';',cRegistro,i)
	cPref3Siva	= SUBSTR(cRegistro,AT(';',cRegistro,i-1)+1,nPos-1)
	i = i + 1
	nPos		= AT(';',cRegistro,i)
	cPref3Civa	= SUBSTR(cRegistro,AT(';',cRegistro,i-1)+1,nPos-1)
	i = i + 3
	nPos		= AT(';',cRegistro,i)
	cStock		= SUBSTR(cRegistro,AT(';',cRegistro,i-1)+1,nPos-1)
	i = i + 2
	nPos		= AT(';',cRegistro,i)
	cAlicuota	= SUBSTR(cRegistro,AT(';',cRegistro,i-1)+1,nPos-1)
	
	if lentrim(cRubro)<>0 and not lentrim(cRubro)$cCadRubro
		store 1100000001 to lntipoprod,lntipovta,
		store 0 to lnolista,lnporcecomi,lnporcedev,lnporcesuge,lntasavied,lntasapata
		lnretibruto	= 1 
		lcnombre	= NombreNi(ALLTRIM(UPPER(cRubro)))
		lncodrubro	= lncodrubro + 1
		INSERT INTO CsrRubro (id,numero,nombre,idtipoprod,idtipovta,perceibruto,idfuerzavta,nolista;
			,porcecomi,porcesuge,porcedev,tasavied,tasapata) ;
		VALUES (lnidrubro,lncodrubro,lcnombre,lntipoprod,lntipovta,lnretibruto,lnidfuerzavta,lnolista;
			,lnporcecomi,lnporcesuge,lnporcedev,lntasavied,lntasapata)
		lnidrubro = lnidrubro + 1
		cCadRubro	= cCadRubro + "/" + cRubro
		
		INSERT INTO Csrmarca (id,numero,nombre,flete,flete2,idfuerzavta);
		VALUES (lnidrubro,lncodrubro,lcnombre,0,0,lnidfuerzavta)
	
	endif 
	IF VAL(cCodigo)<>0
		SELECT CsrProducto
		LOCATE FOR numero = VAL(cCodigo)
		IF numero = VAL(cCodigo)
			replace peso WITH VAL(cKilos)
		ENDIF 
	ENDIF 
	SELECT CsrLista
ENDSCAN 

SELECT CsrProducto
vista()

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')



CLOSE tables
CLOSE INDEXES
CLOSE DATABASES