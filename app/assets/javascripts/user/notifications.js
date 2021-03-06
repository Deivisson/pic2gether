$(document).on('ready page:load', function (){
	$("#notification-show-all").click(function(e){
		var h = $(window).height() * 1;
		var url = $(this).attr('href');
		var dialog_form = $(getModalContainer("notifications-show-all-modal-dialog")).dialog({
		    autoOpen: false,
		    width: 700,
		    height: h,
		    modal: true,
				open: function(){
					$(".ui-widget-overlay").addClass("modal-overlay notifications-show-all-modal-dialog-class").removeClass("ui-widget-overlay");
          $('.notifications-show-all-modal-dialog-class').bind('click',function(){
            $('#notifications-show-all-modal-dialog').dialog('close');
          });
        },		    
		    close: function() {
		      $('#notifications-show-all-modal-dialog').remove();
		      if ($("div[aria-describedby='notifications-show-all-modal-dialog']").length > 0) {
			      	$("div[aria-describedby='notifications-show-all-modal-dialog']").remove();
		      }
		      jQuery('body').css('overflow','auto');
		    },
		    draggable: false,
        resizable: false,
        dialogClass: 'noTitleStuff'
		  });
		  dialog_form.load(url + '#notifications-all-modal-container', function(){
	  		jQuery('body').css('overflow','hidden');
	  		$(".ui-dialog-content").css("overflow-x", "hidden");
	  		$("#notification-modal-close-button").click(function() {
	  			$("#notifications-show-all-modal-dialog").dialog( "close" );
				});
		  });
		  dialog_form.dialog('open');
		  e.preventDefault();  
	});	
	
});
