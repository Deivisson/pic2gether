$(document).on('ready page:load', function (){
	photographerPreview();
});

function photographerPreview(){
	$(".photographer-profile").click(function(e){
		var h = $(window).height() * 1;
		var url = $(this).attr('href');
		var dialog_form = $(getModalContainer("photographer-modal-dialog")).dialog({
		    autoOpen: false,
		    width: 900,
		    height: h,
		    modal: true,
		    close: function() {
		      $('#photographer-modal-dialog').remove();
		      jQuery('body').css('overflow','auto');
		    },
		    draggable: false,
        resizable: false,
        dialogClass: 'noTitleStuff'
		  });
		  dialog_form.load(url + ' #photographer-show-modal-container', function(){
	  		jQuery('body').css('overflow','hidden');
	  		$(".ui-dialog-content").css("overflow-x", "hidden");
	  		photoView();
		  });
		  dialog_form.dialog('open');
		  e.preventDefault();  
	});	
}