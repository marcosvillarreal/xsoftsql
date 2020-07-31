procedure citivta


   set conso off
   set device to print
   set print on
   dispositivo=_vexporta
   set printer to &dispositivo
   _zz = 0
   sele tabla
   go 1
   t_ivari=ivari
   feinimes=ctod('01-'+strzero(desde_mes,2)+'-'+strzero(desde_anio,4))
   fechasta=gomo(feinimes,1)-1
   sele cabeza ; set order to 3 ; seek_dato(dtos(feinimes),.t.)
   do while fecha<=fechasta .and. !eof()
      if tipocomp>=6 .or. talonario=0 ; skip ; loop ; endif
      if pelocuit(cuit)=pelocuit(e_cuit)
         skip
         loop
      endif

      if 'ANULA'$NOMBRE .AND. IMPORTE=0 ; SKIP ; LOOP ; ENDIF

      _ipocomp = tipocomp
      lcipocomp = '06'
      do case
         case _ipocomp=2 .and. letra='E'
            lcipocomp = '19'
         case _ipocomp=3 .and. letra='E'
            lcipocomp = '20'
         case _ipocomp=4 .and. letra='E'
            lcipocomp = '21'
         case _ipocomp=2 .and. letra='A'
            lcipocomp = '01'
         case _ipocomp=3 .and. letra='A'
            lcipocomp = '02'
         case _ipocomp=4 .and. letra='A'
            lcipocomp = '03'
         case _ipocomp=2 .and. letra='B'
            lcipocomp = '06'
         case _ipocomp=3 .and. letra='B'
            lcipocomp = '07'
         case _ipocomp=4 .and. letra='B'
            lcipocomp = '08'
         case _ipocomp=1 .and. letra="X"
            lcipocomp = '83'
         case _ipocomp=1 .and. letra="A"
            lcipocomp = '81'
         case _ipocomp=1 .and. letra="B"
            lcipocomp = '82'
      endcase

      lnivari = t_ivari
      sele cuerpo ; set order to 1 ; seek cabeza->orden
      do while !eof() .and. orden = cabeza->orden
         if total<>0
            lnivari = iva_ri
         endif
         skip
      enddo

      Sele cabeza
      _nombre=cabeza->nombre
      If len(alltrim(_nombre))=0
         _nombre='N/N'
      endif
      xcuit = strtran(cuit,'-','') ; xcuit = strtran(xcuit,'.','')
      xcuit = strtran(xcuit,'/','')
      *qtipodoc = if(docdgi=0.and.letra='A',80,docdgi)
      qtipodoc=80

      IF qtipodoc <> 80 ; Xcuit = "00000000000" ;  qtipodoc = 99 ; endif
      if qtipodoc=80 .and. len(trim(xcuit))<=1 ; Xcuit = "27000000006" ; endif

      if lcipocomp='82' .or. lcipocomp='83'
          qtipodoc=96
      endif

      linea = '1'+dtos(fecha)+lcipocomp+' '+strzero(talonario,4)+strzero(numcomp,20)+strzero(numcomp,20)
      linea = linea + strzero(qtipodoc,2) + xcuit + left(_nombre+space(30),30)
      linea = linea + transform(importe*100,'999999999999999') + transform(neto_exe*100,'999999999999999')
      linea = linea + transform(gravado*100,'999999999999999')
      linea = linea + strzero(lnivari*100,4)
      linea = linea + transform(neto_iva*100,'999999999999999') +'000000000000000' + transform(0,'999999999999999')
      linea = linea + '000000000000000' + '000000000000000' + '000000000000000' + '000000000000000'
      linea = linea + '00' + '000' + '0000000000' +'1'
      linea = linea + ' ' + '00000000000000' + '00000000' + '00000000' + space(75)
      linea = linea + '00000000' + '000000000000000'

       @ prow()+_zz,0 say linea
       _zz =1
       skip
   enddo


   sele moviprov && ventas
   set order to 8
   Seek_dato(dtos(feinimes),.t.)

   do while !eof() .and. fecha_fac<=fechasta
      if tipocomp=9 .or. tipocomp=14 .or. tipocomp=15
        skip
        loop
      endif
      if actividad<>0
         sele actividad ; set order to 1 ; seek moviprov->actividad
         if !actividad->libro='V'
            sele moviprov
            skip
            loop
         endif
      endif

      Sele moviprov
      if _detaiva[tipocomp]<>'S' ; skip ; loop ; endif
      if tipocomp=4 ; skip ; loop ; endif
      if red(iva+otroiva)=0 ; skip ; loop ; endif
      if cuota > 1
         skip
         loop
      endif

      _ipocomp = tipocomp
      lcipocomp = '06'

      do case
         case _ipocomp=2 .and. letra='A'
            lcipocomp = '01'
         case _ipocomp=3 .and. letra='A'
            lcipocomp = '02'
         case _ipocomp=4 .and. letra='A'
            lcipocomp = '03'
         case _ipocomp=2 .and. letra='B'
            lcipocomp = '06'
         case _ipocomp=3 .and. letra='B'
            lcipocomp = '07'
         case _ipocomp=4 .and. letra='B'
            lcipocomp = '08'
         case _ipocomp=1 .and. letra="X"
            lcipocomp = '83'
         case _ipocomp=1 .and. letra="A"
            lcipocomp = '81'
         case _ipocomp=1 .and. letra="B"
            lcipocomp = '82'
         case _ipocomp=15 .and. letra="A"
            lcipocomp = '63'
         case _ipocomp=15 .and. letra="B"
            lcipocomp = '64'
         case _ipocomp=15
            lcipocomp = '64'
         case _ipocomp=8 .or. _ipocomp=9 .or. _ipocomp=14
            lcipocomp = '64'

      endcase

      lnivari = t_ivari

      m_importe = iva+otroiva
      m_tipocompro = tipocomp
      m_nrocompro = strzero(talonario,4)+strzero(numcomp,20)
      m_cliente   = cliente
      m_nombre=nombre
      if _vcuit='S'
         hago_el_cambio()
      endif
      _tipocbte=_citi[moviprov->tipocomp]
      _tipocbte=strzero(_tipocbte,2)
      m_cuit=pelocuit(cuit)
      _neto_exe=exen
      _gravado=negra
      _importe=importeco
      _neto_iva=iva+otroiva
      _fecha=fecha_fac
      xcuit = strtran(cuit,'-','') ; xcuit = strtran(xcuit,'.','')
      xcuit = strtran(xcuit,'/','')
      *qtipodoc = if(docdgi=0.and.letra='A',80,docdgi)
      qtipodoc=80
      IF qtipodoc <> 80 ; Xcuit = "00000000000" ;  qtipodoc = 99 ; endif
      if qtipodoc=80 .and. len(trim(xcuit))<=1 ; Xcuit = "27000000006" ; endif
      If len(alltrim(m_nombre))=0
         m_nombre='N/N'
      endif
      linea = '1'+dtos(_fecha)+lcipocomp+' '+strzero(talonario,4)+strzero(numcomp,20)+strzero(numcomp,20)
      linea = linea + strzero(qtipodoc,2) + xcuit + left(m_nombre+space(30),30)
      linea = linea + transform(_importe*100,'999999999999999') + transform(_neto_exe*100,'999999999999999')
      linea = linea + transform(_gravado*100,'999999999999999')
      linea = linea + strzero(lnivari*100,4)
      linea = linea + transform(_neto_iva*100,'999999999999999') +'000000000000000' + transform(0,'999999999999999')
      linea = linea + '000000000000000' + '000000000000000' + '000000000000000' + '000000000000000'
      linea = linea + '00' + '000' + '0000000000' +'1'
      linea = linea + ' ' + '00000000000000' + '00000000' + '00000000' + space(75)
      linea = linea + '00000000' + '000000000000000'

       @ prow()+_zz,0 say linea
       _zz =1


      Sele Moviprov
      skip

  enddo


   ? ''

   set print off
   set printer to
   set device to screen
   set conso on
return
