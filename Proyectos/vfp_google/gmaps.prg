*:*****************************************************************************************************
*: GMAPS. BUSQUEDA EN GOOGLE MAPS POR DIRECCION
*:
*:*****************************************************************************************************

function gmaps(ltxbusca,ltxcartel,xnavega,xserie)
*:                |        |         |      |
*:           Direccion    Tag        |      |
*:                              browser 1/0 |  
*:                                          |   
*:                                          el archivo es fijo (tmpbgoo.htm) o seriado (tmpbgooNNN.thm)
*:

if parameters()=0
	return ""
endif	

if parameters()<2
	ltxcartel=""
endif

if parameters()<3
	xnavega=1
endif

if parameters()<4
	xserie=0
endif


ltxcartel=iif(len(alltrim(ltxcartel))=0,"Punto de referencia",ltxcartel)	

*: <script src="https://cdn.jsdelivr.net/json3/3.3.2/json3.js"></script>

ltxbusca = Strtran(ALLTRIM(ltxbusca),'ñ','n',1,10,1)	&& Eñes :)

lcClave = "http://maps.google.es/maps?file=api&v=2.x&" + ;
	"key=ABQIAAAAtOjLpIVcO8im8KJFR8pcMhQjskl1-YgiA" + ;
	"_BGX2yRrf7htVrbmBTWZt39_v1rJ4xxwZZCEomegYBo1w"
TEXT TO lcHtml NOSHOW TEXTMERGE
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
    <title>Busqueda en Google Maps</title>
    <script src="<<lcClave>>"
    type="text/javascript"></script>
    <script type="text/javascript">
    //<![CDATA[
    var map = null
    var geocoder = null
    var address = "<<ltxbusca>>"
	var tagg = "<<ltxcartel>>"
	
    function load()
    { if (GBrowserIsCompatible())
      { map = new GMap2(document.getElementById("map"),'G_SATELLITE_MAP');
        map.addControl(new GLargeMapControl());
        map.addControl (new GMapTypeControl());
        map.addControl(new GOverviewMapControl());

        geocoder = new GClientGeocoder();
        if (geocoder) {
            geocoder.getLatLng(address,
          function(point)
          { if (!point)
            { alert("Longitud y latitud no determinada con estos datos");
             }
          else
            { map.setCenter(point, 17);
            map.setMapType(G_NORMAL_MAP);
            var marker = new GMarker(point);
            map.addOverlay(marker);
            marker.openInfoWindowHtml(tagg);
            }
          }
         );
       }
      }
    }
    //]]>
    </script>
  </head>
  <body  scroll="no" bgcolor="#CCCCCC" topmargin="0" leftmargin="0" onload="load()" onunload="GUnload()">
  <div id="map" style="width: 100%; height: 100%"></div>
  </body>
</html>
ENDTEXT

*:y creamos temporal
if xserie=1
	u_tmpfile=sys(5)+curdir()+"Tmpbgoo"+alltrim(str(seconds()))+".htm"
else
	u_tmpfile=sys(5)+curdir()+"Tmpbgoo.htm"
endif

Strtofile(lcHtml,u_tmpfile)

if xnavega=1
 DECLARE INTEGER ShellExecute IN shell32; 
    INTEGER hwnd,; 
    STRING  lpOperation,; 
    STRING  lpFile,; 
    STRING  lpParameters,;  
    STRING  lpDirectory,; 
    INTEGER nShowCmd
	= ShellExecute(0, "open",u_tmpfile,"", "",3)
endif

return u_tmpfile


*:eof()