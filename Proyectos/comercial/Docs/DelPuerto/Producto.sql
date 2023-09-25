use delpuerto
go
WITH Ca AS
(
SELECT producto.*, ROW_NUMBER() OVER(ORDER BY numero) AS RowNum FROM producto
where idrubro <> 1100000036
)

update producto set numero =  Rownum  + 1  where idrubro <> 1100000036