use leon
go

update datamenu set sec_picture = 'folder.ico' where sec_tipoacce = 0

update datamenu set sec_tipodoacce= 0 where sec_tipoacce = 0
update datamenu set sec_tipodoacce= 1 where sec_picture like 'abm%'
update datamenu set sec_tipodoacce= 2 where sec_picture like 'text%'
update datamenu set sec_tipodoacce= 3 where sec_picture like 'edit%'
update datamenu set sec_tipodoacce= 4 where sec_picture like 'tools%'
update datamenu set sec_tipodoacce= 5 where sec_picture like 'exit%'

select * from datamenu 
where sec_tipoacce <> 9 and isnull(sec_tipodoacce,-1) <> 0
--and rtrim(sec_picture)=''
--update datamenu set sec_picture = '' where sec_tipoacce = 0
--update datamenu set sec_picture = 'abm.ico' where sec_picture = 'abm.png'
--update datamenu set sec_picture = 'edit.ico' where sec_picture = 'REGISTRA.BMP'
--update datamenu set sec_picture = 'exit.ico' where sec_doacce like '%frmlogout%' and sec_tipoacce= 1 and rtrim(sec_picture)=''
--update datamenu set sec_picture = 'edit.ico' where sec_doacce like '%reg%' and sec_tipoacce= 1 and rtrim(sec_picture)=''
--update datamenu set sec_picture = 'tools.ico' where sec_doacce like '%frm%' and sec_tipoacce= 1 and rtrim(sec_picture)=''
--update datamenu set sec_picture = 'edit.ico' where sec_doacce like '%gener%' and sec_tipoacce= 1 and rtrim(sec_picture)=''
--update datamenu set sec_picture = 'text.ico' where sec_doacce like '%sub%' and sec_tipoacce= 1 and rtrim(sec_picture)=''
--update datamenu set sec_picture = 'edit.ico' where sec_doacce like '%lista%' and sec_tipoacce= 1 and rtrim(sec_picture)=''
--update datamenu set sec_picture = 'edit.ico' where sec_doacce like '%est_%' and sec_tipoacce= 1 and rtrim(sec_picture)=''
--update datamenu set sec_picture = 'edit.ico' where sec_doacce like '%expo%' and sec_tipoacce= 1 and rtrim(sec_picture)=''

