window.addEvent('domready', function(){
	// smooth anchor scrolling
	new SmoothScroll(); 
	// style area
	if(document.id('gkStyleArea')){
		$$('#gkStyleArea a').each(function(element,index){
			element.addEvent('click',function(e){
	            e.stop();
				changeStyle(index+1);
			});
		});
	}
	
	// font-size switcher
	if(document.id('gkTools') && document.id('gkComponentWrap')) {
		var current_fs = 100;
		var content_fx = new Fx.Tween(document.id('gkComponentWrap'), { property: 'font-size', unit: '%', duration: 200 }).set(100);
		document.id('gkToolsInc').addEvent('click', function(e){ 
			e.stop(); 
			if(current_fs < 150) { 
				content_fx.start(current_fs + 10); 
				current_fs += 10; 
			} 
		});
		document.id('gkToolsReset').addEvent('click', function(e){ 
			e.stop(); 
			content_fx.start(100); 
			current_fs = 100; 
		});
		document.id('gkToolsDec').addEvent('click', function(e){ 
			e.stop(); 
			if(current_fs > 70) { 
				content_fx.start(current_fs - 10); 
				current_fs -= 10; 
			} 
		});
	}
	// login popup
	if(document.id('btnLogin') || document.id('btnRegister')) {
		var popup_overlay = document.id('gkPopupOverlay');
		popup_overlay.setStyles({'display': 'block', 'opacity': '0'});
		popup_overlay.fade('out');
		var opened_popup = null;
		var popup_login = null;
		var popup_login_h = null;
		var popup_login_fx = null;
		var popup_register = null;
		var popup_register_h = null;
		var popup_register_fx = null;
		
		if(document.id('btnLogin')) {
			popup_login = document.id('gkPopupLogin');
			popup_login.setStyle('display', 'block');
			popup_login_h = popup_login.getElement('.gkPopupWrap').getSize().y + 8;
			popup_login_fx = new Fx.Morph(popup_login, {duration:200, transition: Fx.Transitions.Circ.easeInOut}).set({'opacity': 0, 'height': 0, 'margin-top':0}); 
			document.id('btnLogin').addEvent('click', function(e) {
				new Event(e).stop();
				popup_overlay.fade(0.45);
				popup_login_fx.start({'opacity':1, 'margin-top': -popup_login_h / 2, 'height': popup_login_h});
				opened_popup = 'login';
			});
		}
		
		if(document.id('btnRegister')) {
			popup_register = document.id('gkPopupRegister');
			popup_register.setStyle('display', 'block');
			popup_register_h = popup_register.getElement('.gkPopupWrap').getSize().y + 8;
			popup_register_fx = new Fx.Morph(popup_register, {duration:200, transition: Fx.Transitions.Circ.easeInOut}).set({'opacity': 0, 'height': 0, 'margin-top':0}); 
			document.id('btnRegister').addEvent('click', function(e) {
				new Event(e).stop();
				showGKRecaptcha('gk_recaptcha',  'submit_1', 'recaptcha_required_1');
				popup_overlay.fade(0.45);
				popup_register_fx.start({'opacity':1, 'margin-top': -popup_register_h / 2, 'height': popup_register_h});
				opened_popup = 'register';
				
			});
		}
		
		popup_overlay.addEvent('click', function() {
			if(opened_popup == 'login')	{
				popup_overlay.fade('out');
				popup_login_fx.start({
					'opacity' : 0,
					'height' : 0,
					'margin-top': 0
				});
			}
			
			if(opened_popup == 'register') {
				popup_overlay.fade('out');
				popup_register_fx.start({
					'opacity' : 0,
					'height' : 0,
					'margin-top': 0
				});
			}	
		});
	}
	// nsp header suffix improvement ;)
	if($$('div.header')[0] && $$('div.header')[0].getElement('.nspHeader')) {
		$$('div.header').each(function(mod) {
			var headers = mod.getElements('.nspHeader');
			headers.each(function(elm) {
				if(elm.getParent().getElement('p.nspInfo')) {
					elm.getParent().getElement('p.nspInfo').inject(elm, 'bottom');
				}
				
				if(elm.getParent().getElement('p.nspText')) {
					elm.getParent().getElement('p.nspText').inject(elm, 'bottom');
				}
			});
		});
	}
	//changes for module in jomsocial position
    if(document.getElements('.moduletable')){

        var el =  document.getElements('.moduletable');
        var tab = document.getElements('.moduletable h3');

        for (var i=0; i < tab.length; i++) {   
          if(tab[i]) {
              tab[i].addClass('header').innerHTML = '<span>'+ tab[i].get('html')+'</span>';
          }
          if(el[i]) {
              el[i].removeClass('moduletable').addClass('box').innerHTML = '<div>'+ el[i].get('html')+'</div>';
          }
        }  
    }
});
// function to set cookie
function setCookie(c_name, value, expire) {
	var exdate=new Date();
	exdate.setDate(exdate.getDate()+expire);
	document.cookie=c_name+ "=" +escape(value) + ((expire==null) ? "" : ";expires=" + exdate.toUTCString());
}
// Function to change styles
function changeStyle(style){
	var file1 = $GK_TMPL_URL+'/css/style'+style+'.css';
	var file2 = $GK_TMPL_URL+'/css/typography.style'+style+'.css';
	new Asset.css(file1);
	new Asset.css(file2);
	Cookie.write('gk_twn2_16_style',style, { duration:365, path: '/' });
}