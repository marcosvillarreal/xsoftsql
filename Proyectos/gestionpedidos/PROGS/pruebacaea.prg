CLEAR 

oFactura = CREATEOBJECT('oFacElectronica')
oFactura.p_periodo = 201506
oFactura.p_quincena = 2
oFactura.informar_caea()

RELEASE oFactura