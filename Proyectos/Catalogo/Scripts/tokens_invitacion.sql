use kleja

go

-- En BD de Kleja
CREATE TABLE tokens_invitacion (
  token VARCHAR(50) PRIMARY KEY,
  nombre_campana VARCHAR(100),
  beneficios NVARCHAR(MAX), -- JSON
  usado_count INT DEFAULT 0,
  fecha_creacion DATETIME DEFAULT GETDATE(),
  fecha_expira DATETIME,
  creado_por VARCHAR(50),
  activo BIT DEFAULT 1
)