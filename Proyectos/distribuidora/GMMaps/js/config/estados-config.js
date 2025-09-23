// config/estados-config.js - Estados con códigos VFP-compatibles
window.estadosConfig = {    
	// Configuraciones de estados por campo dinámico usando CÓDIGOS    
		activo: {        
			'true': { codigo: 'ACTIVO', descripcion: 'Activo' },        
			'false': { codigo: 'INACTIVO', descripcion: 'Inactivo' }    
		},    
		estado_cuenta: {        
			al_dia: { codigo: 'AL_DIA', descripcion: 'Al día' },        
			con_deuda: { codigo: 'CON_DEUDA', descripcion: 'Con deuda' },        
			moroso: { codigo: 'MOROSO', descripcion: 'Moroso' },        
			bloqueado: { codigo: 'BLOQUEADO', descripcion: 'Bloqueado' }    
		},    
		categoria_cliente: {        
			
Clientes: { codigo: 'CLIENTES', descripcion :'Clientes' },
Cta_cte_servicio: { codigo: 'CTA_CTE_SERVICIO', descripcion :'Cta cte servicio' }
		},    
		canal_venta: {
			
Almacen_y_desp: { codigo: 'ALMACEN_Y_DESP', descripcion :'Almacen y desp' },
Clubsoc_fomento: { codigo: 'CLUBSOC_FOMENTO', descripcion :'Clubsoc fomento' },
Minimercado: { codigo: 'MINIMERCADO', descripcion :'Minimercado' },
Otros: { codigo: 'OTROS', descripcion :'Otros' }        
		
		},    
		zona_geografica: {        
			
Jueves_1_vrosas_whi: { codigo: 'JUEVES_1_VROSAS_WHI', descripcion :'Jueves 1 vrosas whi' },
Jueves_2_centro_sude: { codigo: 'JUEVES_2_CENTRO_SUDE', descripcion :'Jueves 2 centro sude' },
Martes_1_centro_nort: { codigo: 'MARTES_1_CENTRO_NORT', descripcion :'Martes 1 centro nort' },
Martes_2_norte: { codigo: 'MARTES_2_NORTE', descripcion :'Martes 2 norte' },
Martes_3_centro: { codigo: 'MARTES_3_CENTRO', descripcion :'Martes 3 centro' },
Miecoles_3_espora: { codigo: 'MIECOLES_3_ESPORA', descripcion :'Miecoles 3 espora' },
Miercoles_1_vmitre: { codigo: 'MIERCOLES_1_VMITRE', descripcion :'Miercoles 1 vmitre' },
Miercoles_2_aldea_ro: { codigo: 'MIERCOLES_2_ALDEA_RO', descripcion :'Miercoles 2 aldea ro' },
Sin_sector: { codigo: 'SIN_SECTOR', descripcion :'Sin sector' },
Viernes_1_bordeux_ma: { codigo: 'VIERNES_1_BORDEUX_MA', descripcion :'Viernes 1 bordeux ma' },
Viernes_2: { codigo: 'VIERNES_2', descripcion :'Viernes 2' },
Viernes_4: { codigo: 'VIERNES_4', descripcion :'Viernes 4' } 
		},    
		tipo_negocio: {        
			comercial: { codigo: 'COMERCIAL', descripcion: 'Comercial' },        
			particular: { codigo: 'PARTICULAR', descripcion: 'Particular' },        
			empresa: { codigo: 'EMPRESA', descripcion: 'Empresa' }    
		},
		vendedor:{
			
DAIANA: { codigo: 'DAIANA', descripcion :'Daiana' },
MARCOS: { codigo: 'MARCOS', descripcion :'Marcos' },
Oscar: { codigo: 'OSCAR', descripcion :'Oscar' }
		}
};
console.log('?? Estados-config cargado (códigos VFP-compatibles):', Object.keys(window.estadosConfig));