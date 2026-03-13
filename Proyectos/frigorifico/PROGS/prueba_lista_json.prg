* Script para generar clientes.json desde VFP
TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT TOP 1000 id, cnumero as codigo, cnombre, cuit, saldo 
FROM ctacte
ENDTEXT 
=CrearCursorAdapter("curClientes",lcCmd)
    
    * Convertir el cursor a JSON (Usando una librería como FoxBin2Prg o simplemente manual para test)
    * Si no tienes librerías de JSON, puedes usar esta forma rápida para el test:
    SET TEXTMERGE TO clientes.json
    SET TEXTMERGE ON
    \ [
    SCAN
        \  {
        \    "id": <<curClientes.id>>,
        \    "codigo": "<<ALLTRIM(curClientes.codigo)>>",
        \    "nombre": "<<ALLTRIM(curClientes.cnombre)>>",
        \    "cuit": "<<ALLTRIM(curClientes.cuit)>>",
        \    "saldo": <<STR(curClientes.saldo, 12, 2)>>
        \  }<<IIF(RECNO() < RECCOUNT(), ",", "")>>
    ENDSCAN
    \ ]
    SET TEXTMERGE OFF
    SET TEXTMERGE TO
   * SQLDISCONNECT(lnHandle)
    MESSAGEBOX("Archivo clientes.json generado con éxito")
*ENDIF