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
			
clientes: { codigo: 'CLIENTES', descripcion :'Clientes' }
		},    
		canal_venta: {
			
almacen_y_desp: { codigo: 'ALMACEN Y DESP', descripcion :'Almacen y desp' },
club/soc_fomento: { codigo: 'CLUB/SOC FOMENTO', descripcion :'Club/soc fomento' },
otros: { codigo: 'OTROS', descripcion :'Otros' }        
		
		},    
		zona_geografica: {        
			
sin_sector: { codigo: 'SIN SECTOR', descripcion :'Sin sector' } 
		},    
		tipo_negocio: {        
			comercial: { codigo: 'COMERCIAL', descripcion: 'Comercial' },        
			particular: { codigo: 'PARTICULAR', descripcion: 'Particular' },        
			empresa: { codigo: 'EMPRESA', descripcion: 'Empresa' }    
		}
};
console.log('?? Estados-config cargado (códigos VFP-compatibles):', Object.keys(window.estadosConfig));