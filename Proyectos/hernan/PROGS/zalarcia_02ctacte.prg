
DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

CLOSE DATABASES
CLOSE TABLES
OPEN DATABASE ? EXCLUSIVE

SET SAFETY OFF

Oavisar.proceso('S','Vaciando archivos') 

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON

SET DATABASE TO Alarcia
USE Alarcia!ctacte IN 0 ALIAS Csrctacte EXCLUSIVE
ZAP IN Csrctacte

USE Alarcia!localidad IN 0 ALIAS Csrlocalidad EXCLUSIVE

USE Alarcia!provincia IN 0 ALIAS Csrprovincia EXCLUSIVE

USE Alarcia!zona IN 0 ALIAS Csrzona EXCLUSIVE
ZAP IN Csrzona

USE Alarcia!zonaruta IN 0 ALIAS Csrzonaruta EXCLUSIVE
ZAP IN Csrzonaruta

USE Alarcia!vendedor IN 0 ALIAS CsrVendedor EXCLUSIVE
ZAP IN Csrvendedor

USE Alarcia!catectacte IN 0 ALIAS CsrTipoCtacte EXCLUSIVE
ZAP IN CsrTipoCtacte

USE Alarcia!ruta IN 0 ALIAS Csrruta EXCLUSIVE
ZAP IN Csrruta

USE Alarcia!rutavdor IN 0 ALIAS Csrrutavdor EXCLUSIVE 
ZAP IN Csrrutavdor

USE Alarcia!caberuta IN 0 ALIAS Csrcaberuta EXCLUSIVE
ZAP IN Csrcaberuta

USE Alarcia!cuerruta IN 0 ALIAS Csrcuerruta EXCLUSIVE
ZAP IN Csrcuerruta

USE Alarcia!FuerzaVta IN 0 ALIAS CsrFuerzaVta EXCLUSIVE
ZAP IN  CsrFuerzaVta

USE Alarcia!Barrio IN 0 ALIAS CsrBarrio EXCLUSIVE
ZAP IN  CsrBarrio

USE Alarcia!Plancue IN 0 ALIAS CsrPlanCue EXCLUSIVE
SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 
USE  "\soft\ALARCIA\gestion\clientes" in 0 alias CsrDeudorViej EXCLUSIVE

USE  "\soft\ALARCIA\gestion\proveed" in 0 alias CsrAcreedorViej EXCLUSIVE

USE "\soft\ALARCIA\gestion\localida" in 0 alias CsrLocalidadViejo EXCLUSIVE

USE "\soft\ALARCIA\gestion\provinci" in 0 alias CsrProvinciaViejo EXCLUSIVE

USE "\soft\ALARCIA\gestion\categori" in 0 alias CsrCategoriaDeudor EXCLUSIVE

*USE "\soft\ALARCIA\gestion\barrio" in 0 alias CsrBarrioviejo EXCLUSIVE

USE "\soft\ALARCIA\gestion\zona" IN 0 ALIAS CsrzonasVie EXCLUSIVE

USE "\soft\ALARCIA\gestion\vendedor" IN 0 ALIAS CsrVendeVie EXCLUSIVE

*USE "\soft\ALARCIA\gestion\carpetas" IN 0 ALIAS CsrRecorrido EXCLUSIVE

*USE "\soft\ALARCIA\gestion\noventa" IN 0 ALIAS CsrNoventa EXCLUSIVE



Oavisar.proceso('S','Procesando '+alias()) 
SELECT * FROM CsrDeudorViej ORDER BY numero INTO CURSOR CsrDeudor
SELECT * FROM CsrAcreedorViej ORDER BY numero INTO CURSOR Csracreedor


SELECT CsrTipoctacte
lnid = 1
IF FSIZE('id')>4
   lntama = 10
ELSE 
   lntam = 8
ENDIF 
lccadena = strzero(lnid,lntam)
lnid = VAL(str(Goapp.sucursal10+10,2)+lccadena)
SELECT CsrCategoriaDeudor
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()    
			&&&comprobar Ñ
			lcnombre=alltrim(UPPER(CsrCategoriaDeudor.nombre))
			IF '¤'$lcnombre OR '¥'$lcnombre
			 	FOR lni=1 to LEN(lcnombre)
			 		lc=SUBSTR(lcnombre,lni,1)
			 		IF '¤'=lc OR '¥'$lc
			 			lcnombre = ALLTRIM(SUBSTR(lcnombre,1,lni-1))+ALLTRIM('Ñ')+ALLTRIM(SUBSTR(lcnombre,lni+1,LEN(lcnombre)))
			 		ENDIF 
			 	ENDFOR  
			ENDIF 
			&&&&&&        
           INSERT INTO CsrTipoCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch);
           VALUES (lnid,CsrCategoriaDeudor.numero,lcnombre,0,0,0,'00000')
           lnid = lnid +1 
ENDSCAN
INSERT INTO CsrTipoCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnid,20,'CTA CTE BANCO',0,0,0,'00000')
lnid = lnid +1 
INSERT INTO CsrTipoCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnid,21,'CTA CTE PROVEEDOR',0,0,0,'01000')
*!*	lnid = lnid +1 
*!*	lnids = VAL(STR(Goapp.sucursal10 + 10,2)+LTRIM(STR(lnid)))
*!*	INSERT INTO CsrTipoCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnids,22,'CTA CTE SERVICIO',0,0,0,'00000')


SELECT CsrVendedor
lnid = 1
IF FSIZE('id')>4
   lntam = 10
ELSE 
   lntam = 8
ENDIF  
lccadena = strzero(lnid,lntam)
lnid = VAL(str(Goapp.sucursal10+10,2)+lccadena)
SELECT CsrVendeVie
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
            IF numero=0
               loop
           ENDIF
           lnprevta =1
           lnestado = 1
           &&&&&&&&&&&&& agregado 19/08 nombres con Ñ
           lcnombre=alltrim(UPPER(CsrvendeVie.nombre))
			IF '¤'$lcnombre OR '¥'$lcnombre
			 	FOR lni=1 to LEN(lcnombre)
			 		lc=SUBSTR(lcnombre,lni,1)
			 		IF '¤'=lc OR '¥'$lc
			 			lcnombre = ALLTRIM(SUBSTR(lcnombre,1,lni-1))+ALLTRIM('Ñ')+ALLTRIM(SUBSTR(lcnombre,lni+1,LEN(lcnombre)))
			 		ENDIF 
			 	ENDFOR  
			ENDIF   
			&&&&&&&&&&&&&&&&&&&&66                     
           INSERT INTO Csrvendedor (id,numero,nombre,clave,idctaflete,planilla,comision,estado,idctacomision;
           ,idctasueldo,prevta,idgrupocomi,lista,idctacte,acumulavale);
			values(lnid,CsrvendeVie.numero,lcnombre,"",1,1,Csrvendevie.comision,0,0,1,0,1,1,0,0)
           			 
           	lnid = lnid + 1

ENDSCAN

SELECT CsrZona
lnid = 1
lnnum= 1
IF FSIZE('id')>4
   lntam = 10
ELSE 
   lntam = 8
ENDIF 
lccadena = strzero(lnid,lntam)
lnid = VAL(str(Goapp.sucursal10+10,2)+lccadena)
SELECT CsrZonasVie
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()  
	&&&&&&&&&&&&& agregado 19/08 nombres con Ñ
   	lcnombre=alltrim(UPPER(CsrzonasVie.nombre))
	IF '¤'$lcnombre OR '¥'$lcnombre
	 	FOR lni=1 to LEN(lcnombre)
	 		lc=SUBSTR(lcnombre,lni,1)
	 		IF '¤'=lc OR '¥'$lc
	 			lcnombre = ALLTRIM(SUBSTR(lcnombre,1,lni-1))+ALLTRIM('Ñ')+ALLTRIM(SUBSTR(lcnombre,lni+1,LEN(lcnombre)))
	 		ENDIF 
	 	ENDFOR  
	ENDIF   
	&&&&&&&&&&&&&&&&&&&&66                   
   	INSERT INTO CsrZona (id,numero,nombre,porflete,abrevia);
   			 VALUES (lnid,lnnum,lcnombre,0,Csrzonasvie.numero)
   	lnnum = lnnum + 1
   	lnid = lnid + 1
ENDSCAN

SELECT CsrCtacte
lnid = 1
IF FSIZE('id')>4
   lntam = 10
ELSE 
   lntam = 8
ENDIF 
lccadena = strzero(lnid,lntam)
lnid = VAL(str(Goapp.sucursal10+10,2)+lccadena)
IF FSIZE('idlocalidad')>4
   	lntamloc = 10
ELSE 
   lntamloc = 8
ENDIF  
IF FSIZE('idprovincia')>4
   	lntamprov = 10
ELSE 
   	lntamprov = 8
ENDIF  
IF FSIZE('idcategoria')>4
   	lntamcate = 10
ELSE 
   	lntamcate = 8
ENDIF  
IF FSIZE('tipoiva')>4
   	lntamcuit = 10
ELSE 
   	lntamcuit = 8
ENDIF  

SELECT CsrDeudor
Oavisar.proceso('S','Procesando '+'Clientes') 
GO  TOP 

LOCAL lnidlocalidad,lntipoiva,lnctalogistica,lnctadeudor,lnctaacreedor,lnidcategoria,lnidprovincia;
,lnctabanco,lnctaotro,lnidplanpago,lnidcanalvta,lnsaldo,lnsaldoant,lnestadocta,lnbonif1,lnbonif2;
,lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnidcateibrng,lncomision,lnidtipodoc,lnlista,lndiasvto;
,lnexistegan 
	
STORE 0 TO lnidlocalidad,lntipoiva,lnctalogistica,lnctadeudor,lnctaacreedor,lnidcategoria,lnidprovincia
STORE 0 TO lnctabanco,lnctaotro,lnidplanpago,lnsaldo,lnsaldoant,lnestadocta,lnbonif1,lnbonif2
STORE 0 TO lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnidcateibrng,lncomision,lnidtipodoc
STORE 1 TO 	lnctadeudor,lnlista, lnidcanalvta
	
SCAN 

 		IF recno('CsrDeudor')/100=INT(RECNO('CsrDeudor')/100)
	    	*Oavisar.proceso('N')
	    	lcTitulo = "Clientes "+STR(RECNO(),10)   
	    	*?(lctitulo)  
	    	Oavisar.proceso('S',lcTitulo,.t.,recno())
	 	ENDIF
		lccnumero		= ALLTRIM(STR(CsrDeudor.numero))
		lccnombre		= ALLTRIM(CsrDeudor.nombre)
		lccdireccion	= ALLTRIM(CsrDeudor.direccion)
		lccpostal		= ""
		lcctelefono		= ALLTRIM(CsrDeudor.telefono)
		lcemail			= ""
		lccuit			= ""
		ldfechalta		= DATETIME(1900,01,01,0,0,0)
		lcobserva		= CsrDeudor.observa
		lcinscri01		= ""
		ldfecins01		= DATETIME(1900,01,01,0,0,0)
		lcinscri02		= IIF(CsrDeudor.ibrutos<>'N' and EMPTY(CsrDeudor.iblp),ALLTRIM(CsrDeudor.cuit),"")
		lcinscri03		= ""
		lcingbrutos		= IIF(CsrDeudor.ibrutos<>"N",ALLTRIM(CsrDeudor.Iblp),"")
		ldfecultcompra	= DATETIME(1900,01,01,0,0,0)
		ldfecultpago	= DATETIME(1900,01,01,0,0,0)
		lcnumdoc		= SUBSTR(CsrDeudor.cuit,4,8)
		lnexisteibto	= IIF(CsrDeudor.Ibrutos<>'N',1,0)
		lnexistegan 	= IIF(CsrDeudor.gananciaS<>'N',1,0)
		lctelefono2 	= STRTRAN(CsrDeudor.documento," ","")
		lndiasvto		= CsrDeudor.diasvto
		lntipocuit 		= CsrDeudor.tipocuit
		lcLocalidadBuscada = CsrDeudor.Localidad
		lnidplanpago	= 1100000001
		
		lccadena = strzero(6,lntamloc)
		lnidlocalidad = VAL(str(Goapp.sucursal10+10,2)+lccadena)
		lccadena = strzero(2,lntamprov)
		lnidprovincia = VAL(str(Goapp.sucursal10+10,2)+lccadena)
		
*!*			LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcnombre)
*!*			IF FOUND()
*!*				lnidlocalidad = CsrLocalidad.id
*!*				lnidprovincia = CsrLocalidad.idprovincia
*!*				lccpostal = CsrLocalidad.cpostal
*!*			ENDIF
		
		lccadena = strzero(1,lntamcate)
		lnidcategoria = VAL(str(Goapp.sucursal10+10,2)+lccadena)

		SELECT CsrTipoCtacte
		LOCATE FOR numero = CsrDeudor.categoria
		IF FOUND()
			lnidcategoria = CsrTipoCtacte.id
		ENDIF 
		
		lccadena = strzero(lntipocuit,lntamcuit)
		lntipoiva = VAL(str(Goapp.sucursal10+10,2)+lccadena)
		
		IF lntipoiva=VAL(STR(Goapp.sucursal10 + 10,2)+LTRIM(strzero(7,lntamcuit)))
			   lntipoiva = VAL(STR(Goapp.sucursal10 + 10,2)+LTRIM(strzero(5,lntamcuit)))
		ENDIF 
		lccuit =CsrDeudor.cuit
		*lccuit =STRTRAN(CsrDeudor.cuit,"-","")
		IF lntipoiva=VAL(STR(Goapp.sucursal10 + 10,2)+LTRIM(strzero(3,lntamcuit)))
			lncuit=''
		ENDIF
		
        ldfecfac = CsrDeudor.fechaulcpr
		IF !EMPTY(ldfecfac)
			ldfecultcompra = DATETIME(YEAR(ldfecfac),MONTH(ldfecfac),DAY(ldfecfac),0,0,0)
		ENDIF 
		ldfechap = CsrDeudor.Fechaulpag
		IF !EMPTY(ldfechap)
			ldfecultpago = DATETIME(YEAR(ldfechap),MONTH(ldfechap),DAY(ldfechap),0,0,0)
		ENDIF 
		
		 &&&&&&&&&&&&& agregado 19/08 nombres con Ñ
       	lcnombre=alltrim(UPPER(lccnombre))
		IF '¤'$lcnombre OR '¥'$lcnombre
		 	FOR lni=1 to LEN(lcnombre)
		 		lc=SUBSTR(lcnombre,lni,1)
		 		IF '¤'=lc OR '¥'$lc
		 			lcnombre = ALLTRIM(SUBSTR(lcnombre,1,lni-1))+ALLTRIM('Ñ')+ALLTRIM(SUBSTR(lcnombre,lni+1,LEN(lcnombre)))
		 		ENDIF 
		 	ENDFOR  
		ENDIF   
		lcnomctacte = lcnombre
		lcnombre=alltrim(UPPER(lccdireccion))
		IF '¤'$lcnombre OR '¥'$lcnombre
		 	FOR lni=1 to LEN(lcnombre)
		 		lc=SUBSTR(lcnombre,lni,1)
		 		IF '¤'=lc OR '¥'$lc
		 			lcnombre = ALLTRIM(SUBSTR(lcnombre,1,lni-1))+ALLTRIM('Ñ')+ALLTRIM(SUBSTR(lcnombre,lni+1,LEN(lcnombre)))
		 		ENDIF 
		 	ENDFOR  
		ENDIF 
		lccdireccion = lcnombre
		&&&&&&&&&&&&&&&&&&&&   
					
  		SELECT CsrCtacte
   		APPEND BLANK
   		REPLACE id with lnid,cnumero with lccnumero,cnombre with lcnomctacte,cdireccion with lccdireccion,cpostal with lccpostal;	
		,idlocalidad with lnidlocalidad, idprovincia with lnidprovincia,ctelefono with lcctelefono,email with lcemail;
		,tipoiva with lntipoiva,cuit with lccuit,idcategoria with lnidcategoria,ctadeudor with lnctadeudor
		replace ctaacreedor with lnctaacreedor,ctalogistica with lnctalogistica,ctabanco with lnctabanco,ctaotro with lnctaotro;
		,idplanpago	with lnidplanpago,idcanalvta with lnidcanalvta,fechalta with ldfechalta,observa with lcobserva;
		,saldo with lnsaldo,saldoant with lnsaldoant,estadocta with lnestadocta,bonif1 with lnbonif1;
		,bonif2 with lnbonif2,copiatkt with lncopiatkt,inscri01 with lcinscri01,fecins01 with ldfecins01
		replace inscri02 with lcinscri02,inscri03 with lcinscri03,convenio with lnconvenio,saldoauto with lnsaldoauto;
		,idbarrio with lnidbarrio,lista with lnlista,idcateibrng with lnidcateibrng,ingbrutos with lcingbrutos;
		,comision with lncomision,fecultcompra with ldfecultcompra,fecultpago with ldfecultpago
		replace numdoc with lcnumdoc,idtipodoc	with lnidtipodoc,existeibto	with lnexisteibto,existegan	with lnexistegan;
		,ctelefono2 with lctelefono2,diasvto with lndiasvto IN CsrCtacte

		lnid = lnid + 1
		          
ENDSCAN

SELECT CsrAcreedor
Oavisar.proceso('S','Procesando '+'Proveedores') 
GO  TOP 

*LOCAL lnidlocalidad,lntipoiva,lnctalogistica,lnctadeudor,lnctaacreedor,lnidcategoria,lnidprovincia;
*,lnctabanco,lnctaotro,lnidplanpago,lnidcanalvta,lnsaldo,lnsaldoant,lnestadocta,lnbonif1,lnbonif2;
*,lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnidcateibrng,lncomision,lnidtipodoc,lnlista,lndiasvto
	
STORE 0 TO lnidlocalidad,lntipoiva,lnctalogistica,lnctadeudor,lnctaacreedor,lnidcategoria,lnidprovincia
STORE 0 TO lnctabanco,lnctaotro,lnidplanpago,lnsaldo,lnsaldoant,lnestadocta,lnbonif1,lnbonif2
STORE 0 TO lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnidcateibrng,lncomision,lnidtipodoc,lnlista,lndiasvto
STORE 0 TO lnexistegan 
STORE 1 TO 	lnctaacreedor, lnidcanalvta
	
SCAN 

		lccnumero		= ALLTRIM(STR(50000+CsrAcreedor.numero))
		lccnombre		= ALLTRIM(CsrAcreedor.nombre)
		lccdireccion	= ALLTRIM(CsrAcreedor.direccion)
		lccpostal		= ""
		lcctelefono		= ALLTRIM(CsrAcreedor.telefono)
		lcemail			= ""
		lccuit			= ""
		ldfechalta		= DATETIME(1900,01,01,0,0,0)
		lcobserva		= CsrAcreedor.observa
		lcinscri01		= ""
		ldfecins01		= DATETIME(1900,01,01,0,0,0)
		lcinscri02		= ""
		lcinscri03		= ""
		lcingbrutos		= ""
		ldfecultcompra	= DATETIME(1900,01,01,0,0,0)
		ldfecultpago	= DATETIME(1900,01,01,0,0,0)
		lcnumdoc		= SUBSTR(CsrAcreedor.cuit,4,8)
		lnexisteibto	= IIF(CsrAcreedor.Ibrutos<>'N',1,0)
		lctelefono2 	= CsrAcreedor.fax
		lntipocuit 		= CsrAcreedor.tipocuit
		lnidplanpago	= 1100000002
		lcLocalidadBuscada = CsrAcreedor.Localidad
		
		lccadena = strzero(6,lntamloc)
		lnidlocalidad = VAL(str(Goapp.sucursal10+10,2)+lccadena)
		lccadena = strzero(2,lntamprov)
		lnidprovincia = VAL(str(Goapp.sucursal10+10,2)+lccadena)
		

*!*			SELECT CsrLocalidad
*!*			LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcnombre)
*!*			IF FOUND()
*!*				lnidlocalidad = CsrLocalidad.id
*!*				lnidprovincia = CsrLocalidad.idprovincia
*!*				lccpostal = CsrLocalidad.cpostal
*!*			ENDIF
		lccadena = strzero(1,lntamcate)
		lnidcategoria = VAL(str(Goapp.sucursal10+10,2)+lccadena)

		SELECT CsrTipoCtacte
		LOCATE FOR numero = CsrDeudor.categoria
		IF FOUND()
			lnidcategoria = CsrTipoCtacte.id
		ENDIF 
		
		lccadena = strzero(lntipocuit,lntamcuit)
		lntipoiva = VAL(str(Goapp.sucursal10+10,2)+lccadena)

		IF lntipoiva=VAL(STR(Goapp.sucursal10 + 10,2)+LTRIM(strzero(7,lntamcuit)))
			   lntipoiva = VAL(STR(Goapp.sucursal10 + 10,2)+LTRIM(strzero(5,lntamcuit)))
		ENDIF 
		lccuit =STRTRAN(CsrAcreedor.cuit,"-","")
		IF lntipoiva=VAL(STR(Goapp.sucursal10 + 10,2)+LTRIM(strzero(3,lntamcuit)))
			lncuit=''
		ENDIF
		
        ldfecfac = CsrAcreedor.fechaulcpr
		IF !EMPTY(ldfecfac)
			ldfecultcompra = DATETIME(YEAR(ldfecfac),MONTH(ldfecfac),DAY(ldfecfac),0,0,0)
		ENDIF 
		ldfechap = CsrAcreedor.Fechaulpag
		IF !EMPTY(ldfechap)
			ldfecultpago = DATETIME(YEAR(ldfechap),MONTH(ldfechap),DAY(ldfechap),0,0,0)
		ENDIF 
		
		 &&&&&&&&&&&&& agregado 19/08 nombres con Ñ
       	lcnombre=alltrim(UPPER(lccnombre))
		IF '¤'$lcnombre OR '¥'$lcnombre
		 	FOR lni=1 to LEN(lcnombre)
		 		lc=SUBSTR(lcnombre,lni,1)
		 		IF '¤'=lc OR '¥'$lc
		 			lcnombre = ALLTRIM(SUBSTR(lcnombre,1,lni-1))+ALLTRIM('Ñ')+ALLTRIM(SUBSTR(lcnombre,lni+1,LEN(lcnombre)))
		 		ENDIF 
		 	ENDFOR  
		ENDIF  
		lcnomctacte = lcnombre
		lcnombre=alltrim(UPPER(lccdireccion))
		IF '¤'$lcnombre OR '¥'$lcnombre
		 	FOR lni=1 to LEN(lcnombre)
		 		lc=SUBSTR(lcnombre,lni,1)
		 		IF '¤'=lc OR '¥'$lc
		 			lcnombre = ALLTRIM(SUBSTR(lcnombre,1,lni-1))+ALLTRIM('Ñ')+ALLTRIM(SUBSTR(lcnombre,lni+1,LEN(lcnombre)))
		 		ENDIF 
		 	ENDFOR  
		ENDIF  
		lccdireccion = lcnombre
		&&&&&&&&&&&&&&&&&&&&   
					
  		SELECT CsrCtacte
   		APPEND BLANK
   		REPLACE id with lnid,cnumero with lccnumero,cnombre with lcnomctacte,cdireccion with lccdireccion,cpostal with lccpostal;	
		,idlocalidad with lnidlocalidad, idprovincia with lnidprovincia,ctelefono with lcctelefono,email with lcemail;
		,tipoiva with lntipoiva,cuit with lccuit,idcategoria with lnidcategoria,ctadeudor with lnctadeudor
		replace ctaacreedor with lnctaacreedor,ctalogistica with lnctalogistica,ctabanco with lnctabanco,ctaotro with lnctaotro;
		,idplanpago	with lnidplanpago,idcanalvta with lnidcanalvta,fechalta with ldfechalta,observa with lcobserva;
		,saldo with lnsaldo,saldoant with lnsaldoant,estadocta with lnestadocta,bonif1 with lnbonif1;
		,bonif2 with lnbonif2,copiatkt with lncopiatkt,inscri01 with lcinscri01,fecins01 with ldfecins01
		replace inscri02 with lcinscri02,inscri03 with lcinscri03,convenio with lnconvenio,saldoauto with lnsaldoauto;
		,idbarrio with lnidbarrio,lista with lnlista,idcateibrng with lnidcateibrng,ingbrutos with lcingbrutos;
		,comision with lncomision,fecultcompra with ldfecultcompra,fecultpago with ldfecultpago
		replace numdoc with lcnumdoc,idtipodoc	with lnidtipodoc,existeibto	with lnexisteibto,existegan	with lnexistegan;
		,ctelefono2 with lctelefono2,diasvto with lndiasvto IN CsrCtacte

		lnid = lnid + 1
		          
ENDSCAN

**************************
***** CARGAMOS LAS AREAS DE NEGOCIOS
**************************

*!*	SELECT CsrFletero
*!*	lnid = 1
*!*	IF FSIZE('id')>4
*!*	   lntam = 10
*!*	ELSE 
*!*	   lntam = 8
*!*	ENDIF 
*!*	lccadena = strzero(lnid,lntam)
*!*	lnids = VAL(str(Goapp.sucursal10+10,2)+lccadena)

*!*	SELECT CsrFleteroVie
*!*	Oavisar.proceso('S','Procesando '+alias()) 
*!*	GO top
*!*	SCAN FOR !EOF()
*!*	           SELECT Csrctacte
*!*			LOCATE FOR cnumero=ALLTRIM(STR(CsrFleteroVie.cliente))
*!*			lnidctacte = 0
*!*			IF cnumero=ALLTRIM(STR(CsrFleterovie.cliente))
*!*				lnidctacte=CsrCtacte.id
*!*			ENDIF 
*!*		&&&&&&&&&&&&& agregado 19/08 nombres con Ñ
*!*	   	lcnombre=alltrim(UPPER(CsrFleteroVie.nombre))
*!*		IF '¤'$lcnombre OR '¥'$lcnombre
*!*		 	FOR lni=1 to LEN(lcnombre)
*!*		 		lc=SUBSTR(lcnombre,lni,1)
*!*		 		IF '¤'=lc OR '¥'$lc
*!*		 			lcnombre = ALLTRIM(SUBSTR(lcnombre,1,lni-1))+ALLTRIM('Ñ')+ALLTRIM(SUBSTR(lcnombre,lni+1,LEN(lcnombre)))
*!*		 		ENDIF 
*!*		 	ENDFOR  
*!*		ENDIF   
*!*		&&&&&&&&&&&&&&&&&&&&  l    
*!*	           INSERT INTO CsrFletero (id,numero,nombre,direccion,telefono,tipoflete,switch,idctacte);
*!*	           			 VALUES (lnids,CsrFleteroVie.numero,lcnombre,"","",1,"00000",lnidctacte)
*!*	           lnid = lnid + 1
*!*	           lccadena = strzero(lnid,lntam)
*!*				lnids = VAL(str(Goapp.sucursal10+10,2)+lccadena)
*!*	ENDSCAN

SELECT CsrFuerzaVta
lnid = 1
IF FSIZE('id')>4
   lntam = 10
ELSE 
   lntam = 8
ENDIF 
lccadena = strzero(lnid,lntam)
lnid= VAL(str(Goapp.sucursal10+10,2)+lccadena)

INSERT INTO Csrfuerzavta (id,numero,nombre) VALUES (lnid,1,"FUERZA VTA 1")
lnid = lnid +1
INSERT INTO Csrfuerzavta (id,numero,nombre) VALUES (lnid,2,"FUERZA VTA 2")
********************CARGADO DE RUTAS**********************
***ACLARACION. LOS VENDEDORES DE ALARCIA NO TIENEN DIAS ESPECIFICOS PARA VISITAR
***EL VENDEDOR NO TIENE ZONA ASIGNADA = 0
*****DEFINICION DE "ID"
SELECT CsrRuta
lnid = 1
IF FSIZE('id')>4
   lntam = 10
ELSE 
   lntam = 8
ENDIF 
lccadena = strzero(lnid,lntam)
lnid = VAL(str(Goapp.sucursal10+10,2)+lccadena)
lnnumero = 1
SELECT CsrCabeRuta
lnidcabeza = 1
IF FSIZE('id')>4
   lntamCABE = 10
ELSE 
   lntamCABE = 8
ENDIF 
lccadena = strzero(lnidcabeza,lntamCABE)
lnidcabeza = VAL(str(Goapp.sucursal10+10,2)+lccadena)
 
SELECT CsrRutaVdor
lnidrutavdor = 1
IF FSIZE('id')>4
   lntamRUTA = 10
ELSE 
   lntamRUTA = 8
ENDIF 
lccadena = strzero(lnidrutavdor,lntamRUTA)
lnidrutavdor = INT(VAL(str(Goapp.sucursal10+10,2)+lccadena))

SELECT CsrZonaRuta
lnidzonaruta = 1
IF FSIZE('id')>4
   lntamZR = 10
ELSE 
   lntamZR = 8
ENDIF 
lccadena = strzero(lnidzonaruta,lntamZR)
lnidzonaruta= VAL(str(Goapp.sucursal10+10,2)+lccadenA)

SELECT CsrCuerRuta
lnidcuerruta = 1
IF FSIZE('id')>4
   lntamCUER = 10
ELSE 
   lntamCUER = 8
ENDIF  
lccadena = strzero(lnidcuerrutA,lntamCUER)
lnidcuerruta = VAL(str(Goapp.sucursal10+10,2)+lccadena)


*************PROCESO
SELECT CsrDeudor
Oavisar.proceso('S','Procesando '+'RUTAS') 
GO top
 
SCAN FOR !EOF()

       
	IF CsrDeudor.vendedor#0
		SELECT CsrVendedor
		LOCATE FOR numero=CsrDeudor.vendedor
		IF numero#CsrDeudor.vendedor
			SELECT CsrDeudor
			LOOP
		ENDIF 
		SELECT CsrCtacte
		LOCATE FOR VAL(cnumero) = CsrDeudor.numero
		IF VAL(cnumero) = (CsrDeudor.numero)
			SELECT CsrDeudor
			LOOP
		ENDIF 
		*por defecto todos  a la pampa
		SELECT CsrZona
		GO TOP 

		SELECT CsrRuta
		LOCATE FOR nombre=TRIM(Csrzona.nombre)+" "+STR(Csrvendedor.numero,3)
		IF nombre#TRIM(Csrzona.nombre)+" "+STR(Csrvendedor.numero,3)
			INSERT INTO CsrRuta (id,numero,nombre) VALUES (lnid,lnnumero,TRIM(Csrzona.nombre)+" "+STR(Csrvendedor.numero,3))		     		
			lnid = lnid + 1
			lnnumero = lnnumero +1
		ENDIF 
	
		SELECT Csrzonaruta
		LOCATE FOR idzona=Csrzona.id AND idruta = Csrruta.id
		IF idzona#Csrzona.id OR idruta # Csrruta.id
			INSERT INTO Csrzonaruta (id,idzona,idruta,switch) VALUES (lnidzonaruta,Csrzona.id,Csrruta.id,'00000')
			lnidzonaruta = lnidzonaruta + 1

	    ENDIF 
	      
		SELECT CsrRutaVdor
		LOCATE FOR idvendedor=Csrvendedor.id  AND idruta=Csrruta.id AND idfuerzavta=1
		IF idvendedor#Csrvendedor.id  OR idruta#Csrruta.id OR idfuerzavta#1
			INSERT INTO CsrRutaVdor (id,idruta,idvendedor,switch,idfuerzavta);
			VALUES (lnidrutavdor,Csrruta.id,Csrvendedor.id,'00000',1)
			lnidrutavdor = lnidrutavdor + 1

		ENDIF 
		 
		lcdias = ALLTRIM('234567')
		FOR i=1 TO LEN(lcdias)
			SELECT CsrCaberuta
			LOCATE FOR idrutavdor=Csrrutavdor.id AND dia=VAL(SUBSTR(lcdias,i,1))
			IF idrutavdor#Csrrutavdor.id OR dia#VAL(SUBSTR(lcdias,i,1))
				INSERT INTO Csrcaberuta (id,idrutavdor,dia) VALUES (lnidcabeza,Csrrutavdor.id,VAL(SUBSTR(lcdias,i,1)))
				lnidcabeza = lnidcabeza + 1

			ENDIF 
			*IF CsrRecorrido.orden#0
			SELECT CsrCuerruta
			INSERT INTO Csrcuerruta (id,idcaberuta,idctacte,orden,turno) VALUES (lnidcuerruta,Csrcaberuta.id,Csrctacte.id,1,1)
	   		lnidcuerruta = lnidcuerruta + 1

 				
			*ENDIF 	   				
		NEXT 
	ENDIF 
	SELECT CsrDeudor
ENDSCAN

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	