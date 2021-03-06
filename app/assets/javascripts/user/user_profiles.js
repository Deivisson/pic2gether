$(document).on('ready page:load', function (){
	$("#edit-cover").click(function(e){
			var url = $(this).attr('href');
			var dialog_form = $(getModalContainer("edit-cover-modal-dialog")).dialog({
			    autoOpen: false,
			    width: 690,
			    height: 600,
			    modal: true,
			    open: function(){
						$(".ui-widget-overlay").addClass("modal-overlay edit-cover-modal-dialog-class").removeClass("ui-widget-overlay");
	          $('.edit-cover-modal-dialog-class').bind('click',function(){
	            $('#edit-cover-modal-dialog').dialog('close');
	          });
	        },
			    close: function() {
			      $('#edit-modal-cover-containter').remove();
			      if ($("div[aria-describedby='edit-cover-modal-dialog']").length > 0) {
			      	$("div[aria-describedby='edit-cover-modal-dialog']").remove();
			      }
			    }
			  });

			  dialog_form.load(url + '#edit-modal-cover-containter', function(){
		  		$(this).dialog('option',"title",$("#modal-title-edit-cover").text());
		  		$(".ui-widget-overlay").css("opacity","0.8");
		  		$("#edit-cover-modal-dialog").css("overflow-x","hidden");
			  });
			  
			  dialog_form.dialog('open');
			  e.preventDefault();  
	});
});

function showAvatarPreview(input) {
	if (input.files && input.files[0]) {
		var filerdr = new FileReader();
		filerdr.onload = function(e) {
			$('#user-avatar').attr('src', e.target.result);
		}
		filerdr.readAsDataURL(input.files[0]);
	}
}