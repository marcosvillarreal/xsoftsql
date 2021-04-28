use comercio
go
WITH Ca AS
(
SELECT datamenu.*, ROW_NUMBER() OVER(ORDER BY sec_descacce) AS RowNum FROM datamenu
)

update ca set id =  Rownum 