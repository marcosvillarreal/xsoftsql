window.addEvent('load', function() {
	if(typeof($Gavick) !== 'undefined') {
		// get the plugin configuration
		var $G = $Gavick['gk_ajax_search'];
		// if form exists
		if(document.id($G['container_id'])) {
			// create an input handler
			var input = document.id($G['container_id']).getElement('#mod-search-searchword');
			input.setProperty('autocomplete', 'off');
			// create necessary HTML structures
			var html = '<div class="gk_ajax_search_wrap"><div class="gk_ajax_search_total"></div><span class="gk_ajax_search_close">'+$G['lang_close']+'</span><div class="gk_ajax_search_results"></div><div class="gk_ajax_search_more">'+$G['lang_all_results']+'</div></div>';
			var popup = new Element('div', {'id': 'gk_ajax_search', 'html': html});
			popup.inject(document.body, 'bottom');
			popup.addClass('hide');
			// add events to the input and popup
			document.id('gk_ajax_search').getElement('.gk_ajax_search_more').addEvent('click', function() {
				input.getParent('form').submit();
			});
			
			document.id('gk_ajax_search').getElement('.gk_ajax_search_close').addEvent('click', function() {
				popup.addClass('hide');
				(function() { popup.setStyle('display', 'none') }).delay(350);
			});
			
			var overPopup = false;
			popup.addEvent('mouseenter', function() { overPopup = true; });
			popup.addEvent('mouseleave', function() { overPopup = false; });
			
			document.body.addEvent('click', function() {
				if(!overPopup) {
					document.id('gk_ajax_search').getElement('.gk_ajax_search_close').fireEvent('click');
				}
			});
			
			// AJAX request
			var HTMLReq = new Request.HTML({
				evalScripts: false,
				onSuccess: function(tree, elements, html) {
					document.id('gk_ajax_search').getElement('.gk_ajax_search_results').set('html', '');
					document.id('gk_ajax_search').getElement('.gk_ajax_search_total').set('html', '');
					// hidden wrapper for the results
					var res = new Element('div', {
						'class': 'gkHidden', 
						'html': html
					}).injectInside(
						document.id('gk_ajax_search').getElement('.gk_ajax_search_results'), 
						'bottom'
					);
					// results
					if(res.getElement('.search-results')) {
						[
							'dt', 
							'dd.result-category', 
							'dd.result-created', 
							'dd.result-text'
						].each(function(selector){
							res.getElement('.search-results').getElements(selector).each(function(el, i){
								if(i > $G['length'] - 1) el.destroy();
							});
						});
						
						res.getElement('.search-results').injectInside(
							document.id('gk_ajax_search').getElement('.gk_ajax_search_results'), 
							'bottom'
						);
					} else {
						var info = new Element('p', {'html': '<strong>'+$G['lang_no_results']+'</strong>'});
						info.injectInside(
							document.id('gk_ajax_search').getElement('.gk_ajax_search_results'), 
							'bottom'
						);	
					}
					// amount of results
					if(res.getElement('.searchintro strong')) {
						res.getElement('.searchintro strong').injectInside(
							document.id('gk_ajax_search').getElement('.gk_ajax_search_total'),
							'bottom'
						);
					}
					// positioning the popup
					var position = {
						bottom: input.getCoordinates().bottom,
						right: input.getCoordinates().right - 300
					};
					
					popup.setStyles({
						top: position.bottom + "px",
						left: position.right + "px"
					});
					
					if(popup.hasClass('hide')) { popup.removeClass('hide'); popup.setStyle('display', 'block'); }
					if(input.hasClass('loader')) { input.removeClass('loader'); } 
				}
			});
			
			var ajaxRequestTimer = false;
			
			input.addEvent('keydown', function(event) {
				if(
					event.key != 'enter' &&
					event.key != 'up' &&
					event.key != 'down' &&
					event.key != 'left' &&
					event.key != 'right' &&
					event.key != 'delete' &&
					event.key != 'esc') {
					
					if(ajaxRequestTimer) { clearTimeout(ajaxRequestTimer);	}
					if(!input.hasClass('loader')) { input.addClass('loader'); } 
					
					ajaxRequestTimer = (function(){
						HTMLReq.get('index.php?limit=10&option=com_search&ordering=newest&searchphrase=any&searchword='+input.get('value')+'&tmpl=ajax&view=search&Itemid=9999');
						ajaxRequestTimer = false;
					}).delay($G['delay']);
				}
			});
			
			input.addEvent('keyup', function(event) {
				if(
					event.key != 'enter' &&
					event.key != 'up' &&
					event.key != 'down' &&
					event.key != 'left' &&
					event.key != 'right' &&
					event.key != 'delete' &&
					event.key != 'esc') {
					
					if(ajaxRequestTimer) { clearTimeout(ajaxRequestTimer);	} 
					if(!input.hasClass('loader')) { input.addClass('loader'); } 
					
					ajaxRequestTimer = (function(){
						HTMLReq.get('index.php?limit=10&option=com_search&ordering=newest&searchphrase=any&searchword='+input.get('value')+'&tmpl=ajax&view=search&Itemid=9999');
						ajaxRequestTimer = false;
					}).delay($G['delay']);
				}
			});
			
			// set position of the popup
			var position = {
				bottom: input.getCoordinates().bottom,
				right: input.getCoordinates().right - 300
			};
			
			popup.setStyles({
				top: position.bottom + "px",
				left: position.right + "px"
			});
		}
	}
});