*-- Seteos de VFP --
set century on
set date ital
set delete on
set exclu off
set multi on
set talk off
set notify off
set point to '.'
set separator to ','
set confirm on
set status off
set status bar off
set multilocks on
set autoincerror on
set escape off
set cursor on
Set EngineBehavior 80
SET MEMOWIDTH TO 8192
SET REPORTBEHAVIOR 90
SET HOURS TO 24

SET EXACT ON 

*------------------------------------------------------------------------------
* COLORES KML (formato AABBGGRR - Alpha Blue Green Red en hexadecimal)
*------------------------------------------------------------------------------

* Colores para el depósito
#DEFINE KML_COLOR_DEPOSITO           "ff0000ff"    && Rojo brillante
#DEFINE KML_COLOR_DEPOSITO_ALT       "ff000080"    && Rojo oscuro  
#DEFINE KML_COLOR_DEPOSITO_VERDE     "ff008000"    && Verde oscuro

* Colores para clientes
#DEFINE KML_COLOR_CLIENTE            "ff00ff00"    && Verde brillante
#DEFINE KML_COLOR_CLIENTE_ALT        "ff00ffff"    && Amarillo
#DEFINE KML_COLOR_CLIENTE_AZUL       "ffff0000"    && Azul
#DEFINE KML_COLOR_CLIENTE_NARANJA    "ff0080ff"    && Naranja

* Colores para la ruta
#DEFINE KML_COLOR_RUTA               "ff0000ff"    && Azul brillante  
#DEFINE KML_COLOR_RUTA_ALT           "ff800080"    && Púrpura
#DEFINE KML_COLOR_RUTA_VERDE         "ff008000"    && Verde
#DEFINE KML_COLOR_RUTA_NARANJA       "ff0080ff"    && Naranja

*------------------------------------------------------------------------------
* ICONOS DISPONIBLES EN GOOGLE EARTH/MAPS
*------------------------------------------------------------------------------

* Iconos para depósito
#DEFINE KML_ICONO_DEPOSITO           "homegardenbusiness.png"    && Edificio comercial
#DEFINE KML_ICONO_DEPOSITO_ALT       "industrial.png"           && Industrial  
#DEFINE KML_ICONO_DEPOSITO_ALMACEN   "warehouse.png"            && Almacén

* Iconos para clientes  
#DEFINE KML_ICONO_CLIENTE            "truck.png"                && Camión
#DEFINE KML_ICONO_CLIENTE_ALT        "cabs.png"                 && Taxi/delivery
#DEFINE KML_ICONO_CLIENTE_PAQUETE    "postoffice-us.png"        && Paquete postal
#DEFINE KML_ICONO_CLIENTE_CASA       "homegardenbusiness.png"   && Casa/negocio
#DEFINE KML_ICONO_CLIENTE_TIENDA     "shoppingcart.png"         && Tienda
#DEFINE KML_ICONO_CLIENTE_STAR       "star.png"                 && Estrella

*------------------------------------------------------------------------------
* ESCALAS DE ICONOS
*------------------------------------------------------------------------------
#DEFINE KML_ESCALA_DEPOSITO          "1.3"         && Depósito más grande
#DEFINE KML_ESCALA_CLIENTE           "1.0"         && Clientes tamaño normal
#DEFINE KML_ESCALA_CLIENTE_SMALL     "0.8"         && Clientes pequeños
#DEFINE KML_ESCALA_CLIENTE_BIG       "1.2"         && Clientes grandes

*------------------------------------------------------------------------------  
* ESTILOS DE LÍNEA DE RUTA
*------------------------------------------------------------------------------
#DEFINE KML_ANCHO_RUTA               "4"           && Línea gruesa
#DEFINE KML_ANCHO_RUTA_DELGADA       "2"           && Línea delgada
#DEFINE KML_ANCHO_RUTA_GRUESA        "6"           && Línea muy gruesa

*------------------------------------------------------------------------------
* ESCALAS DE ETIQUETAS
*------------------------------------------------------------------------------
#DEFINE KML_ESCALA_LABEL_DEPOSITO    "1.2"         && Etiqueta grande para depósito
#DEFINE KML_ESCALA_LABEL_CLIENTE     "1.0"         && Etiqueta normal para cliente
#DEFINE KML_ESCALA_LABEL_SMALL       "0.8"         && Etiqueta pequeña

*------------------------------------------------------------------------------
* CONFIGURACIONES POR TIPO DE CLIENTE (si tienes diferentes tipos)
*------------------------------------------------------------------------------

* Cliente VIP
#DEFINE KML_COLOR_CLIENTE_VIP        "ffff00ff"    && Magenta
#DEFINE KML_ICONO_CLIENTE_VIP        "star.png"    && Estrella
#DEFINE KML_ESCALA_CLIENTE_VIP       "1.3"         && Más grande

* Cliente normal  
#DEFINE KML_COLOR_CLIENTE_NORMAL     "ff00ff00"    && Verde
#DEFINE KML_ICONO_CLIENTE_NORMAL     "truck.png"   && Camión
#DEFINE KML_ESCALA_CLIENTE_NORMAL    "1.0"         && Normal

* Cliente nuevo
#DEFINE KML_COLOR_CLIENTE_NUEVO      "ff00ffff"    && Amarillo  
#DEFINE KML_ICONO_CLIENTE_NUEVO      "cabs.png"    && Taxi
#DEFINE KML_ESCALA_CLIENTE_NUEVO     "1.1"         && Poco más grande

*------------------------------------------------------------------------------
* TEMAS PREDEFINIDOS
*------------------------------------------------------------------------------

* TEMA CLÁSICO (Azul/Rojo)
#DEFINE TEMA_CLASICO_DEPOSITO        "ff0000ff"    && Rojo
#DEFINE TEMA_CLASICO_CLIENTE         "ffff0000"    && Azul  
#DEFINE TEMA_CLASICO_RUTA            "ff0000ff"    && Azul

* TEMA NATURA (Verdes/Marrones) 
#DEFINE TEMA_NATURA_DEPOSITO         "ff008000"    && Verde oscuro
#DEFINE TEMA_NATURA_CLIENTE          "ff00ff00"    && Verde claro
#DEFINE TEMA_NATURA_RUTA             "ff808000"    && Verde oliva

* TEMA SUNSET (Naranjas/Rojos)
#DEFINE TEMA_SUNSET_DEPOSITO         "ff000080"    && Rojo oscuro  
#DEFINE TEMA_SUNSET_CLIENTE          "ff0080ff"    && Naranja
#DEFINE TEMA_SUNSET_RUTA             "ff0040ff"    && Naranja rojizo

