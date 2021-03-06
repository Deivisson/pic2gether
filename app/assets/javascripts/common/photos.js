$(document).on('ready page:load', function (){
	photoView();
	adjustLayout();
	PhotoPopupMenuTrigger();
	PhotoAvoidRightClick();
});

function photoView(){
	$(".photo-picture").unbind("click");
	$(".photo-picture").bind("click",function(e){
		var w = $(window).width() * 1;
		var h = $(window).height() * 1;
		var url = $(this).attr('href');
		var dialog_form = $(getModalContainer("photo-modal-dialog",true)).dialog({
		    autoOpen: false,
		    width: w,
		    height: h,
		    modal: true,
		    close: function() {
		      $('#photo-modal-dialog').remove();
		      jQuery('body').css('overflow','auto');
		    },
		    draggable: false,
        resizable: false,
        dialogClass: 'noTitleStuff'
		  });
			$(".ui-widget-content").addClass("ui-widget-content-full");
		  dialog_form.load(url + ' #photo-show-container', function(){
		  		jQuery('body').css('overflow','hidden');
		  		$(".ui-widget-overlay").css("opacity","1");
		  		adjustLayout();
		  		PhotoAvoidRightClick("#photo-picture");
	  			$("#photo-view-modal-close-button").click(function(e) {
	  				e.preventDefault();
		  			$("#photo-modal-dialog").dialog( "close" );
		  			console.log('TESTE');
				});
		  });
		  dialog_form.dialog('open');
		  e.preventDefault();
	});
}

$(window).resize(function () {
	adjustLayout();
});

function adjustLayout(){
	 //alert("Size " + w + "x" + h);
	if($("#photo-show-container").length > 0)	{
		$(".ui-widget-content").css({
			height:"100%",
			width: "100%"
		});
		var w = $("#photo-container").width();
		var h = $("#photo-container").height();
		$("#photo-picture").css("left",(w/2) - ($("#photo-picture").width()/2) );
		$("#photo-toolbar").css("left",(w/2) - ($("#photo-toolbar").width()/2));
		$(".photo-show-extra-content").css("top", h + 10);


		$(".ui-widget-content-full").css("overflow-y","hidden");
		$("#photo-modal-dialog").css("overflow-y","visible").css("width","97.8%");
	  $("#down-page-photo-view").click(function(){
	  	var top = $('#photo-list-comments').offset().top - 200;
	  	$('#photo-modal-dialog').animate({scrollTop: top},250);
	  });
 	}
}

function resizeModalDialog(){
	var w = $(window).width() * 1;
	var h = $(window).height() * 1;
	$("#ui-widget-overlay").css("height",h);
	$("#ui-widget-overlay").css("width",w);
	$("#ui-widget-content").css("height",h);
	$("#ui-widget-content").css("width",w);
}


function handleFileUpload(files,obj)
{
   for (var i = 0; i < files.length; i++)
   {
        var fd = $("#new_photo");
        fd.append('file', files[i]);
   }
}


function showImagePreview(input) {
	if (input.files && input.files[0]) {
		var filerdr = new FileReader();
		filerdr.onload = function(e) {
			$("#image-upload").css("background-image",'url(' + e.target.result + ')');
		}
		filerdr.readAsDataURL(input.files[0]);
		$("#dragandrophandler").css("border","1px solid #777")
		$("li#photo_picture_input > label").hide();
		$("#photo_title").focus();
		$("#photo_remove").css("display", "block");

		$("#photo_remove").on("click", function () {
			console.log("teste")
      $("#image-upload").css("background-image","")
      $("li#photo_picture_input > label").show();
      $("#photo_remove").css("display", "none");
 		 });
	}
}

function PhotoPopupMenuTrigger(){
	if ($(".photo-menu-popup-arrow").length > 0) {
		$(".photo-menu-popup-arrow").unbind("click");
		$(".photo-menu-popup-arrow").bind("click",function(){
			var elementid = $(this).attr("photo-id");
			$("#"+elementid).toggleClass('open-menu');
		});
	}
	if($(".photo-share-menu-link").length > 0) {
		$(".photo-share-menu-link").unbind("click");
		$(".photo-share-menu-link").bind("click", function(e) {
			e.preventDefault();
		});
	}
}


function PhotoAvoidRightClick(photoElem) {
	if (photoElem == undefined) photoElem =".img-pic"
	if ($(photoElem).length > 0) {
		$(photoElem).on("contextmenu",function() {
	 		alert("Direitos autorais pertence a " + $(this).attr("owner") +".");
	   	return false;
		});
	}
}
