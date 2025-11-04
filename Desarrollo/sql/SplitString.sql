CREATE FUNCTION dbo.SplitString
(
    @InputString NVARCHAR(MAX),
    @Delimiter CHAR(1)
)
RETURNS @OutputTable TABLE (
    value NVARCHAR(MAX)
)
AS
BEGIN
    DECLARE @Start INT, @End INT

    IF @InputString IS NULL RETURN

    -- Asegurarse de que la cadena termina con el delimitador para capturar la última palabra
    SET @InputString = @InputString + @Delimiter
    
    SET @Start = 1
    SET @End = CHARINDEX(@Delimiter, @InputString)

    WHILE @End > 0
    BEGIN
        INSERT INTO @OutputTable (value)
        SELECT LTRIM(RTRIM(SUBSTRING(@InputString, @Start, @End - @Start)))
        
        SET @Start = @End + 1
        SET @End = CHARINDEX(@Delimiter, @InputString, @Start)
    END
    
    RETURN
END
GO