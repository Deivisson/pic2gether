module User::SocialNetworkHelper
	#https://developers.facebook.com/docs/javascript/reference/FB.ui
	def facebook_script
		script = <<-SCRIPT
			<script src="https://connect.facebook.net/en_US/all.js"></script>
		  <script>
		    FB.init({
		      appId:'1546622365584604',
		      cookie:true,
		      status:true,
		      xfbml:true
		    });
			</script>
		SCRIPT
		script.html_safe
	end

	def facebook_invite_friends
		script = <<-SCRIPT
			<script>
				function FacebookInviteFriends()
		    {
		      FB.ui({
		      	title:'Convidar Amigos',
		        method: 'apprequests',
  	        message: 'Torne o Pic2gether conhecido para seus amigos. Eles também merecem !!',
		        display: 'popup'
		      }, function(response){
		        UpdateInvitedFriends();
		      });
		    }
	    </script>
		SCRIPT
		script.html_safe
	end

	def facebook_share()
		script = <<-SCRIPT
			<script>
				function FacebookShare(link='https://pic2gether.com')
		    {
		      FB.ui({
		        method: 'share',
		        app_id:'1546622365584604',
		        display: 'popup',
					  href: link ,
		      }, function(response){
		        UpdateSocialNetworkShared('facebook',response);
		      });
		    }
	    </script>
		SCRIPT
		script.html_safe		
	end
	
	def facebook_image_share(image_link)
		meta = <<-META
			<link rel="image_src" href="#{URI.join(root_url, image_link).to_s}" />
			<meta property="og:image" content="#{URI.join(root_url, image_link).to_s}" />
		META
		content_for :facebook_image_to_share do 
			meta.html_safe
		end
	end

	def twitter_link_to_share(title,content,html_options={})
		html_options.merge!(target:'_blank')
		link_to title,"https://twitter.com/home?status=#{content}", html_options
	end

	def twitter_share
		script = <<-SCRIPT
			<script>
				function TwitterShare() {	
		    	UpdateSocialNetworkShared('twitter',JSON.stringify("[]"));
	      };
	    </script>
		SCRIPT
		script.html_safe		
	end
	
end