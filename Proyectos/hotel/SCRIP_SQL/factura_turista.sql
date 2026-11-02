-- ============================================================
-- Hotel - Factura T (comprobantes de turismo, WSCT / RG 3971) - estructura (29/10/2026)
-- Se puede correr mas de una vez: cada paso controla si ya existe.
-- Literales solo ASCII (sqlcmd -i sin -f 65001 corrompe tildes).
-- ============================================================
USE hotel_mu
GO

-- ------------------------------------------------------------
-- 1) Clases de comprobante turista (tipo 06), definidas por el usuario.
--    afectado / debehaber en blanco (confirmado por el usuario), igual que las clases con tipo
--    distinto de 00 de otros sistemas (MIPYMES 01, LUM 05).
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM dbo.clasecomp WHERE codigo = 'A' AND tipo = '06')
    INSERT INTO dbo.clasecomp (codigo, cnombre, afectado, debehaber, tipo) VALUES ('A', 'FACTURA TURISTA', '', '', '06');
IF NOT EXISTS (SELECT 1 FROM dbo.clasecomp WHERE codigo = 'C' AND tipo = '06')
    INSERT INTO dbo.clasecomp (codigo, cnombre, afectado, debehaber, tipo) VALUES ('C', 'NOTA CREDITO TUR', '', '', '06');
IF NOT EXISTS (SELECT 1 FROM dbo.clasecomp WHERE codigo = 'B' AND tipo = '06')
    INSERT INTO dbo.clasecomp (codigo, cnombre, afectado, debehaber, tipo) VALUES ('B', 'NOTA DEBITO TUR', '', '', '06');
GO

-- ------------------------------------------------------------
-- 2) Tipo de comprobante ARCA para la clase + tipo (clasecomp = clase + clasetipo), letra T:
--    195 Factura T, 196 Nota de Debito T, 197 Nota de Credito T.
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM dbo.AfipComproba WHERE clasecomp = 'A06' AND letra = 'T')
    INSERT INTO dbo.AfipComproba (clasecomp, letra, codafip) VALUES ('A06', 'T', 195);
IF NOT EXISTS (SELECT 1 FROM dbo.AfipComproba WHERE clasecomp = 'B06' AND letra = 'T')
    INSERT INTO dbo.AfipComproba (clasecomp, letra, codafip) VALUES ('B06', 'T', 196);
IF NOT EXISTS (SELECT 1 FROM dbo.AfipComproba WHERE clasecomp = 'C06' AND letra = 'T')
    INSERT INTO dbo.AfipComproba (clasecomp, letra, codafip) VALUES ('C06', 'T', 197);
GO

-- ------------------------------------------------------------
-- 3) cabefac: documento del receptor.
--    dni pasa de char(10) a char(20) y se reutiliza segun tipodoc (pasaporte, CI extranjera...).
--    tipodoc = codigo ARCA del documento (96 DNI, 94 pasaporte, 91 CI extranjera, ...); 0 = no informado.
--    cuit sigue separado. ctacte no se toca (ya tiene dni y pasaporte por separado).
-- ------------------------------------------------------------
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
           WHERE TABLE_NAME = 'cabefac' AND COLUMN_NAME = 'dni' AND CHARACTER_MAXIMUM_LENGTH < 20)
    ALTER TABLE dbo.cabefac ALTER COLUMN dni CHAR(20) NULL;
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'cabefac' AND COLUMN_NAME = 'tipodoc')
    ALTER TABLE dbo.cabefac ADD tipodoc INT NOT NULL CONSTRAINT DF_cabefac_tipodoc DEFAULT 0;
GO

-- ------------------------------------------------------------
-- 4) rubro.codtur: codigo de item de turismo del rubro (1 alojamiento sin desayuno,
--    2 alojamiento con desayuno, 5 excedente). 0 = no definido -> se manda 5.
--    El alojamiento (cargos HAB / HAM) va siempre con 2: incluye desayuno.
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'rubro' AND COLUMN_NAME = 'codtur')
    ALTER TABLE dbo.rubro ADD codtur INT NOT NULL CONSTRAINT DF_rubro_codtur DEFAULT 0;
GO

-- ------------------------------------------------------------
-- 5) cuerfac.codtur: codigo de turismo con que se informo cada item (lo arma regfacvta: cargos HAB/HAM = 2,
--    resto = rubro.codtur del producto). Queda grabado para copiar la factura a una nota de credito T.
--    0 = sin definir -> se informa 5.
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'cuerfac' AND COLUMN_NAME = 'codtur')
    ALTER TABLE dbo.cuerfac ADD codtur INT NOT NULL CONSTRAINT DF_cuerfac_codtur DEFAULT 0;
GO

-- ------------------------------------------------------------
-- 6) Rubro 1 CARGOS (habitacion, cama adicional, ...) = 2 (alojamiento con desayuno, da reintegro).
--    Asi la habitacion cargada a mano (sin cargo de la reserva) tambien sale con 2.
--    Solo si sigue sin definir: no pisa un valor cargado despues por el usuario.
-- ------------------------------------------------------------
UPDATE dbo.rubro SET codtur = 2 WHERE numero = 1 AND codtur = 0;
GO

-- ------------------------------------------------------------
-- 7) valor.pagointer: tilde PAGO INTERNACIONAL (ABM de valores). Solo los valores tildados se ofrecen
--    para cobrar la factura T con reintegro (pidopagotur): tarjeta (clase A) o transferencia (clase L).
--    Arranca en 0; se inicializan AMERICAN EXPRESS, DINERS, MASTERCARD, VISA y TRANS ICBC. El resto lo tilda el usuario.
-- ------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'valor' AND COLUMN_NAME = 'pagointer')
    ALTER TABLE dbo.valor ADD pagointer NUMERIC(1,0) NOT NULL CONSTRAINT DF_valor_pagointer DEFAULT 0;
GO

-- Valores iniciales con pago internacional (pedido del usuario), por numero de valor y solo si siguen sin tildar:
--   5 AMERICAN EXPRESS, 10 DINERS, 14 MASTERCARD, 17 VISA, 2 TRANS ICBC.
UPDATE dbo.valor SET pagointer = 1
 WHERE pagointer = 0
   AND numero IN (5, 10, 14, 17, 2);
GO

-- ------------------------------------------------------------
-- PENDIENTES (no se ejecutan):
--  - comprobante: altas de FACTURA / NOTA CREDITO / NOTA DEBITO turista con clasetipo '06'.
--  - prefijonro: talonarios letra T con el punto de venta habilitado para comprobantes T.
--  - paises.codpais: cargar el codigo de pais de ARCA (WSCT.ConsultarPaises).
--  - paraconta: cuenta del reintegro de IVA a turistas (la define el contador).
-- ------------------------------------------------------------
