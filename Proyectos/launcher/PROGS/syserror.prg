
procedure errorsys

	LOCAL aFoxErr,nTotErr
	DIMENSION aFoxErr[1]
	nTotErr = AERROR(aFoxErr)
	nError  = AfoxErr[1,1]	
	
		DO CASE
		*!*		   CASE INLIST(nError,1733,1734)  && property not found -- traps SETALL()
		*!*			RETURN
			CASE nError=1938                  && no parent
				RETURN
			CASE nError=2059      	      &&  corta estructura endtry
				RETURN               		      		
			CASE nToterr>0 AND nError = 1420  && Corrupt Ole object in General field.
				Mensaje_error(nError)
				RETURN
			CASE nToterr>0 AND nError = 1429  && error conexion ADO
			        =Mensaje_error(nError)
			        lcmensaje = 'Error de conexi�n a la Base de Datos Seleccionada'+CHR(13)+;
			                    'Consulte a su Administrador de Sistemas'
			        =Oavisar.usuario(lcmensaje,0)
			        QUIT 
			CASE nError=1115  && error GETCURSORADAPTER en obtenercursor, cuando el alias es cursor vfp
			     RETURN 			        
			CASE nError=1426  && error com cuando uso excel
			     GO BOTTOM IN ALIAS()
			     RETURN 
			CASE nError = 5                   && record out of range
 				if !eof()
  			          go bott
				    skip
 			      endif
				RETURN
			CASE nError = 4                   && fin de archivo
  				go bott
				return     		
			CASE nError = 1884     		  && Uniqueness ID error
			*	IF CURSORGETPROP("buffering")=1
			*		MESSAGEBOX(ERR_UNIQUEKEY_LOC)
			*		RETURN
			*	ENDIF
			*	IF MESSAGEBOX(ERR_UNIQUEKEY_LOC+" "+ERR_UNIQUEKEY2_LOC,36)=6
			*		TABLEREVERT(.T.)
			*	ENDIF
				RETURN
			CASE nError = 12 OR nError = 13    		  && variable no found
 				=Mensaje_error(nError)
		        QUIT	
			OTHERWISE	
				=Mensaje_error(nError)
				RETURN	
		ENDCASE
RETURN 

function Mensaje_error(nError)
    lcmensaje = 'Linea n� '+MESSAGE(1) +CHR(13)+"Error n�: "+STR(nError)+CHR(13);
                +'Error '+MESSAGE()+chr(13)+' Alias '+alias()+' registro '+str(recno())+chr(13);
                +'Control activo '+sys(18) 
    
    =Oavisar.usuario(lcmensaje,0)
    
RETURN

