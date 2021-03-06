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
  	        message: 'Conheça o site Pic2gether. O portal que lhe dará grande exposição, inspirações e realmente ajudará a melhorar suas habilidades fotográficas: https://pic2gether.com',
		        display: 'popup'
		      }, function(response){
		        UpdateInvitedFriends('facebook',response);
		      });
		    }
	    </script>
		SCRIPT
		script.html_safe
	end

	def facebook_share()
		script = <<-SCRIPT
			<script>
				function FacebookShare(link,title,share_callback)
		    {
		    	if (link == undefined) {
		    		link='https://pic2gether.com'
		    	}
		    	if (title == undefined || title == '') {
		    		title = 'Pic2gether'
		    	}
		      FB.ui({
		        method: 'share',
		        app_id:'1546622365584604',
		        display: 'popup',
					  href: link ,
					  title: title,
		      }, function(response){
		      	if (share_callback != undefined) {
		      		UpdateSocialNetworkShared('facebook',response,share_callback);	
		      	}
		      });
		    }
	    </script>
		SCRIPT
		script.html_safe		
	end
	
	def facebook_image_share(image_link,description=nil)
		if description.nil?
			meta = <<-META
				<link rel="image_src" href="#{URI.join(root_url, image_link).to_s}" />
				<meta property="og:image" content="#{URI.join(root_url, image_link).to_s}" />
			META
		else
			meta = <<-META
				<link rel="image_src" href="#{URI.join(root_url, image_link).to_s}" />
				<meta property="og:image" content="#{URI.join(root_url, image_link).to_s}" />
				<meta property="og:description" content="#{description}" />
			META
		end
		content_for :facebook_image_to_share do 
			meta.html_safe
		end
	end

	def twitter_link_to_share(title,content,html_options={}, &block)
		html_options.merge!(target:'_blank')
		link_to("https://twitter.com/home?status=#{content}", html_options) do
			inner_html = []
			inner_html << title
			inner_html << content_tag(:nil,&block)
			inner_html.join.html_safe
		end
	end

	def twitter_share
		script = <<-SCRIPT
			<script>
				function TwitterShare(share_callback) {	
					if (share_callback != undefined) {
		    		UpdateSocialNetworkShared('twitter',JSON.stringify("[]"),share_callback);
	    		}
	      };
	    </script>
		SCRIPT
		script.html_safe		
	end
	
	def google_plus_link_to_share(title,content,html_options={}, &block)
		html_options.merge!(target:'_blank')
		link_to("https://plus.google.com/share?url=#{content}", html_options) do
			inner_html = []
			inner_html << title
			inner_html << content_tag(:nil,&block)
			inner_html.join.html_safe
		end
	end

	def google_plus_share
		script = <<-SCRIPT
			<script>
				function GooglePlusShare(share_callback) {	
					if (share_callback != undefined) {
		    		UpdateSocialNetworkShared('google_plus',JSON.stringify("[]"),share_callback);
	    		}
	      };
	    </script>
		SCRIPT
		script.html_safe		
	end
end